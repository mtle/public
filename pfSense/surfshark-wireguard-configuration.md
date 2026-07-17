# Wireguard VPN

#### Sample Wireguard configuration
```
Address = 10.14.0.2/16
# PublicKey = CJvM8d66sFEh5VlvMLahh+9kui8VKngCp4E/fZkgoiM=
DNS = 162.252.172.57, 149.154.159.92
[Peer]
PublicKey = W9bzkcL3fiV64vDpB4pbrz8QafNn3y5P9Yc/kQvy4TA=
AllowedIPs = 0.0.0.0/0
Endpoint = ca-tor.prod.surfshark.com:51820
```

## 1. Add tunnel
Go to **VPN** → **WireGuard** → **Tunnels** and create a new tunnel with the following settings.

#### Tunnel configuration

|Field|Value|
|---|---|
|`Description`| tun_ca|
|`Listen port`| 51820 *change to a different number if needed*|
|`Interface Keys`| [Enter private key](#Sample-Wireguard-configuration)|
|`Public key`| This will be automatically generated|

#### Interface configuration
[See](#Create-a-WireGuard-interface)

Click **Save** Tunnel when done.


## 2. Add peer
#### Peer Configuration

|Field|Value|
|---|---|
|`Enable`| :white_check_mark: `Enable`|
|`Tunnel`| [tun_ca](#Tunel_Configuration)|
|`Description`| e.g. peer_ca |
|`Dynamic Endpoint`| uncheck|
|`Endpoint`| [endpoint IP from VPN provider configuration file](#Sample-Wireguard-configuration)|
|`Port`| 51820|
|`Keep Alive`| 25|
|`Public Key`| [public key from VPN provider configuration file](#Sample-Wireguard-configuration)|

#### Address Configuration

|Field|Value|
|---|---|
|`Allowed IPs`| 0.0.0.0/0|

Click **Save** Peer when done.

### 2.1 Enable Wireguard
Go to the **Settings** tab, check **Enable WireGuard**, then click **Save** and **Apply Changes**.<br/>

## 3. Create a WireGuard interface
The VPN client is now running, but no traffic is being routed through it. <br/>
Configure the Interfaces and Firewall rules to route network traffic through the VPN tunnel. <br/>

Go to **Interfaces** → **Interface Assignments** → **Available network ports** and select tun_wg? → Add. <br/>

This will create an interface named `OPTx`. Click on the newly created one to configure it.

##### General configuration
|Field|Value|
|---|---|
|Enable|:white_check_mark: Enable interface|
|Description| *WG_ca* |
|IPv4 Configuration Type|Static IPv4|
|IPv6 Configuration Type|None|
|MTU|1432 *see* [^1]|
|IPv4 Address|10.14.5.2/32|
|IPv4 Upstream gateway| Click `Add a New GW` and enter `name=wg_ca_gw` `IP=10.14.5.2 (same as interface addr)`|

>[!TIP]: consider setting local interface `MTU` to the same value.
> [what is mss](https://www.cloudflare.com/learning/network-layer/what-is-mss/)

>[!NOTE]: On WANs with `1500` byte *MTUs*, the *MTU* for *WireGuard* interfaces should be `1420` for *VPNs* carrying *IPv6* packets, or `1440` for *IPv4* traffic. <br/>
> On *PPPoE WAN* type, set IPv4 *MTU* to `1432`.

Click **Save** and **Apply**.

## 4. Add a new gateway
[!NOTE]: GW was added in [General configuration:Upstream gw](#general-configuration)

Go to **System** → **Routing** → **Gateways** and click **Add** to add a new gateway.

[!TIP]: uncheck `Gateway Monitoring` and set `Monitor IP`

[!WARNING]: DO not set
|Field|Value|
|--- |--- |
|*Use non-local gateway*| :white_check_mark: *Use non-local gateway through interface specific route*|

Click **Save** and **Apply Changes**.

##### Table: Gateways
|Name|Default|Interface|Gateway|Monitor IP|Description|
|---|---|---|---|---|---|
|WAN_DHCP| |WAN|dynamic|dynamic|Interface WAN_DHCP Gateway|
|proton_gw| |PROTON|10.2.11.1|149.22.81.28|proton ca-free gw|
|wg_ca_gw| |WG_CA|10.14.5.1|149.154.159.92|wireguard ca gw|

## 5. Firewall
### 5.1 Outbound NAT
#### Set Outbound NAT Mode to **Hybrid** or **Manual**
**Firewall** → **NAT** → **Outbound** and select *Manual Outbound NAT rule generation* or *Hybrid Outbound NAT rule generation*. <br/>
Click **Save** and **Apply Changes**. <br/>


### 5.2 New Mappings
Under **Mappings** <br/>
1. **Delete** any NAT rules that allow local traffic to go out through the *WAN* interface
2. then **Add** new `Outbound NAT Entry:`

|Field|Value|
|---|---|
|Interface| select the interface |
|Source|`Network or Alias` -> choose one in `192.168.x.y` |

##### Table: Outbound NAT Mapping
|Interface|Source|Source Port|Destination|Destination Port|NAT Address|NAT Port|Static Port|Description|
|---|---|---|---|---|---|---|---|---|
|WAN|127.0.0.0/8| * | * |500 (ISAKMP)|WAN address| * | |Auto created rule for ISAKMP - localhost to WAN
|WG_ca|192.168.11.0/24|*|*|500 (ISAKMP)|WG_ca address|*| |WG_ca to WAN|
|WG_ca|192.168.11.0/24|*|*|*|WG_ca address|*| |WG_ca to WAN|

[!IMPORTANT]: Use the `WG*` interface address **NOT** `WAN` address

### 5.3 Interface rules

#### WG Interface gateway
`Interface` -> select the WG interface created in [*Create a WireGuard interface*](#Create-a-WireGuard-interface)
|Static IPv4 Configuration| |
|IPv4 Upstream gateway| select the GW in [*Add a new gateway*](#Add-a-new-gateway) |

#### Local interface rule
**Firewall** → **Rules** → **if/vlan_if** → **Allow to Internet rule** → **Edit (pencil icon)**. <br/>
Click **Display advanced** → **Gateway** and select the gateway created in [**Add a new gateway**](#Add-a-new-gateway). <br/>
Click **Save** and **Apply Changes**. <br/>

## 6. Static routes
Navigate to **System** > **Routing** > **Static routes** tab.
1. Click the Add button and configure the routes as follows:
`Destination network: The IP address of the WireGuard server - 10.2.0.2(proton)/10.14.5.2(surfshark)`
2. Gateway: WAN gateway.
3. Description (not necessary) - WAN to VPN, for example. In our case, we left it blank.

#### Sample Static Routes
|Field|Value|
|Network|Gateway|Interface|Description|
|---|---|---|---|
|10.14.0.0/16|WAN_DHCP - 192.168.11.2|WAN|Route to surfshark GW|

[!NOTE]: to set the `WG GW` as default
Navigate to **System** >** Routing** >** Gateways** tab and set Default gateway IPv4 to the one we configured previously (in the dropdown menu). <br/>
Click **Save** and **Apply change**s.


## 7. DNS Settings
All internet traffic passing through the pfSense firewall will now be routed through the VPN server. However, DNS requests are not. To fix this, we need to change the DNS settings in pfSense. <br/>

In pfSense, go to **System** → **General setup** → **DNS Server Settings** and configure the following settings:

|Field|Value|
|---|---|
|DNS Servers| 10.2.0.1 [*see here*](#Static-IPv4-configuration)|
|Gateway| the name of the gateway we configured in [*Add a new gateway*](#add-a-new-gateway)|
|DNS Server Override| unchecked|

Click **Save**.

Now go to **Services** → **DNS Resolver** → **General Settings** and change the following:

|Field|Value|
|---|---|
|Outgoing Network Interfaces| [WG_ca](#Create-a-Wireguard_interface)|
|DNS Query Forwarding| check Enable Forwarding mode|
Click **Save** and **Apply Changes**.

## 8. VPN kill switch (Optional)

### Add a new `reject` rule: <br/>
**Firewall** -> **Rules** -> **floating** -> **Add** <br/>
|`Action`| `Reject`|
|`Quick`|:white_check_mark:|
|`Interface`| `WAN`|
|`Direction`| `any`|
|`Address Family`| `IPv4` (or IPv4 + IPv6)|
|`Protocol`| `any`|
|`Source`| `any`|
|`Destination`| `any`|
|`Description`|enter a description for your rule (optional)|
Click **Save**.

### Add a new `pass` rule: <br/>
**Firewall** -> **Rules** -> **floating** -> **Add** <br/>
|`Action`| `Pass`|
|`Quick`|:white_check_mark:|
|`Interface`| `WAN`|
|`Direction`|`any`|
|`Address Family`| `IPv4` (or IPv4 + IPv6)|
|`Protocol`| `any`|
|`Source`| `any`|
|`Destination`| drop-down menu to `Single host or alias` -> `10.14.5.2` (IP of WireGuard “server”)|
|`Description`| enter a description for your rule (optional)|

Click **Save**.

## Referenes:
[comparitech:pfsense-wireguard-setup](https://www.comparitech.com/blog/vpn-privacy/pfsense-wireguard-setup/)
=== DONE ===
