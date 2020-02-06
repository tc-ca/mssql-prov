export name=$1
/opt/mssql-tools/bin/sqlcmd -l 30 -S localhost,1433 -h-1 -V1 -U sa -P $SA_PASSWORD -Q "
SET NOCOUNT ON
USE [$(PATCH_TABLE_DB_NAME)]
GO

IF EXISTS(
	SELECT 1
	FROM PATCH_HISTORY
	WHERE PATCH_FIlE_NM=\$(name)
) BEGIN
	RAISERROR ('Patch already applied!',1,1)
END
" > /dev/null
