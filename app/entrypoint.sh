source ./common.sh;
awaitServer;
checkPatchTable;
if [ $? -ne 0 ] ; then
	echo "Could not find patch history, performing first time setup provision.";
	source /app/provision.sh;
	echo "Spoofing patch logs ...";
	logOnly=1; # Provision step makes patching redundant, populate the table so the patches won't be run on future startups.
fi

checkPatchTable;
if [ $? -ne 0 ] ; then
	echo "Patch history table or db is missing. Please ensure the provision step creates the database and table properly.";
else 
	source /app/patch.sh;
fi
