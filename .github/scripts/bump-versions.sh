#!/bin/bash

after=${AFTER_COMMIT_SHA}
before=${BEFORE_COMMIT_SHA}
git checkout development -q
for cmt in $(git rev-list --reverse $before..$after); do
    git checkout -q $cmt
    commit_message=$(git log -1 --pretty=format:"%s")
    changes=$(git diff --name-only HEAD^ HEAD)
    
        version_file_dir=$(dirname $version_file)
        version_change_file=$version_file_dir/version_changelog

        for change in ${changes[@]}; do
            if echo $change | grep -q $version_file_dir; then

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
            fi
        done
    
done


