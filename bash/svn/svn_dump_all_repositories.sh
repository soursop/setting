#!/bin/bash
REPO_BASE=/SVN/SERVER/repository
cd "$REPO_BASE"
for f in *; do
	./../svn_dump_repository.sh $f
done
