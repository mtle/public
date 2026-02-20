# vim set: ts=4 sw=4 sts=4 et:

```
START TRANSACTION;
SET @ipv4_reservation='172.19.xx.yy';
SET @hostname = 'ylinca.freeddns.org';
SET @identifier_type='hw-address';
SET @identifier_value='aa:bb:cc:dd:ee:ff';
SET @dhcp4_subnet_id=1;

INSERT INTO hosts (dhcp_identifier,
                   dhcp_identifier_type,
		   dhcp4_subnet_id,
                   ipv4_address,
                   hostname)
VALUES (UNHEX(REPLACE(@identifier_value, ':', '')),
	(SELECT type FROM host_identifier_type WHERE name=@identifier_type),
	@dhcp4_subnet_id,
	INET_ATON(@ipv4_reservation),
	@hostname);

-- Store generated host identifier so as we can associate --
-- inserted options with this host --
SET @inserted_host_id = (SELECT LAST_INSERT_ID());


-- Specify DNS servers option value --
SET @dns_servers_option_code = 5;
-- This option comprises one or multiple IPv4 addresses. --
-- We insert option containing two IPv4 addresses: 192.0.2.1 and --
-- 192.0.2.2 by concatenating hexadecimal representations of these --
-- addresses and then converting the result into binary format. --
SET @dns_servers_option_value = UNHEX(CONCAT(LPAD(HEX(INET_ATON('172.xx.yy.31')), 8, 0), LPAD(HEX(INET_ATON('172.xx.yy.33')), 8, 0), LPAD(HEX(INET_ATON('172.xx.yy.23')), 8, 0)));

INSERT INTO dhcp4_options (code, value, space, host_id, scope_id)
VALUES (@dns_servers_option_code,
	@dns_servers_option_value,
	'dhcp4',
	@inserted_host_id,
	(SELECT scope_id FROM dhcp_option_scope WHERE scope_name = @scope_name));

-- Specify Router option value --
SET @router_option_code = 3;
-- This time let's use formatted option value instead of the --
-- binary value. This is only possibly for the options for which --
-- option definitions exist. Option definitions are predefined for --
-- most of the standard options, but also it is possible to define --
-- option definitions for other options in the Kea configuration file.--
SET @router_option_value = '172.xx.yy.5';

INSERT INTO dhcp4_options (code, formatted_value, space, host_id, scope_id)
VALUES (@router_option_code,
	@router_option_value,
	'dhcp4',
	@inserted_host_id,
	(SELECT scope_id FROM dhcp_option_scope WHERE scope_name = @scope_name));

-- Specify Domain name option value --
SET @domain_name_option_code = 15;
SET @domain_name_option_value = 'freeddns.org';

INSERT INTO dhcp4_options (code, formatted_value, space, host_id, scope_id)
VALUES (@domain_name_option_code,
	@domain_name_option_value,
	'dhcp4',
	@inserted_host_id,
	(SELECT scope_id FROM dhcp_option_scope WHERE scope_name = @scope_name));

-- Specify Domain search option value --
SET @domain_search_option_code = 119;
SET @domain_search_option_value = 'freeddns.org';

INSERT INTO dhcp4_options (code, formatted_value, space, host_id, scope_id)
VALUES (@domain_search_option_code,
	@domain_search_option_value,
	'dhcp4',
	@inserted_host_id,
	(SELECT scope_id FROM dhcp_option_scope WHERE scope_name = @scope_name));


COMMIT;

```

