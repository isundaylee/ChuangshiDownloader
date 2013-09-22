require './ChuangshiDownloader'
require './Formatter'
require './Epubifier'

# URL = 'http://chuangshi.qq.com/read/bk/js/150211411-m.html'
# OUTPUT = '太阳的距离'
# TITLE = '太阳的距离'
# AUTHOR = '黑耀圣石'
# OUTPUT_FILE = '太阳的距离.epub'

URL = 'http://chuangshi.qq.com/read/bk/xh/6431644-m.html'
OUTPUT = '剑碎山河'
TITLE = '剑碎山河'
AUTHOR = '老普洱'
OUTPUT_FILE = '剑碎山河.epub'

ChuangshiDownloader.download(URL, OUTPUT)
Formatter.format(OUTPUT)
Epubifier.epubify(TITLE, OUTPUT, AUTHOR, OUTPUT_FILE)