http://zookeeper.apache.org/doc/trunk/zookeeperProgrammers.html

# Introduction

# Questions

* 부모 서버와 연결이 끊겼을 때 어떻게 해당 서버를 자식 노드 리스트에서 제외시키나?

zookeeper 연결 + WAS 연결 => 같은 트랜젝션 단위로 작성. WAS 연결이 안되면 zookeeper 연결되 안됨 => 세션 종료 => zookeeper 임시 노드 자동 삭제

* 세션 유지는 어떻게 하나? ping을 계속 때리나?

* 데이터 락 관리는 제대로 되나?

### The ZooKeeper Data Model

* Data Model
 
그냥 트리 구조로 된 네임스페이스만 제공. 음..

* ZNodes
 
기본 노드. 노드 상태 변화를 감지하기 위해 버전 번호가 있다. 
(분산 환경 버전 관리가 거의 비슷한듯; elasticsearch도 그렇고 각 노드의 리비전 번호로 update, delete 등의 트랜젝션을 제어함)
 
* Watchers
 
변경 사항이 있을때마다, 클라이언트에게 변경 사항을 콜백으로 전송
 
* Data Access
 
Read할 때나 Write 할 때나 해당 네임스페이스의 모든 데이터를 읽어들이 거나 갈아치움.
1M 미만의 작은 데이터만 각 노드에 저장 가능. (대용량 데이터라면 NFS, HDFS를 쓰는게..)
 
* Ephemeral Nodes
 
세션을 유지하는 동안만 active한 znode를 생성해준다.
뭔가 명확해 보이지만 추상적이다. (active하다는 건 부모 노드 아래 자식 노드로 넣어준다는 뜻일테고, 세션을 유지한다는 건 어떻게 하겠다는 건지 이해가 안간다.)
세션 상황에 따라 제거가 될 수도 있으므로, 자손 노드를 못 가지게 되어 있다.
 
* Sequence Nodes -- Unique Naming
 
노드를 만들때 자동으로 path의 마지막에 카운트를 증가시킬 수록 할 수 있다. 부모 노드 아래에서 unique 하다. (파일 시스템이니 폴더 네임스페이스 개념하고 샆은듯)
4bytes 단위이니 2147483647 이상 카운트 증가는 불가능 하다.
 
### Time in Zookeeper
 
* Zxid

 일종의 트랜젝션 ID(ZooKeeper Transaction Id), Zookeeper 내의 모든 변경사항에 대해 순서대로 번호를 매긴 것. zxid1이 zxid2

* Version numbers

 각 노드의 버전 번호. 3가지의 버전 존재. version(data 변경), cversion(자식 노드의 개수 변경), aversion(ACL 변경)

* Ticks

 멀티 서버 ZooKeeper를 사용하는 경우, 각 이벤트(upload status, session timeouts, peer간 connection timeout)의 적용 시점을 정의하기 위해 tick을 사용한다. tick을 간접적으로 추론하는 것도 가능한다. tick time * 2배의 시간이 최소한의 session timeout 시간이 된다. 

* Real time

 znode 생성이나 수정 시에 timestamp를 추가하는 경우를 제외하고, real time을 사용하지 않는다. 

### ZooKeeper Stat Structure

각 필요한 정보를 필드에서 찾아올 수 있다. [참조](http://zookeeper.apache.org/doc/trunk/zookeeperProgrammers.html#sc_zkStatStructure)

### ZooKeeper Sessions

각 클라이언트 language로 구현된 handle 을 생성하여 ZooKeeper에 접속을 한다. 
한번 세션이 생성되면 CONNECTING상태가 되는데, ZooKeeper가 상태를 CONNECTED로 지정하였는지 확인하기 위해 다른 서버에 접속한다.
만약에 알수 없는 error(session expiration, authentication failure)가 발생하거나, 애플리케이션에서 handle을 종료 시키면 handle은 CLOSED tkdxork ehlsek.

[sessin]!(http://zookeeper.apache.org/doc/trunk/images/state_dia.jpg)

