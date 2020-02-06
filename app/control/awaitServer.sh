echo "Waiting for MS SQL to be available ⏳"
. /app/control/isAvailable.sh
is_up=$?
while [ $is_up -ne 0 ] ; do 
	echo "Waiting for MS SQL to be available ⏳"
	sleep 1
	. /app/control/isAvailable.sh
	is_up=$?
done
echo "Server is up!";