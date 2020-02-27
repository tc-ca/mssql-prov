echo "Beginning provision step ..."
find "/app/provision" -type f -name "*.sql" -print0 | 
while IFS= read -r -d '' file; do
	sql -e -i $file;
done
echo "Server is provisioned!"