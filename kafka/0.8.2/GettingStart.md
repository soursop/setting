# Step 1: Download code

다운로드 the 0.8.2.0 release, 압축 푼다.

    > wget http://mirror.apache-kr.org/kafka/0.8.2.0/kafka_2.10-0.8.2.0.tgz
    > tar -xzf kafka_2.10-0.8.2.0.tgz
    > cd kafka_2.10-0.8.2.0

# Step 2: Start the server

Kafka는 ZooKeeper를 이용하므로 먼저 ZooKeeper server를 실행시켜야 한다. 따로 설치를 안했다면,  패키지안에 존재하는 스크립트 패키지를 이용할 수 있다. 엉성하지만 single-node ZooKeeper instance를 얻을 수 있다.

    > bin/zookeeper-server-start.sh config/zookeeper.properties
    [2013-04-22 15:01:37,495] INFO Reading configuration from: config/zookeeper.properties (org.apache.zookeeper.server.quorum.QuorumPeerConfig)
    ...

Kafka server 실행:

    > bin/kafka-server-start.sh config/server.properties
    [2013-04-22 15:01:47,028] INFO Verifying properties (kafka.utils.VerifiableProperties)
    [2013-04-22 15:01:47,051] INFO Property socket.send.buffer.bytes is overridden to 1048576 (kafka.utils.VerifiableProperties)
    ...

# Step 3: Create a topic

single partition 과 replica를 1개 가진 "test" 토픽을 생성한다.

    > bin/kafka-topics.sh --create --zookeeper localhost:2181 --replication-factor 1 --partitions 1 --topic test

list topic command를 사용해 모든 토픽 리스트를 볼 수 있다 :

    > bin/kafka-topics.sh --list --zookeeper localhost:2181
    test

매번 토픽을 생성하는 대신, 브로커 설정을 통해 토픽이 존재하지 않을 때는 재동으로 토픽을 생성하도록 할 수 있다.

#Step 4: Send some messages

Kafka는 standard inout이나 파일로부터 input을 받아와 Kafka cluster로 전송할 수 있는 클라이언트도 함께 제공한다. 각 라인 입력시마다 메시지가 전송된다. Producer를 실행한 뒤 몇몇 메시지를 콘솔에 입력하면 서버로 전송이 된다.


    > bin/kafka-console-producer.sh --broker-list localhost:9092 --topic test 
    This is a message
    This is another message

ps. WARN Property topic is not valid (kafka.utils.VerifiableProperties)
라는 warn이 뜨지만 메시지는 제대로 간다. 이것때문에 안가는줄 알고 실제 소스까지 까서 삽질했다.

# Step 5: Start a consumer

command line consumer를 이용해 테스트를 해보자.

    > bin/kafka-console-consumer.sh --zookeeper localhost:2181 --topic test --from-beginning
    This is a message
    This is another message

위와 같이 메시지 전송을 받는 것을 확인 가능하다.
위의 명령들은 옵션이 다양한데 옵션없이 명령어를 치면 관련 옵션들을 확인 가능하다.

Step 6: Setting up a multi-broker cluster

추가적으로 변경할 필요 없이, 브로커 인스턴스를 추가시키는 것만으로도 multi-broker 설정이 가능하다.
(여기서는 로컬에서 kafka server 인스턴스를 여러개 띄운다. 하지만 본인은 다른 서버에서 띄워봤다.
각 브로커에 설정파일을 복사하자:

    > cp config/server.properties config/server-1.properties 
    > cp config/server.properties config/server-2.properties


아래의 프로퍼티 값을 수정하자:
 
config/server-1.properties:
    broker.id=1
    port=9093
    log.dir=/tmp/kafka-logs-1
 
config/server-2.properties:
    broker.id=2
    port=9094
    log.dir=/tmp/kafka-logs-2

(본인은 다른 서버에서 작업을 하였으므로 broker.id만 바꿔줬다. 서로 다른 서버에 인스턴스가 띄워져 있다면 포트랑 로그 dir은 중복되도 상관 없을듯 하여 그냥 두었다.)

broker.id는 클러스터에서 유일한 키값이므로 중복되면 안된다. 

이미 Zookeeper는 단일 노드를 가지고 있는 상태로 기동되어 있다. 그래서 나머지 2개의 노드를 기동 시켜야 한다:

    > bin/kafka-server-start.sh config/server-1.properties &
    ...
    > bin/kafka-server-start.sh config/server-2.properties &
    ...

이제 2개의 복제 factor를 이용해 새로운 토픽을 생성한다:

    > bin/kafka-topics.sh --create --zookeeper localhost:2181 --replication-factor 3 --partitions 1 --topic my-replicated-topic

주키퍼가 제대로 클러스터 정보를 갱신했는지를 확인하기 위해, "describe topics" command를 실행한다 :

    > bin/kafka-topics.sh --describe --zookeeper localhost:2181 --topic my-replicated-topic
    Topic:my-replicated-topic	PartitionCount:1	ReplicationFactor:3	Configs:
	    Topic: my-replicated-topic	Partition: 0	Leader: 1	Replicas: 1,2,0	Isr: 1,2,0

첫번째 줄은 모든 파티션의 요약 정보이고, 각 추가 라인은 1개 파티션의 정보를 보여준다. (예제에서는 파티션이 1개라 1줄만 추가 출력)

- leader		: read, write 권한 가진 노드
- replicas		: 해당 노드를 복제하는 노드 리스트 (leader도 복제 노드에 포함)
- isr			: 현재 in-sync상태인 복제 노드 집합. 현재 살아있고 leader와 sync가 맞는 상태이다

이미 생성했던 test 토픽에도 똑같이 상태를 확인할 수 있다.

    > bin/kafka-topics.sh --describe --zookeeper localhost:2181 --topic test
    Topic:test	PartitionCount:1	ReplicationFactor:1	Configs:
	    Topic: test	Partition: 0	Leader: 0	Replicas: 0	Isr: 0

test 토픽을 생성했을때, 복제노드가 서버 0번에만 있었기 때문에, 해당 복제본이 0개만 있는 것으로 나온다.

새로운 토픽에 몇가지 메시지를 publish해보자 :

    > bin/kafka-console-producer.sh --broker-list localhost:9092 --topic my-replicated-topic
    ...
    my test message 1
    my test message 2
    ^C 

이제 아래 메시지를 받아온다 :

    > bin/kafka-console-consumer.sh --zookeeper localhost:2181 --from-beginning --topic my-replicated-topic
    ...
    my test message 1
    my test message 2
    ^C

이제 fault-tolerance를 테스트 해보자. leader인 Broker 1를 kill 시켜보자 :

    > ps | grep server-1.properties
    7564 ttys002    0:15.91 /System/Library/Frameworks/JavaVM.framework/Versions/1.6/Home/bin/java...
    > kill -9 7564

leader가 다른 슬레이므로 변경되고 in-sync 복제 셋에서 1이 사라졌다:

    > bin/kafka-topics.sh --describe --zookeeper localhost:2181 --topic my-replicated-topic
    Topic:my-replicated-topic	PartitionCount:1	ReplicationFactor:3	Configs:
	    Topic: my-replicated-topic	Partition: 0	Leader: 2	Replicas: 1,2,0	Isr: 2,0

원래 메시지를 writed 하던 leader가 다운되었지만, consumption에는 이상이 없다. 메시지를 다 받아온다.:

    > bin/kafka-console-consumer.sh --zookeeper localhost:2181 --from-beginning --topic my-replicated-topic
    ...
    my test message 1
    my test message 2
    ^C

ps. 본인은 서버1, 서버2에서 클러스터링 테스트를 했음. 서버1 프로세스를 죽인후, 서버2가 leader가 되는 것을 확인. 하지만 서버2에서 새로운 메시지 전송 시도시 파이프가 깨졌다는 메시지 발생. shell-script 커멘드라 생긴 문제인지는 잘 모르겠음.
