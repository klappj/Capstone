# This script is going to try to predict the next word given the previous 3
# with luck, it will also be able to do some prediction as you type
# but that is black magic.

library(tm)
library(stringr)



# this is the placeholder to load files
# onegram
# twogram
# trigram
# fourgram

# clean up the input
cleanInput <- function(text){
  text <- removePunctuation(text)
  text <- removeNumbers(text)
  text <- str_replace_all(text, "[^[:alnum:]]", " ")
  text <- stripWhitespace(text)
  text <- tolower(text)
  text <- stemDocument(text)
  return(text)
}


input <- cleanInput(input)

inputLength <- sapply(strsplit(input, " "), length)
lastword <- word(input, -1)
#if inputLength > 1
last2word <- paste(word(input, -2), lastword, sep = " ")

#if inputLength > 2
last3word <- paste(word(input, -3), last2word, sep = " ")

onegramCount <- onegram[onegram$String == lastword,]$Count
digramCount <- digram[digram$String == last2word,]$Count
trigramCount <- trigram[trigram$String == last3word,]$Count


temp3 <- fourgram[fourgram$Three == last3word,]
temp3$p <- temp3$Count / trigramCount

temp2 <- trigram[trigram$Two == last2word,]
temp2$p <- temp2$Count/digramCount

temp1 <- digram[digram$One == lastword,]
temp1$p <- temp1$Count / onegramCount

# first hundred words should be good enough
if (dim(temp3)[1] > 100) { temp3 <- temp3[1:100,]}
if (dim(temp2)[1] > 100) { temp2 <- temp2[1:100,]}
if (dim(temp1)[1] > 100) { temp1 <- temp1[1:100,]}

guesses <- rbind(temp1[,c("String","Count","p")],temp2[,c("String","Count","p")],temp3[,c("String","Count","p")])

# well, there you have it, guesses. Now just to put these in order with a loop.

# Start with 3 word string, try to find that word in fourgram
# ... 

# find that string in the 3 gram to find n for denominator of odds

# find the last 2 words in 3 gram


# find the middle word to find n for denominator of oddds

# find last word in dictionary

# shit ... the onegrams have been snipped, so I might have to build a dictionary

# that wasn't the intent, but it makes things faster, 
# and the ngrams are very, very slow to build from the short corpus

# given the odds, this function should return next word guesses in order


# the next function should, given the list of guesses, and the letters the 
# input is givng as typing, do a predictive typing. 
# this might require building my own dictionary again, before the text was 
# cleaned ... that would give word frequencies. Other thought is to just
# find a dictionary somewhere else.


