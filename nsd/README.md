# Configuring NLnet Labs Name Server Daemon (NSD)

NSD is an authoritative DNS name server. It has been developed for operations in environments where speed, reliability, stability and security are of high importance.

[digitalocean:how-to-use-nsd-an-authoritative-only-dns-server](https://www.digitalocean.com/community/tutorials/how-to-use-nsd-an-authoritative-only-dns-server-on-ubuntu-14-04)<br/>
[Archlinux](https://wiki.archlinux.org/title/NSD)<br/>
[loga.us:unbound-caching-and-nsd-local-authoritative-master-slave-dns-server-part-2](https://loga.us/2014/08/05/unbound-caching-and-nsd-local-authoritative-master-slave-dns-server-part-2/#more-282)<br/>
[nsd_authoritative_dns](https://docs.rockylinux.org/guides/dns/nsd_authoritative_dns/)<br/>

### To generate SSL keys and certificates that NSD uses to securely communicate between the daemon portion of the application and the controller are generated
```
# nsd-control-setup
```

### Configuration validation check
```
# nsd-checkconf /etc/nsd/nsd.conf	--  no output, means the syntax of the main configuration file is valid
```

### Zone files validation check
```
# nsd-checkzone -p adm.mple ./nsd/zones/adm.mple.forward
# nsd-checkzone -p pub.mple ./nsd/zones/pub.mple.forward
# nsd-checkzone -p 55.19.172.in-addr.arpa ./nsd/zones/adm.mple.reverse
# nsd-checkzone -p 88.19.172.in-addr.arpa ./nsd/zones/pub.mple.reverse
```

### SElinux check
```
# dnf provides */semanage
# semanage port -l | grep dns
dns_port_t                     tcp      53, 853
dns_port_t                     udp      53, 853
dnssec_port_t                  tcp      8955
opendnssec_port_t              tcp      15354
opendnssec_port_t              udp      15354
```

### Add custom port (5335) to SElinux
```
# semanage port -a -t dns_port_t -p tcp 5335
# semanage port -a -t dns_port_t -p udp 5335
```

### FW rules
```
# firewall-cmd  --permanent --zone=<internal> --add-service=<port>
# firewall-cmd --reload
```
### Give nsd user access to files
```
# chown -R nsd:nsd /var/lib/nsd
```

### Start the service
```
# systemctl start nsd.service
# tail -20 /var/log/syslog
# journalctl -xeu nsd.service
```

### Control: ref: https://nsd.docs.nlnetlabs.nl/en/latest/manpages/nsd-control.html
```
# nsd-control notify			-- sent from primary server
# nsd-control transfer			-- sent from primary server
# nsd-control force_transfer	-- sent from primary server
# nsd-control status | reload | reconfig
```


### Important
Set the followings in unbound.conf

```
do-not-query-localhost: no
local-zone: "example.com" nodefault
domain-insecure: "example.com"
```

** at the end of unbound.conf **
```
stub-zone:
        name: "55.19.172.in-addr.arpa"
        stub-addr: ::1@5353
        stub-addr: 127.0.0.1@55553
stub-zone:
       name: "example.com"
       stub-addr: 127.0.0.1@55553 <- nsd port
```

[ref](https://www.sbarjatiya.com/notes_wiki/index.php/Configuring_IPv6_and_IPv4,_forward_and_reverse_DNS)<br/>
[ref](https://arstechnica.com/gadgets/2020/08/understanding-dns-anatomy-of-a-bind-zone-file/)<br/>
[ref](https://www.zytrax.com/books/dns/)<br/>
[ref](https://flylib.com/books/en/2.684.1/)<br/>


