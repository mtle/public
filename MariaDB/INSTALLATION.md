# MariaDB installation

###  On rhel
|Name|OS|IP|
|:---:|:---|:---:|
|jaco|Redhat Enterprise Linux 10|172.aa.xx.yy|
|saro|Redhat Enterprise Linux 10|172.aa.xx.zz|

#### Install mariadb-server
```
# dnf update
# dnf install mariadb-server -y
```

#### Verify
```
# rpm -qi mariadb-server
```

#### enable and start
```
# systemctl enable mariadb.service
# systemctl start mariadb.service
```

#### Secure the DB servers
```
# mysql_secure_installation
```

#### Firewall
```
# firewalld-cmd --add-service=mysql --zone=trusted --permanent
# firewalld-cmd --reload
```
