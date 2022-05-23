#!/bin/bash

after=842f9f82ec4069733810aaeb5a97ec1900654349 
before=4071057ddd3dac6558dcb464d321184592bfa7da
git checkout development -q
for cmt in $(git rev-list --reverse $before..$after); do
    git checkout -q $cmt
    commit_message=$(git log -1 --pretty=format:"%s")
    changes=$(git diff --name-only HEAD^ HEAD)


    for change in ${changes[@]}; do
        

            if echo $commit_message | grep -qE '(!:)|BREAKING'; then
                    npm version major
                    version= awk '/version/{gsub(/("|",)/,"",$2);print $2}' package.json
                    git tag -a $version-RFS -m $version-RFS
                    git tag -a $version-RC -m $version-RC
                    git tag -a $version-KO -m $version-KO
                    break
            fi

            if echo $commit_msg | grep -qE '^feat'; then
                       npm version minor
                       version= awk '/version/{gsub(/("|",)/,"",$2);print $2}' package.json
                        git tag -a $version-RFS -m $version-RFS
                        git tag -a $version-RC -m $version-RC
                        git tag -a $version-KO -m $version-KO
                    break
            fi

            if ! echo $(cat $version_change_file) | grep -qE '(MAJOR)|(MINOR)'; then
                    npm version patch
                    version= awk '/version/{gsub(/("|",)/,"",$2);print $2}' package.json
                    git tag -a $version-RFS -m $version-RFS
                    git tag -a $version-RC -m $version-RC
                    git tag -a $version-KO -m $version-KO
            fi
        
    done
    
done


