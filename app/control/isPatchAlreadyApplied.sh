export name=$1
/opt/mssql-tools/bin/sqlcmd -l 30 -S localhost,1433 -h-1 -V1 -U sa -P $SA_PASSWORD -Q $'
SET NOCOUNT ON

IF EXISTS(
	SELECT 1
	FROM [$(PATCH_HISTORY_DB)].[$(PATCH_HISTORY_SCHEMA)].[$(PATCH_HISTORY_TABLE)]
	WHERE PATCH_FIlE_NM=\'$(name)\'
) BEGIN
	RAISERROR (\'Patch already applied!\',1,1)
END
' #> /dev/null
