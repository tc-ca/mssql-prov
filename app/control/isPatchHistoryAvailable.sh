/opt/mssql-tools/bin/sqlcmd -l 30 -S localhost,1433 -h-1 -V1 -U sa -P $SA_PASSWORD -Q "
SET NOCOUNT ON
IF DB_ID(\$(PATCH_HISTORY_DB)) IS NULL BEGIN
	RAISEERROR ('patch history db doesn''t exist!', 1,1)
END

USE [\$(PATCH_HISTORY_DB)]
GO

IF OBJECT_ID('PATCH_HISTORY') IS NULL BEGIN
	RAISERROR ('Patch history is missing!',1,1)
END
" > /dev/null