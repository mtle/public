-- vi:set ts=4 sw=4 sts=4 et:

```
START TRANSACTION;
SET @ipv4_reservation='172.19.xx.yy';
SET @hostname = 'yulinca.freeddns.org';
SET @identifier_type='hw-address';
SET @identifier_value='aa:bb:cc:dd:ee:ff';
SET @dhcp4_subnet_id=555;
SET @next_server='10.0.0.1';
SET @server_hostname='fw.freeddns.org';
SET @boot_file_name='bootfile.efi';

INSERT INTO hosts (dhcp_identifier,
		dhcp_identifier_type,
		dhcp4_subnet_id,
		ipv4_address,
		hostname,
		dhcp4_next_server,
		dhcp4_server_hostname,
		dhcp4_boot_file_name)

VALUES (UNHEX(REPLACE(@identifier_value, ':', '')),
	(SELECT type FROM host_identifier_type WHERE name=@identifier_type),
	@dhcp4_subnet_id,
	INET_ATON(@ipv4_reservation),
	@hostname,
	INET_ATON(@next_server),
	@server_hostname,
	@boot_file_name);

COMMIT;
```
