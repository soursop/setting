# Introduction

* 왜 스파크는 HOT할까?
 * 빠르다 : 메모리 이용, Lazy Execution, 효율적인 스케줄링
 * 안정적이다 : HDFS

# Menual

* Spark를 실행하는 방법은 크게 2가지다.
* 1. bin에서 쉘 스크립트(spark-shell) 실행 2. 클라이언트 언어를 사용해서 애플리케이션을 만들어 돌리기
* 개인적으로 1로 테스트 후, 2에 적용한다
* Spark Shell
 * 옵션과 같이 실행하기
 : MASTER=”spark://n001:7077” ADD_JARS=/home/myuserid/twitter4j/lib/twitter4j-core-3.0.5.jar SPARK_MEM=”24G” ./spark-shell 

# Problems

* [Task not serializable](http://stackoverflow.com/questions/22592811/task-not-serializable-java-io-notserializableexception-when-calling-function-ou)
 * RDD의 action이 실행될때 직렬화가 불가능 할 때가 있는데, 사실 이 문제의 경우 로컬 프로그래밍 습관 때문에 생기는 경우가 대부분이다.
 spark의 경우 각 job들이 분산 노드들에게 쪼개서 할당되는데, 이 경우 같이 공유 해야 하는 공유 자원들이 있다. 
 각 노드간에 공유해야 하는 자원들은 자동으로 serialize 통신을 하게 되는데, 
 이 경우 serialize 처리가 되어 있지 않는 객체들은 에러와 함께 죽어버리게 된다.
 e.g.) DriverManager.getConnection을 참조값으로 넘겨주는 경우
 e.g.) 공유 자원을 넘겨 줄때 각 노드간의 환경이 다른 경우(노드간의 스칼라 버전이 다른경우, serilize 형식이 다르므로 에러와 함께 죽음)
