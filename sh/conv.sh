#!/bin/sh  
for line in `find . -name *.lua| xargs file | awk -F: '{print $1,$2}' | awk '{print $1"|"$2}'`; do  
    name=`echo $line| cut -f1 -d\|`  
    code=`echo $line| cut -f2 -d\|`  
    if [[ $code == "ISO-8859" ]]; then  
        iconv -f GB2312 -t UTF-8 $name > /tmp/utf8.tmp  
        mv /tmp/utf8.tmp $name  
        echo "iconved file $name"  
    fi  
done  
