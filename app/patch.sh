echo "Beginning patch step ...";
for dir in /app/patch/*; do
	if ! [ -d "$dir" ]; then
		echo "Patcher encountered file, should be dir instead! ($dir)";
	elif ! [ -e "$dir/version" ]; then
		echo "Patch ${dir} missing version file!";
	elif ! [ -e "$dir/comments" ]; then
		echo "Patch ${dir} missing comments file!";
	else
		echo "Checking for patch ${dir}..."
		. /app/control/isPatchAlreadyApplied.sh "'$dir'"
		if [ $? -ne 0 ]; then
			echo "Patch ${dir} already applied!"
		else
			echo "Patch ${dir} not yet applied!"
			if [ -z $logOnly ]; then 
				if [ -e "$dir/run.sh" ]; then
					. "$dir/run.sh"
				else
					echo "No patch run.sh found, sequencing *.sql files instead."
					cd "$dir"
					for file in *.sql; do
						/opt/mssql-tools/bin/sqlcmd -X -S localhost,1433 -U SA -P $SA_PASSWORD -l 30 -e -i "$file"
					done
					cd ..
				fi
			fi
			. /app/control/logPatch.sh "'$dir'" "'$(cat "$dir/version")'" "'$(cat "$dir/comments")'"
		fi	
	fi
done
echo "Patching complete!";