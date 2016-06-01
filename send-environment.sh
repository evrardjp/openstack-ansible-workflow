HOST="$1"
PARAMS="${@:2}"
ansible-playbook -i "$HOST," -u root synchro.yml  -e folder="$HOST" $PARAMS

#ssh -t $HOST git config --global user.name "Jean-Philippe Evrard"
#ssh -t $HOST git config --global user.email "jean-philippe.evrard@rackspace.co.uk"
#ssh -t $HOST git config --global gitreview.username "evrardjp"
#
#echo "Start the build by typing  ..."
#echo ssh -t $HOST screen -S build sh /root/screen_start.sh
#
#echo "Join the build by typing..."
#echo "ssh -t root@$HOST screen -x build"
