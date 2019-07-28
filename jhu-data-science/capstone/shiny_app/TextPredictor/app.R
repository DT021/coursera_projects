#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(tidyverse)
library(stringr)

# Models data
load("models.Rdata")

# Take user input and split into list of words
# return 4 most recent words in a form that matches
# ngram model data
input_to_query <- function(i){
  # Remove extra spaces
  i <- gsub("\\s+", " ", str_trim(i))
  # Split on spaces
  words <- strsplit(i, "[[:space:]]")[[1]]
  # tail-4
  last_four <- tail(words, 4)
  last_four
}


# Backoff model lookup
backoff_lookup <- function(items){
  
  # Lowercase because that's how it's represented in the model
  items <- tolower(items)
  
  # Generate lists of items to perform lookup on, depending on how many
  # words we have as input
  if(length(items) == 4){
    lookup_items <- list(
      paste0("^", paste(items[1], items[2], items[3], items[4], sep="_"), "_"),
      paste0("^", paste(items[2], items[3], items[4], sep="_"), "_"),
      paste0("^", paste(items[3], items[4], sep="_"), "_"),
      paste0("^", paste(items[4], sep="_"), "_")
    )
  } else if(length(items) == 3){
    lookup_items <- list(
      paste0("^", paste(items[1], items[2], items[3], sep="_"), "_"),
      paste0("^", paste(items[2], items[3], sep="_"), "_"),
      paste0("^", paste(items[3], sep="_"), "_")
    )
  } else if(length(items) == 2){
    lookup_items <- list(
      paste0("^", paste(items[1], items[2], sep="_"), "_"),
      paste0("^", paste(items[2], sep="_"), "_")
    )
  } else if(length(items) == 1){
    lookup_items <- list(
      paste0("^", paste(items[1], sep="_"), "_")
    )
  }
  
  # Take each 
  for(i in 1:length(items)){
    item <- lookup_items[[i]]
    models[[length(items)+1-i]] %>%
      filter(grepl(item, text)) %>%
      arrange(desc(n)) -> return
    
    if(nrow(return) > 0) 
      break
  }
  if(nrow(return) > 0){
    # If we find an "i" make it uppercase
    if(tail(str_split(return[1,1], "_")[[1]],1) == "i"){
      "I"
    } else {
      tail(str_split(return[1,1], "_")[[1]],1)
    }
  } else {
    # If we don't find a match, pick one of the top 15 unigrams at random
    unigrams <- c("the", "to", "and", "a", "of", 
                  "I", "in", "for", "is", "that", 
                  "you", "it", "on", "with", "was")
    unigrams[sample(1:length(unigrams),1)]
  }
}

# Take input and send it to processing functions
process_input <- function(i){
  # Check if input length is greater than zero
  if(length(input_to_query(i)) > 0){
    backoff_lookup(input_to_query(i))
  }
  else {
    return("")
  }
  
}

# Define UI for application that draws a histogram
ui <- fluidPage(
    tags$head(
      tags$style(HTML('#Button button{background-color:#007bff !important;color:white}')),
      tags$style(HTML('textarea{width:500px !important;height:100px !important}')),
      tags$style(HTML('h3{width:500px !important;}')),
      tags$style(HTML('h4{width:500px !important;}')),
      tags$style(HTML('h5{padding-left:15px;margin-bottom:5px;margin-top:5px}')),
      tags$style(HTML('p{width:500px !important;}'))
    ),

    # Application title
    titlePanel("Autocompletion App"),
    h5("Tyler Burleigh"),
    h5("2019-07-28"),

    # Show a plot of the generated distribution
    mainPanel(
      h3("Hello! This app will attempt to predict the next word as you type."),
      h4("It does this using a simple ngram backoff model trained on texts from Twitter,
         news sites, and blogs. The ngram models are frequency based, meaning they return
         the most frequent ngram found. The \"backoff\" refers to the fact that it tries
         to find a match at the highest ngram, but if it doesn't find one, then it searches
         lower ngrams until it finds one."),
      h4("This app will also use as many words as it can from what you have entered.
         If you have entered 4 words or more into the text box, it tries to find a 5-gram match. 
         If it doesn't find a 5-gram match, it searches 4-gram, 3-gram, and 2-gram models using 
         the last 3, 2, and 1 words entered. If it still doesn't find a match, then it picks one 
         of the top-15 most frequently used unigrams at random."),
      br(),
      textAreaInput("text", "Type here", ""),
      p("A button will appear below once you have entered some text. Click it
        to add it to your text above."),
      uiOutput('Button'),
      br(),
      br(),
      br(),
      br(),
      br(),
      br()
    )
)

# Define server logic required to draw a histogram
server <- function(input, output, session) {
  predicted <- reactive({ return(process_input(input$text)) })
  output$value <- renderText({ predicted() })
  
  output$Button <- renderUI({
    
    # Validate that reval() is distinct than ""
    shiny::validate(
      shiny::need(predicted() != "", message = "")
    )
    
    actionButton("click", label = predicted())
  })
  
  observeEvent(input$click, {
    updateTextInput(session, "text", value = paste(input$text, predicted()))
  })
}

# Run the application 
shinyApp(ui = ui, server = server)
