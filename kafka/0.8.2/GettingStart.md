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

We can now see that topic if we run the list topic command:

    > bin/kafka-topics.sh --list --zookeeper localhost:2181
    test

Alternatively, instead of manually creating topics you can also configure your brokers to auto-create topics when a non-existent topic is published to.
Step 4: Send some messages

Kafka는 standard inout이나 파일로부터 input을 받아와 Kafka cluster로 전송할 수 있는 클라이언트도 함께 제공한다. 각 라인 입력시마다 메시지가 전송된다. Producer를 실행한 뒤 몇몇 메시지를 콘솔에 입력하면 서버로 전송이 된다.


    > bin/kafka-console-producer.sh --broker-list localhost:9092 --topic test 
    This is a message
    This is another message

ps. WARN Property topic is not valid (kafka.utils.VerifiableProperties)
라는 warn이 뜨지만 메시지는 제대로 간다. 이것때문에 안가는줄 알고 실제 소스까지 까서 삽질했다.
