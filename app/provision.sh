echo "Waiting for MS SQL to be available ⏳"
. /app/control/isAvailable.sh
is_up=$?
while [ $is_up -ne 0 ] ; do 
	echo "Waiting for MS SQL to be available ⏳"
	sleep 1
	. /app/control/isAvailable.sh
	is_up=$?
done

echo "Server is up! Beginning provision step."
/opt/mssql-tools/bin/sqlcmd -X -S localhost,1433 -U SA -P $SA_PASSWORD -l 30 -e -i /app/provision/*.sql
echo "Server is provisioned!"