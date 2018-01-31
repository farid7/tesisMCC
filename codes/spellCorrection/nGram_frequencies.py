from collections import Counter
import re
import string 
import csv
import bz2
import sys

inputfile = sys.argv[1] #"data/justTextAplications.txt.bz2"
outputfile= sys.argv[2] #"data/test.csv"	
mostCommon= int(sys.argv[3])

####################################
###---Function for n-grams ######
def nGram(text, n=2):
    "return all the n-grams in a text. Ther are normalized to lowercase, numbers and simbols are ignored"
    aux = re.findall('[a-z]+', text.lower())
    temp=[]                                       #array that saves n-grams finded
    for i in xrange(len(aux)-n+1):
        ngram=''                                  #variable that stores words for n-grams
        for j in xrange(n):
            ngram += aux[i+j] + ' '
        temp.append(ngram.strip())                       #updating array
    return temp

#####################################
###---Openning files---#######
writefile = open(outputfile, 'wb')
writer = csv.writer(writefile)


####################################
####---Iterate over a file
if inputfile.endswith(".bz2"):
	cnt = Counter()

	source_file = bz2.BZ2File(inputfile, "r")
	#count = 0
	for line in source_file:
	#    count += 1
	    aux = nGram(line, n=2)
	    for grama in aux:
	        cnt[grama] += 1
	    #if count > 2:
	    #    break
	source_file.close()   

else:
	TEXT = file('data/justTextAplications.txt').read()
	cnt = Counter(nGram(TEXT, n=2))

	#with open(inputfile, "r") as f:
	#count = 0
	#	for line in f:
			#count += 1
	#		aux = nGram(line, n=2)
	#    	for grama in aux:
	#        	cnt[grama] += 1
	    	#if count > 2:
	    	#    break
	#f.close()



###3###############################
###--- Writing into a file
for key in cnt.most_common(mostCommon):
    print key
    #writer.writerow(key)                   #Output both the key and the count
#writefile.close()


#python nGram_frequencies.py ./inputFile ./outputFile nCommon
#ej. python nGram_frequencies.py data/justTextAplications.txt.bz2 data/test.csv 20