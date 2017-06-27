#!/bin/sh

#ctags -R .
echo "making ctags for '.' ..."
find ./ -name "*.cpp" -or -name "*.h" | xargs ctags --extra=f 

#dnames=( 
#    'x'
#    'y'
#    )

dnames=$*

if [[ -z $COMM_DIR ]]; then
    commonName="Common OtherInclude"
else
    commonName=$COMM_DIR
fi

for dname in ${dnames[*]}; do
    echo "making ctags for '$dname $commonName' ..."
    find $dname $commonName  -name "*.cpp" -or -name "*.h" | xargs ctags --extra=f -o $dname.tags
done

