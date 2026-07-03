# Basic System Configuration:

## System
### General setup
| | |
|---|---|
|`hostname` | `fw`|
|`domain` | `linkon.dedyn.io`|

#### DNS server settings:
| | |
|---|---|
|`DNS servers` | `1.1.1.3 9.9.9.9`|
|`override DNS`| `uncheck`|
|`DNS Resolution Behavior`| `Use local, ignore remote`|

#### Localization:
| | |
|---|---|
|`Timezone`| select `UTC`|
|`Timeservers`| add `ntp1.torix.ca time.nrc.ca`|

#### webConfigurator:
Default <br/>

### Advanced
#### Admin Access:
| | |
|---|---|
|`Protocol`| select `https`|
|`ssh`| `enable`|
|`sshd key only`| `public key only`|

#### Networking:
| | |
|---|---|
|`Use if_pppoe kernel module for PPPoE client`| :white_check_mark: `Use if_pppoe kernel module for PPPoE client`|

#### Miscellaneous:
| | |
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
### VLANs:
`Interfaces` -> `Assignment` -> `VLANs`: Add <br/>

|Interface|VLAN tag| Priority|Description|
|---|---|---|---|
|ix0|5||vpn_ca|
|ix0|7|	|vpn_vn|
|ix0|11||vpn_us|
|ix0|13||pub|
|ix0|15||iot|
|re0|40||primus_pppoe|


### Interface groups:
`Interfaces` -> `Assignment` -> `Interface Groups`: Add

|Name|Members|Decription|
|---|---|---|
|safe_ifs|LAN, VPN_CA, VPN_VN|mgmt/safe interfaces|
|local_ifs|LAN, VPN_CA, VPN_VN, PUB, IOT|all local interfaces|


## Firewall
### Aliases:
#### Firewall Aliases IP
|Name|Type|Values|Decription|
|---|---|---|---|
|IPv4PrivateNetworks|Network(s)|10.0.0.0/8, 172.12.0.0/12, 192.168.0.0/16| RFC1918|


#### Firewall Aliases Ports
|Name|Type|Values|Decription|
|---|---|---|---|
|anti_lockout_ports|Port(s)|443, 22|Anti-lockout|
|wireguard_ports|Port(s)|51820, 51821, 51822|wireguard_ports|

### Rules:
#### Group rules:
Select `Firewall` -> `Rules` -> `local_ifs` <br/
|Protocol|Source|Port|Destination|Port|Gateway|Description|
|---|---|---|---|---|---|---|
|IPv4 TCP|safe_interfaces networks| * |This Firewall (self)|anti_lockout_ports| * |Anti-lockout rule|
|IPv4 ICMP| echoreq |safe_interfaces networks| * |This Firewall (self)| * |Allow echo requests|
|IPv4 TCP/UDP|local_ifs networks|* |This Firewall (self)|53 (DNS)|* |Allow DNS requests|

#### Interface rules:
Select `Firewall` -> `Rules` -> `select an interface`
|Protocol|Source|Port|Destination|Port|Gateway|Description|
|---|---|---|---|---|---|---|
|IPv4 * |VPN_CA subnets| * |!IPv4PrivateNetworks| * |wg_ca_gw|Allow access to internet and block access to private networks|
|IPv4+6 * |VPN_CA subnets| * | * | * | * |default - last match|

## Services
### DNS Resolver
#### General settings:
| | |
|---|---|
|`Enable`| :white_check_mark: `Enable DNS resolver`|
|`Network Interfaces`| select localhost + all local/vlan interfaces|
|`Outgoing Network Interfaces`| select `WAN/PPPoE`|
|`Strict Outgoing Network Interface Binding`| :white_check_mark: `Do not send recursive queries if none of the selected Outgoing Network Interfaces are available.`|
|`DNSSEC`| :white_check_mark: `enable DNSSEC Support`|
|`DNS Query Forwarding`|<code>
:white_check_mark: `Enable Forwarding Mode` <br/>
:white_check_mark: `Use SSL/TLS for outgoing DNS Queries to Forwarding Servers` <br/>
</code>|
|`Custom options`|<code>
server:
module-config: "respip validator iterator"

include: "/usr/local/etc/unbound/custom_server.conf"

include: "/usr/local/etc/unbound/custom_auth_zones.conf"
</code>
```
```
|

# Wireguard VPN

Sample Wireguard configuration fromProtonvpn <br/>
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
Go to VPN → WireGuard → Tunnels and create a new tunnel with the following settings. <br/>

#### Tunnel configuration:
| | |
|---|---|
|`Description`| Choose a suitable description|
|`Listen port`| 51820|
|`Interface Keys`| Private key from the configuration file (see above)|
|`Public key`| This will be automatically generated|

#### Interface configuration:

| | |
|---|---|
|`Interface Addresses`| 10.2.0.2/32|
Click *Save* Tunnel when done. <br/>


## Add peer
#### Peer Configuration:
| | |
|---|---|
|`Enable`| :white_check_mark: `Enable`|
|`Tunnel`| the tunnel created in the previous step|
|`Description`| choose a descriptive name, for example, the server name|
|`Dynamic Endpoint`| uncheck|
|`Endpoint`| endpoint IP address from your downloaded WireGuard configuration|
|`Port`| 51820|
|`Keep Alive`| 25|
|`Public Key`| public key from your downloaded WireGuard configuration file (see above)|

#### Address Configuration:
| | |
|---|---|
|`Allowed IPs`| 0.0.0.0/0|
Click *Save* Peer when done. <br/>




