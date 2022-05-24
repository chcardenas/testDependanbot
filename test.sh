#!/bin/bash

version=$(awk '/version/{gsub(/("|",)/,"",$2);print $2}' package.json)

  echo $version

commit_message=$(git log -1 --pretty=format:"%s")
feat=$(echo $commit_message | cut -d "(" -f2 | cut -d ")" -f1)
echo $feat
msg=$(echo "### $feat \n\n\n")
size=$(echo $feat | wc -c)
echo $msg
if [ $size -lt 2 ]; then
    echo "zero" 
else
    #non-zero length
    echo "filed"
fi

feat="feat(feature):asdsad
BREAKING"
if  echo $feat | grep -qE '^feat'; then
                    echo true
                    npm version major
fi

