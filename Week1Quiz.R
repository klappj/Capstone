# First test script, read one document, count lines

scanTwitter = function() {
  con <- file("en_US.twitter.txt", "r")
  numLines = as.integer(0)
  maxLength = as.integer(0)
  hasHate = as.integer(0)
  hasLove = as.integer(0)
  hasPhrase = as.integer(0)
  
  
  while ( TRUE ) {
    line = readLines(con, n = 1)
    if ( length(line) == 0 ) {
      break
    }
    maxLength = max(maxLength,nchar(line))
    numLines = numLines + 1
    hasHate = hasHate + grepl("hate", line)
    hasLove = hasLove + grepl("love", line)
    hasPhrase = hasPhrase + grepl("A computer once beat me at chess, but it was no match for me at kickboxing",line)
    
    if(grepl("biostats",line)) {print(line)}
    #if (numLines > 1000) {break} # This just to read the first thousand to test
    
  }
  print(maxLength)
  print(numLines)
  print(hasHate)
  print(hasLove)
  print(hasPhrase)
  close(con)
}

scanNews = function() {
  con <- file("en_US.news.txt", "r")
  numLines = as.integer(0)
  maxLength = as.integer(0)
  hasHate = as.integer(0)
  hasLove = as.integer(0)

  
  while ( TRUE ) {
    line = readLines(con, n = 1)
    if ( length(line) == 0 ) {
      break
    }
    maxLength = max(maxLength,nchar(line))
    numLines = numLines + 1
    hasHate = hasHate + grepl("hate", line)
    hasLove = hasLove + grepl("love", line)

  }
  print(maxLength)
  print(numLines)
  print(hasHate)
  print(hasLove)
  close(con)
}

scanBlog = function() {
  con <- file("en_US.blogs.txt", "r")
  numLines = as.integer(0)
  maxLength = as.integer(0)
  hasHate = as.integer(0)
  hasLove = as.integer(0)
  
  
  while ( TRUE ) {
    line = readLines(con, n = 1)
    if ( length(line) == 0 ) {
      break
    }
    maxLength = max(maxLength,nchar(line))
    numLines = numLines + 1
    hasHate = hasHate + grepl("hate", line)
    hasLove = hasLove + grepl("love", line)
    
  }
  print(maxLength)
  print(numLines)
  print(hasHate)
  print(hasLove)
  close(con)
}