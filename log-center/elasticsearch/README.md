curl http://10.149.149.3:32760/_cat/nodes?v

curl http://10.149.149.3:32760/books/_count?pretty

curl 192.168.3.236:9200/_cat/indices?

curl 10.149.149.3:32760/_cat/indices?

curl http://192.168.3.236:9200/_cluster/health?pretty

curl http://192.168.3.236:9200/_cat/master

curl http://192.168.3.236:9200/_cat/indices?v

curl http://192.168.3.236:9200/_cat/shards/{index}


curl -XPUT 'http://10.149.149.3:32760/company/' -d '{
    "settings" : {
        "index" : {
            "number_of_shards" : 3,
            "number_of_replicas" : 2
        }
    }
}'
curl -XDELETE 'http://10.149.149.3:32760/company'
