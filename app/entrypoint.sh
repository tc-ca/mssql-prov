source ./common.sh;
awaitServer;
if ! checkPatchTable; then
	echo "Could not find patch history, performing first time setup provision.";
	source /app/provision.sh;
fi

if [ -d patch ]; then
	if ! checkPatchTable; then
		echo "Patch history table or db is missing. Please ensure the provision step creates the database and table properly.";
	else 
		source /app/patch.sh;
	fi
else
	echo "No patch directory found.";
fi
