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
			applyDir "$dir";
			logPatch "$dir" "$(cat "$dir/version")" "$(cat "$dir/comments")";
		else
			echo "Patch ${dir} already applied!";
		fi	
	fi
done
echo "Patching complete!";