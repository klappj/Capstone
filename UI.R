# This is the shiny UI code
# want a widget with text input, that reports any text input. 
# want 3 clickable widgets below it that have the recommended words.
# First step is to just put a bargraph on the right. 
#
# https://shiny.rstudio.com/reference/shiny/0.14/updateActionButton.html
# shiny page on changing the label of a button

library(shiny)

ui <- fluidPage(
  # app title
  titlePanel("Word Prediction"),
  
  # sidebar - has the input
  sidebarLayout(
    # this is the textbox where you input
    sidebarPanel(
      textInput("inputText", label = h3("Type Here"))
    ),
    mainPanel(
      plotOutput(outputId = "plotOutput")
    ),
    
  )
)
