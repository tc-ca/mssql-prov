echo "Beginning patch step ...";
for dir in /app/patch/*; do
	if ! [ -d "$dir" ]; then
		echo "Patcher encountered file, should be dir instead! ($dir)";
	elif ! [ -e "$dir/comments" ]; then
		echo "Patch ${dir} missing comments file!";
	else
		comments="$(cat "$dir/comments")";
		hash="$(getDirHash "$dir")";
		echo "Checking for patch ${dir}...";
		if checkPatchUnapplied "$dir" "$hash"; then
			echo "Patch ${dir} not yet applied!";
			cd "$dir";
			applyDir "$dir";
			logPatch "$dir" "$hash" "$comments";
		else
			echo "Patch ${dir} already applied!";
		fi	
	fi
done
echo "Patching complete!";