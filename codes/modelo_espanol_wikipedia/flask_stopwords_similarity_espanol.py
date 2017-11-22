#export FLASK_APP=flask_similarity_WordByWord_espanol.py
#python -m flask run --host 0.0.0.0

import os
import sys
import json

from scipy import spatial
from gensim import models
from flask import Flask, Response
from nltk.corpus import stopwords

puerto =int(sys.argv[1])

app = Flask(__name__)
model = models.Word2Vec.load_word2vec_format('modelo1_wikipedia_espannol.txt', binary=False)
dim =500

#Removing Stop-words
cachedStopWords = stopwords.words("spanish")

@app.route('/')
def index():
	return 'ingrese en URL: 0.0.0.0:%d/similarity/dinero/"${aux}"' %puerto

@app.route('/prueba')
def prueba():
	vec1 = model['economia']
	vec2 = model['tecnologias']
	aux = 1-spatial.distance.cosine(vec1, vec2)
	return 'Similitud(economia, tecnologias): %f' % aux

@app.route('/similarity/<word>/<phrase>')
def similarity(word, phrase):
	qry = [word2 for word2 in phrase.lower().split() if word2 not in cachedStopWords]
	#sentence = phrase.strip()
	total = 0
	count = 0
	vec1 = model[word]
	for w in qry:
		try:
			res = model[w]
			total += abs(1-spatial.distance.cosine(vec1, res))
			count += 1
		except KeyError:
			continue
	total = total / count
	return '%f' % (total)

if __name__ == "__main__":
	port = int(os.environ.get("API_PORT", puerto))
	app.run(host="0.0.0.0", port = port)

#aux="tecnologias tecnologias"
#http 0.0.0.0:5000/similarity/tecnologias/"${aux}"
