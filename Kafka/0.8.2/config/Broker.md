### ${kafka}/config/server.properties
http://kafka.apache.org/documentation.html#brokerconfigs

*용어* 

[offset](http://kafka.apache.org/documentation.html#Topics and Logs) : 각 파티션에서 유일한 메시지 id번호

Property | Default | Description 
--- | --- | --- 
**broker.id**						|					| 브로커의 `id`값. 클러스터에서 유일해야 함
log.dirs						| /tmp/kafka-logs	| 로그 파일 위치
**zookeeper.connect**				| null				| hostname:port 형식으로 주키퍼에 접속한다
num.partitions					| 1					| 토픽 생성시 파티션 개수가 지정되지 않았을 때, 기본 값
auto.create.topics.enable		| true				| 데이터를 produce할 때, 토픽이 없으면 자동 생성
offsets.topic.num.partitions 	| 50				| `offset` commit topic의 파티션 개수. 배포이후에는 변경이 안되기 떄문에 보통 높이 지정하는걸 추천 (e.g. 100-200)
**offsets.topic.retention.minutes**	| 1440				| `offset` 보관 기간
