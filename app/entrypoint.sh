. /app/control/awaitServer.sh

. /app/control/isPatchHistoryAvailable.sh
if [ $? -ne 0 ] ; then
	echo "Could not find patch history, performing first time setup provision."
	. /app/provision.sh
	logOnly=1 # Provision step makes patching redundant, populate the table so the patches won't be run on future startups.
fi

. /app/control/isPatchHistoryAvailable.sh
if [ $? -ne 0 ] ; then
	echo "Patch history is missing. Please ensure the provision step creates the table properly."
else 
	. /app/patch.sh
fi
