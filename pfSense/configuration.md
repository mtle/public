# Basic System Configuration:

## I. System
### 1. General setup
|Field|Value|
|---|---|
|`hostname` | `fw`|
|`domain` | `linkon.dedyn.io`|

#### DNS server settings:

|Field|Value|
|---|---|
|`DNS servers` | `1.1.1.3 9.9.9.9`|
|`override DNS`| `uncheck`|
|`DNS Resolution Behavior`| `Use local, ignore remote`|

#### Localization

|Field|Value|
|---|---|
|`Timezone`| select `UTC`|
|`Timeservers`| add `ntp1.torix.ca time.nrc.ca`|

#### webConfigurator
Default <br/>

### 2. Advanced
#### Admin Access

|Field|Value|
|---|---|
|`Protocol`| select `https`|
|`ssh`| `enable`|
|`sshd key only`| `public key only`|

#### Firewall & NAT
|Field|Value|
|---|---|
|`Enable Maximum MSS`| :white_check_mark: |
|`Maximum MSS`|1420 |

>[!TIP]
>Maximum MSS size of 1420 is good for Wireguard <br/>
>[what is mss](https://www.cloudflare.com/learning/network-layer/what-is-mss/)

#### Networking

|Field|Value|
|---|---|
|`Use if_pppoe kernel module for PPPoE client`| :white_check_mark: `Use if_pppoe kernel module for PPPoE client`|

#### Miscellaneous

|Field|Value|
|---|---|
|`PowerD`| enable|
|`AC power`| `hiadaptive`|
|`Battery power`| `hiadaptive`|
|`Unknown power`| `hiadaptive`|
|`Cryptographic Hardware`| `AES-NI CPU based acceleration`|
|`Thermal Sensor`| `* cpu ondie thermal sensor`|
|`Use RAM Disks`| :white_check_mark: `Use memory file system for /tmp and /var`|
|`RAM Disk Size`| set [1024] `/tmp`, and [4096] `/var`|

#### Notifications

|Field|Value|
|---|---|
|Console Bell| [ ] Enable the console bell (uncheck)|
|Startup/Shutdown Sound| :white_check_mark: Disable the startup/shutdown beep|


## II. Interfaces

### 1. VLANs
**Interfaces** -> **Assignment** -> **VLANs**: Add

##### vlan table
|Interface|VLAN tag| Priority|Description|
|---|---|---|---|
|ix0|5||vpn_ca|
|ix0|7|	|vpn_vn|
|ix0|11||vpn_us|
|ix0|13||pub|
|ix0|15||iot|
|re0|40||primus_pppoe|


### 2. PPPoE
#### Create a PPPoE interface

Go to **Interfaces** → **Interface Assignments** → **Available network ports** and select [re.40](#vlan-table) → Add. <br/>

This will create an interface named `OPTx`. Click on the newly created one to configure it.

##### General configuration

|Field|Value|
|---|---|
|Enable| checked|
|Description| *primus* |
|IPv4 configuration type| pppoe|
|IPv6 Configuration Type| None|
|MTU|1492|
|Advanced and MLPPP|click `Advanced and MLPPP` button and select from **PPPs**|
|Block private networks and loopback addresses|:white_check_mark:|
|Block bogon networks|:white_check_mark:|

### 3. LAN interface
**Interfaces** → select **LAN***

##### Static IPv4 configuration

|Field|Value|
|---|---|
|IPv4 Configuration Type|Static IPv4|
|IPv6 Configuration Type|None|
|MTU|1432 [^1]|
|IPv4 address|192.168.x.y/24|

Click **Save** and **Apply**.

[^1]: 1432=IPv4, 1412=IPv6. Only for Wireguard behind PPPoE WAN type. If this field is blank, the adapter's default MTU will be used. This is typically 1500 bytes but can vary in some circumstances.

### 4. Interface groups
**Interfaces** -> **Assignment** -> **Interface Groups**: Add

|Name|Members|Decription|
|---|---|---|
|safe_ifs|LAN, VPN_CA, VPN_VN|mgmt/safe interfaces|
|local_ifs|LAN, VPN_CA, VPN_VN, PUB, IOT|all local interfaces|


## III. Firewall
### 1. Aliases
#### Firewall Aliases IP
|Name|Type|Values|Decription|
|---|---|---|---|
|All_RFC1918_Networks|Network(s)|10.0.0.0/8, 172.12.0.0/12, 192.168.0.0/16| RFC1918|


#### Firewall Aliases Ports
|Name|Type|Values|Decription|
|---|---|---|---|
|anti_lockout_ports|Port(s)|443, 22|Anti-lockout|
|wireguard_ports|Port(s)|51820, 51821, 51822|wireguard_ports|

### 2. Rules
#### Group rules
Select **Firewall** -> **Rules** -> **local_ifs**

|Protocol|Source|Port|Destination|Port|Gateway|Description|
|---|---|---|---|---|---|---|
|IPv4 TCP|safe_interfaces networks| * |This Firewall (self)|anti_lockout_ports| * |Anti-lockout rule|
|IPv4 ICMP| echoreq |safe_interfaces networks| * |This Firewall (self)| * |Allow echo requests|
|IPv4 TCP/UDP|local_ifs networks|* |This Firewall (self)|53 (DNS)|* |Allow DNS requests|

#### Interface rules
Select **Firewall** -> **Rules** -> **select an interface**

|Protocol|Source|Port|Destination|Port|Gateway|Description|
|---|---|---|---|---|---|---|
|IPv4 * |VPN_CA subnets| * |!IPv4PrivateNetworks| * |wg_ca_gw|Allow access to internet and block access to private networks|
|IPv4+6 * |VPN_CA subnets| * | * | * | * |default - last match|

## IV. Services
### 1. DNS Resolver (unbound)
#### General settings

|Field|Value|
|---|---|
|`Enable`| :white_check_mark: `Enable DNS resolver`|
|`Network Interfaces`| select localhost + all local/vlan interfaces|
|`Outgoing Network Interfaces`| select `WAN/PPPoE`|
|`Strict Outgoing Network Interface Binding`| :white_check_mark: `Do not send recursive queries if none of the selected Outgoing Network Interfaces are available.`|
|`DNSSEC`| :white_check_mark: `enable DNSSEC Support`|
|`DNS Query Forwarding`| :white_check_mark: `Enable Forwarding Mode` <br> :white_check_mark: `Use SSL/TLS for outgoing DNS Queries to Forwarding Servers`|
|`Custom options`|server:<br>module-config: "respip validator iterator"<br>include: "/usr/local/etc/unbound/custom_server.conf"<br>include: "/usr/local/etc/unbound/custom_auth_zones.conf"|

