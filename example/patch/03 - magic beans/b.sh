for word in magic beans; do
	export word=$word;
	sql -e -i template.sql
done
break;