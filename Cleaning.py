# Cribbed from towardsdatasciene.com
# This script cleans up the databases

# Import pandas
import pandas as pd
# Import nltk
import nltk
# Punctuations
import string
# IMport tokenizer
from nltk.tokenize import RegexpTokenizer
# Import Lemmatizer
from nltk.stem import WordNetLemmatizer
# Import Stemmer
from nltk.stem.porter import PorterStemmer
# OS commands
import os

# read data (this time twitter data
os.chdir("C:\\Users\\John.Klapp\\Documents\\Capstone\\corpus")
df = pd.read_table("en_us.blogs.txt",header=None)
print("dataframe loaded")
# make all strings
df[0] = df[0].astype('str')
# to lowercase
df[0] = df[0].str.lower()
print("is lowered")

def remove_punctuation(text):
    no_punct = "".join([c for c in text if c not in string.punctuation])
    return no_punct

df[0] = df[0].apply(lambda x: remove_punctuation(x))

print("punctuation removed")
# strip unicode randomness
df[0] = df[0].apply(lambda x: x.encode('ascii', errors = 'ignore'))

print("unicode gone")
#save processed file
import numpy as np
np.savetxt(r'blogslr.txt', df.values, "%s")


