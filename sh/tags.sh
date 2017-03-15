#!/bin/sh

#ctags -R .
find ./ -name "*.cpp" -or -name "*.h" | xargs ctags --extra=f 

files=( 
    'x'
    'y'
    )

for dname in ${files[*]}; do
    find $dname Common/ OtherInclude/ -name "*.cpp" -or -name "*.h" | xargs ctags --extra=f -o $dname.tags
done
