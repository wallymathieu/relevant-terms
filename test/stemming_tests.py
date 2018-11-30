import nltk
from nltk.stem import PorterStemmer
from nltk.tokenize import sent_tokenize, word_tokenize
import re
import os
from nltk.corpus import stopwords
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.feature_extraction.text import TfidfTransformer

#with open(os.path.join( os.path.dirname(__file__), "24117.txt"), 'r') as file:
#  words = map( word_tokenize, sent_tokenize( file.read()) )
#  for word in words:
#    print(ps.stem(word))

def stem_sentences(doc):
  ps = PorterStemmer()
  # sentence tokenize and then word tokenize
  sentences = map( word_tokenize, sent_tokenize( doc) )
  # apply stemming to each word in each sentence
  return list(map(lambda sentence: list(map(ps.stem,sentence)) , sentences))

def word_frequency(doc):
  all_stopwords = set( stopwords.words('swedish')) | set (stopwords.words('english'))
  words = nltk.word_tokenize(doc)

  def at_least_one_char(word): return len(word) > 1
  def non_numeric(word): return not word.isnumeric()
  def lowercase(word): return word.lower()
  def not_stopword(word): return word not in all_stopwords
  words = list(filter(not_stopword, map(lowercase, 
            filter(non_numeric, filter(at_least_one_char, words)))))

  return nltk.FreqDist(words)

class CrossValidationProbDist(nltk.CrossValidationProbDist):
  def __init__(self, freqdists, bins):
    super().__init__(freqdists, bins)
  def max(self):
    raise NotImplementedError()
  

def open_local_text(file_name):
  open(os.path.join( os.path.dirname(__file__), file_name), 'r')
doc_pg8518 = ""
doc_53173= ""
with open_local_text("pg8518.txt") as file_pg8518:
  doc_pg8518 = file_pg8518.read()
with open_local_text("53173-0.txt") as file_53173:
  doc_53173 = file_53173.read()

# Assuming classification then you want to extract relevant features
# (words, phrases, n-grams). Start with stemming, remove stopwords and then
# apply tfidf. That would be a good starting point.
def try_cross_validation():
  fdist_pg8518 = word_frequency (doc_pg8518)
  fdist_53173 = word_frequency (doc_53173)
  cdist = CrossValidationProbDist([fdist_53173, fdist_pg8518],1)
  print (cdist.samples())
  print (cdist.prob("viskar"))
  #output top 50 words
  #print ("++++++++++")
  #for word, frequency in fdist_pg8518.most_common(50):
  #    print(u'{};{}'.format(word, frequency))

def try_tfidf():
  #print ("++++++++++")
  #for word, frequency in fdist_53173.most_common(50):
  #    print(u'{};{}'.format(word, frequency))
  # ¯de¯
  vectorizer = TfidfVectorizer()
  vectorizer.fit_transform(corpus)
  #transformer.

try_tfidf()