#!/usr/bin/env bash
#
#
mysql_root_pw="ChangeThePassword"
mysql_cmd="mysql -u root --password='${mysql_root_pw}'"

db_user='rolesbb'
db_pw='ChangeThePassword'
db_host='%'

dbs=('mdept$owner' 'rolesbb' 'rolessrv')
echo "CREATE USER '${db_user}' IDENTIFIED BY '${db_pw}';" | ${mysql_cmd}
grants="SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, REFERENCES, INDEX, ALTER, CREATE TEMPORARY TABLES, LOCK TABLES, CREATE VIEW, SHOW VIEW, CREATE ROUTINE, ALTER ROUTINE, EXECUTE"
for db in "${dbs[@]}"; do
	echo "CREATE DATABASE IF NOT EXISTS \`${db}\`;" | ${mysql_cmd}
	echo "GRANT ${grants} ON \`${db}\`.* TO '${db_user}'@'${db_host}';" | ${mysql_cmd}
	${mysql_cmd} --database="$db" < "${db}_db_dump_nodata.sql"
	${mysql_cmd} --database="$db" < "${db}_stored_procs.sql"
done