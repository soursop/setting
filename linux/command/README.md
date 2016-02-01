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
    ssh-keygen -t rsa (rsa 방식의 공개키 쌍을 만들겠다는 옵션)
    
[ssh로 파일이 있는지 체크하기](http://serverfault.com/questions/103174/check-to-see-if-a-directory-exists-remotely-shell-script)

    if ! ssh user@host "test -e '/usr/local/username/$folder'"; then
      # the file doesn't exist

[ssh 설정하기](https://opentutorials.org/module/432/3742)

접속 허용하고 싶은 target 서버에, 내 서버의 pub 키를 복사한다 (ex: ssh egoing.net 하고 싶을때)

    user@client~$ scp $HOME/.ssh/id_rsa.pub egoing@egoing.net:id_rsa.pub

target 서버에서 해당 pub 키를 추가한다

    user@client~$ cat .ssh/id_rsa.pub | ssh ruser@server 'cat >> .ssh/authorized_keys'

target 서버에서 authorized_keys 권한을 변환한다 (이 .ssh 디렉토리는 권한이 반드시 700 (rwx --- ---)여야 합니다. 권한이 안전하게 설정되어 있지 않으면 OpenSSH는 에러를 뱉어내고 제대로 동작하지 않습니다.)

    user@client~$ ssh ruser@server 'chmod 600 .ssh/authorized_keys'

### kill all process

    kill $(ps aux | grep '프로세스이름' | grep -v grep | awk '{print $2}')

### 서비스 등록

[우분투 서비스 컨트롤 방법](http://snoopybox.co.kr/1720)
