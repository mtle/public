# Securing MariaDB Connection

#### Checking for TLS support status of Maria installation
```
$ mysql -u root -p
> SHOW GLOBAL VARIABLES LIKE 'have_ssl';
```

**Interpretation of the result:**
1. If the result is NO, then the server was not compiled with TLS support. You need to either recompile or install a different version.
2. If the result is DISABLED, then the server was compiled with TLS support, but TLS is not configured yet. You need to tweak your MySQL configuration.
3. If the result is YES, then the server was compiled with TLS support, and TLS is enabled. Your MySQL should be ready to accept TLS connections from Kea.

#### Enable TLS support in MariaDB

##### Generate self-signed certificates
```
# openssl req -newkey rsa:4096 -days 365000 -nodes -keyout kea-key.pem -out kea-req.pem
# openssl x509 -req -in kea-req.pem -days 365000 -CA /etc/mysql/tls/ca.pem -CAkey /etc/mysql/tls/ca-key.pem -set_serial 01 -out kea-cert.pem
# openssl req -x509 -newkey rsa:4096 -keyout key.pem -out cert.pem -sha256 -days 36500 -nodes -subj "/C=XX/ST=State/L=City/O=Home/OU=/CN=serverName"
# sudo chown mysql.mysql /etc/mysql/tls/*.pem
```

##### Adding certificates to mariadb-server 
```
root@jaco ~]# nvim /etc/my.cnf.d/mariadb-server.cnf
[mariadb]
ssl_cert = /etc/mysql/tls/server-cert.pem
ssl_key = /etc/mysql/tls/server-key.pem
ssl_ca = /etc/mysql/tls/ca.pem
```
