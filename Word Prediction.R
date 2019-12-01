# This script is going to try to predict the next word given the previous 3
# with luck, it will also be able to do some prediction as you type
# but that is black magic.

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

if (dim(guesses)[1] == 0) {
  # If we have no guesses, at all
  output = c("the","to","and")
} else {
  # do somemthing with guesses$String[1]
  firstStem <- word(guesses[1,"String"],-1)
  output = stemDict[stemDict$Stem == firstStem,"String"]
  #if (dim(output)<3)
}



# the next function should, given the list of guesses, and the letters the 
# input is givng as typing, do a predictive typing. 
# this might require building my own dictionary again, before the text was 
# cleaned ... that would give word frequencies. Other thought is to just
# find a dictionary somewhere else.


