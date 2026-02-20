#!/bin/bash
# insert-ipv4-host-to-hosts-table.sh
# vi: set ts=4 sw=4 sts=4 et:

subn="$1"
ip4=$subn.$2
hn="$3"
hw="$4"
rt="$5"

dns1=$subn.27
dns2=$subn.29
dns3=$subn.23

echo $ip4 $hn $hw $rt $dns1 $dns2 $dns3


mysql -u "$6" -p "$7" << EOF
START TRANSACTION;
SET @ipv4_reservation="$ip4";
SET @hostname="$hn";
SET @identifier_value="$hw";
SET @dhcp4_subnet_id="$vlan";
SET @identifier_type='hw-address';
SET @next_server='';
SET @server_hostname='';
SET @boot_file_name='';
SET @scope_name='subnet';

INSERT INTO keadb.hosts (dhcp_identifier,
                   dhcp_identifier_type,
		           dhcp4_subnet_id,
                   ipv4_address,
                   hostname,
                   dhcp4_next_server,
                   dhcp4_server_hostname,
                   dhcp4_boot_file_name)
VALUES (UNHEX(REPLACE(@identifier_value, ':', '')),
	(SELECT type FROM keadb.host_identifier_type WHERE name=@identifier_type),
        @dhcp4_subnet_id,
        INET_ATON(@ipv4_reservation),
        @hostname,
        INET_ATON(@next_server),
        @server_hostname,
        @boot_file_name)
;


-- Store generated host identifier so as we can associate
-- inserted options with this host
SET @inserted_host_id = (SELECT LAST_INSERT_ID());

-- Specify DNS servers option value
SET @dns_servers_option_code = 6;
SET @dns_servers_option_value = UNHEX(CONCAT(LPAD(HEX(INET_ATON("$dns1")), 8, 0), LPAD(HEX(INET_ATON("$dns2")), 8, 0), LPAD(HEX(INET_ATON("$dns3")), 8, 0)));

INSERT INTO keadb.dhcp4_options (code, value, space, host_id, scope_id)
VALUES (@dns_servers_option_code,
        @dns_servers_option_value,
        'dhcp4',
        @inserted_host_id,
        (SELECT scope_id FROM keadb.dhcp_option_scope WHERE scope_name = @scope_name));

-- Specify Router option value
SET @router_option_code = 3;
SET @router_option_value = "$rt";
INSERT INTO keadb.dhcp4_options (code, formatted_value, space, host_id, scope_id)
VALUES (@router_option_code,
        @router_option_value,
        'dhcp4',
        @inserted_host_id,
        (SELECT scope_id FROM keadb.dhcp_option_scope WHERE scope_name = @scope_name))
;

-- option: domain-name
SET @domain_name_option_code = 15;
SET @domain_name="$dn";
INSERT INTO keadb.dhcp4_options (code, formatted_value, space, host_id, scope_id)
VALUES (@domain_name_option_code,
        @domain_name,
        'dhcp4',
        @inserted_host_id,
        (SELECT scope_id FROM keadb.dhcp_option_scope WHERE scope_name = @scope_name))
;
		
-- option: domain-search
SET @domain_search_option_code = 119;
INSERT INTO keadb.dhcp4_options (code, formatted_value, space, host_id, scope_id)
VALUES (@domain_search_option_code,
        @domain_name,
        'dhcp4',
        @inserted_host_id,
        (SELECT scope_id FROM keadb.dhcp_option_scope WHERE scope_name = @scope_name))
;


COMMIT;



-- Check if the insert is successful
SELECT
    HEX(h.dhcp_identifier) AS dhcp_identifier,
    i.name AS dhcp_identifier_name,
    h.dhcp4_subnet_id AS dhcp4_subnet_id,
    INET_NTOA(h.ipv4_address) AS ipv4_address,
    h.hostname AS hostname
FROM
    keadb.hosts AS h
INNER JOIN keadb.host_identifier_type AS i ON h.dhcp_identifier_type = i.type
;

EOF

