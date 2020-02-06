export filename=$1
export version=$2
export comments=$3
/opt/mssql-tools/bin/sqlcmd -l 30 -S localhost,1433 -h-1 -V1 -U sa -P $SA_PASSWORD -Q "
SET NOCOUNT ON
USE [$DB_NAME]
GO

INSERT INTO PATCH_HISTORY
(PATCH_FILE_NM, APPLIED_DTE, VERSION_CD, COMMENTS_TXT)
VALUES (\$(filename), GETDATE(), \$(version), \$(comments))
"
echo "Patch ${filename} applied!";