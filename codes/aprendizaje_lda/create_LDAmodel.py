#!/usr/bin/env python
# coding: utf-8

from six import iteritems
from collections import defaultdict
import gensim
import sys
import os
import logging

file=sys.argv[1]
n_topics = int(sys.argv[2])

stoplist = set('ref del se es un o ua por como para con su http www más sus son the url titulo ha and fechaacceso sobre puede org cita refame pdf las otros por era e sin si embargo que le hasta archivo todos imdbse vez to title sido hay for esa asi para son sea ser ya lo se o e ni u etc no hacer solo cada pais tipo tener quiero tener &amp toda todas media aquellas cualquier general buen buena siempre py tar gz csv txt htmls temp dar img'.split())

dictionary = gensim.corpora.Dictionary(line.lower().split() for line in open(file))
stop_ids = [dictionary.token2id[stopword] for stopword in stoplist if stopword in dictionary.token2id]
once_ids = [tokenid for tokenid, docfreq in iteritems(dictionary.dfs) if docfreq < 1]
dictionary.filter_tokens(stop_ids + once_ids)
dictionary.compactify() #remove gaps in id sequence after words that were removed
####Construying BagOfWords representation of a Corpus from a text file
class MyCorpus(object):
	def __iter__(self):
		for line in open(file):
			yield dictionary.doc2bow(line.lower().split())

#saving corpus in MarketMatrix format
corpus = MyCorpus()
lda = gensim.models.ldamodel.LdaModel(corpus=corpus, id2word=dictionary, num_topics=n_topics, update_every=1, chunksize=100, passes=5)

name=str(n_topics)+'_model.lda'
lda.save(name)
#gensim.models.ldamodel.LdaModel.load(name, mmap='r')

for i in  lda.print_topics():
	print  i



