#!/bin/bash

after=${AFTER_COMMIT_SHA}
before=${BEFORE_COMMIT_SHA}
IFS=':'
changelog_file=CHANGELOG.md
git config --global user.name 'christian bot'
git config  --global user.email 'chcardenas.ext@acciona.com'

for cmt in $(git rev-list --reverse $before..$after); do
    git checkout -q $cmt
    commit_message=$(git log -1 --pretty=format:"%s")
    echo "Message: $commit_message" 
    msg=$(echo $commit_message | cut -d "(" -f2 | cut -d ")" -f1)
    size=$(echo $msg | wc -c)
    read -a strarr <<< "$msg"
        if [ $size -lt 2 ]; then
           msg=$(echo - $strarr[1]) 
        else
           #non-zero length
            msg=$(echo "- ***$msg***: $strarr[1] ") 
        fi
        msgb=$(echo "### $strarr[0] ")
        echo $commit_message
        if echo $commit_message | grep -qE '(!:)|BREAKING'; then
        
           echo "major version"
           npm version major                  
                    
           break
        fi

        if echo $commit_msg | grep -qE '^feat'; then
           echo "minor version"
           npm version minor             
           break
        fi

        if  echo $commit_msg| grep -qE '^fix'; then
            echo "patch version"
            npm version patch
                    
        fi
        
    
done

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
git push --tags
