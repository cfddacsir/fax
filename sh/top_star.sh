top -b -o RES "-p"$(printf "%s," $(ps -Af | grep starccm | awk '{print $2}' ))"1" -n 2

