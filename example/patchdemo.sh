# load .env file
export $(egrep -v '^#' .env | xargs)

echo "Provision step logs patches as completed, but doesn't apply them.";
echo "The provision step creates the schema from scratch, but patches are only for updating databases to the new schema.";
echo "Lets delete the cats DB and run the patch, as if we were upgrading from an old schema";
docker exec myDB /opt/mssql-tools/bin/sqlcmd -l 30 -S localhost,1433 -h-1 -V1 -U sa -P $SA_PASSWORD -Q $'
	DROP DATABASE [CATWORLD]
	GO
';
sleep 1;
echo "The catworld database should no longer exist";
docker exec myDB /opt/mssql-tools/bin/sqlcmd -l 30 -S localhost,1433 -h-1 -V1 -U sa -P $SA_PASSWORD -Q $'
	SELECT \'catworld id: \', DB_ID(\'CATWORLD\')
	GO
';
sleep 1;

echo "To demonstrate the patch process, we'll need to force it to run the patch.";
echo "To have it execute the patch, we remove it from the history table.";
docker exec myDB /opt/mssql-tools/bin/sqlcmd -l 30 -S localhost,1433 -h-1 -V1 -U sa -P $SA_PASSWORD -Q $'
	DELETE FROM master.dbo.PATCH_HISTORY
	WHERE VERSION_CD=\'1.0.0\'
	GO
';
sleep 1;

echo "Will now restart the container so patches are applied (since it happens on startup)";
docker restart myDB;

sleep 10;

echo "Checking for new cats database, also checking patch table";
docker exec myDB /opt/mssql-tools/bin/sqlcmd -l 30 -S localhost,1433 -h-1 -V1 -U sa -P $SA_PASSWORD -Q $'
	SELECT \'catworld id: \', DB_ID(\'CATWORLD\')
	GO

	SELECT * FROM master.dbo.PATCH_HISTORY
	GO
';
sleep 1;

echo "The patch history table should have re-added the cats entry, and now the catworld db exists!";