#!/bin/bash

after=${AFTER_COMMIT_SHA}
before=${BEFORE_COMMIT_SHA}
git config --global user.name 'christian bot'
git config  --global user.email 'chcardenas.ext@acciona.com'

git checkout development -q
for cmt in $(git rev-list --reverse $before..$after); do
    git checkout -q $cmt
    commit_message=$(git log -1 --pretty=format:"%s")
    changes=$(git diff --name-only HEAD^ HEAD)


    for change in ${changes[@]}; do


            if echo $commit_message | grep -qE '(!:)|BREAKING'; then
                    npm version major
                    version=$(awk '/version/{gsub(/("|",)/,"",$2);print $2}' package.json)
                    git tag -a $version-RFS -m $version-RFS
                    git tag -a $version-RC -m $version-RC
                    git tag -a $version-KO -m $version-KO
                    git push --tags
                    break
            fi

            if echo $commit_msg | grep -qE '^feat'; then
                       npm version minor
                       version=$(awk '/version/{gsub(/("|",)/,"",$2);print $2}' package.json)
                        git tag -a $version-RFS -m $version-RFS
                        git tag -a $version-RC -m $version-RC
                        git tag -a $version-KO -m $version-KO
                        git push --tags
                    break
            fi

            if ! echo $commit_msg| grep -qE '^fix'; then
                    npm version patch
                    version=$(awk '/version/{gsub(/("|",)/,"",$2);print $2}' package.json)
                    git tag -a $version-RFS -m $version-RFS
                    git tag -a $version-RC -m $version-RC
                    git tag -a $version-KO -m $version-KO
                    git push --tags
            fi
        
    done
    
done


