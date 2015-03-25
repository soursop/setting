# Execute

[백그라운드 실행](http://unix.stackexchange.com/questions/103731/run-a-command-without-making-me-wait)

    nohup long-running-command > /dev/null 2>&1 &
    # 2>&1의 의미는 표준 출력의 전달되는 곳으로 표준에러를 전달하라라는 의미. 
    
# Zip

압축풀기 (절대 경로로 압축했다면 압축 풀 폴더 지정 필요가 없다.)

    tar -zxvf [파일명.tar.gz] -C [압축 풀 폴더]
압축하기

    tar zcvf [파일명.tar.gz] [압축 폴더]

# SSH

[ssh로 파일이 있는지 체크하기](http://serverfault.com/questions/103174/check-to-see-if-a-directory-exists-remotely-shell-script)

    if ! ssh user@host "test -e '/usr/local/username/$folder'"; then
      # the file doesn't exist
