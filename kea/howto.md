# How to configure kea with MariaDB master-master replication

## System commands:

```
# systemctl enable kea-dhcp4.service
# systemctl enable kea-ctrl-agent.service
# systemctl start|status|restart|stop kea-dhcp4.service
# systemctl start|status|restart|stop kea-ctrl-agent.service
# journalctl -u kea-ctrl-agent
# journalctl -u kea-dhcp4
# keacrtl start|status|stop
```

#### Kea’s RESTful API with curl:
```
$ ``curl -X POST -H "Content-Type: application/json" -d '{ "command": "config-get", "service": [ "dhcp4" ] }'  http://192.168.1.3:8000/``
```

#### To control the given Kea service via a UNIX domain socket, use socat in interactive mode as follows:
```
$ socat UNIX:/run/kea/kea-ctrl-socket -
```
#### in batch mode, include the “ignoreeof” option as shown below to ensure socat waits long enough for the server to respond:
```
$ echo "{ "command": "config-get", "service": [ "dhcp4" }" | socat UNIX:/run/kea/kea4-ctrl-socket -,ignoreeof
```

## Configuring MariaDB:

#### Database admininstration - section 4.3.2
[kea doc](https://kea.readthedocs.io/en/kea-2.2.0/arm/admin.html)

#### Log into MySQL as “root”:
```
# mysql -u root -p
MariaDB [(none)]> create database keadb;
MariaDB [(none)]> set @@global.log_bin_trust_function_creators = 1;
```

Note: con also use one keadb to store both leases and hosts
** Create the user under which Kea will access the database (and give it a password), then grant it access to the database tables: u=kea, p= **
##### Local user:
```
MariaDB [(none)]> CREATE USER 'kea'@'localhost' IDENTIFIED BY 'password';
MariaDB [(none)]> GRANT ALL ON keadb.* TO 'kea'@'localhost';
MariaDB [(none)]> FLUSH PRIVILEGES;
MariaDB [(none)]> quit
```

##### Remote user:
```
MariaDB [(none)]> CREATE USER 'kea'@'ip_address' IDENTIFIED BY 'password';
MariaDB [(none)]> GRANT ALL ON keadb.* TO 'kea'@'ip_address';
MariaDB [(none)]> FLUSH PRIVILEGES;
MariaDB [(none)]> quit
```

#### use the kea-admin tool to initialize keadb 
```
$  kea-admin db-init mysql -u kea -p <password> -n keadb
```

#### Database backup/clone

```
$ mysql -u kea -p
$ MariaDB [(none)]> use keadb;	-- switch to keadb
$ MariaDB [keadb]> show tables;
```

##### Dump the db
```
$ mariadb-dump --user=kea --password --lock-tables --databases keadb > /data/backup/keadb.sql
```

##### dump the table
```
$ mariadb-dump --user=kea --password --lock-tables keadb hosts > /data/backup/keadb_hosts.sql
```

##### Import the dumped DB to another server
```
$ mysql -u kea -p classicmodels_backup < keadb.sql
$ mysql -u username -p database_name < /path/to/file.sql
```


### IPv4 Reservation
In order to add an IPv4 address and hostname reservation for a client, identified by its MAC address the following MySQL INSERT statement can be used:

#### sql query to reserve a host
[sql query to reserve a host](query-to-reserve-static-host.sql)


#### sql query to set DHCPv4 options
[sql query to set DHCPv4 options](query-to-set-DHCPv4-options.sql)

##### Update config, lease-database, hosts-database, and config-databases
```
"lease-database": {
  "type": "mysql",
  "name": "kea",
  "user": "kea",
  "password": "secret1",
  "host": "localhost",
  "port": 3306,
  "trust-anchor": "/etc/mysql/tls/ca.pem",
  "cert-file": "/etc/kea/tls/kea-cert.pem",
  "key-file": "/etc/kea/tls/kea-key.pem"
},
```

##### Checking
```
$ kea-dhcp4 -c /etc/kea-kea-dhcp4.conf
```

## Database Replication
[master-master replication](../MariaDB/Master-Master-Replication.md)

#### Referenses
https://bobcares.com/blog/mariadb-master-slave-replication/
https://msutic.blogspot.com/2015/02/mariadbmysql-master-master-replication.html
https://github.com/isc-projects/kea/blob/master/doc/examples/kea4/advanced.json
https://github.com/isc-projects/kea/blob/master/doc/examples/kea4/backends.json
https://github.com/isc-projects/kea/blob/master/doc/examples/kea4/mysql-reservations.json
https://github.com/josh73/migrate-host-reservations-to-kea-mysql/blob/master/update_dhcpd_db.py
https://gitlab.isc.org/isc-projects/kea/-/wikis/docs/editing-host-reservations

