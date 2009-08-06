import elementtree.ElementTree as ET
import codecs
import re
import sys

# Get XML filename from passed-in arguments
source = sys.argv[1]

re_obj = re.compile("/|<|<|\|")
tree = ET.ElementTree(file=source)
abstract = ''
filecount = 0
linecount = 0

for patapp in tree.findall('us-patent-application'):
    # If current file has 1000 lines, dump into new file
    if linecount % 1000 == 0:
        fh = codecs.open(str(filecount) + '.txt', 'a', 'utf-8')
        filecount += 1
    for elem in patapp.getiterator():
        if elem.tag == 'abstract':
            for p in elem:
                if p.getchildren() == []:
                    abstract = p.text
                    if abstract != '' and re_obj.search(abstract) == None:
                        fh.write(abstract + "\n")
                        linecount += 1

fh.close()
