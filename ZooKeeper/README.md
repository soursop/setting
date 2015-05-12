http://zookeeper.apache.org/doc/trunk/zookeeperProgrammers.html

# Introduction

# Questions

* 부모 서버와 연결이 끊겼을 때 어떻게 해당 서버를 자식 노드 리스트에서 제외시키나?

zookeeper 연결 + WAS 연결 => 같은 트랜젝션 단위로 작성. WAS 연결이 안되면 zookeeper 연결되 안됨 => 세션 종료 => zookeeper 임시 노드 자동 삭제

* 그렇다면 저장가능한 데이터는 무엇일까?

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
 뭔가 명확해 보이지만 추상적이다. active하다는 건 부모 노드 아래 자식 노드로 넣어준다는 뜻일테고, 세션을 유지한다는 건 어떻게 하겠다는 건지 이해가 안간다.
 세션 상황에 따라 제거가 될 수도 있으므로, 자손 노드를 못 가지게 되어 있다.
 
 * Sequence Nodes -- Unique Naming
 
 노드를 만들때 자동으로 path의 마지막에 카운트를 증가시킬 수록 할 수 있다. 부모 노드 아래에서 unique 하다. (파일 시스템이니 폴더 네임스페이스 개념하고 샆은듯)
 4bytes 단위이니 2147483647 이상 카운트 증가는 불가능 하다.
 
* Time in Zookeeper
 
 
 
 
