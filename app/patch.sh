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
			find "$dir" -type f \( -name "*.sh" -o -name "*.sh" \) -print0 | sort -t '\0' |
			while IFS= read -r -d '' file; do
				case $file in
					*.sh)
						echo "Discovered patch shell file $file";
						source "$file";
						;;
					*.sql)
						echo "Discovered patch sql file $file";
						sql -e -i "$file";
						;;
				esac
			done
			logPatch "$dir" "$(cat "$dir/version")" "$(cat "$dir/comments")";
		else
			echo "Patch ${dir} already applied!";
		fi	
	fi
done
echo "Patching complete!";