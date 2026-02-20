# User managment

### To check for remote access of 'kea' user
```
> SELECT host FROM mysql.user WHERE User = 'kea';
```

### To allow 'kea' remote access from an ip_address
```
> CREATE USER 'kea'@'ip_address' IDENTIFIED BY 'some_pass';
> GRANT ALL PRIVILEGES ON *.* 'kea'@'ip_address';
> GRANT ALL ON keadb.* TO 'kea'@'ip_address';
```

### To allow 'kea' remote access from any ip
```
> CREATE USER 'kea'@'%' IDENTIFIED BY 'some_pass';
> GRANT ALL PRIVILEGES ON *.* 'kea'@'%';
```

### Finally, reload the permissions
```
> FLUSH PRIVILEGES;
```

### Check access
```
> mysql -u kea -p -h mysql-server-ip -D keadb
```

