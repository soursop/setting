Property | Default | Description 
--- | --- | --- 
`broker.id`						|					| 브로커의 id값. 클러스터에서 유일해야 함
log.dirs						| /tmp/kafka-logs	| 로그 파일 위치
`zookeeper.connect`				| null				| hostname:port 형식으로 주키퍼에 접속한다
num.partitions					| 1					| 토픽 생성시 파티션 개수가 지정되지 않았을 때, 기본 값
auto.create.topics.enable		| true				| 데이터를 produce할 때, 토픽이 없으면 자동 생성
offsets.topic.num.partitions 	| 50				| 파티션 off셋 카운트 되는 숫자. 보통 높이 지정하는걸 추천 (e.g. 100-200)
offsets.topic.retention.minutes	| 1440				| 메시지 보관 기간
