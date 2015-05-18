http://kafka.apache.org/07/performance.html

# Performance Results

아래의 테스트는 토픽, 컨슈머, 프로듀서 개수에 따른 Kafka 처리량에 대한 기본적이 정보를 제공한다. 카프카 노드는 각각 독립적이기 때문에, 단일 프로듀서, 컨슈머, 브로커 만으로도 large cluster 결과치를 추정 가능하다.

서로 영향을 주지 않기 위해 프로듀서와 컨슈머 테스트를 분리하여 시행한다. 컨슈머의 경우 캐시 되지 않은 lacklog message를 테스트(cold performance)를 시행한다. production 과 consumption를 동시에 테스트 하면 cache가 활성화 되기 때문에 퍼포먼스에 도움을 주는 경향이 있다.

파라미터는 아래와 같이 세팅한다 :

- message size = 200 bytes
- batch size = 200 messages
- fetch size = 1MB
- flush interval = 600 messages

# What is the producer throughput as a function of batch size?

50MB/sec 처리량으로 시스템에 데이터를 전송할 수 있다. 하지만, 이 숫자는 배치 사이즈에 따라 변할 수 있다. 아래의 그래프는 2가지 요소의 관계를 표현해준다.

![producer throughput](http://kafka.apache.org/07/images/onlyBatchSize.jpg)

# What is the consumer throughput?

테스트에 따르면, 브로커에서 100M/sec가량을 소비할 수 있다. 그리고 전체 수치는 컨슈머 스레드 숫자를 증가시키더라도 별다른 변화를 보이지 않는다.

![consumer throughput](http://kafka.apache.org/07/images/onlyConsumer.jpg)

# Does data size effect our performance?

![data size](http://kafka.apache.org/07/images/dataSize.jpg)

# What is the effect of the number of producer threads on producer throughput?

몇개의 스레드만으로도 최대 아웃풋이 나온다.

![number of producer threads](http://kafka.apache.org/07/images/onlyProducer.jpg)

# What is the effect of number of topics on producer throughput?

토픽의 개수는 전체 데이터 처리에 약간의 영향을 미친다. 아래의 그래프에서는 40개의 프로듀서와 다양한 숫자의 토픽을 사용했을 때의 결과치이다.

![umber of topics](http://kafka.apache.org/07/images/onlyTopic.jpg)

# How to Run a Performance Test

perf 폴더 아래 퍼포먼스와 관련된 코드가 있다. 실행하기 위해서는 :

     ../run-simulator.sh -kafkaServer=localhost -numTopic=10  -reportFile=report-html/data -time=15 -numConsumer=20 -numProducer=40 -xaxis=numTopic

이 코드는 40개의 프로듀서와 20개의 컨슈머 쓰레드가 로컬 카프카 서버에서 producing/consuming하게 될 것이다. 이 시뷸레이터는 15분동안 실행되며, 결과는 report-html/data 에 저장될 것이다. 

기본적으로 consumed/produced된 데이터 MB, 주어진 토픽 숫자에 따라 consumed/produced된 메시지의 수를 기록하게 된다. report.html에서 char를 그려울 것이다.

다른 파라미터들은 numParts, fetchSize, messageSize를 포함하고 있다.

토픽의 수가 얼마나 테스트에 영향을 미쳤나 테스트하기 위해서, 아래의 스크립트를 사용할 수 있다. (utlbin 폴더 아래 있다)

    #!/bin/bash
    for i in 1 10 20 30 40 50;
    do
      ../kafka-server.sh server.properties 2>&1 >kafka.out&
    sleep 60
     ../run-simulator.sh -kafkaServer=localhost -numTopic=$i  -reportFile=report-html/data -time=15 -numConsumer=20 -numProducer=40 -xaxis=numTopic
     ../stop-server.sh
     rm -rf /tmp/kafka-logs
     sleep 300
    done
