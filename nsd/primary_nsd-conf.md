## Copy to ```/etc/nsd/nsd.conf```

```
# vi: set ts=4 sw=4 sts=4 et:
# Primary NSD configuration file.
# /etc/nsd/nsd.conf

server:
    server-count: 1
    ip-address: 127.0.0.1
    ip-address: 192.168.yy.29
    do-ip4: yes
    do-ip6: no
    port: 5353
    username: nsd
    identity: ": master NSD"
    zonesdir: "/etc/nsd/zones"
    verbosity: 0
    logfile: "/tmp/nsd.log"
    log-only-syslog: no
    pidfile: "/run/nsd/nsd.pid"
    hide-version: yes
    hide-identity: yes
    #round-robin: yes
    minimal-responses: yes
    refuse-any: yes
    log-time-ascii: yes

    # The file where secondary zone refresh and expire timeouts are kept.
    # If you delete this file, all secondary zones are forced to be
    # 'refreshing' (as if nsd got a notify).  Set to "" to disable.
    xfrdfile: "/var/lib/nsd/ixfr.state"
    # The directory where zone transfers are stored, in a subdir of it.
    xfrdir: "/var/lib/nsd"

    # the database to use, if set to "" then no disk-database is used, less memory usage.
    database: ""

remote-control:
    control-enable: yes
    control-interface: 127.0.0.1
    # control-interface: /run/nsd/nsd.ctl
    control-port: 8952
    server-key-file: "/etc/nsd/nsd_server.key"
    server-cert-file: "/etc/nsd/nsd_server.pem"
    control-key-file: "/etc/nsd/nsd_control.key"
    control-cert-file: "/etc/nsd/nsd_control.pem"

pattern:
    name: "tosecondary"
    notify: 192.168.yy.31@5353 secure_key
    provide-xfr: 192.168.yy.31 secure_key

    notify: 192.168.yy.33@5353 secure_key
    provide-xfr: 192.168.yy.33 secure_key

    outgoing-interface: 192.168.yy.23
    notify-retry: 5

key:
    name: "secure_key"
    algorithm: hmac-md5
    secret: "+tfNHZ5TeBqsgye+e/hhJigZ0uHgjo00A="
    # secret: "dd if=/dev/random of=/dev/stdout count=1 bs=32 | openssl base64"

# Fixed zone entries.
zone:
    name: "168.192.in-addr.arpa"
    zonefile: "changeMe.rev"
    include-pattern: "tosecondary"
zone:
    name: "changeMe.org"
    zonefile: "changeMe.fwd"
    include-pattern: "tosecondary"

```
