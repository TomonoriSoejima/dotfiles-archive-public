#  ---------------------------------------------------------------------------
#
#  Description:  This file holds all my BASH configurations and aliases tailed for ESP.
#
#  Sections:
#  1.   alias
#  2.   function
#  3.   completion
#  4.   Reminders & Notes
#


#   -------------------------------
#   1.  alias
#   -------------------------------

 # this is to make sure there is no unsable alias set for mac.
if [ "$(uname)" != "Darwin" ]
then
	alias vlog='find $FASTSEARCH/var/log/ > ~/.secretlog ; vi ~/.secretlog'
	alias vcon='find $FASTSEARCH/etc/ > ~/.conf ; vi ~/.conf'
	alias vfix='find $FASTSEARCH/data/data_fixml | grep "gz$" | sort > ~/.fix ; vi ~/.fix'
	alias tools="cd $HOME/share/unixtools"
	alias td='cd /mnt/share/ESP-TEST-DATA'
	alias ins='cd ~/share/FAST-Products/esp/esp.5.3/linux/release'
	alias clean="nctrl stop indexer; rm -rf $FASTSEARCH/data/data_{fixml,index}; rm $FASTSEARCH/var/log/indexer/* ; nctrl start indexer"
	export PGPASSWORD=fast
	PATH="$PATH":/usr/local/mysql/bin
	PATH="$PATH:`pwd`/bin:/mnt/share/unixtools:$JAVA_HOME/bin:/mnt/share/unixtools/dstat-0.7.2"
	export PATH
	alias pgit="git log --pretty=format:'%h : %s' --topo-order --graph"
	
	alias grep='grep --color=always'
	alias which='which -a'
	alias pgrep='pgrep -lf'
	alias ss='$FASTSEARCH/rdbms/bin/mysql -S $FASTSEARCH/rdbms/mysql.sock -ufast -pfast vespa'
	alias td='cd /mnt/share/ESP-TEST-DATA'
	alias locate='locate -i'                                                                  
	
	alias dstat-full='dstat -Tclmdrn' 
	alias dstat-mem='dstat -Tclm'
	alias dstat-cpu='dstat -Tclr'
	alias dstat-net='dstat -Tclnd'
	alias dstat-disk='dstat -Tcldr'
	
	export LS_COLORS='no=00;36:fi=00;36:di=04;31:ln=01'
	export EXINIT="set ic nu"
	export PS1="[\u@\h \W]\\$"
	alias qr2="nctrl start qrserver; sleep 3; wget  http://$(hostname):15100/control?debug.timings=1"

	complete -W "$(echo `cat ~/share/team/completion/comp_indexeradmin`)" inad   
	complete -W "$(echo `cat ~/share/team/completion/comp_indexerinfo`)" in2
	complete -W "$(echo `cat ~/share/team/completion/comp_crawleradmin`)" crad

fi





if [ "$(uname)" != "Darwin" ]
then

	cu () { cd ~/Logs/$1 ; }

	_cuslog() {
	  local cur
	  cur=${COMP_WORDS[COMP_CWORD]}
	  COMPREPLY=( $( compgen -S/ -d ~/Logs/$cur |  sed -e s,^.*Logs\/,,  ) )
	  # COMPREPLY=( $( compgen -S/ -d ~/Logs/$cur | \grep APAC | sed -e s,^.*Logs\/,,  ) )
	}

	complete -o nospace -F _cuslog cu

fi

# you need to create ~/Logs on your home.
# run this at home




function server() { # via https://gist.github.com/1525217                                                                                
    local host=`hostname`
    local port="${1:-8888}"
    (sleep 1 && open "http://${host}:${port}/")&
    python -m SimpleHTTPServer "$port"

}


alias urldecode='python -c "import sys, urllib as ul; print ul.unquote_plus(sys.stdin.readline())"'




bb()
{
	password="btmufj"
	echo $@
	zip -eP $password $1.zip "$@"
	echo $1.zip created with $password
}



backup () 
{ 
    cp $1{,.`date +%Y-%m-%d`}
}
big () 
{ 
    osascript -e "tell application \"Quicksilver\" to show large type \"$1\""
}

get ()
{
	col=` echo $1 | tr '_' ' ' | cut -d" " -f 2`
	getfixml -m -c $col -i $1
}

wtol()
{
	echo "$1" | tr '\' '/'
}

# byte () 
# { 
# 		SLIST="bytes,KB,MB,GB,TB,PB,EB,ZB,YB";
# 		POWER=1;
# 		VAL=$( echo "scale=2; $1 / 1" | bc);
# 		VINT=$( echo $VAL / 1024 | bc );
# 		while [ $VINT -gt 0 ]; do
# 				let POWER=POWER+1;
# 				VAL=$( echo "scale=2; $VAL / 1024" | bc);
# 				VINT=$( echo $VAL / 1024 | bc );
# 		done;
# 		echo $VAL$( echo $SLIST | cut -f$POWER -d, )
# }

byte () 
{ 
	atai=""
	if  [ $# -eq 0 ]; then
		local in; 
		read in;
		atai=$in
	else 
		atai=$1
	fi
	
	echo $atai

		# SLIST="bytes,KB,MB,GB,TB,PB,EB,ZB,YB";
		# POWER=1;
		# VAL=$( echo "scale=2; $atai / 1" | bc);
		# VINT=$( echo $VAL / 1024 | bc );
		# while [ $VINT -gt 0 ]; do
		# 		let POWER=POWER+1;
		# 		VAL=$( echo "scale=2; $VAL / 1024" | bc);
		# 		VINT=$( echo $VAL / 1024 | bc );
		# done;
		# echo $VAL$( echo $SLIST | cut -f$POWER -d, )
}

fixml_range() {
		MAGIC=250
		if [ ! $# == 1 ] 
		then
				echo "range parameter is missing"
				echo "e.g) sh $0 409"
				exit 1
		fi

		echo "running fixml range calc for $1"
		AFTER="${1/$'\r'/}"

		SET=$(expr $AFTER / $MAGIC)
		ELEM=$(expr $AFTER % $MAGIC)
		printf "Set_00%x/" $SET
		printf "Elem_%x\n" $ELEM
}

getrandom() {
		echo -n "How many random numbers do you want to generate? "
		read max

		for (( start = 1; start <= $max; start++ ))
		do
				echo -e $RANDOM
		done
}


getinternalid() {
	for i in $(cat $1);do
		echo -n $i | md5 | awk '{print $1"_momo"}' | sed -e s,momo,$2,
done
}


co() {

	collection-admin -m listcollections | grep -v PRO | awk -F" " '{print $NF}' | sed -n '5,$p' | sed -n  '$!p'

}



# complete
espprocess=`cat << P
adminserver
browserengine
cachemanager
cglogdispatcher
clarity_webcluster
completionserver
configserver
contentdistributor
crawler
fdmworker
httpd
indexer
indexingdispatcher
lmgrd
logserver
logtransformer
master
nameservice
nctrl
procserver_1
qrserver
resourceservice
search-1
storageservice
ubermaster
walinkstorerreceiver
walookupdb0
webanalyzer
start
status
restart
reloadcfg
stop
topfdispatch
alertengine
aedispatcher
alerting_alertengine_0
alerting_aedispatcher_0
P`


complete -W "$(echo $espprocess)" nctrl
