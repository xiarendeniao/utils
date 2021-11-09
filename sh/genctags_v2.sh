#!/bin/sh
#author                : dsxu
#Version               :
#Date Of Creation      : 2018-10-15

function add_to_vimrc()
{
    vimrc="${HOME}/.vimrc_ds"
    name=$1
    tag=$2
    rt=`grep -rn "$name" $vimrc`
    if [[ -z $rt ]]
    then
        echo ":map $name :set tags=$tag <CR> " >> $vimrc
        echo 'added ":map $name :set tags=$tag <CR> " to $vimrc'
    else
        echo "ignored $name $tag"
    fi
}

function AddToVimRc()
{
    add_to_vimrc gc1 tags
    add_to_vimrc gc2 tags2
    add_to_vimrc gc3 tags3
    add_to_vimrc gc4 tags4
    add_to_vimrc gc5 tags5
    add_to_vimrc gl luatags
    add_to_vimrc gf ftags
    add_to_vimrc gcz zonetags
    add_to_vimrc gcb battletags
    add_to_vimrc gcs scenetags
    add_to_vimrc gca alltags
    add_to_vimrc gcpb pbtags
    add_to_vimrc gcsh shtags
    add_to_vimrc gcpy pytags
    add_to_vimrc gcgo gotags
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

    find $code_dir_list -name "*.c" -or -name "*.h"  -or -name "*.hpp" -or -name "*.cpp" -or -name "*.cc" > $tmp_file && ctags $ctags_params -L $tmp_file -f $ctags_file

    if [[ $? == 0 ]]
    then
        echo "ctags \"$code_dir_list\" \"$ctags_params\" > \"$ctags_file\" succ"
    else
        echo "ctags \"$code_dir_list\" \"$ctags_params\" > \"$ctags_file\" failed"
    fi
}

function CreatePyTag()
{
    if [[ $# -lt 2 ]]
    then
        echo "invalid params "$*
        exit 1
    fi

    code_dir_list=$1
    ctags_file=$2
    tmp_file=/tmp/c_tags_to_file

    find $code_dir_list -name "*.py" > $tmp_file

    ctags --extra=f -L $tmp_file -f $ctags_file

    if [[ $? == 0 ]]
    then
        echo "ctags \"$code_dir_list\" > \"$ctags_file\" succ"
    else
        echo "ctags \"$code_dir_list\" > \"$ctags_file\" failed"
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

function CreateGoTag()
{
    if [[ $# -lt 2 ]]
    then
        echo "invalid params "$*
        exit 1
    fi

    code_dir_list=$1
    ctags_file=$2
    tmp_file=/tmp/lua_tags_to_file

    find $code_dir_list -name "*.go" > $tmp_file

    # 可以保存到 ~/.ctags文件中
    ctags --langdef=GO \
    --langmap=GO:.go \
    --regex-Go="/func([ \t]+\([^)]+\))?[ \t]+([a-zA-Z0-9_]+)/\2/d,func/" \
    --regex-Go="/var[ \t]+([a-zA-Z_][a-zA-Z0-9_]+)/\1/d,var/" \
    --regex-Go="/type[ \t]+([a-zA-Z_][a-zA-Z0-9_]+)/\1/d,type/" \
    --languages=GO --excmd=pattern --extra=f -L $tmp_file -f$ctags_file

    if [[ $? == 0 ]]
    then
        echo "ctags \"$code_dir_list\" > \"$ctags_file\" succ"
    else
        echo "ctags \"$code_dir_list\" > \"$ctags_file\" failed"
    fi
}

# 为文件名建立跳转
ctags -f ftags --langdef=DS --langmap=DS:.lua.txt.h.cpp.c.cc.conf.proto.py.xml.proto.sh.go.php.json --languages=DS --extra=f -R .

# 为shell建立跳转
ctags -f shtags --langdef=SHELL --langmap=SHELL:.sh --regex-SHELL="/^[ \t]*function[ \t]+([a-zA-Z0-9_]+)[ \t]*()/\1/f/" --languages=SHELL  --excmd=pattern --extra=f -R .

# 为python建立跳转
CreatePyTag . pytags

# 为go建立跳转
CreateGoTag . gotags

# 为lua建立跳转
CreateLuaTag . luatags

# 为C、C++建立跳转
CreateCTag "app/nrc/server/zonesvr" zonetags "--c-types=+px"

CreateCTag "app/nrc/server/scenesvr" scenetags "--c-types=+px"

CreateCTag "app/nrc/server/battlesvr" battletags "--c-types=+px"

#CreateCTag "app/nrc/protocol app/nrc/assets app/nrc/server libsrc/" tags "--c-types=+px"
CreateCTag "app/nrc/protocol app/nrc/assets app/nrc/server libsrc tools" tags

CreateCTag . alltags "--c-types=+px"
cp -rf alltags tags5

# 为pb协议
CreatePbTag "app/nrc/protocol app/nrc/assets/config/proto" pbtags

# 把pbtags加入到tags里面，减少tags文件切换
cat pbtags >> tags

# 目录树
tree . > fs

tree -af . > fs2

# 添加vimrc的快捷键
AddToVimRc
