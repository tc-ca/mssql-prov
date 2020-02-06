echo "Waiting for MS SQL to be available ⏳"
. /app/control/isAvailable.sh
is_up=$?
while [ $is_up -ne 0 ] ; do 
	echo "Waiting for MS SQL to be available ⏳"
	sleep 1
	. /app/control/isAvailable.sh
	is_up=$?
done

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
	echo "Server is up! Beginning patch step."
	. /app/patch.sh
	echo "Server is patched!"
fi
