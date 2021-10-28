#!/bin/sh
#author                : dsxu
#Version               :
#Date Of Creation      : 2018-10-15

function AddToVimRc()
{
    # 为.vimrc添加快捷键
    vimrc="${HOME}/.vimrc_ds"
    rt=`grep -rn "gc1" $vimrc`
    if [[ -z $rt ]]
    then
        echo "\"快捷键调整tag文件：简洁c跳转、带声明的c跳转\(--c-types=+px\)、lua跳转" >> $vimrc
        echo ":map gc1 :set tags=tags <CR> " >> $vimrc
        echo ":map gc2 :set tags=tags2 <CR> " >> $vimrc
        echo ":map gc3 :set tags=tags3 <CR> " >> $vimrc
        echo ":map gc4 :set tags=tags4 <CR> " >> $vimrc
        echo ":map gc5 :set tags=tags5 <CR> " >> $vimrc
        echo ":map gl :set tags=luatags <CR> " >> $vimrc
        echo ":map gf :set tags=ftags <CR> " >> $vimrc
        echo ":map gcz :set tags=zonetags <CR> " >> $vimrc
        echo ":map gcb :set tags=battletags <CR> " >> $vimrc
        echo ":map gcs :set tags=scenetags <CR> " >> $vimrc
        echo ":map gca :set tags=alltags <CR> " >> $vimrc
        echo ":map gcp :set tags=pbtags <CR> " >> $vimrc
        echo ":map gcsh :set tags=shtags <CR> " >> $vimrc
    else
        echo "$vimrc added already"
    fi
}

function CreateCTag()
{
    if [[ $# -lt 2 ]]
    then
        echo "invalid params "$*
        exit 1
    fi

    code_dir_list=$1
    ctags_file=$2
    ctags_params="--extra=f"
    if [[ $# -ge 3 ]] 
    then
        ctags_params="$ctags_params $3"
    fi
    tmp_file=/tmp/c_tags_to_file

    find $code_dir_list -name "*.c" -or -name "*.h" -or -name "*.cpp" -or -name "*.cc" > $tmp_file && ctags $ctags_params -L $tmp_file -f $ctags_file

    if [[ $? == 0 ]]
    then
        echo "ctags \"$code_dir_list\" \"$ctags_params\" > \"$ctags_file\" succ"
    else
        echo "ctags \"$code_dir_list\" \"$ctags_params\" > \"$ctags_file\" failed"
    fi
}

function CreateLuaTag()
{
    if [[ $# -lt 2 ]]
    then
        echo "invalid params "$*
        exit 1
    fi

    code_dir_list=$1
    ctags_file=$2
    tmp_file=/tmp/lua_tags_to_file

    find $code_dir_list -name "*.lua" > $tmp_file

    ctags --langdef=MYLUA --langmap=MYLUA:.lua --regex-MYLUA="/^declare\(\'(\w+)\'\s*,.*$/\1/f/" \
        --regex-MYLUA="/^declare\(\"(\w+)\"\s*,.*$/\1/f/" \
        --regex-MYLUA="/^\s*(\w+)\s*=\s*class\s*\(.*$/\1/f/"  \
        --regex-MYLUA="/^.*\w+\.(\w+)\s*=\s*function\s*\(.*$/\1/f/" \
        --regex-MYLUA="/^.*\s*function\s*(\w+):(\w+).*$/\2/f/" \
        --regex-MYLUA="/^\s*(\w+)\s*=\s*[0-9]+.*$/\1/e/" \
        --regex-MYLUA="/^.*\s*function\s*(\w+)\.(\w+).*$/\2/f/" \
        --regex-MYLUA="/^.*\s*function\s*(\w+)\s*\(.*$/\1/f/" \
        --regex-MYLUA="/^\s*(\w+)\s*=\s*\{.*$/\1/e/" \
        --regex-MYLUA="/^\s*module\s+\"(\w+)\".*$/\1/m,module/" \
        --regex-MYLUA="/^\s*module\s+\"[a-zA-Z0-9._]+\.(\w+)\".*$/\1/m,module/" \
        --regex-MYLUA="/^\s*function\s*(\w+):initialize\s*\(.*$/\1/f/"  \
        --languages=MYLUA --excmd=pattern --extra=f -L $tmp_file -f$ctags_file

    if [[ $? == 0 ]]
    then
        echo "ctags \"$code_dir_list\" > \"$ctags_file\" succ"
    else
        echo "ctags \"$code_dir_list\" > \"$ctags_file\" failed"
    fi
}

function CreatePbTag()
{
    if [[ $# -lt 2 ]]
    then
        echo "invalid params "$*
        exit 1
    fi

    code_dir_list=$1
    ctags_file=$2
    tmp_file=/tmp/lua_tags_to_file

    find $code_dir_list -name "*.proto" > $tmp_file

    # 可以保存到 ~/.ctags文件中
    ctags --langdef=PROTO \
    --langmap=PROTO:.proto \
    --regex-PROTO="/^[ \t]*message[ \t]+([a-zA-Z0-9_\.]+)/\1/m,message/" \
    --regex-PROTO="/^[ \t]*(required|repeated|optional)[ \t]+[a-zA-Z0-9_\.]+[ \t]+([a-zA-Z0-9_]+)[ \t]*=/\2/f,field/" \
    --regex-PROTO="/^[ \t]*([a-zA-Z0-9_]+)[ \t]*=/\1/f,field/" \
    --languages=PROTO --excmd=pattern --extra=f -L $tmp_file -f$ctags_file

    if [[ $? == 0 ]]
    then
        echo "ctags \"$code_dir_list\" > \"$ctags_file\" succ"
    else
        echo "ctags \"$code_dir_list\" > \"$ctags_file\" failed"
    fi
}

# 为文件名建立跳转
ctags -f ftags --langdef=DS --langmap=DS:.lua.txt.h.cpp.c.cc.conf.proto.py.xml.proto.sh.go --languages=DS --extra=f -R .

# 为shell建立跳转
ctags -f shtags --langdef=SHELL --langmap=SHELL:.sh --regex-PROTO="/^[ \t]*function[ \t]+([a-zA-Z0-9_\.]+)[ \t]*()/\1/f/" --languages=SHELL --extra=f -R .

# 为C、C++建立跳转
CreateCTag "app/nrc/server/zonesvr" zonetags "--c-types=+px"

CreateCTag "app/nrc/server/scenesvr" scenetags "--c-types=+px"

CreateCTag "app/nrc/server/battlesvr" battletags "--c-types=+px"

#CreateCTag "app/nrc/protocol app/nrc/assets app/nrc/server libsrc/" tags "--c-types=+px"
CreateCTag "app/nrc/protocol app/nrc/assets app/nrc/server libsrc/" tags

CreateCTag . alltags "--c-types=+px"

# 为pb协议
CreatePbTag "app/nrc/protocol app/nrc/assets/config/proto" pbtags

# 把pbtags加入到tags里面，减少tags文件切换
cat pbtags >> tags

# 目录树
tree . > fs

tree -af . > fs2

# 添加vimrc的快捷键
AddToVimRc
