# This does the data analysis stuff from week 2.
library(tm)
library(RWeka)



smallCorpus <- readRDS("cleanedCorpus.RDS")
smallCorpusDF <-data.frame(text=unlist(sapply(smallCorpus,`[`, "content")), 
                           stringsAsFactors = FALSE)

# that didn't work, trying
smallCorpusDF <- data.frame(smallCorpus$content, stringsAsFactors = FALSE)

## Building the tokenization function for the n-grams
ngramTokenizer <- function(theCorpus, ngramCount) {
  ngramFunction <- NGramTokenizer(theCorpus, 
                                  Weka_control(min = ngramCount, max = ngramCount, 
                                               delimiters = " \\r\\n\\t.,;:\"()?!"))
  ngramFunction <- data.frame(table(ngramFunction))
  ngramFunction <- ngramFunction[order(ngramFunction$Freq, 
                                       decreasing = TRUE),]
  # why was this appended to previous line? Maybe to give only top ten? [1:10,]
  colnames(ngramFunction) <- c("String","Count")
  ngramFunction
}

onegram <- ngramTokenizer(smallCorpusDF, 1)
saveRDS(onegram, "onegram.RD")
digram <- ngramTokenizer(smallCorpusDF, 2)
saveRDS(digram, file = "digram.RDS")
trigram <- ngramTokenizer(smallCorpusDF, 3)
saveRDS(trigram, file = "trigram.RDS")
fourgram <- ngramTokenizer(smallCorpusDF, 4)
saveRDS(fourgram, file = "fourgram.RDS")

