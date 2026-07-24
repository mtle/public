<div>
<h1>OPNSense Wireguard configuration</h1>

<p><a href="https://docs.opnsense.org/manual/how-tos/wireguard-client.html" target="_blank" rel="noopener">Opnsense: WireGuard Road Warrior Setup</a></p>

<p><a href="https://docs.opnsense.org/manual/how-tos/wireguard-selective-routing.html" target="_blank" rel="noopener">Opnsense: WireGuard selective routing</a></p>

<p><a href="https://www.youtube.com/watch?v=5baIK2nIkvA" target="_blank" rel="noopener">YT:Surfshark WireGuard setup</a></p>
</div>

<!-- WG setup -->
<div>
<h1 id="wg">I. Wireguard setup</h1>

<div>
<h2 id="wg_inst">1 - Instance</h2>
<p>Go to VPN ‣ WireGuard ‣ Instances</p>
<p>Click + to add a new Instance configuration</p>
<p>Configure the Instance configuration as follows (if an option is not mentioned below, leave it as the default):</p>

<div>
<table id="tbl_inst">
  <caption>Table: wireguard instance</caption>
  <tr>
    <th style="background-color: lightblue;">Enabled</th>
    <td>&#x2705;</td>
  </tr>
  <tr>
    <th style="background-color: lightblue;">Name</th>
    <td>wg_us</td>
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
    <td>1420 (default) or 1412 if WAN type is PPPoE; it’s 80 bytes less than the WAN MTU</td>
  </tr>
  <tr>
    <th style="background-color: lightblue;">Tunnel Address</th>
    <td><em>10.14.5.2/32</em> - VPN tunnel IP provided by the VPN provider</td>
  </tr>
  <tr>
    <th style="background-color: lightblue;">Peers</th>
    <td>leave it blank initially until the Peer configuration is created</td>
  </tr>
  <tr>
    <th style="background-color: lightblue;">Disable Routes</th>
    <td>&#x2705;</td>
  </tr>
  <tr>
    <th style="background-color: lightblue;">Gateway</th>
    <td><em>10.14.5.1</em> - an IP that is 1 number below the VPN tunnel IP</td>
  </tr>
</table>
</div>

<p><b>Save</b> the Instance configuration</p>
</div>


<div>
<h2 id="wg_peer">2 - Peer</h2>
<p>Go to VPN ‣ WireGuard ‣ Peers</p>
<p>Click + to add a new Peer</p>
<p>Configure the Peer as follows (if an option is not mentioned below, leave it as the default):</p>

<div>
<table id="tbl_peer">
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
    <td><em>51820</em> - From provider</td>
  </tr>
  <tr>
    <th style="background-color: lightblue;">Allowed IPs</th>
    <td>0.0.0.0./0 - allow all</td>
  </tr>
  <tr>
    <th style="background-color: lightblue;">Instances</th>
    <td><a href="#tbl_inst">Instance name</a></td>
  </tr>
  <tr>
    <th style="background-color: lightblue;">Keep alive</th>
    <td>25</td>
  </tr>
</table>
</div>

<p><b>Save</b> and <b>Apply</b></p>
<p>Now go back to VPN ‣ WireGuard ‣ Instances</p>
<p>Open the Instance configuration that was created in <a href="#wg_inst">Instance</a></p>
<p>In the Peers dropdown, select the newly created Peer</p>
<p>Save the Instance configuration again, and then click Apply</p>
<p>Repeat for as many clients as you wish to configure</p>
</div>


<div>
<h3>Enable WireGuard</h3>
<p>Turn on WireGuard under VPN ‣ WireGuard ‣ General if it is not already on (click Apply after checking the chckbox).</p>
<p>Otherwise, restart WireGuard.</p>
</div>
</div>

<!-- System settings -->
<div>
<h1 id="sys">II. System settings</h1>

<div>
<h2 id="sys_if">1 - Assign an interface to WireGuard, <mark>wgX</mark></h2>

<p>Go to Interfaces ‣ Assignments</p>
<p>In the dropdown next to “New interface:”, select the WireGuard device (wg1 if this is your first one)</p>
<p>Add a description (eg <em>wg_us_if</em>)</p>
<p>Click + to add it, then click Save</p>
<p>Then select your new interface under the Interfaces menu</p>
<p>Configure it as follows (if an option is not mentioned below, leave it as the default):</p>

<div>
<table id="tbl_if_assignment">
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
  <th style="background-color: lightblue;">Identifier</th>
  <td>optX</td>
</tr>
<tr>
  <th style="background-color: lightblue;">Device</th>
  <td>wgX</td>
<tr>
  <th style="background-color: lightblue;">Description</th>
  <td>wg_us_if</td>
</tr>
<tr>
  <th style="background-color: lightblue;">IPv4 Configuration Type</th>
  <td>None</td>
</tr>
<tr>
  <th style="background-color: lightblue;">IPv6 Configuration Type</th>
  <td>None</td>
</tr>
<tr>
  <th style="background-color: lightblue;">MTU</th>
  <td>1412</td>
</tr>
<tr>
  <th style="background-color: lightblue;">MSS</th>
  <td>1412</td>
</tr>
</table>
</div>
</div>

<div>
<h2 id="sys_gw">2 - Create a gateway</h2>

<p>Go to System ‣ Gateways ‣ Configuration</p>
<p>Click Add</p>
<p>Configure the gateway as follows:</p>

<div>
<table id="tbl_gw">
<caption>Table: Gateway creation</caption>
<tr>
  <th style="background-color: lightblue;">Name</th>
  <td>ss_us_gw</td>
</tr>
<tr>
  <th style="background-color: lightblue;">Description</th>
  <td>wg_us gw</td>
</tr>
<tr>
  <th style="background-color: lightblue;">Interface</th>
  <td>Select the interface in <a href="#sys_if">Assign WG interface </a>, <a href="#tbl_if_assignment">wg_us_if</a></td>
</tr>
<tr>
  <th style="background-color: lightblue;">Address Family</th>
  <td>Select IPv4 in the dropdown</td>
</tr>
<tr>
  <th style="background-color: lightblue;">IP address</th>
  <td>Gateway IP in <a href="#tbl_inst">Instance</a>, e.g. <b>10.14.5.1</b></td>
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
  <td>Insert the endpoint VPN tunnel IP, copy from <em>VPN</em>-><em>WireGuard</em>-><em>Status</em>-><em>EndPoint</em></td>
</tr>
</table>
</div>
</div>
</div>

<!-- FW config -->
<div>
<h1 id="fw">III. Firewall</h1>

<div>
<h2 id="fw_aliases">1 - Aliases</h2>
<p>Go to Firewall ‣ Aliases ‣ and <makr>ADD 2 new aliases</makr></p>

<div>
<table id="tbl_alias_rfc1918">
<caption>Table: RFC1918 IPv4 private networks</caption>
<tr>
  <th style="background-color: lightblue;">Enable</th>
  <td>&#x2705;</td>
</tr>
<tr>
  <th style="background-color: lightblue;">Name</th>
  <td>RFC1918_networks</td>
</tr>
<tr>
  <th style="background-color: lightblue;">Type</th>
  <td>networks</td>
</tr>
<tr>
  <th style="background-color: lightblue;">contents</th>
  <td><mark>10.0.0.0/8</mark> <mark>172.12.0.0/12</mark> <mark>192.168.0.0/16</mark></td>
</tr>
<tr>
  <th style="background-color: lightblue;">Description</th>
  <td>anything</td>
</tr>
</table>
</div>
<div>
<table id="tbl_alias_vpn">
<caption>Table: VPN networks</caption>
<tr>
  <th style="background-color: lightblue;">Enable</th>
  <td>&#x2705;</td>
</tr>
<tr>
  <th style="background-color: lightblue;">Name</th>
  <td>vpn_networks</td>
</tr>
<tr>
  <th style="background-color: lightblue;">Type</th>
  <td>networks</td>
</tr>
<tr>
  <th style="background-color: lightblue;">contents</th>
  <td><mark>192.168.0.0/20</mark></td>
</tr>
<tr>
  <th style="background-color: lightblue;">Description</th>
  <td></td>
</tr>
</table>
</div>
<div>
<table id="tbl_alias_wg_netorks">
<caption>Table: Provider WG networks</caption>
<tr>
  <th style="background-color: lightblue;">Enable</th>
  <td>&#x2705;</td>
</tr>
<tr>
  <th style="background-color: lightblue;">Name</th>
  <td>wg_networks</td>
</tr>
<tr>
  <th style="background-color: lightblue;">Type</th>
  <td>networks</td>
</tr>
<tr>
  <th style="background-color: lightblue;">contents</th>
  <td><mark>10.14.0.0/16</mark>, <mark>10.2.0.0/16</mark></td>
</tr>
<tr>
  <th style="background-color: lightblue;">Description</th>
  <td>surfshark and protonvpn</td>
</tr>
</table>
</div>
</div>


<div>
<h2 id="fw_srcnat">2 - Source NAT rule</h2>

<p>Go to Firewall ‣ NAT ‣ Source NAT</p>
<p>Mode: Select <mark>Hybrid outbound NAT rule generation</mark> if it is not already selected. Click Apply</p>
<p>Click Add to add a new rule</p>
<p>Configure the rule as follows:</p>

<div>
<table id="tbl_srcnat">
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
  <td>select <a href="#tbl_if_assignment"><em>wg_us_if</em></a> interface</td>
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
  <td> Select <a href="#tbl_alias_vpn">vpn networks</a></td>
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
  <td><mark>interface address</mark></td>
</tr>
<tr>
  <th style="background-color: lightblue;"> Translation Source Port</th>
  <td>any</td>
</tr>
</table>
</div>
</div>


<div>
<h2 id="fw_if_rule">3 - Local Interface rule</h2>

<p>Go to Firewall ‣ Rules ‣ Interface - e.g. local_if <mark><b>vn</b></mark></p>

<div>
<table id="tbl_if_rule">
<caption>Table: Local IF rule to route traffic</caption>
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
  <td>Allow access to internet and block access to private networks</td>
</tr>
<tr>
  <th style="background-color: lightblue;">Invert Interface </th>
  <td>unchecked</td>
</tr>
<tr>
<th style="background-color: lightblue;"> Interface </th>
<td>select a local interface, e.g. <mark>LAN</mark></td>
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
  <td>Select a local network or a host Alias, e.g. <mark>LAN network</mark> or <mark>192.168.5.0/24, 192.168.7.0/24</mark></td>
</tr>
<tr>
  <th style="background-color: lightblue;"> Destination / Invert </th>
  <td> &#x2705; </td>
</tr>
<tr>
  <th style="background-color: lightblue;"> Destination </th>
  <td>select <a href="#tbl_alias_rfc1918">RFC1918_networks</a></td>
</tr>
<tr>
  <th style="background-color: lightblue;"> Destination port range </th>
  <td> any </td>
</tr>
<tr>
  <th style="background-color: lightblue;"> Gateway </th>
  <td>select <a href="#tbl_gw">gw name</a>, <em>ss_us_gw</em></td>
</tr>
</table>
</div>
</div>


<div>
<h2 id="fw_wg_rule">4 - WireGuard rules</h2>

<p>Firewall ‣ Rules ‣ Interface</p>

<div>
<h3 id="fw_wg_grp_rule">4.1 - WG Group rule</h3>
<div>
<table id="tbl_wg_grp_rule">
<caption>Table: WG Group rule to route traffic</caption>
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
  <td>Allow WireGuard Group internet access</td>
</tr>
<tr>
  <th style="background-color: lightblue;">Invert Interface </th>
  <td>unchecked</td>
</tr>
<tr>
<th style="background-color: lightblue;"> Interface </th>
<td>select <mark>Wireguard (Group)</mark></td>

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
  <td><em>10.0.0.0/8</em></td>
</tr>
<tr>
  <th style="background-color: lightblue;"> Destination / Invert </th>
  <td> Unchecked </td>
</tr>
<tr>
  <th style="background-color: lightblue;"> Destination </th>
  <td>any</td>
</tr>
<tr>
  <th style="background-color: lightblue;"> Destination port range </th>
  <td> any </td>
</tr>
<tr>
  <th style="background-color: lightblue;"> Gateway </th>
  <td>any</td>
</tr>
</table>
</div>
</div>

<div>
<h3 id="fw_wg_if_rule">4.2 - WG Interface rule</h3>
<div>
<table id="tbl_wg_if_rule">
<caption>Table: WG Interface rule</caption>
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
  <td>Allow WG IF access to internet</td>
</tr>
<tr>
  <th style="background-color: lightblue;">Invert Interface </th>
  <td>unchecked</td>
</tr>
<tr>
<th style="background-color: lightblue;"> Interface </th>
<td>select <a href="#tbl_if_assignment"><mark>wg_us_if</mark></a></td>

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
  <td>any</td>
</tr>
<tr>
  <th style="background-color: lightblue;"> Destination / Invert </th>
  <td> Unchecked </td>
</tr>
<tr>
  <th style="background-color: lightblue;"> Destination </th>
  <td>any</td>
</tr>
<tr>
  <th style="background-color: lightblue;"> Destination port range </th>
  <td> any </td>
</tr>
<tr>
  <th style="background-color: lightblue;"> Gateway </th>
  <td>none</td>
</tr>
</table>
</div>
</div>
</div>

<div>
<h2 id="fw_kill_switch">5 - VPN kill switch</h2>
<p>Edit <a href="#fw_if_rule">the local fw rule</a> above</p>
<p>Click on the Show/Hide button next to <mark>Advanced Options</mark>. Then, in the <mark>Set local tag</mark> field, add <mark>NO_WAN_EGRESS</mark>
</p>

<p>Save the rule, and then click Apply changes</p>

<p>Then go to Firewall ‣ Rules ‣ Floating</p>

<p>Click Add to add a new rule</p>

<p>Configure the rule as follows:</p>

<div>
<table id="tbl_vpn_killswitch">
<caption>Table: vpn kill switch</caption>
<tr>
  <th style="background-color: lightblue;">Enable</th>
  <td> &#x2705; </td>
</tr>
<tr>
  <th style="background-color: lightblue;"> Action </th>
  <td> Block </td>
</tr>
<tr>
  <th style="background-color: lightblue;"> Quick </th>
  <td> &#x2705; </td>
</tr>
<tr>
  <th style="background-color: lightblue;"> Interface </th>
  <td> WAN </td>
</tr>
<tr>
  <th style="background-color: lightblue;"> Direction </th>
  <td> out </td>
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
  <td> any </td>
</tr>
<tr>
  <th style="background-color: lightblue;"> Destination / Invert </th>
  <td> Unchecked </td>
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
  <td>Block packets tagged with <em>NO_WAN_EGRESS</em></td>
</tr>
<tr>
  <th style="background-color: lightblue;"> Match local tag </th>
  <td><mark>NO_WAN_EGRESS</mark> </td>
</tr>
</table>
</div>
</div>
</div>

<!-- Optional settings -->
<div>
<h1 id="opt">IV. Optional settings</h1>
<div>
<h2 id="opt_routing">1 - Routing for traffic generated by the router</h2>
<p>Services running on the router and configured to use the VPN interface must have their traffic routed to the VPN gateway in order to use the VPN. Note that locally generated traffic is not affected by NAT or by the firewall rule created in <a href="#fw_if_rule">Firewall</a>.</p>

<p>Go to Firewall ‣ Rules ‣ Floating</p>

<p>Click Add to add a new rule</p>

<p>Configure the rule as follows (if an option is not mentioned below, leave it as the default). You need to click the Show/Hide button next to “Advanced Options” to reveal the last setting:</p>

<div>
  <table id="tbl_routing">
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
</div>

<b>Save</b> the rule, and then click <b>Apply Changes</b>

</div>


<div>
<h2 id="opt_norm">2 - Create normalization rule</h2>

<p>Go to Firewall ‣ Settings -> Normalization and press + to create one new normalization rule.</p>
<p>If you only pass IPv4 traffic through the wireguard tunnel, create the following rule:</p>

  <div>
  <table id="tbl_norm">
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
</div>
</div>
