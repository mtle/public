# OPNSense Wireguard configuration

<a href="https://docs.opnsense.org/manual/how-tos/wireguard-client.html" target="_blank" rel="noopener">Opnsense: WireGuard Road Warrior Setup</a>
<br>
<a href="https://docs.opnsense.org/manual/how-tos/wireguard-selective-routing.html" target="_blank" rel="noopener">Opnsense: WireGuard selective routing</a>
<br>
<a href="https://www.youtube.com/watch?v=5baIK2nIkvA" target="_blank" rel="noopener">YT:Surfshark WireGuard setup</a>


<div>

<h1>Wireguard setup</h1>
<h2>Step 1 - Wireguard Instance</h2>
<p>Go to VPN ‣ WireGuard ‣ Instances</p>
<p>Click + to add a new Instance configuration</p>
<p>Configure the Instance configuration as follows (if an option is not mentioned below, leave it as the default):</p>

<table>
  <caption>Table: wireguard instance</caption>
  <tr>
    <th style="background-color: lightblue;">Enabled</th>
    <td>&#x2705;</td>
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
    <td>VPN tunnel IP provided by your VPN provider, e.g. <b>10.14.5.2/16</b></td>
  </tr>
  <tr>
    <th style="background-color: lightblue;">Peers</th>
    <td>leave it blank initially until the Peer configuration is created in Step 2</td>
  </tr>
  <tr>
    <th style="background-color: lightblue;">Disable Routes</th>
    <td>&#x2705;</td>
  </tr>
  <tr>
    <th style="background-color: lightblue;">Gateway</th>
    <td>Specify an IP that is 1 number below your VPN tunnel IP, e.g.<b>10.14.5.1</b></td>

</table>

<p>Save the Instance configuration, and then click Save again</p>

</div>


<div>
<h2>Step 2 - Wireguard Peer</h2>
<p>Go to VPN ‣ WireGuard ‣ Peers</p>
<p>Click + to add a new Peer</p>
<p>Configure the Peer as follows (if an option is not mentioned below, leave it as the default):</p>

<table>
  <caption>Table: wireguard peer</caption>
  <tr>
    <th style="background-color: lightblue;">Enabled</th>
    <td>&#x2705;</td>
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
<h3>Enable WireGuard</h3>
Turn on WireGuard under VPN ‣ WireGuard ‣ General if it is not already on (click Apply after checking the checkbox)
<br>
Otherwise, restart WireGuard - you can do this by turning it off and on under VPN ‣ WireGuard ‣ General (click Apply after both unchecking and checking the checkbox)

</div>

<div>
<h2>Step 3 - Assign an interface to WireGuard, <mark>wgX</mark></h2>

<p>Go to Interfaces ‣ Assignments</p>
<p>In the dropdown next to “New interface:”, select the WireGuard device (wg1 if this is your first one)</p>
<p>Add a description (eg <em>surfshark_us_if</em>)</p>
<p>Click + to add it, then click Save</p>
<p>Then select your new interface under the Interfaces menu</p>
<p>Configure it as follows (if an option is not mentioned below, leave it as the default):</p>

<table>
<caption>Table: Interface assignment</caption>
<tr>
<th style="background-color: lightblue;">Enable</th>
<td>&#x2705;</td>
</tr>
<tr>
<th style="background-color: lightblue;">Lock</th>
<td>&#x2705;</td>
</tr>
<tr>
<th style="background-color: lightblue;">Description</th>
<td>surfshark_us_if</td>
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
<h2>Step 4 - Restart WireGuard</h2>
<p>Now restart WireGuard - you can do this from the Dashboard (if you have the services widget) or by turning it off and on under VPN ‣ WireGuard ‣ General</p>
</div>

<div>
<h2>Step 5 - Create a gateway</h2>

<p>Go to System ‣ Gateways ‣ Configuration</p>
<p>Click Add</p>
<p>Configure the gateway as follows (if an option is not mentioned below, leave it as the default):</p>

<table>
<caption>Table: Gateway creation</caption>
<tr>
<th style="background-color: lightblue;">Name</th>
<td>ss_us_gw</td>
</tr>
<tr>
<th style="background-color: lightblue;">Description</th>
<td>surfshark us gw</td>
</tr>
<tr>
<th style="background-color: lightblue;">Interface</th>
<td>Select the interface in step 3</td>
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
<td>&#x2705;</td>
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

<h1>Firewall</h1>

<div>
<h2>Step 6 - Source NAT rule</h2>

<p>Go to Firewall ‣ NAT ‣ Source NAT</p>
<p>Mode: Select “Hybrid outbound NAT rule generation” if it is not already selected. Click Apply</p>
<p>Click Add to add a new rule</p>
<p>Configure the rule as follows (if an option is not mentioned below, leave it as the default):</p>

<table>
<caption>Table: Source NAT rule</caption>
<tr>
<th style="background-color: lightblue;">Enable</th>
<td>&#x2705;</td>
</tr>
<tr>
<th style="background-color: lightblue;">Categories</th>
<td>vpn</td>
</tr>
<tr>
<th style="background-color: lightblue;">Description</th>
<td>wg source NAT</td>
</tr>
<tr>
<th style="background-color: lightblue;">Interface</th>
<td>select the <mark>WAN interface</mark></td>
</tr>
<tr>
<th style="background-color: lightblue;">TCP/IP Version</th>
<td><mark>IPv4</mark></td>
</tr>
<tr>
<th style="background-color: lightblue;"> Protocol </th>
<td> any </td>
</tr>
<tr>
<th style="background-color: lightblue;">Invert Source</th>
<td> Unchecked </td>
</tr>
<tr>
<th style="background-color: lightblue;"> Source address </th>
<td> Select a <mark>WG</mark> interface, e.g. <b>wg_vn network</b></td>
</tr>
<tr>
<tr>
<th style="background-color: lightblue;">Invert Destination</th>
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
<th style="background-color: lightblue;"> Translation Source IP</th>
<td>select <mark>WAN address</mark></td>
</tr>
<tr>
<th style="background-color: lightblue;"> Translation Source Port</th>
<td>any</td>
</tr>

</table>
</div>

<div>

<h2>Step 7 - Create normalization rule - Optional</h2>

<p>Go to Firewall ‣ Settings -> Normalization and press + to create one new normalization rule.</p>
<p>If you only pass IPv4 traffic through the wireguard tunnel, create the following rule:</p>

<table>
<caption>Table: Nornamilzation rule</caption>
<tr>
<th style="background-color: lightblue;">Interface</th>
<td>WireGuard (Group)</td>
</tr>
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


</table>
</div>

<div>
<h2> Step 8 - Local Interface rule</h2>

<p>Go to Firewall ‣ Rules ‣ Interface - e.g. <mark><b>vn</b></mark></p>

<table>
<caption>Table: Local IF rule to route traffic</caption>
<tr>
<th style="background-color: lightblue;">Enable</th>
<td> &#x2705; </td>
</tr>
<tr>
<th style="background-color: lightblue;">Categories</th>
<td>all</td>
</tr>
<tr>
<th style="background-color: lightblue;">Description</th>
<td>Allow access to internet and block access to private networks</td>
</tr>
<tr>
<th style="background-color: lightblue;">Invert Interface </th>
<td>unchecked</td>
</tr>
<tr>
<th style="background-color: lightblue;"> Interface </th>
<td>select a local interface, e.g. <mark>vn</mark></td>
</tr>
<tr>
<th style="background-color: lightblue;"> Quick </th>
<td> &#x2705; </td>
</tr>
<tr>
<th style="background-color: lightblue;">Action</th>
<td>Pass</td>
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
<td>Select a local network or a host Alias, e.g. <mark>vn network</mark> or <mark>192.168.5.0/24, 192.168.7.0/24</mark></td>
</tr>
<tr>
<th style="background-color: lightblue;"> Destination / Invert </th>
<td> &#x2705; </td>
</tr>
<tr>
<th style="background-color: lightblue;"> Destination </th>
<td>select alias <mark>RFC1918_network</mark></td>
</tr>
<tr>
<th style="background-color: lightblue;"> Destination port range </th>
<td> any </td>
</tr>
<tr>
<th style="background-color: lightblue;"> Gateway </th>
<td>select <mark>wg_gw_X</mark></td>
</tr>

</table>

<h2> Step 9. Routing for traffic generated by the router - Optional</h2>
<p>Services running on the router and configured to use the VPN interface must have their traffic routed to the VPN gateway in order to use the VPN. Note that locally generated traffic is not affected by NAT or by the firewall rule created in Step 7.</p>

<p>Go to Firewall ‣ Rules ‣ Floating</p>

<p>Click Add to add a new rule</p>

<p>Configure the rule as follows (if an option is not mentioned below, leave it as the default). You need to click the Show/Hide button next to “Advanced Options” to reveal the last setting:</p>

<table>
<caption>Table: Rule for router services</caption>
<tr>
<th style="background-color: lightblue;">Enable</th>
<td> &#x2705; </td>
</tr>
<tr>
<th style="background-color: lightblue;">Categories</th>
<td>vpn</td>
</tr>
<tr>
<th style="background-color: lightblue;">Description</th>
<td>routing for traffic generated by the router</td>
</tr>
<tr>
<th style="background-color: lightblue;">Invert Interface </th>
<td>unchecked</td>
</tr>
<tr>
<th style="background-color: lightblue;"> Interface </th>
<td><mark>select nothing</mark></td>
</tr>
<tr>
<th style="background-color: lightblue;"> Quick </th>
<td>unchecked</td>
</tr>
<tr>
<th style="background-color: lightblue;">Action</th>
<td>Pass</td>
</tr>
<tr>
<th style="background-color: lightblue;"> Direction </th>
<td><mark>out</mark></td>
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
<td>Select a WG network, e.g. <mark>wg_vn address</mark></td>
</tr>
<tr>
<th style="background-color: lightblue;"> Destination / Invert </th>
<td> &#x2705; </td>
</tr>
<tr>
<th style="background-color: lightblue;"> Destination </th>
<td>Select a WG network, e.g. <mark>wg_vn network</mark></td>
</tr>
<tr>
<th style="background-color: lightblue;"> Destination port range </th>
<td> any </td>
</tr>
<tr>
<th style="background-color: lightblue;"> Gateway </th>
<td>select <mark>wg_gw_X</mark></td>
</tr>
</table>

<b>Save</b> the rule, and then click <b>Apply Changes</b>

</div>


</body>
<html>
