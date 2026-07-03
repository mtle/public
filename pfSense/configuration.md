# Basic System Configuration:

## System
### General setup
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

### Advanced
#### Admin Access

|Field|Value|
|---|---|
|`Protocol`| select `https`|
|`ssh`| `enable`|
|`sshd key only`| `public key only`|

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

## Interfaces
### VLANs
`Interfaces` -> `Assignment` -> `VLANs`: Add <br/>

|Interface|VLAN tag| Priority|Description|
|---|---|---|---|
|ix0|5||vpn_ca|
|ix0|7|	|vpn_vn|
|ix0|11||vpn_us|
|ix0|13||pub|
|ix0|15||iot|
|re0|40||primus_pppoe|


### Interface groups
`Interfaces` -> `Assignment` -> `Interface Groups`: Add

|Name|Members|Decription|
|---|---|---|
|safe_ifs|LAN, VPN_CA, VPN_VN|mgmt/safe interfaces|
|local_ifs|LAN, VPN_CA, VPN_VN, PUB, IOT|all local interfaces|


## Firewall
### Aliases
#### Firewall Aliases IP
|Name|Type|Values|Decription|
|---|---|---|---|
|IPv4PrivateNetworks|Network(s)|10.0.0.0/8, 172.12.0.0/12, 192.168.0.0/16| RFC1918|


#### Firewall Aliases Ports
|Name|Type|Values|Decription|
|---|---|---|---|
|anti_lockout_ports|Port(s)|443, 22|Anti-lockout|
|wireguard_ports|Port(s)|51820, 51821, 51822|wireguard_ports|

### Rules
#### Group rules
Select `Firewall` -> `Rules` -> `local_ifs` <br/>
|Protocol|Source|Port|Destination|Port|Gateway|Description|
|---|---|---|---|---|---|---|
|IPv4 TCP|safe_interfaces networks| * |This Firewall (self)|anti_lockout_ports| * |Anti-lockout rule|
|IPv4 ICMP| echoreq |safe_interfaces networks| * |This Firewall (self)| * |Allow echo requests|
|IPv4 TCP/UDP|local_ifs networks|* |This Firewall (self)|53 (DNS)|* |Allow DNS requests|

#### Interface rules
Select `Firewall` -> `Rules` -> `select an interface`
|Protocol|Source|Port|Destination|Port|Gateway|Description|
|---|---|---|---|---|---|---|
|IPv4 * |VPN_CA subnets| * |!IPv4PrivateNetworks| * |wg_ca_gw|Allow access to internet and block access to private networks|
|IPv4+6 * |VPN_CA subnets| * | * | * | * |default - last match|

## Services
### DNS Resolver
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


# Wireguard VPN

#### Sample Wireguard configuration
```
[Interface]
# Key for ca-free
PrivateKey = <enter private key>
Address = 10.2.0.2/32
DNS = 10.2.0.1

[Peer]
# CA-FREE#11
PublicKey = rROokcTHabt9RJ++V8yfCelZVznfMZDLENtn8X1sLVA=
AllowedIPs = 0.0.0.0/0
Endpoint = 149.22.81.28:51820
```

## Add tunnel
Go to *VPN* → *WireGuard* → *Tunnels* and create a new tunnel with the following settings. <br/>

#### Tunnel configuration

|Field|Value|
|---|---|
|`Description`| tun_proton|
|`Listen port`| 51820 *change to a different number if needed*|
|`Interface Keys`| Private key from [the sample configuration](#Sample-Wireguard-configuration)|
|`Public key`| This will be automatically generated|

#### Interface configuration

|Field|Value|
|---|---|
|`Interface Addresses`| 10.2.0.2/32 [From sample config](#Sample-Wireguard-configuration)|
Click *Save* Tunnel when done. <br/>


## Add peer
#### Peer Configuration

|Field|Value|
|---|---|
|`Enable`| :white_check_mark: `Enable`|
|`Tunnel`| [tun_proton](#Tunel_Configuration)|
|`Description`| choose a descriptive name, for example, the server name|
|`Dynamic Endpoint`| uncheck|
|`Endpoint`| endpoint IP address from your downloaded WireGuard configuration|
|`Port`| 51820|
|`Keep Alive`| 25|
|`Public Key`| public key from your downloaded WireGuard configuration file (see above)|

#### Address Configuration

|Field|Value|
|---|---|
|`Allowed IPs`| 0.0.0.0/0|
Click *Save* Peer when done. <br/>

## Enable Wireguard
Go to the *Settings* tab, check *Enable WireGuard*, then click *Save* and *Apply Changes*.<br/>

## Create a WireGuard interface
The VPN client is now running, but no traffic is being routed through it. <br/>
Configure the Interfaces and Firewall rules to route network traffic through the VPN tunnel.

Go to *Interfaces* → *Interface Assignments* → *Available network ports* and select tun_wg? → Add.

This will create an interface named `OPTx`. Click on the newly created one to configure it.

##### General configuration

|Field|Value|
|---|---|
|Enable| checked|
|Description| *WG_proton* |
|IPv4 configuration type| Static IPv4|
|IPv6 Configuration Type| None|

##### Static IPv4 configuration

|Field|Value|
|---|---|
|IPv4 address|10.2.0.2/32|

Click *Save* and *Apply*.

## Add a new gateway
Go to *System* → *Routing* → *Gateways* and click *Add* to add a new gateway.


|Field|Value|
|--- |--- |
|Interface| [WG_proton](#Create-a-WireGuard-interface)|
|Address Family| ipv4|
|Name| descriptive name|
|Gateway| 10.2.0.1|

Click *Display Advanced* and check *Use non-local gateway*.

|Field|Value|
|--- |--- |
|*Use non-local gateway*| :white_check_mark: *Use non-local gateway through interface specific route*|

Click *Save* and *Apply Changes*.

|Name|Default|Interface|Gateway|Monitor IP|Description|
|---|---|---|---|---|---|
|WAN_DHCP| |WAN|dynamic|dynamic|Interface WAN_DHCP Gateway|
|WAN_DHCP6| |WAN|dynamic|dynamic|Interface WAN_DHCP6 Gateway|
|proton_gw| |PROTON|10.2.11.1|1.1.1.1|proton ca-free gw|
|wg_ca_gw| |WG_CA|10.14.5.1|1.1.1.3|wireguard ca gw|

##  Firewall rules
### Outbound NAT Mode
#### Set Outbound NAT Mode to **Hybrid** or **Manual**
Go to *Firewall* → *NAT* → *Outbound* and select *Manual Outbound NAT rule generation* or *Hybrid Outbound NAT rule generation*. <br/>
Click *Save* and *Apply Changes*. <br/>

### New Mappings
Under `Mappings` click `Add` <br/>

`Edit Advanced Outbound NAT Entry:``

|Field|Value|
|---|---|
|Interface| select the interface |
|Source|`Network or Alias` -> choose one in `192.168.x.y` |

|Interface|Source|Source Port|Destination|Destination Port|NAT Address|NAT Port|Static Port|Description|
|---|---|---|---|---|---|---|---|---|
|WAN|127.0.0.0/8| * | * |500 (ISAKMP)|WAN address| * | |Auto created rule for ISAKMP - localhost to WAN
|PROTON|192.168.11.0/24|*|*|500 (ISAKMP)|WAN address|*| |PROTON to WAN|
|PROTON|192.168.11.0/24|*|*|*|WAN address|*| |PROTON to WAN|

### Interface rule
#### WG Interface gateway
`Interface` -> select the WG interface created in [*Create a WireGuard interface*](#Create-a-WireGuard-interface)
|Static IPv4 Configuration| |
|IPv4 Upstream gateway| select the GW in [*Add a new gateway*](#Add-a-new-gateway) |

#### Local interface rule
*Firewall* → *Rules* → *if/vlan_if* → *Allow to Internet rule* → *Edit (pencil icon)*.
Click *Display advanced* → *Gateway* and select the gateway created in [*Add a new gateway*](#Add-a-new-gateway).
Click *Save* and *Apply Changes*.

### DNS Settings
All internet traffic passing through the pfSense firewall will now be routed through the VPN server. However, DNS requests are not. To fix this, we need to change the DNS settings in pfSense. <br/>

In pfSense, go to *System* → *General setup* → *DNS Server Settings* and configure the following settings:

|Field|Value|
|---|---|
|DNS Servers| 10.2.0.1 [*see here*](#Static-IPv4-configuration)|
|Gateway| the name of the gateway we configured in [*Add a new gateway*](#add-a-new-gateway)|
|DNS Server Override| unchecked|

Click *Save*.

Now go to *Services* → *DNS Resolver* → *General Settings* and change the following:

|Field|Value|
|---|---|
|Outgoing Network Interfaces| [WG_proton](#Create-a-Wireguard_interface)|
|DNS Query Forwarding| check Enable Forwarding mode|
Click *Save* and *Apply Changes*.

=== DONE ===

