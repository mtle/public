# MariaDB Master-Master Replication


## Description

Replication in SQL databases is the process of copying data from a database server to other servers.
Data from one database server will be constantly copied to one or more servers.
Benefits are:
- to distribute and balance requests across a pool of replicated servers
- to provide failover and high availability of MariaDB databases

**Replication schemes:**
- Master-Master: all servers can perform write and read
- Master-Slave: only master can write

Replication is based on a special binlog file which Master server saves all operations to. Slave servers receive and apply changes to their databases.

## Systems
```
Server 1 (jaco): Redhat Enterprise Linux 10
Server 2 (saro): Redhat Enterprise Linux 10
```
|Name|OS|IP|
|:---:|:---|:---:|
|jaco|Redhat Enterprise Linux 10|172.19.xx.yy|
|saro|Redhat Enterprise Linux 10|172.19.xx.zz|

## Deployment

### I: Configuring MariaDB servers
#### I.A: On jaco
##### I.A.1: edit config
```
vim /etc/my.cnf.d/mariadb-server.cnf
```
_Insert_
```
[mariadb]
server_id=27
log-bin
log-basename=jaco
binlog-format=mixed
bind-address=172.19.xx.yy
```

_Restart mariadb_
```
systemctl restart mariadb.service
```

##### I.A.2: User creation:
```
mariadb -u root -p
```
On ```MariaDB [(none)]>``` 
```
CREATE USER 'replication'@'saroIP' IDENTIFIED BY 'PASSWORD';
GRANT REPLICATION SLAVE ON *.* TO 'replication'@'saroIP';
flush privileges;
```


#### I.B: On saro
##### I.B.1: edit config
```
vim /etc/my.cnf.d/mariadb-server.cnf
```
_Insert_
```
[mariadb]
server_id=29
log-bin
log-basename=saro
binlog-format=mixed
bind-address=172.19.xx.zz
```

_Restart mariadb_
```
systemctl restart mariadb.service
```

##### I.B.2: User creation:
```
# mariadb -u root -p
```
On ```MariaDB [(none)]>```
```
create user 'replica_user'@'%' identified by 'password@123';
grant replication slave on *.* to 'replica_user'@'%';
flush privileges;
```


### II: Start Master-Master Replication
** Start on saro first, then jaco**

#### II.A.1: On jaro:
```
mariadb -u root -p
```

##### Recording binlog values
```
flush tables with read lock;
```
```
show binlog status;
```
or
```
show master status;
```
** Do not quit your session to keep the lock. **
** Record the File and Position details. **

#### II.B.1: On saro:
```
stop slave;
```
```
CHANGE MASTER TO MASTER_HOST='jacoIP',
      MASTER_USER='replication',
      MASTER_PASSWORD='password',
      MASTER_PORT=3306,
      MASTER_CONNECT_RETRY=10,
      MASTER_LOG_FILE='jacoLog_file_name',   --- from II.A.1 - jaco's show master status command
      MASTER_LOG_POS=jacoLog_file_position;  --- from II.A.1 - jaco's show master status command
```
```
start replica;
```
```
show replica status\g
```

#### II.B.2: On saro:
```
mariadb -u root -p
```

##### Recording binlog values
```
flush tables with read lock;
```
```
show binlog status;
```
or
```
show master status;
```

** Do not quit your session to keep the lock. **
** Record the File and Position details. **

#### II.A.2: On jaco:
```
stop slave;
```
```
CHANGE MASTER TO MASTER_HOST='saroIP',
      MASTER_USER='replication',
      MASTER_PASSWORD='password',
      MASTER_PORT=3306,
      MASTER_CONNECT_RETRY=10,
      MASTER_LOG_FILE='saroLog_file_name',   --- from II.B.2 - saro's show master status command
      MASTER_LOG_POS=saroLog_file_position;  --- from II.B.2 - saro's show master status command
```
```
start replica;
```
```
show replica status\g
```

#### Remove the lock on both servers
```
MariaDB [(none)]> UNLOCK TABLES;
```

** Mariadb master-master replication is enabled and complete. **

<p align="center">
<a href="https://www.howtoforge.com/how-to-setup-mariadb-master-master-replication-on-debian-11/"></a>
<a href="https://docs.rockylinux.org/books/web_services/043-database-servers-replication/"></a>
<a href="https://github.github.com/gfm/"></a>
<a href="https://github.com/github/docs/blob/main/content/get-started/writing-on-github/getting-started-with-writing-and-formatting-on-github/basic-writing-and-formatting-syntax.md"></a>
<br />
