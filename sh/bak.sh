t=`date +"%Y%m%d%H%M"`
find . -name *.o | xargs rm
tar zvcf "robot$t.tar.gz" ./*
sz "robot$t.tar.gz"
/bin/rm "robot$t.tar.gz"
