## Copy to ```/etc/unbound/```

```
# /etc/unbound/unbound.conf
# vi:set ts=4 sts=4 sw=4 et:

# Use this anywhere in the file to include other text into this file.
#include: "otherfile.conf"

# The server clause sets the main parameters.
server:
	verbosity: 1
	# statistics-interval: 0
	# statistics-cumulative: no
	# extended-statistics: no
	num-threads: 1

	interface: 192.168.3.29
	interface: 192.168.5.29
	interface: 192.168.7.29
	interface-automatic: no
	port: 53

	outgoing-interface: 192.168.3.29
	outgoing-port-permit: 32768-60999
	outgoing-port-avoid: 0-32767
	outgoing-port-avoid: 61000-65535
	so-reuseport: yes
	ip-transparent: yes
	max-udp-size: 3072
	do-ip6: no
	edns-tcp-keepalive: yes
	access-control: 127.0.0.0/8 allow_snoop
	access-control: 192.168.0.0/16 allow_snoop
	chroot: ""
	username: "unbound"
	directory: "/etc/unbound"
	unblock-lan-zones: yes 
	insecure-lan-zones: yes
	do-not-query-localhost: no
	pidfile: "/var/run/unbound/unbound.pid"
	root-hints: "/var/lib/unbound/root.hints"
	hide-identity: yes
	hide-version: yes
	harden-glue: yes
	harden-dnssec-stripped: yes
	harden-below-nxdomain: yes
	harden-referral-path: yes
	qname-minimisation: yes
	aggressive-nsec: yes
	private-address: 192.168.0.0/16
	private-domain: "changeMe.freeddns.org"
	unwanted-reply-threshold: 10000000
	prefetch: yes
	prefetch-key: yes
	deny-any: yes
	rrset-roundrobin: yes
	minimal-responses: yes
	module-config: "ipsecmod validator iterator"
	trust-anchor-signaling: yes
	root-key-sentinel: yes
	trusted-keys-file: /etc/unbound/keys.d/*.key
	auto-trust-anchor-file: "/var/lib/unbound/root.key"
	domain-insecure: "changeMe.freeddns.org"
	val-clean-additional: yes
	val-permissive-mode: no
	serve-expired: yes
	serve-expired-ttl: 14400
	val-log-level: 1
	local-zone: "168.192.in-addr.arpa." nodefault
	include: /etc/unbound/local.d/*.conf
	tls-ciphers: "PROFILE=SYSTEM"
	tls-cert-bundle: "/etc/pki/ca-trust/extracted/pem/tls-ca-bundle.pem"
	ipsecmod-enabled: no
	ipsecmod-hook:/usr/libexec/ipsec/_unbound-hook

	# the log file, "" means log to stderr.
	# Use of this option sets use-syslog to "no".
	# logfile: ""

	# Log to syslog(3) if yes. The log facility LOG_DAEMON is used to
	# log to. If yes, it overrides the logfile.
	use-syslog: no

	# Log identity to report. if empty, defaults to the name of argv[0]
	# (usually "unbound").
	# log-identity: ""

	# print UTC timestamp in ascii to logfile, default is epoch in seconds.
	log-time-ascii: yes

	# print one line with time, IP, name, type, class for every query.
	# log-queries: no

	# print one line per reply, with time, IP, name, type, class, rcode,
	# timetoresolve, fromcache and responsesize.
	# log-replies: no

	# log with tag 'query' and 'reply' instead of 'info' for
	# filtering log-queries and log-replies from the log.
	# log-tag-queryreply: no

	# log with destination address, port and type for log-replies.
	# log-destaddr: no

	# log the local-zone actions, like local-zone type inform is enabled
	# also for the other local zone types.
	# log-local-actions: no

	# print log lines that say why queries return SERVFAIL to clients.
	# log-servfail: no

	# Redirect .adm domain to the reverse proxy IP(192.168.3.47)
        #private-domain: "adm"
	#domain-insecure: "adm"
        #local-zone: "adm." nodefault
        #local-zone: "adm" redirect
        #local-data: "adm A 192.168.3.47"

remote-control:
	control-enable: yes
	server-key-file: "/etc/unbound/unbound_server.key"
	server-cert-file: "/etc/unbound/unbound_server.pem"
	control-key-file: "/etc/unbound/unbound_control.key"
	control-cert-file: "/etc/unbound/unbound_control.pem"

stub-zone:
	name: "168.192.in-addr.arpa"
	stub-addr: 127.0.0.1@5353
stub-zone:
	name: "changeMe.freeddns.org"
	stub-addr: 127.0.0.1@5353

forward-zone:
	name: "."
	forward-tls-upstream: yes
	forward-addr: 1.1.1.3@853#family.cloudflare-dns.com
	forward-addr: 208.67.222.123@853#familyshield.opendns.com
	forward-addr: 149.112.121.30@853#family.canadianshield.cira.ca
	forward-addr: 8.8.8.8@853#dns.google.com
auth-zone:
	name: "."
	primary: 199.9.14.201         # b.root-servers.net
	primary: 192.33.4.12          # c.root-servers.net
	primary: 199.7.91.13          # d.root-servers.net
	primary: 192.5.5.241          # f.root-servers.net
	primary: 192.112.36.4         # g.root-servers.net
	primary: 193.0.14.129         # k.root-servers.net
	primary: 192.0.47.132         # xfr.cjr.dns.icann.org
	primary: 192.0.32.132         # xfr.lax.dns.icann.org
	primary: 2001:500:200::b      # b.root-servers.net
	primary: 2001:500:2::c        # c.root-servers.net
	primary: 2001:500:2d::d       # d.root-servers.net
	primary: 2001:500:2f::f       # f.root-servers.net
	primary: 2001:500:12::d0d     # g.root-servers.net
	primary: 2001:7fd::1          # k.root-servers.net
	primary: 2620:0:2830:202::132 # xfr.cjr.dns.icann.org
	primary: 2620:0:2d0:202::132  # xfr.lax.dns.icann.org
	fallback-enabled: yes
	for-downstream: no
	for-upstream: yes
```
