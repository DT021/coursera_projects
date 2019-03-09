library(shiny)             # R webapps
library(httr)

server <- function(input, output, session) {
  
  # Get calories information
  get_calories <- function(text) {
    
    data <- httr::POST(
      "https://trackapi.nutritionix.com/v2/natural/nutrients/",
      body = list(query = text),
      httr::add_headers(`x-app-id` = "ID_HERE",
                        `x-app-key` = "KEY_HERE"),
      encode = "json"
    )
    
    # Retrieve content
    result <- httr::content(data)
    
    # Sum calories of all ingredients
    sum(sapply(result, function (x) {
      sapply(x, function(y) {
        sum(y['nf_calories'][[1]])
      })
    })) -> calories
    
    # Sum fat of all ingredients
    sum(sapply(result, function (x) {
      sapply(x, function(y) {
        sum(y['nf_total_fat'][[1]])
      })
    })) -> fat
    
    # Sum protein of all ingredients
    sum(sapply(result, function (x) {
      sapply(x, function(y) {
        sum(y['nf_protein'][[1]])
      })
    })) -> protein
    
    # Sum protein of all ingredients
    sum(sapply(result, function (x) {
      sapply(x, function(y) {
        sum(y['nf_total_carbohydrate'][[1]])
      })
    })) -> carbs
    
    paste0("Fat: ", fat, " g <br>",
           "Protein: ", protein, " g <br>",
           "Carbs: ", carbs, " g <br><br>",
           "Calories: ", calories)
  }
  
  # Render the output
  output$calories <- renderText({
    if(input$ingredients != "")
      get_calories(input$ingredients)
  })
  
  
}






