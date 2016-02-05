#/bin/sh
{ nc -l 0 & } && PID=$!
PORT=$(lsof -p $PID | grep TCP | cut -d ':' -f2 | cut -d ' ' -f1) 
kill -15 $PID >/dev/null && echo $PORT

