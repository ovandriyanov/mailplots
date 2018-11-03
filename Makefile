spam.data: message_stat.csv
	sh -c "tail -n+2 message_stat.csv | cut -d';' -f1,18 | tr ';' ' ' >spam.data"

spamfold.data: message_stat.csv
	sh -c "tail -n+2 message_stat.csv | cut -d';' -f1,18 | tr ';' ' ' | ./fold.py --foldtype max >spamfold.data"

msgfold.data: message_stat.csv
	sh -c "tail -n+2 message_stat.csv | cut -d';' -f1 | sed s'/.*/\0 1/' | ./fold.py --foldtype sum --width 600 >msgfold.data"

rss.data: maild_stat.csv
	sh -c "tail -n+2 maild_stat.csv | cut -d';' -f1,4 | tr ';' ' ' >rss.data"

sessions.data:
	tail -n+2 message_stat.csv | cut -d';' -f1,2 | sed 's/\([^;]\);\(.*\)\+/\1 1\n\2 -1/' | sort -n | awk '{ sum += $$2; printf "%f %d\n", $$1, sum }' | ./fold.py --width=600 --foldtype=max >sessions.data

latency.data:
	tail -n+2 message_stat.csv | cut -d';' -f1,2 | tr ';' ' ' | awk '{ printf "%f %f\n", $$1, $$2 - $$1 }' >latency.data

latencyfold.data:
	tail -n+2 message_stat.csv | cut -d';' -f1,2 | tr ';' ' ' |  awk '{ printf "%f %f\n", $$1, $$2 - $$1 }' | ./fold.py --width 600 --foldtype max >latencyfold.data

utime.data:
	tail -n+2 maild_stat.csv | cut -d';' -f1,5 | tr ';' ' ' | ./fold.py --width 600 --foldtype sum >utime.data
