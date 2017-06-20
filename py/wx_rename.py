#encoding=utf-8
from pprint import pprint
from datetime import datetime
import sys, time, os

if __name__ == '__main__':
    dname, prefix = sys.argv[1], sys.argv[2]
    index = 1
    for f in os.listdir(dname):
        if not f.endswith('.mp4'): continue
        if len(f) > 18:
            fullName = os.path.join(dname,f)
            newName = os.path.join(dname,'%s-%s.mp4'%(prefix,index))
            os.rename(fullName, newName)
            print 'rename %s to %s' % (fullName, newName)
            index += 1
