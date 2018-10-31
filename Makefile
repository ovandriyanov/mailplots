spam.data: message_stat.csv
	sh -c "tail -n+2 message_stat.csv | cut -d';' -f1,18 | tr ';' ' ' >spam.data"

spamfold.data: message_stat.csv
	sh -c "tail -n+2 message_stat.csv | cut -d';' -f1,18 | tr ';' ' ' | ./fold.py --foldtype max >spamfold.data"

msgfold.data: message_stat.csv
	sh -c "tail -n+2 message_stat.csv | cut -d';' -f1 | sed s'/.*/\0 1/' | ./fold.py --foldtype sum --width 360 >msgfold.data"

rss.data: maild_stat.csv
	sh -c "tail -n+2 maild_stat.csv | cut -d';' -f1,4 | tr ';' ' ' >rss.data"
