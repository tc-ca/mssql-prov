shopt -s expand_aliases;
alias sql='/opt/mssql-tools/bin/sqlcmd -S localhost,1433 -U SA -P $SA_PASSWORD -l 30 -h-1 -V1';

function checkServerStatus {
	sql -Q "SET NOCOUNT ON SELECT @@servername" > /dev/null && return 0 || return 1;
}

function awaitServer {
	echo "Waiting for MS SQL to be available ⏳";
	until checkServerStatus; do 
		echo "Waiting for MS SQL to be available ⏳";
		sleep 1;
	done
	echo "Server is up!";
}

function checkPatchUnapplied {
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
	' && return 0 || return 1;#> /dev/null
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
	' && return 0 || return 1; #> /dev/null
}

function logPatch {
	export filename=$1;
	export version=$2;
	export comments=$3;
	sql -Q $'
		SET NOCOUNT ON

		INSERT INTO [$(PATCH_HISTORY_DB)].[$(PATCH_HISTORY_SCHEMA)].[$(PATCH_HISTORY_TABLE)]
		(PATCH_FILE_NM, APPLIED_DTE, VERSION_CD, COMMENTS_TXT)
		VALUES (\'$(filename)\', GETDATE(), \'$(version)\', \'$(comments)\')
	';
	echo "Patch ${filename} applied!";
}

function applyDir {
	echo "Applying files in $1";
	find "$1" -type f \( -name "*.sh" -o -name "*.sql" \) -print0 | sort -t '\0' |
	while IFS= read -r -d '' file; do
		case $file in
			*.sh)
				echo "Discovered shell file $file";
				source "$file";
				;;
			*.sql)
				echo "Discovered sql file $file";
				sql -e -i "$file";
				;;
		esac
	done
}