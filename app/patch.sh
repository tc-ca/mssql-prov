echo "Beginning patch step ...";
for dir in /app/patch/*; do
	if ! [ -d "$dir" ]; then
		echo "Patcher encountered file, should be dir instead! ($dir)";
	elif ! [ -e "$dir/version" ]; then
		echo "Patch ${dir} missing version file!";
	elif ! [ -e "$dir/comments" ]; then
		echo "Patch ${dir} missing comments file!";
	else
		version="$(cat "$dir/version")";
		comments="$(cat "$dir/comments")";
		echo "Checking for patch ${dir}...";
		if checkPatchUnapplied "$version"; then
			echo "Patch ${dir} not yet applied!";
			cd "$dir";
			applyDir "$dir";
			logPatch "$dir" "$version" "$comments";
		else
			echo "Patch ${dir} already applied!";
		fi	
	fi
done
echo "Patching complete!";