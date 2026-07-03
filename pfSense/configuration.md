# Basic System Configuration:

## System
### General setup
`hostname` : `fw`
`domain` : `linkon.dedyn.io`

#### DNS server settings:
`DNS servers` : `1.1.1.3 9.9.9.9`
`override DNS`: `uncheck`
`DNS Resolution Behavior`: `Use local, ignore remote`

#### Localization:
`Timezone`: select `UTC`
`Timeservers`: add `ntp1.torix.ca time.nrc.ca`

#### webConfigurator:
Default

### Advanced
#### Admin Access:
`Protocol`: select `https`
`ssh`: `enable`
`sshd key only`: `public key only`

#### Networking:
`Use if_pppoe kernel module for PPPoE client`: check `Use if_pppoe kernel module for PPPoE client`

#### Miscellaneous:
`PowerD`: enable
`AC power`: `hiadaptive`
`Battery power`: `hiadaptive`
`Unknown power`: `hiadaptive`
`Cryptographic Hardware`: `AES-NI CPU based acceleration`
`Thermal Sensors`: `* cpu ondie thermal sensor`
`Use RAM Disks`: check `Use memory file system for /tmp and /var`
`RAM Disk Size`: set [1024] `/tmp`, and [4096] `/var`

## Interfaces
### VLANs:
`Interfaces` -> `Assignment` -> `VLANs`: Add

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
|safe_ifs|LAN, VPN_CA, VPN_VN|safe_interfaces|
|local_ifs|LAN, VPN_CA, VPN_VN, PUB, IOT||


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
Select `Firewall` -> `Rules` -> `local_ifs`
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
`Enable`: :white_check_mark: `Enable DNS resolver`
`Network Interfaces`: select localhost + all local/vlan interfaces
`Outgoing Network Interfaces`: select `WAN/PPPoE`
`Strict Outgoing Network Interface Binding`: check `Do not send recursive queries if none of the selected Outgoing Network Interfaces are available.`
`DNSSEC`: check `enable DNSSEC Support`
`DNS Query Forwarding`:
:white_check_mark: `Enable Forwarding Mode`
:white_check_mark: `Use SSL/TLS for outgoing DNS Queries to Forwarding Servers`

