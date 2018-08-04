FNAME=/tmp/tags_to_file

find include server libsrc  ../server_thirdparty_proj/tsf4g_base/include/  ../server_thirdparty_proj/tcaplus_service/include/ -name "*.c" -or -name "*.h" -or -name "*.cpp" -or -name "*.cc" > $FNAME && ctags --extra=f --c-types=+px -fc_include_declare_tags -L $FNAME 

find server include libsrc  ../server_thirdparty_proj/tsf4g_base/include/ ../server_thirdparty_proj/tcaplus_service/include/ -name "*.c" -or -name "*.h" -or -name "*.cpp" -or -name "*.cc" > $FNAME && ctags --extra=f -ftags -L $FNAME

find include server/zonesvrd libsrc  ../server_thirdparty_proj/tsf4g_base/include/  ../server_thirdparty_proj/tcaplus_service/include/ -name "*.c" -or -name "*.h" -or -name "*.cpp" -or -name "*.cc" > $FNAME && ctags --extra=f --c-types=+px -fc_include_declare_tags_zone -L $FNAME

find include server/zonesvrd libsrc  ../server_thirdparty_proj/tsf4g_base/include/ ../server_thirdparty_proj/tcaplus_service/include/ -name "*.c" -or -name "*.h" -or -name "*.cpp" -or -name "*.cc" > $FNAME && ctags --extra=f -ftags_zone -L $FNAME

#find include server libsrc  ../server_thirdparty_proj/ -name "*.c" -or -name "*.h" -or -name "*.cpp" -or -name "*.cc" > $FNAME && ctags --extra=f --c-types=+px -fc_include_third_tags -L $FNAME

#tree -asfDF server > fs.server

tree -af server > fs.server
