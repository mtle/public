## Copy to ```/etc/unbound/```

```
# /etc/unbound/unbound.conf
include: "/etc/unbound/unbound.conf.d/00_server.conf"
# vi:ts=2:sts=2:
```

```
# /etc/unbound/unbound.conf.d/00_server.conf
#
server:
  chroot: ""
  username: "unbound"
  directory: "/etc/unbound"
  pidfile: /var/run/unbound.pid
  tls-cert-bundle: /etc/ssl/certs/ca-certificates.crt
  root-hints: /usr/share/dns/root.hints

  num-threads: 4
  interface: 0.0.0.0
  port: 53
  outgoing-port-permit: 32768-60999
  outgoing-port-avoid: 0-32767
  outgoing-port-avoid: 61000-65535
  so-reuseport: yes
  ip-transparent: yes
  do-ip4: yes
  do-ip6: no
  do-udp: yes
  do-tcp: yes
  edns-tcp-keepalive: yes

  access-control: 0.0.0.0/0 refuse
  access-control: 127.0.0.0/8 allow
  access-control: 192.168.0.0/16 allow

  hide-trustanchor: yes
  hide-identity: yes
  hide-version: yes
  harden-glue: yes
  harden-dnssec-stripped: yes
  harden-below-nxdomain: yes
  harden-referral-path: yes

  qname-minimisation: yes
  qname-minimisation-strict: yes
  aggressive-nsec: yes
  unwanted-reply-threshold: 10000000
  prefetch: yes
  prefetch-key: yes
  deny-any: yes
  rrset-roundrobin: no
  minimal-responses: yes

  module-config: "respip validator iterator"
  trust-anchor-signaling: yes
  root-key-sentinel: yes

  serve-expired: yes
  serve-expired-ttl: 14400

  tls-ciphers: "PROFILE=SYSTEM"
  ede: yes
  ede-serve-expired: yes

  use-syslog: yes
  verbosity: 0
  log-time-ascii: yes
  log-queries: no
  log-replies: no
  log-tag-queryreply: no
  log-local-actions: no
  log-servfail: no

include: /etc/unbound/unbound.conf.d/root-auto-trust-anchor-file.conf

# Allows local zones to bypass filtering (often used with private-domain)
#  unblock-lan-zones: yes
#  insecure-lan-zones: yes
#  do-not-query-localhost: no
#
# Private networks for DNS Rebinding prevention (when enabled)
  private-address: 0.0.0.0/8
  private-address: 10.0.0.0/8
  private-address: 100.64.0.0/10
  private-address: 169.254.0.0/16
  private-address: 172.16.0.0/12
  private-address: 192.0.2.0/24
  private-address: 192.168.0.0/16
  private-address: 198.18.0.0/15
  private-address: 198.51.100.0/24
  private-address: 203.0.113.0/24
  private-address: 233.252.0.0/24
  private-address: ::1/128
  private-address: 2001:db8::/32
  private-address: fc00::/8
  private-address: fd00::/8
  private-address: fe80::/10

# Private domains (DNS Rebinding)
include: /etc/unbound/unbound.conf.d/10_private_domains.conf

include: /etc/unbound/unbound.conf.d/30_auth_zones.conf
include: /etc/unbound/unbound.conf.d/30_forward_zones.conf
include: /etc/unbound/unbound.conf.d/40_dnsbl.conf

include: /etc/unbound/unbound.conf.d/remote-control.conf

# vi:ts=2:sw=2:
```
