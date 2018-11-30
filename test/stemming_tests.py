import nltk
from nltk.stem import PorterStemmer
from nltk.tokenize import sent_tokenize, word_tokenize
import re
import os
from nltk.corpus import stopwords

nltk.download('punkt')
nltk.download('stopwords')
ps = PorterStemmer()

#with open(os.path.join( os.path.dirname(__file__), "24117.txt"), 'r') as file:
#  words = map( word_tokenize, sent_tokenize( file.read()) )
#  for word in words:
#    print(ps.stem(word))

def stem_sentences(doc):
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



# Assuming classification then you want to extract relevant features
# (words, phrases, n-grams). Start with stemming, remove stopwords and then
# apply tfidf. That would be a good starting point.
def pg8518():
  with open(os.path.join( os.path.dirname(__file__), "pg8518.txt"), 'r') as file:
    doc = file.read()
    sentences = stem_sentences(doc)
    print (sentences)
    print ("++++++++++")

    # Output top 50 words
    fdist = word_frequency (doc)
    
    for word, frequency in fdist.most_common(50):
        print(u'{};{}'.format(word, frequency))
#term frequency
pg8518()