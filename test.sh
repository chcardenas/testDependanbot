#!/bin/bash

version=$(awk '/version/{gsub(/("|",)/,"",$2);print $2}' package.json)

  echo $version
IFS=":"
commit_message="feat(depen): bla"
#$(git log -1 --pretty=format:"%s")
feat=$(echo $commit_message | cut -d "(" -f2 | cut -d ")" -f1)
echo $feat
msg=$(echo "### $feat \n\n\n")
size=$(echo $feat | wc -c)
echo $commit_message
read -r -a strarr <<< "$commit_message"
echo ${strarr[1]}
data=" - ${strarr[1]}"
echo $data
if [ $size -lt 2 ]; then
    echo "zero" 
else
    #non-zero length
    echo "filed"
    echo $feat
fi

feat="feat(feature):asdsad
BREAKING"
if  echo $feat | grep -qE '^feat'; then
                    echo true
                    
fi
if echo $commit_message | grep -qE '^feat'; then
           echo "minor version"
           break
fi

