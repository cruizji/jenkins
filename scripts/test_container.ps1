
#!/bin/bash
contador=0

while true
do
  ((contador=contador+1))
  STATUS=$(curl -s -o /dev/null -w '%{http_code}' http://localhost:8000)
  if [ $STATUS -eq 200 ] || [ $contador -eq 3 ]; then
    echo "Got 200! All done!"
    break
  else
    echo "Got $STATUS :( Not done yet..."
    sleep 1
  fi

done
