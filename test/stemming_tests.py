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

#with open(os.path.join( os.path.dirname(__file__), "pg8518.txt"), 'r') as file:
#  sent_words = map( word_tokenize, sent_tokenize( file.read()) )
#  for sent_word in sent_words:
#    print(">>>>>>>>>>>>>>")
#    for word in sent_word:
#      print(ps.stem(word))
#    print("<<<<<<<<<<<<<<")

# Assuming classification then you want to extract relevant features
# (words, phrases, n-grams). Start with stemming, remove stopwords and then
# apply tfidf. That would be a good starting point.

print ( set(stopwords.words('swedish')))
