#!/bin/bash
REPO_BASE=/SVN/SERVER/repository
SVNADMIN=svnadmin
TARGET_SERVER=타깃호스트
cd "$REPO_BASE"
for f in *; do
	if [ -d "$f" ];
	then
		REVISION=`svn info svn://localhost/$f --username '계정' --password '비번' | grep '^Revision:' | sed -e 's/^Revision: //'`
		REMOTE_REVISION=`svn info svn://$TARGET_SERVER/$f --username '계정' --password '비번' | grep '^Revision:' | sed -e 's/^Revision: //'`
		echo "not changed: $(($REVISION)):$REMOTE_REVISION"
		if [[ $REVISION > 0 ]] && [[ $(($REMOTE_REVISION - $REVISION)) > 0 ]]; 
		then
			echo "changed range: $(($REVISION + 1)):$REMOTE_REVISION"

			ssh $TARGET_SERVER "$SVNADMIN dump $REPO_BASE/$f --revision $(($REVISION + 1)):head --incremental >$REPO_BASE/$f.svndump"

			#scp "$f.testtext" "계정@$TARGET_SERVER:$REPO_BASE/"
			scp "계정@$TARGET_SERVER:$REPO_BASE/$f.svndump" "$REPO_BASE/"

			$SVNADMIN load "$REPO_BASE/$f" < "$REPO_BASE/$f.svndump"
			ssh $TARGET_SERVER "rm $REPO_BASE/$f.svndump"

			#rm "$f.testtext"
			rm "$f.svndump"
		fi
	fi
done
