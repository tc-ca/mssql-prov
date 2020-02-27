for x in magic beans; do
	export berf=$x;
	sql -Q $'
		SELECT \'$(berf)\'
		GO
	';
	# sql -e -i template.sql
done
break;