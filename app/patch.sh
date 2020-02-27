echo "Beginning patch step ...";
for dir in /app/patch/*; do
	if ! [ -d "$dir" ]; then
		echo "Patcher encountered file, should be dir instead! ($dir)";
	elif ! [ -e "$dir/version" ]; then
		echo "Patch ${dir} missing version file!";
	elif ! [ -e "$dir/comments" ]; then
		echo "Patch ${dir} missing comments file!";
	else
		echo "Checking for patch ${dir}...";
		if checkPatchUnapplied "$dir"; then
			echo "Patch ${dir} not yet applied!";
			find "$dir" -type f -name "*.sh" -print0 |
			while IFS= read -r -d '' file; do
				echo "Discovered patch shell file $file";
				source $file;
			
			done
			
			find "$dir" -type f -name "*.sql" -print0 |
			while IFS= read -r -d '' file; do
				echo "Discovered patch sql file $file";
				sql -e -i "$file";
			done
			logPatch "$dir" "$(cat "$dir/version")" "$(cat "$dir/comments")";
		else
			echo "Patch ${dir} already applied!";
		fi	
	fi
done
echo "Patching complete!";