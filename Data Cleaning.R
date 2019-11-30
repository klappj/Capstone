# Week 2 things to try
# load the documents, create a dictionary, count 2-grams and 3-grams
# templated from https://eight2late.wordpress.com/2015/05/27/a-gentle-introduction-to-text-mining-using-r/

library(tm)
#docs <- Corpus(DirSource("C:/Users/John.Klapp/Documents/Capstone/corpus"))
# that was too much data and nothing really happened, it just worked for hours

set.seed(20191109)
blogs <- readLines("./corpus/en_US.blogs.txt", 
                   encoding = "UTF-8", skipNul=TRUE)
BlogSample <- blogs[sample(1:length(blogs),10000)]
rm(blogs)

news <- readLines("./corpus/en_US.news.txt", 
                  encoding = "UTF-8", skipNul=TRUE)
NewsSample <- news[sample(1:length(news),10000)]
rm(news)

twitter <- readLines("./corpus/en_US.twitter.txt", 
                     encoding = "UTF-8", skipNul=TRUE)
TwitterSample <- twitter[sample(1:length(twitter),10000)]
rm(twitter)
# that actually worked inside of 5 seconds

# put it all together

textSample <- c(BlogSample, NewsSample, TwitterSample)

rm(BlogSample)
rm(NewsSample)
rm(TwitterSample)


# now to clean this crap up
badWords <- read.table("badwords.txt", header = FALSE)

smallCorpus <- Corpus(VectorSource(textSample))

smallCorpus = tm_map(smallCorpus, content_transformer(function(x) iconv(x, to="UTF-8", sub="byte")))

# get rid of bad words, URLs, punctuation and extra white space. 
smallCorpus <- tm_map(smallCorpus, content_transformer(removePunctuation))
smallCorpus <- tm_map(smallCorpus, removeWords, profanityWords)
smallCorpus <- tm_map(smallCorpus, content_transformer(removeNumbers))
removeURL <- function(x) gsub("http[[:alnum:]]*", "", x) 
smallCorpus <- tm_map(smallCorpus, content_transformer(removeURL))
smallCorpus <- tm_map(smallCorpus, stemDocument)
smallCorpus <- tm_map(smallCorpus, stripWhitespace)

# Save this crap before the computer blows up.
# Should "crap" be in the badwords list?

saveRDS(smallCorpus, "cleanedCorpus.RDS")

