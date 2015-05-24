# ELK Stack Example
### Performance Check

`top` : realtime cpu check

## Logstash (log parsing) 1.4.2
* Even though agent(logstash) is killed, it is ok to deliver date to broker as long as you restart agent. (you don't hava to restart all ELK Stack.)
* grok test page : http://grokdebug.herokuapp.com/patterns#

install

    tar zxvf logstash-1.4.2.tar.gz

sprintf format

    output {
      statsd {
        increment => "apache.%{[response][status]}"
      }
      file {
        path => "/var/log/%{type}.%{+yyyy.MM.dd.HH}"
      }
    }

## Redis (Broker) 2.8.19

Configuring Redis as a cache

    maxmemory 2mb
    maxmemory-policy allkeys-lru

data monitoring

    ./redis-cli monitor | grep -E ' "(get|set|rpush)" '
    ./redis-cli monitor         // monitor all log

process check

    netstat -tanpu|grep redis

problem
* Redis not allow unsubscribe from other thread. so, if logstash inputs contains redis, shutdownning your logstash would be impossible. 
* PUB Message is not stored in queue. if Subscriber is not exist, it would be possible missing some message.

## ElasticSearch (Search Engine)

remove all documents

    curl -XDELETE 'http://localhost:9200/logstash-2015.01.28/logs/_query' -d '{"query": {"match_all": {}}}'
    
remove index

    curl -XDELETE 'http://localhost:9200/logstash-2015.01.28/'
    
default expire config file

    config/mappings/_default/_default_.json

useful plugin 
* kopf : show all nodes, and shards information (https://github.com/lmenezes/elasticsearch-kopf/releases)
* elasticsearch-head : show query, and nodes (https://github.com/mobz/elasticsearch-head)
it dosen't exist release version. so after installed (bin/plugin --install mobz/elasticsearch-head), compress head folder. (tar zcvf elasticsearch-head-1.0.0.tar.gz head)
* bigdisk : show disk status (https://github.com/lukas-vlcek/bigdesk/releases)

query
* curl -XGET 'http://localhos:9200/logstash-2015.02.08/logs/_search?q=class:CommonsLogger.error'

## Kibana (Web UI)
* terms : count unique column (http://stackoverflow.com/questions/19102220/how-to-retrieve-unique-count-of-a-field-using-kibana-elastic-search)
