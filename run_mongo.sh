#!/bin/bash

short_system=$(uname -s)
sys_vagrant="0"
sys_cygwin="0"
sys_osx="0"

system=$(uname -a)


if [ "$sys_vagrant" == "0" ]
then
# on vagrant guest


	mongo_running=$(ps -ae | grep mongod | wc -l | xargs)

	if [ "$mongo_running" == "1" ]
	then
		echo "Mongo is already running."
	else
	
		echo "Attempting to start mongod"
		
		rm ~/.mongo_log &> /dev/null
		$(mongod --fork --logpath ~/.mongo_log &> ~/.mongo_result);
		mongo_result=$(grep "Unclean shutdown" ~/.mongo_log | wc -l | xargs)
		
		if [ "$mongo_result" == "1" ]
		then
			echo "Mongo failed to shutdown tidily. Cleaning up now."
			rm /data/db/mongod.lock
			rm ~/.mongo_log
			$(mongod --dbpath /data/db --repair &> ~/.repair_result)
			$(mongod --fork --logpath ~/.mongo_log &> ~/.mongo_result);
		fi
		
		mongo_start_result=$(grep "started successfully" ~/.mongo_result | wc -l | xargs)
		
		if [ "$mongo_start_result" == "1" ]
		then
			echo "Mongo started successfully."
		else
			echo "Mongo has failed to start."
		fi
	fi
	
else

  if [ "$sys_osx" == "1" ]
  then

	echo "Run this only on vagrant"
  
  elif [ "$sys_cygwin" == "1"  ]
  then
  
	echo "Run this only on vagrant"

   fi
fi
