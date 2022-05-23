#!/bin/bash

version=$(awk '/version/{gsub(/("|",)/,"",$2);print $2}' package.json)

  echo $version