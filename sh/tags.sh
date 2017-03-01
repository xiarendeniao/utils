#!/bin/sh

ctags -R .

files=( 
    'x'
    'y'
    )

for dname in ${files[*]}; do
    find $dname Common/ OtherInclude/ -name "*.cpp" -or -name "*.h" | xargs ctags --extra=f -o $dname.tags
done
