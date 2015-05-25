### Kafka Offset Monitor
http://quantifind.com/KafkaOffsetMonitor/

    java -cp KafkaOffsetMonitor-assembly-0.2.1.jar \
     com.quantifind.kafka.offsetapp.OffsetGetterWeb \
     --zk zk-server1,zk-server2 \
     --port 8080 \
     --refresh 10.seconds \
     --retain 2.days

 zk : the ZooKeeper hosts
 port : app 이 실행될 port
 refresh : 얼마나 app이 자주 refresh되고 point를 DB에 저장할지
 retain : 어떤 기간 동안 points를 DB에 저장할지
 dbName : 어디에 history를 저장할지 (default 'offsetapp')
