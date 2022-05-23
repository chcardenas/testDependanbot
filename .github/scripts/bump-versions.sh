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
    changes=$(git diff --name-only HEAD^ HEAD)
    msg=$(echo $commit_message | cut -d "(" -f2 | cut -d ")" -f1)
    size=$(echo $msg | wc -c)
    read -a strarr <<< "$msg"
    
    
    
    for change in ${changes[@]}; do
            if [ $size -lt 2 ]; then
                msg=$(echo - $starr[1]) 
            else
                #non-zero length
                msg=$(echo "- ***$msg***: $starr[1] ") 
            fi
            msgb=$(echo "### $starr[0] ")
            
            if echo $commit_message | grep -qE '(!:)|BREAKING'; then
        
                    
                    npm version major                  
                    
                    break
            fi

            if echo $commit_msg | grep -qE '^feat'; then
                       npm version minor
                        
                    break
            fi

            if ! echo $commit_msg| grep -qE '^fix'; then
                    npm version patch
                    
            fi
        
    done
    
done
version=$(awk '/version/{gsub(/("|",)/,"",$2);print $2}' package.json)
date=$(git show -s --format=%cd --date=short )
msgc=$(echo "## v$version ($date) ")
#echo "$msgc" >> $changelog_file
#echo "$msgb" >> $changelog_file
#echo "$msg" >> $changelog_file

sed -i $msg
sed -i $msgb
sed -i $msgc
git  checkout development
git add package.json CHANGELOG.md
git commit -m "CI: bump versions"
git push 
git tag -a $version-RFS -m $version-RFS
git tag -a $version-RC -m $version-RC
git tag -a $version-KO -m $version-KO
git push --tags
