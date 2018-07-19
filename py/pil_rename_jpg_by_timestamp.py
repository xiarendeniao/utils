#encoding=utf-8

from PIL import Image
import os, platform

def Deal(fname):
    try:
        m = Image.open(fname, 'r')
    except Exception, e:
        #print '%s not image ignored' % fname
        return

    try:
        info = m._getexif()
    except Exception, e:
        #print '%s ignored %r' % (fname, e)  #png
        return

    m.fp.close()

    if type(info) == dict and 36867 in info:
        dt = info[36867]
        dt = dt.replace(':','').replace(' ','-')
        #print '%s timestamp %s' % (fname, dt)
        right_index = fname.rfind('.')
        assert(right_index > 0)
        
        if platform.uname()[0] == 'Windows':
            left_index = fname.rfind('\\')
        else:
            left_index = fname.rfind('/')

        name = '%s%s%s' % (left_index >= 0 and fname[0:left_index+1] or '', dt, fname[right_index:])

        if name == fname:
            #print '%s ignored' % fname
            return

        index = 1
        while os.path.isfile(name):
            name = '%s%s-%d%s' % (left_index >= 0 and fname[0:left_index+1] or '', dt, index, fname[right_index:])
            index += 1

        #import pdb; pdb.set_trace()
        print 'rename %s -> %s' % (fname, name)
        os.rename(fname, name)

    else:
        #print '%s has none timestamp ignored' % fname
        pass

if __name__ == '__main__':
    for root, dirs, files in os.walk("."):
        for filename in files:
            filepath = os.path.join(root, filename)
            Deal(filepath)
