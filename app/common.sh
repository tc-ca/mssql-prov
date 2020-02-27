function sql {
	/opt/mssql-tools/bin/sqlcmd -S localhost,1433 -U SA -P $SA_PASSWORD -l 30 -h-1 -V1 $@;
}

function checkServerStatus {
	sql -Q "SET NOCOUNT ON SELECT @@servername" > /dev/null;
}

function awaitServer {
	echo "Waiting for MS SQL to be available ⏳";
	checkServerStatus;
	is_up=$?;
	while [ $is_up -ne 0 ] ; do 
		echo "Waiting for MS SQL to be available ⏳";
		sleep 1;
		checkServerStatus;
		is_up=$?;
	done
	echo "Server is up!";
}

function checkPatchApplied {
	export name=$1
	sql -Q $'
		SET NOCOUNT ON

		IF EXISTS(
			SELECT 1
			FROM [$(PATCH_HISTORY_DB)].[$(PATCH_HISTORY_SCHEMA)].[$(PATCH_HISTORY_TABLE)]
			WHERE PATCH_FIlE_NM=\'$(name)\'
		) BEGIN
			RAISERROR (\'Patch already applied!\',1,1)
		END
	' #> /dev/null
}

function checkPatchTable {
	sql -Q $'
		SET NOCOUNT ON
		IF DB_ID(\'$(PATCH_HISTORY_DB)\') IS NULL BEGIN
			RAISERROR (\'Patch history db doesn\'\'t exist!\', 1,1)
		END

		IF OBJECT_ID(\'[$(PATCH_HISTORY_DB)].[$(PATCH_HISTORY_SCHEMA)].[$(PATCH_HISTORY_TABLE)]\') IS NULL BEGIN
			RAISERROR (\'Patch history table doesn\'\'t exist!\',1,1)
		END
	'; #> /dev/null
}

function logPatch {
	export filename=$1;
	export version=$2;
	export comments=$3;
	sql -Q '
		SET NOCOUNT ON

		INSERT INTO [$(PATCH_HISTORY_DB)].[$(PATCH_HISTORY_SCHEMA)].[$(PATCH_HISTORY_TABLE)]
		(PATCH_FILE_NM, APPLIED_DTE, VERSION_CD, COMMENTS_TXT)
		VALUES ($(filename), GETDATE(), $(version), $(comments))
	';
	echo "Patch ${filename} applied!";
}