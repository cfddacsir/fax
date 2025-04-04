loo=$(loo)
echo $loo

port=$(          head -n 100 $(loo) | grep -e Server | \
                 awk '{print $3}' | \
								 awk -F ":" '{print $2 }' )

printf "
  port = $port 

"


