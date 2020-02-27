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
		checkPatchApplied "$dir";
		if [ $? -ne 0 ]; then
			echo "Patch ${dir} already applied!";
		else
			echo "Patch ${dir} not yet applied!";
			for file in $(find -name "*.sh" "$dir"); do
				echo "Discovered patch sh file ($file)";
				[ -z $logOnly ] && source "$file";
			done
			for file in $(find -name "*.sql" "$dir"); do
				echo "Discovered patch sql file $(file)";
				[ -z $logOnly ] && sql -e -i "$file"
			done
			logPatch "$dir" "$(cat "$dir/version")" "$(cat "$dir/comments")";
		fi	
	fi
done
echo "Patching complete!";