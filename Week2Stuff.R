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
TwitterSmple <- twitter[sample(1:length(twitter),10000)]
rm(twitter)

# put it all together

textSample <- c(BlogSample, NewsSample, TwitterSample)

rm(BlogSample)
rm(NewsSample)
rm(TwitterSample)



