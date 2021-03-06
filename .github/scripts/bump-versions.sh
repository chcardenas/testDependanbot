#!/bin/bash

after=${AFTER_COMMIT_SHA}
before=${BEFORE_COMMIT_SHA}
IFS=':'
changelog_file=CHANGELOG.md
git config --global user.name "christian cardenas"
git config --global user.email "chcardenas.ext@acciona.com"
push=0
remoteRepo="https://${GITHUB_ACTOR}:${GITHUB_TOKEN}@github.com/${GITHUB_REPOSITORY}.git"
echo $remoteRepo
for cmt in $(git rev-list --reverse $before..$after); do
    git checkout -q $cmt
    echo "Looking messages"
    commit_message=$(git log -1 --pretty=format:"%b")
    msg=$(echo $commit_message | cut -d "(" -f2 | cut -d ")" -f1)
    size=$(echo $msg | wc -c)
    read -a strarr <<< "$commit_message"
        comments=$(git log -1 -s --pretty=format:"%b")
        if [ $size -lt 2 ]; then
           msg="- ${comments}" 
        else
            msg="- ***$msg***: ${comments} " 
        fi
        msgb="### ${strarr[0]} "
        
        if echo $commit_message | grep -qE '(!:)|BREAKING'; then 
           echo "major version"
           npm version major --git-tag-version false 
           push=1
           break
        fi

        if echo $commit_message | grep -qE '^feat'; then
           echo "minor version"
           npm version minor --git-tag-version false
           push=1
           break
        fi

        if  echo $commit_message | grep -qE '^fix'; then
            echo "patch version"
            npm version patch --git-tag-version false
            push=1
        fi
        
    
done
zero=0
if [[ $push -eq $zero ]]; then
    echo "Exit without changes"
    exit 1;
fi
version=$(awk '/version/{gsub(/("|",)/,"",$2);print $2}' package.json)
echo $version
date=$(git show -s --format=%cd --date=short )
msgc=$(echo "## v$version ($date) ")
#echo "$msgc" >> $changelog_file
#echo "$msgb" >> $changelog_file
#echo "$msg" >> $changelog_file

echo -e "$msg \n\n\n$(cat $changelog_file)" > $changelog_file
echo -e "$msgb \n\n\n$(cat $changelog_file)" > $changelog_file

echo -e "$msgc \n\n\n$(cat $changelog_file)" > $changelog_file
git  checkout development
git add package.json CHANGELOG.md
git commit -m "CI: bump versions"
git push 
git tag -a $version-RFS -m $version-RFS
git tag -a $version-RC -m $version-RC
git tag -a $version-KO -m $version-KO
git push  --tags
exit 0