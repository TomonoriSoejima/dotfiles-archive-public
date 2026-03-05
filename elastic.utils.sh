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
if [ "$(uname)" == "Darwin" ]
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
	alias locate='locate -i'                                                                  
	alias ycheck='open "http://yaml-online-parser.appspot.com/"'                                                                  
	alias echeck="ps -ef | grep -i elastic"
	alias don="sh start.sh"
	alias cl="curator_cli   --http_auth elastic:changeme "

	
	
fi



backup () 
{ 
    cp $1{,.`date +%Y-%m-%d`}
}
big () 
{ 
    osascript -e "tell application \"Quicksilver\" to show large type \"$1\""
}

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
	
	SLIST="bytes,KB,MB,GB,TB,PB,EB,ZB,YB";
	POWER=1;
	VAL=$( echo "scale=2; $atai / 1" | bc);
	VINT=$( echo $VAL / 1024 | bc );
	while [ $VINT -gt 0 ]; do
			let POWER=POWER+1;
			VAL=$( echo "scale=2; $VAL / 1024" | bc);
			VINT=$( echo $VAL / 1024 | bc );
	done;
	echo $VAL$( echo $SLIST | cut -f$POWER -d, )
}


ke () 
{
	echo "killing elastic & kibana process"
	kill -9 $(ps -ef |grep elastic | grep -v grep | awk '{print $2}')
	kill -9 $(ps -ef |grep kibana | grep -v grep | awk '{print $2}')

}


kel () 
{
	echo "killing Elasticsearch"
	kill -9 $(ps -ef |grep elastic | grep -v grep | awk '{print $2}')
	
}


elastic_dump ()
{
	pgrep Elasticsearch | awk -F' ' '{print $1}' | xargs jstack -l
}



ko ()
{
	code=$(echo $1 | awk -F "/" '{print $NF"#"}')
	echo "日時 : "
	echo 接続先 URL : $1
	echo ""
	echo 電話で参加される場合は以下を使用下さい。
	echo "電話番号 : (0)3-4578-1488"
	echo パスコード  $code

	open https://www.elastic.co/support_policy/japanese

}

# kibana2json is from https://github.com/spinscale/kibana2json
boon () 
{
    if [ $# -eq 0 ]; then
      echo "no file specified!!!" 1>&2
      exit
    fi

    cat $1 | kibana2json | jq -c '.hits.hits[] | { index: {_index:._index, _type:._type}}, ._source' > MY_BULK_DATA
    curl -sk -H "Content-Type: application/x-ndjson" -XPOST localhost:9200/_bulk --data-binary "@MY_BULK_DATA"; echo
    # rm MY_BULK_DATA
}


mappi ()
{
	name=$(jq -r 'keys[]' $1)
	echo $1 shows $name is the index name
	echo creating $name

	curl -s -XDELETE http://localhost:9200/$name > /dev/null

	jq .$name $1 |  curl -H 'Content-Type: application/x-ndjson' -s -X PUT "localhost:9200/$name" --data-binary @- | jq .
}

task ()
{
	name=$1

	printf "\n== Bulk uploading $2 to index... \n"
	cat $2 | jq -s '.[].nodes[].tasks | .[]'  | jq -cs --arg case_id $name '.[] |  { index: {_index: $case_id}}, .' |  http localhost:9200/_bulk

	printf "\n== Creating index pattern $name\n"

	printf '{
	"attributes": {
	"title": "%s",
	"timeFieldName": "start_time"
	}
	}' "$name" | 
	http  --follow --timeout 3600 post localhost:5601/api/saved_objects/index-pattern/$name?overwrite=true \
	kbn-xsrf:'True' \
	Content-Type:'application/json;charset=UTF-8' \
	Content-Type:'text/plain'


	open http://localhost:5601/app/kibana#/discover
}


ana () 
{
	tool="$HOME/elastic/source/support-analyzer-4.2.7/bin/"
	jps | grep Invoker > /dev/null

    if [ $? -eq 0 ]; then
      echo "Invoker is up already!!!"
	else
		$tool/support-analyzer > /dev/null 2>&1 &
		sleep 3
    fi

	$tool/upload-diagnostic $1
	if  [ $? -eq 0 ]; then
		
		echo $1 | grep "tar.gz$"
		zip_file=""
		if [ $? -eq 0 ]; then
			zip_file=$(echo $1 | sed -e s,.tar.gz,.zip,)
		else
			zip_file=analyzed-$1
		fi
		unzip analyzed-$zip_file
		open $(echo analyzed-$zip_file | sed -e 's,.zip,\/analyzed.html,')	
	fi

}