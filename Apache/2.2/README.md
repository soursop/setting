# Setting (Apache 2.0 -> Apache 2.2)

${APACHE_HOME} 폴더 구성하기

    ${APACHE_HOME}
	        bin
	        etc
        		apache2
        		libapache2-mod-jk
        	var
        		lock
        		log
	        		libapache2-mod-jk
	        	run

${APACHE_HOME}/etc/apache2/mods-enabled 폴더에서 로그 가능한 모듈만 추리기

* [standard module] (http://www.programkr.com/blog/MYjNyADMwYT5.html)

mod_jk 관련 경로 지정하기

    ${APACHE_HOME}/etc/apache2/mods-enabled/mod_jk.conf

apach2.conf 설정파일 수정하기

    ${APACHE_HOME}/etc/apache2/apach2.conf

* ServerRoot 지정하기
* import 설정 파일 경로 지정하기
* [아파치 실행 User Group 설정하기](http://askubuntu.com/questions/122330/unable-to-restart-apache-getting-error-apache2-bad-user-name-apache-run-use)
* [아파치 실행 계정으로 www-data 그룹을 추가 시키기] (http://serverfault.com/questions/130469/apache2-bad-user-name-www-data)
* 환경 변수로 설정 되어 있는 아파치 로그 -> 실제 경로로 변경하기

# Menual
[Http Auth] (http://httpd.apache.org/docs/2.2/ko/howto/auth.html)

# Problem Solve

[No groups file 문제] (https://forums.gentoo.org/viewtopic-t-691121-start-0.html)
: 모듈이 제대로 설치되어 있지 않아, http 인증 설정을 못불러옴
