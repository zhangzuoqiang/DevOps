#!/bin/bash


for war_line in `grep -v "^#"  war.txt`
  do
  echo "================="
  #echo $war_line

OLD_IFS="$IFS"
IFS=":"
war_arr=($war_line)
IFS="$OLD_IFS"
for war_s in ${war_arr[@]}
do  
   server_type=${war_arr[0]}
   war_path=${war_arr[1]}
done


   echo "server_type:$server_type server_path:$war_path"  >> /home/winupon/deploy.log

	for server_line in `grep -v "^#" remote_server.txt`
  	  do
                echo "-----------------"

	         OLD_IFS="$IFS"
                 IFS=":"
                 server_arr=($server_line)
                 IFS="$OLD_IFS"
                 for server_s in ${server_arr[@]}
                 do
    		   ip="${server_arr[0]}"	
    		   port="${server_arr[1]}"	
    		   user="${server_arr[2]}"	
		 done
	 echo "server_type:$server_type server_path:$war_path ip:$ip port:$port user:$user"

	#Remote execute shell
 	  ssh -p $port $user@$ip "mkdir -p /usr/local/src/deploy"
          ssh -p $port $user@$ip "rm -rf /usr/local/src/deploy/deploy.sh"
	  scp -P $port /usr/local/src/deploy/deploy.txt $user@$ip:/usr/local/src/deploy/deploy.sh
          echo deploy file create done!

          ssh -p $port $user@$ip "chmod +x /usr/local/src/deploy/deploy.sh"
	  ssh -p $port $user@$ip "/usr/local/src/deploy/deploy.sh $server_type $war_path" $user
   
  	done
        echo "server done"

         #local exec
        echo $server_type $war_path
	mkdir -p /usr/local/src/deploy
       rm -rf /usr/local/src/deploy/deploy.sh
       cp /usr/local/src/deploy/deploy.txt /usr/local/src/deploy/deploy.sh
       chmod +x /usr/local/src/deploy/deploy.sh
        /usr/local/src/deploy/deploy.sh $server_type $war_path $user
  done



