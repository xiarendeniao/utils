#encoding=utf-8

import string, random, os
from datetime import datetime

charPool = None
def rand_string(size=6, chars=None):
    if chars == None:
        global charPool
        if not charPool:
            charPool = string.ascii_uppercase + string.ascii_lowercase + string.digits
        chars = charPool
    return ''.join(random.choice(chars) for _ in range(size))

def rand_chinese_word():
    aim = None
    while not aim:
        head = random.randint(0xB0, 0xDF)
        body = random.randint(0xA, 0xF)
        tail = random.randint(0, 0xF)
        val = ( head << 0x8 ) | (body << 0x4 ) | tail
        str = "%x" % val 
        try:
            aim = str.decode('hex').decode('gb2312')
        except Exception,e:
            print('rand chinese word failed. %r' % e)
    return aim.encode('utf-8')

def rand_chinese_str(size=10):
    aimStr = ''
    for i in range(size):
        aimStr += rand_chinese_word()
    return aimStr

def now_tick():
    dt = datetime.now()
    return (dt.hour*3600 + dt.minute*60 + dt.second)*1000 + dt.microsecond/1000.0

def rand_dir():
    degrees = random.randint(0,360)
    return (math.cos(math.radians(degrees)), math.sin(math.radians(degrees)))

def calc_dir(startX, startZ, endX, endZ):
    radians = math.atan2(endZ-startZ, endX-startX)
    cos = math.cos(radians)
    sin = math.sin(radians) 
    assert(0.99 < cos*cos+sin*sin < 1.01)
    return cos, sin 

def calc_dst(startX, startZ, endX, endZ):
    dx = endX - startX
    dz = endZ - startZ
    return math.hypot(dx, dz) 

'''
写完了才发现python有类似的库可以用)
tempfile https://docs.python.org/2/library/tempfile.html#module-tempfile
'''
def create_confuse_dir(pd = '.', dirDeep = 3, minDirNum = 1, maxDirNum = 5, minDirLen = 1, maxDirLen = 10):
    def func(pd, dirDeep):
        if pd == '.':
            pd = os.path.join('.','.'+rand_string(random.randint(1,10)))
            os.mkdir(pd)
        for _ in range(random.randint(minDirNum, maxDirNum)):
            dname = rand_string(random.randint(minDirLen, maxDirLen))
            fullName = os.path.join(pd, dname)
            try:
                if random.randint(0,1) == 0:
                    os.mkdir(fullName)
                    if dirDeep > 0: func(fullName, dirDeep-1)
                else:
                    f = open(fullName, 'w')
                    f.write(rand_string(random.randint(0,1024)))
                    f.close()
            except Exception,e:
                print('warning: %r %s' % (e,fullName))
    func(pd, dirDeep)

