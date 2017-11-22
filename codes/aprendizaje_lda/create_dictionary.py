#!/usr/bin/env python
# coding: utf-8

from six import iteritems
from collections import defaultdict
import gensim
import sys
import os
import logging


#file='acumulado.txt'

file = sys.argv[1]
sal_dictionary = sys.argv[2]

stoplist = set('ref del se es un o ua por como para con su http www más sus son the url título ha and fechaacceso sobre puede org cita refame pdf Las otros Por era e sin si embargo Qué le hasta Archivo todos imdbSe vez to title sido hay for esa asi para son sea ser ya lo se o e ni u etc no hacer solo cada pais tipo tener quiero tener &amp toda todas media aquellas cualquier general buen buena siempre py tar gz csv txt htmls temp dar img'.split())

dictionary = gensim.corpora.Dictionary(line.lower().split() for line in open(file))
stop_ids = [dictionary.token2id[stopword] for stopword in stoplist if stopword in dictionary.token2id]
once_ids = [tokenid for tokenid, docfreq in iteritems(dictionary.dfs) if docfreq < 1]
dictionary.filter_tokens(stop_ids + once_ids)
dictionary.compactify() #remove gaps in id sequence after words that were removed

dictionary.save(sal_dictionary)  # store the dictionary, for future reference

#print(dictionary)
print(dictionary.token2id)