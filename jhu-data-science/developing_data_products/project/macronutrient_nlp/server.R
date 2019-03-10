library(shiny)             # R webapps
library(httr)

server <- function(input, output, session) {
  
  # Get calories information
  get_calories <- function(text) {
    
    data <- httr::POST(
      "https://api.edamam.com/api/nutrition-details?app_id=MYAPP&app_key=MYKEY",
      body = list(title = "NA", ingr = text),
      encode = "json"
    )
    
    # Retrieve content
    result <- httr::content(data)
    
    paste0("Fat: ", result$totalNutrients$FAT$quantity, " g || ",
           "Protein: ", result$totalNutrients$PROCNT$quantity, " g || ",
           "Carbs: ", result$totalNutrients$CHOCDF$quantity, " g <br>",
           "Calories: ", result$totalNutrients$ENERC_KCAL$quantity)
  }
  
  # Render the output
  output$calories <- renderText({
    if(length(stringi::stri_split_lines(input$ingredients)[[1]]) > 1)
      get_calories(stringi::stri_split_lines(input$ingredients)[[1]])
    else if(input$ingredients == "") "Enter recipe above"
    else "Recipe must be at least 2 lines in length"
  })
  
  
}






