#!/bin/sh

#Author                : dsxu
#Version               :
#Date Of Creation      : 2018-10-15

# params:  code_dir_list ctags_file ctags_params 
CreateCTag()
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

# params:  code_dir_list ctags_file
CreateLuaTag()
{
    if [[ $# -lt 2 ]]
    then
        echo "invalid params "$*
        exit 1
    fi

    ctags_params='--langdef=MYLUA --langmap=MYLUA:.lua'
    ctags_params=$ctags_params' --regex-MYLUA="/^\s*(\w+)\s*=\s*class\s*\(.*$/\1/f/"'
    ctags_params=$ctags_params' --regex-MYLUA="/^.*\w+\.(\w+)\s*=\s*function\s*\(.*$/\1/f/"'
    ctags_params=$ctags_params' --regex-MYLUA="/^.*\s*function\s*(\w+):(\w+).*$/\2/f/"'
    ctags_params=$ctags_params' --regex-MYLUA="/^\s*(\w+)\s*=\s*[0-9]+.*$/\1/e/"'
    ctags_params=$ctags_params' --regex-MYLUA="/^.*\s*function\s*(\w+)\.(\w+).*$/\2/f/"'
    ctags_params=$ctags_params' --regex-MYLUA="/^.*\s*function\s*(\w+)\s*\(.*$/\1/f/"'
    ctags_params=$ctags_params' --regex-MYLUA="/^\s*(\w+)\s*=\s*\{.*$/\1/e/"'
    ctags_params=$ctags_params' --regex-MYLUA="/^\s*module\s+\"(\w+)\".*$/\1/m,module/"'
    ctags_params=$ctags_params' --regex-MYLUA="/^\s*module\s+\"[a-zA-Z0-9._]+\.(\w+)\".*$/\1/m,module/"'
    ctags_params=$ctags_params' --regex-MYLUA="/^\s*function\s*(\w+):initialize\s*\(.*$/\1/f/"'
    ctags_params=$ctags_params' --languages=MYLUA --excmd=pattern --extra=f'

    code_dir_list=$1
    ctags_file=$2
    tmp_file=/tmp/lua_tags_to_file

    find $code_dir_list -name "*.lua" > $tmp_file && ctags "$ctags_params" -L $tmp_file -f $ctags_file

    if [[ $? == 0 ]]
    then
        echo "ctags \"$code_dir_list\" \"$ctags_params\" > \"$ctags_file\" succ"
    else
        echo "ctags \"$code_dir_list\" \"$ctags_params\" > \"$ctags_file\" failed"
    fi
}

CreateCTag "server" tags

CreateCTag "include server libsrc" tags2

CreateCTag "include server libsrc tools" tags3

CreateCTag "include server libsrc tools" tags4 "--c-types=+px"

CreateCTag "include server libsrc tools ext" tags5 "--c-types=+px"

CreateCTag "include server libsrc ../server_thirdparty_proj/behaviac-3.5.7/" aitags "--c-types=+px"

CreateLuaTag "dataconfig/lua server/lua_conn server/lua_crontab server/lua_script"  luatags

#tree -asfDF server > fs.server

tree -af server > fs.server

tree -af . > fs
