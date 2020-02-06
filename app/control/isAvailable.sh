/opt/mssql-tools/bin/sqlcmd -l 30 -S localhost,1433 -h-1 -V1 -U sa -P $SA_PASSWORD -Q "SET NOCOUNT ON SELECT @@servername" > /dev/null
