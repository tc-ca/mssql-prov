echo "Beginning provision step ..."
for file in $(find -name "*.sql" "/app/provision/"); do
	/opt/mssql-tools/bin/sqlcmd -X -S localhost,1433 -U SA -P $SA_PASSWORD -l 30 -e -i "$file";
done
echo "Server is provisioned!"