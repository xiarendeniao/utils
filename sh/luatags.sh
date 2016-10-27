#!/bin/sh
args=$*
if [[ $# -eq 0 ]]; then
    args=.
fi
ctags --langdef=MYLUA --langmap=MYLUA:.lua --regex-MYLUA="/^declare\(\"(\w+)\"\s*,.*$/\1/f/" --regex-MYLUA="/^\s*(\w+)\s*=\s*class\s*\(.*$/\1/f/"  --regex-MYLUA="/^.*\w+\.(\w+)\s*=\s*function\s*\(.*$/\1/f/" --regex-MYLUA="/^.*\s*function\s*(\w+):(\w+).*$/\2/f/" --regex-MYLUA="/^\s*(\w+)\s*=\s*[0-9]+.*$/\1/e/" --regex-MYLUA="/^.*\s*function\s*(\w+)\.(\w+).*$/\2/f/" --regex-MYLUA="/^.*\s*function\s*(\w+)\s*\(.*$/\1/f/" --regex-MYLUA="/^\s*(\w+)\s*=\s*\{.*$/\1/e/" --regex-MYLUA="/^\s*module\s+\"(\w+)\".*$/\1/m,module/" --regex-MYLUA="/^\s*module\s+\"[a-zA-Z0-9._]+\.(\w+)\".*$/\1/m,module/" --regex-MYLUA="/^\s*function\s*(\w+):initialize\s*\(.*$/\1/f/"  --languages=MYLUA --excmd=pattern --extra=f -R $args
