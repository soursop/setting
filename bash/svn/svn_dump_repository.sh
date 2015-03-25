#!/bin/bash
REPO_BASE=/SVN/SERVER/repository
SVNADMIN=svnadmin
TARGET_SERVER=타깃호스트
cd "$REPO_BASE"
REVISION=`svn info svn://localhost/$1 --username ' 계정' --password '비번' | grep '^Revision:' | sed -e 's/^Revision: //'`
if [ -d "$1" ] && [[ $REVISION > 0 ]]; 
then
	echo "$REVISION"
	echo "1. dump repository"
	$SVNADMIN dump "$1" >"$1.svndump"
	#echo "$1" >"$f.testtext"
	echo "2. make conf tar"
	tar zcvf "${1}_conf.tar.gz" "$REPO_BASE/$1/conf" 

	echo "3. SSH make remote repository"
	ssh $TARGET_SERVER "$SVNADMIN create $REPO_BASE/$1"

	echo "4. SCP dump repository"
	#scp "$1.testtext" "계정@$TARGET_SERVER:$REPO_BASE/"
	scp "$1.svndump" "계정@$TARGET_SERVER:$REPO_BASE/"
	echo "5. SCP conf tar"
	scp "${1}_conf.tar.gz" "계정@$TARGET_SERVER:$REPO_BASE/"

	echo "6. SSH load dump file"
	ssh $TARGET_SERVER "$SVNADMIN load $REPO_BASE/$1 < $REPO_BASE/${1}.svndump"
	echo "7. SSH remove dump file"
	ssh $TARGET_SERVER "rm $REPO_BASE/${1}.svndump"
	echo "8. SSH untar conf"
	ssh $TARGET_SERVER "tar -zxvf $REPO_BASE/${1}_conf.tar.gz"
	echo "9. SSH remove conf tar"
	ssh $TARGET_SERVER "rm $REPO_BASE/${1}_conf.tar.gz"

	#rm "$1.testtext"
	echo "10. remove conf tar"
	rm "${1}_conf.tar.gz"
	echo "11. remove svndump"
	rm "$1.svndump"
fi
