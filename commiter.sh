#!/bin/bash
reviewer=""
commit_to_e1=true
create_pull_request=true

if [[ $2 == *e2* ]]; then
	commit_to_e1=false
fi

if [[ $2 == *nopr* ]]; then
	create_pull_request=false
fi

reviewer=@$1

e1BranchName="SZOPTEST"

#push to equvalent branch in origin 
branchName=$(git symbolic-ref --short HEAD)
git push origin $branchName

if [[ create_pull_request == true ]]; then
	git create-pull-request $branchName test reviewer
fi

#checkout to DEVELOP if task is from E1

if [[ $branchName == *$e1BranchName* && $commit_to_e1 == true ]]; then
	git checkout develop
	git fetch origin
	git merge "origin/develop" --no-edit
	git merge $branchName --no-edit
	git push origin develop

fi

#checkout to DEVELOP_E2
git checkout develop_e2
git fetch origin
git merge "origin/develop_e2" --no-edit
git merge $branchName --no-edit
git push origin develop_e2
