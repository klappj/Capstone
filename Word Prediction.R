# This script is going to try to predict the next word given the previous 3
# with luck, it will also be able to do some prediction as you type
# but that is black magic.

# This has 3 functions:
# cleanInput(text) returns text that's cleaned and stemmed to match ngrams
# getGuesses(text) returns a sorted frame of Stems and probabilities
# getWords(guesses) returns 3 words from that getGuesses result 

library(tm)
library(stringr)

# load files
stemDict <- readRDS(file = "stemDict.RDS")
onegram <- readRDS(file = "onegram.RDS")
digram <- readRDS(file = "digram.RDS")
trigram <- readRDS(file = "trigram.RDS")
fourgram <- readRDS(file = "fourgram.RDS")

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


getGuesses <- function(input) {
  # this function creates a dataframe of guesses from the last 3 words of
  # the input string. 
  # This worked when the input was one word (threw some warnings)
  # this worked with a nonsenes phrase, returned a 0 length vector
  
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
  # Now order them, because I confused the snot out of myself earlier
  guesses <- guesses[order(-guesses$p),]
  return(guesses)
}


# find the top three word from the guesses file
getWords <- function(guesses) {
  if (dim(guesses)[1] == 0) {
    # If we have no guesses, at all
    return(c("the","to","and"))
  }
  firstStem <- word(guesses[1,"String"],-1)
  output = stemDict[stemDict$Stem == firstStem,"String"]
  if (length(output) >= 3){
    return(output[1:3])
  }
  # so the first guess didn't have enough; Now to think.
    if (dim(guesses)[1] > 1) {
    nextStems <- word(guesses[-1,"String"],-1)
    # if there are more than 3 stems, we don't care about the rest
    # and we don't want to waste computational time looking them up in the
    # stem dictionary
    if (length(nextStems) > 3) {
      nextStems <- nextStems[1:3]
    }
    # pick out those stems from the whole dataframe
    nextStems <- stemDict[stemDict$Stem %in% nextStems,]
    # nextStems <- nextStems[order(-nextStem$Count)] # This is redundant because ngrams are already sorted
    if (dim(nextStems)[1] > 3) {
      nextStems <- nextStems[1:3,]
    }
    output = c(as.character(output), as.character(nextStems$String))    
    if(length(output) > 2) {
      return(output)
    }
    # well shit, let's just append some common words to get 3 answer
    output = c(output, "the", "to","and")
    return(output[1:3])
  }
}                    

# the next function should, given the list of guesses, and the letters the 
# input is givng as typing, do a predictive typing. 


