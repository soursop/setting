### Execute

[백그라운드 실행](http://unix.stackexchange.com/questions/103731/run-a-command-without-making-me-wait)

    nohup long-running-command > /dev/null 2>&1 &
    # 2>&1의 의미는 표준 출력의 전달되는 곳으로 표준에러를 전달하라라는 의미. 
    
### Zip

압축풀기 (절대 경로로 압축했다면 압축 풀 폴더 지정 필요가 없다.)

    tar -zxvf [파일명.tar.gz] -C [압축 풀 폴더]
압축하기

    tar zcvf [파일명.tar.gz] [압축 폴더]

### SSH
[ssh 만들기](https://git-scm.com/book/ko/v1/Git-%EC%84%9C%EB%B2%84-SSH-%EA%B3%B5%EA%B0%9C%ED%82%A4-%EB%A7%8C%EB%93%A4%EA%B8%B0)

    ssh-keygen
    
[ssh로 파일이 있는지 체크하기](http://serverfault.com/questions/103174/check-to-see-if-a-directory-exists-remotely-shell-script)

    if ! ssh user@host "test -e '/usr/local/username/$folder'"; then
      # the file doesn't exist

[ssh 설정하기](https://opentutorials.org/module/432/3742)

접속 허용하고 싶은 target 서버에, 내 서버의 pub 키를 복사한다 (ex: ssh egoing.net 하고 싶을때)

    scp $HOME/.ssh/id_rsa.pub egoing@egoing.net:id_rsa.pub

target 서버에서 해당 pub 키를 추가한다
    
    cat $HOME/id_rsa.pub >> $HOME/.ssh/authorized_keys

### kill all process

    kill $(ps aux | grep '프로세스이름' | grep -v grep | awk '{print $2}')

### 서비스 등록

[우분투 서비스 컨트롤 방법](http://snoopybox.co.kr/1720)
