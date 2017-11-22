#export FLASK_APP=flask_LDA_query.py
#python -m flask run --host 0.0.0.0

from gensim import models, corpora
from collections import defaultdict
from flask import Flask, Response
from six import iteritems

import sys
import os
import logging


app = Flask(__name__)

dic = sys.argv[1]
mod = sys.argv[2]
#qry = sys.argv[3]
puerto =int(sys.argv[3])

dictionary=corpora.dictionary.Dictionary.load(dic)
model = models.ldamodel.LdaModel.load(mod)

@app.route('/')
def index():
	return 'ingrese en URL: 0.0.0.0:%d/lda_model/"${aux}"' % puerto

@app.route('/prueba')
def prueba():
	qry ='servicios venta'
	vec = dictionary.doc2bow(qry.lower().split())
	aux = model[vec]
	return 'Topicos en LDA(%s) : %s' % (qry, aux)

@app.route('/lda_model/<phrase>')
def similarity(phrase):
	qry=phrase
	vec = dictionary.doc2bow(qry.lower().split())
	aux = model[vec]
	return '%s' % (aux)

@app.route('/topicos')
def lda_topicos():
	aux = model.print_topics()
	return '%s' % (aux)

if __name__ == "__main__":
	port = int(os.environ.get("API_PORT", puerto))
	app.run(host="0.0.0.0", port = port)

#python flask_LDA_query.py aplications.dict 7_model.lda 5000

#aux="tecnologias tecnologias"
#http 0.0.0.0:5000/lda_model/"${aux}"
