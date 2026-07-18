# OPNSense Wireguard configuration

<h1>Introduction</h1>

<a href="https://docs.opnsense.org/manual/how-tos/wireguard-client.html" target="_blank" rel="noopener">Opnsense: WireGuard Road Warrior Setup</a>
<br>
<a href="https://docs.opnsense.org/manual/how-tos/wireguard-selective-routing.html" target="_blank" rel="noopener">Opnsense: WireGuard selective routing</a>


<div>
<p>
<mark>
There is no need to configure IPs on the interface. The tunnel address(es) specified in the Instance configuration for your server will be automatically assigned to the interface once WireGuard is restarted
</mark>
</p>
</div>

<div>
<p>
WireGuard is a simple, fast VPN protocol using modern cryptography. It aims to be faster and less complex than IPsec whilst also being a considerably more performant alternative to OpenVPN. Initially released for the Linux kernel, it is now cross-platform and widely deployable.

<p>
</p>
This how-to describes setting up a central WireGuard Instance (server) on OPNsense and configuring one or more client peers to create a tunnel to it.

</p>
</div>


<div>

<h1>Step 1 - Wireguard Instance</h1>
<p>Go to `VPN` ‣ `WireGuard` ‣ `Instances`</p>
<p>Click + to add a new Instance configuration</p>
<p>Configure the Instance configuration as follows (if an option is not mentioned below, leave it as the default):</p>

<table>
  <tr>
    <th style="background-color: lightblue;">Enabled</th>
    <td>Checked</td>
  </tr>
  <tr>
    <th style="background-color: lightblue;">Name</th>
    <td>surfshark_us</td>
  </tr>
  <tr>
    <th style="background-color: lightblue;">Public Key</th>
    <td>From provider conf [Credentials].PublicKey</td>
  </tr>
  <tr>
    <th style="background-color: lightblue;">Private Key</th>
    <td>From provider conf [Credentials].PrivateKey</td>
  </tr>
  </tr>
  <tr>
    <th style="background-color: lightblue;">Listen Port</th>
    <td>51821 or a higher numbered unique port</td>
  </tr>
  <tr>
    <th style="background-color: lightblue;">DNS Server</th>
    <td>Leave this blank, otherwise WireGuard will overwrite OPNsense’s DNS configuration</td>
  </tr>
  <tr>
    <th style="background-color: lightblue;">MTU</th>
    <td>1420 (default) or 1412 if you use PPPoE; it’s 80 bytes less than your WAN MTU</td>
  </tr>
  <tr>
    <th style="background-color: lightblue;">Tunnel Address</th>
    <td>VPN tunnel IP provided by your VPN provider, e.g. <b>10.14.5.2/32</b></td>
  </tr>
  <tr>
    <th style="background-color: lightblue;">Peers</th>
    <td>leave it blank initially until the Peer configuration is created in Step 2</td>
  </tr>
  <tr>
    <th style="background-color: lightblue;">Disable Routes</th>
    <td>Checked</td>
  </tr>
  <tr>
    <th style="background-color: lightblue;">Gateway</th>
    <td>Specify an IP that is 1 number below your VPN tunnel IP, e.g.<b>10.14.5.1</b></td>

</table>

<p>Save the Instance configuration, and then click Save again</p>

</div>


<div>
<h1>Step 2 - Configure the peer</h1>
<p>Go to VPN ‣ WireGuard ‣ Peers</p>
<p>Click + to add a new Peer</p>
<p>Configure the Peer as follows (if an option is not mentioned below, leave it as the default):</p>

<table>
  <tr>
    <th style="background-color: lightblue;">Enabled</th>
    <td>Checked</td>
  </tr>
  <tr>
    <th style="background-color: lightblue;">Name</th>
    <td>us-buffalo</td>
  </tr>
  <tr>
    <th style="background-color: lightblue;">Public Key</th>
    <td>From provider conf [Interface].PublicKey</td>
  </tr>
  <tr>
    <th style="background-color: lightblue;">Endpoint Address</th>
    <td>From provider. e.g. us-buf.prod.surfshark.com</td>
  </tr>
  <tr>
    <th style="background-color: lightblue;">Endpoint Address</th>
    <td>From provider. e.g. 51280</td>
  </tr>
  <tr>
    <th style="background-color: lightblue;">Allowed IPs</th>
    <td>0.0.0.0./0 - allow all</td>
  </tr>
  <tr>
    <th style="background-color: lightblue;">Instances</th>
    <td>From step 1; i.e. surfshark_us</td>
  </tr>
  <tr>
    <th style="background-color: lightblue;">Keep alive</th>
    <td>25</td>
  </tr>
</table>
<p>Save the Peer configuration, and then click Apply</p>
<p>Now go back to VPN ‣ WireGuard ‣ Instances</p>
<p>Open the Instance configuration that was created in Step 1</p>
<p>In the Peers dropdown, select the newly created Peer</p>
<p>Save the Instance configuration again, and then click Apply</p>
<p>Repeat this Step 2 for as many clients as you wish to configure</p>

</div>


<div>
<h1>Step 3 - Turn on/restart WireGuard</h1>
Turn on WireGuard under VPN ‣ WireGuard ‣ General if it is not already on (click Apply after checking the checkbox)
<br>
Otherwise, restart WireGuard - you can do this by turning it off and on under VPN ‣ WireGuard ‣ General (click Apply after both unchecking and checking the checkbox)

</div>

<div>
<h1>Step 4 - Assign an interface to WireGuard</h1>

<p>Go to Interfaces ‣ Assignments</p>
<p>In the dropdown next to “New interface:”, select the WireGuard device (wg1 if this is your first one)</p>
<p>Add a description (eg surfshark_us)</p>
<p>Click + to add it, then click Save</p>
<p>Then select your new interface under the Interfaces menu</p>
<p>Configure it as follows (if an option is not mentioned below, leave it as the default):</p>

<table>
<tr>
<th style="background-color: lightblue;">Enable</th>
<td>Checked</td>
</tr>
<tr>
<th style="background-color: lightblue;">Lock</th>
<td>Checked</td>
</tr>
<tr>
<th style="background-color: lightblue;">Description</th>
<td>surfshark_us</td>
</tr>
<tr>
<th style="background-color: lightblue;">IPv4 Configuration Type</th>
<td>None</td>
</tr>
<tr>
<th style="background-color: lightblue;">IPv6 Configuration Type</th>
<td>None</td>
</tr>


</table>


</div>

<div>
<h1>Step 5 - Restart WireGuard</h1>
<p>Now restart WireGuard - you can do this from the Dashboard (if you have the services widget) or by turning it off and on under VPN ‣ WireGuard ‣ General</p>
</div>

<div>
<h1>Step 6 - Create a gateway</h1>

<p>Go to System ‣ Gateways ‣ Configuration</p>
<p>Click Add</p>
<p>Configure the gateway as follows (if an option is not mentioned below, leave it as the default):</p>

<table>
<tr>
<th style="background-color: lightblue;">Name</th>
<td>WG_VN</td>
</tr>
<tr>
<th style="background-color: lightblue;">Description</th>
<td>Add one if you wish to</td>
</tr>
<tr>
<th style="background-color: lightblue;">Interface</th>
<td>Select the interface in step 4</td>
</tr>
<tr>
<th style="background-color: lightblue;">Address Family</th>
<td>Select IPv4 in the dropdown</td>
</tr>
<tr>
<th style="background-color: lightblue;">IP address</th>
<td>Gateway IP in step 2, e.g. <b>10.14.5.1</b></td>
</tr>
<tr>
<th style="background-color: lightblue;">Far Gateway</th>
<td>Checked</td>
</tr>
<tr>
<th style="background-color: lightblue;">Disable Gateway Monitoring</th>
<td>Unchecked</td>
</tr>
<tr>
<th style="background-color: lightblue;">Monitor IP</th>
<td>Insert the endpoint VPN tunnel IP (NOT the public IP) of your VPN provider</td>
</tr>
</table>
</div>


<div>
<h1>Step 7 - Create an outbound NAT rule</h1>

<p>Go to Firewall ‣ NAT ‣ Outbound</p>
<p>Select “Hybrid outbound NAT rule generation” if it is not already selected, and click Save and then Apply changes</p>
<p>Click Add to add a new rule</p>
<p>Configure the rule as follows (if an option is not mentioned below, leave it as the default):</p>

<table>
<th style="background-color: lightblue;">Interface</th>
<td>surfshark_us</td>
</tr>
<tr>
<th style="background-color: lightblue;">TCP/IP Version</th>
<td>IPv4 or IPv6 (as applicable)</td>
</tr>
<tr>
<th style="background-color: lightblue;"> Protocol </th>
<td> any </td>
</tr>
<tr>
<th style="background-color: lightblue;"> Source invert </th>
<td> Unchecked </td>
</tr>
<tr>
<th style="background-color: lightblue;"> Source address </th>
<td> Select a local interface, e.g. <b>VPN net</b></td>
</tr>
<tr>
<th style="background-color: lightblue;"> Source port </th>
<td> any </td>
</tr>
<tr>
<th style="background-color: lightblue;"> Destination invert </th>
<td> Unchecked </td>
</tr>
<tr>
<th style="background-color: lightblue;"> Destination address </th>
<td> any </td>
</tr>
<tr>
<th style="background-color: lightblue;"> Destination port </th>
<td> any </td>
</tr>
<tr>
<th style="background-color: lightblue;"> Translation / target </th>
<td> Interface address </td>
</tr>
<tr>
<th style="background-color: lightblue;"> Description </th>
<td> NAT:WG </td>
</tr>

</table>
</div>

<div>

<h1>Step 8 - Create normalization rules</h1>

<p>Go to Firewall ‣ Settings -> Normalization and press + to create one new normalization rule.</p>
<p>If you only pass IPv4 traffic through the wireguard tunnel, create the following rule:</p>

<table>
<th style="background-color: lightblue;">Interface</th>
<td>WireGuard (Group)</td>
<tr>
<th style="background-color: lightblue;">Direction</th>
<td>Any</td>
</tr>
<tr>
<th style="background-color: lightblue;">Protocol</th>
<td>any</td>
</tr>
<tr>
<th style="background-color: lightblue;">Source</th>
<td>any</td>
</tr>
<tr>
<th style="background-color: lightblue;">Destination</th>
<td>any</td>
</tr>
<tr>
<th style="background-color: lightblue;">Destination port</th>
<td>any</td>
</tr>
<tr>
<th style="background-color: lightblue;">Description</th>
<td>Wireguard MSS Clamping IPv4</td>
</tr>
<tr>
<th style="background-color: lightblue;">Max mss</th>
<td>1380 (default) or 1372 if you use PPPoE; it’s 40 bytes less than your Wireguard MTU</td>
</tr>


<table>
</div>

<div>
<h1> Step 9 - Firewall rule - Wireguard group</h1>

<p>Go to Firewall ‣ rules ‣ Wireguard Group</p>

<table>
<th style="background-color: lightblue;">Action</th>
<td>Pass</td>
<tr>
<th style="background-color: lightblue;"> Quick </th>
<td> Checked </td>
</tr>
<tr>
<th style="background-color: lightblue;"> Interface </th>
<td> Wireguard Group </td>
</tr>
<tr>
<th style="background-color: lightblue;"> Direction </th>
<td> in </td>
</tr>
<tr>
<th style="background-color: lightblue;"> TCP/IP Version </th>
<td> IPv4 </td>
</tr>
<tr>
<th style="background-color: lightblue;"> Protocol </th>
<td> any </td>
</tr>
<tr>
<th style="background-color: lightblue;"> Source / Invert </th>
<td> Unchecked </td>
</tr>
<tr>
<th style="background-color: lightblue;"> Source </th>
<td> Select the relevant hosts Alias, e.g. WG_tunnels: 10.0.0.0/8, 10.14.0.0/16 </td>
</tr>
<tr>
<th style="background-color: lightblue;"> Destination / Invert </th>
<td> Checked </td>
</tr>
<tr>
<th style="background-color: lightblue;"> Destination </th>
<td> any </td>
</tr>
<tr>
<th style="background-color: lightblue;"> Destination port range </th>
<td> any </td>
</tr>
<tr>
<th style="background-color: lightblue;"> Description </th>
<td> Allow WireGuard group Internet access </td>
</tr>
<tr>
<th style="background-color: lightblue;"> Gateway </th>
<td> Default </td>
</tr>

</table>

</div>


</body>
<html>
