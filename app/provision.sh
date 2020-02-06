echo "Beginning provision step ..."
/opt/mssql-tools/bin/sqlcmd -X -S localhost,1433 -U SA -P $SA_PASSWORD -l 30 -e -i /app/provision/*.sql
echo "Server is provisioned!"