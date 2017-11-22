#! /usr/bin/env python

def parsing(file):
    for p in xrange(21):
	   soup=BeautifulSoup(open(file), 'lxml')
	   print soup.find_all('div', class_='preg')[p], "|"

if __name__ == "__main__":
    import sys
    from bs4 import BeautifulSoup
    f=sys.argv[1]
    #p=int(sys.argv[2])
    parsing(f)

#file=file.html
#preg=0
# ./Parsing_html.py $file $preg | sed 's/<div class="preg">/ /g; s/<h5>.*<\/h5>/ /g; s/<p class=\"r-texto\">/ /g; s/<\/p>/ /g; s/<\/div>/ /g'

'''
for i in xrange(20):
    print i
    print soup.find_all('div', class_='preg')[i]
    print ''
'''
#################################################### 
'''
echo "id|p1|p2|p3|p4|p5|p6|p7|p8|p9|p10|p11|p12|p13|p14|p15|p16|p17|p18|p19|p20|p21" > salida.csv
file=aux
echo $file "|" $(./Parsing_html.py $file | 
sed 's/<div class="preg">/ /g; s/<h5>.*<\/h5>/ /g; s/<p class=\"r-texto\">/ /g;; s/<p class=\"texto\">/ /g; s/<\/p>/ /g; s/<\/div>/ /g; s/<br\/>/ /g; s/<\/h6>/ /g; s/<h6>/ /g' | 
tr -s " "| 
tr -d "\n" ) >> salida.csv
'''
