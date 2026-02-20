# Database export and import

## Export: on master/primary
```
MariaDb (None)]> FLUSH TABLES WITH READ LOCK;
MariaDb (None)]> quit
```
On CLI,
```
mariadb-dump -u root -p --add-drop-database --add-drop-table keadb --result-file=backup.sql
```
or 
```
mysqldump -u root -p keadb > backup.sql
```

#### Once the data has been copied, release the lock on the master
```
MariaDb (None)]> unlock tables;
```

## Import: on slave/secondary
On CLI,
```
mariadb -u root -p keadb < backup.sql
```
or
```
mysql -u root -p keadb < backup.sql
```
