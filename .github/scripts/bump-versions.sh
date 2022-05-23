#!/bin/bash

after=${AFTER_COMMIT_SHA}
before=${BEFORE_COMMIT_SHA}
IFS=':'
changelog_file=CHANGELOG.md
git config --global user.name 'christian bot'
git config  --global user.email 'chcardenas.ext@acciona.com'

git checkout development -q
for cmt in $(git rev-list --reverse $before..$after); do
    git checkout -q $cmt
    commit_message=$(git log -1 --pretty=format:"%s")
    changes=$(git diff --name-only HEAD^ HEAD)
    msg=$(echo $commit_message | cut -d "(" -f2 | cut -d ")" -f1)
    size=$(echo $msg | wc -c)
    read -a strarr <<< "$msg"
    if [ $size -lt 2 ]; then
        msg=$(echo - $starr[1]) 
    else
        #non-zero length
        msg=$(echo "- ***$msg***: $starr[1] \n\n\n") 
    fi
    
    echo "$msg" >> $changelog_file
    for change in ${changes[@]}; do

            msg= $(echo "### $starr[0] \n\n\n")
            echo "$msg" >> $changelog_file
            if echo $commit_message | grep -qE '(!:)|BREAKING'; then
        
                    
                    npm version major
                    version=$(awk '/version/{gsub(/("|",)/,"",$2);print $2}' package.json)
                    git tag -a $version-RFS -m $version-RFS
                    git tag -a $version-RC -m $version-RC
                    git tag -a $version-KO -m $version-KO
                    
                    break
            fi

            if echo $commit_msg | grep -qE '^feat'; then
                       npm version minor
                       version=$(awk '/version/{gsub(/("|",)/,"",$2);print $2}' package.json)
                        git tag -a $version-RFS -m $version-RFS
                        git tag -a $version-RC -m $version-RC
                        git tag -a $version-KO -m $version-KO
                    break
            fi

            if ! echo $commit_msg| grep -qE '^fix'; then
                    npm version patch
                    version=$(awk '/version/{gsub(/("|",)/,"",$2);print $2}' package.json)
                    git tag -a $version-RFS -m $version-RFS
                    git tag -a $version-RC -m $version-RC
                    git tag -a $version-KO -m $version-KO
            fi
        
    done
    
done
date=$(git show -s --format=%cd --date=short )
msg=$(echo "## v$version ($date) \n\n\n")
 echo "$msg" >> $changelog_file
git add package.json CHANGELOG.md
git commit -m "CI: bump versions"
git push --tags
