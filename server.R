# This is the server for the word prediction shiny app

library(shiny)
library(ggplot2)

server <- function(input, output) {
  observe({
    phrase <- input$inputText
    output$plotOutput <- renderPlot(
    ggplot(data = data.frame(x=rnorm(300)), aes(x=x))+geom_histogram()+ggtitle(input$inputText))

  })
    
  # output$plotOutput <- renderPlot(
  #   if(input$inputText != ""){
  #     
  #     matches = fourgram[foourgram$String == phrase,]
  #     ggplot(data = matches[1:20,], aes(x = String, y = Count))
  #     +geom_bar(stat="identity")+coord_flip()
  #     
  #   }
  # )
  # insert a line where we output something
  
  
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
