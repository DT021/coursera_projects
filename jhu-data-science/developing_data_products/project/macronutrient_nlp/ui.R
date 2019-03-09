
#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)             # R webapps
library(httr)

ui <- fluidPage(theme = "bootstrap.css",
  absolutePanel(
    id = "myId", fixed = TRUE,
    draggable = FALSE, top = 0, left = 0, right = 0, bottom = 0,
    width = 600, height = "auto",
    
    h1("Macronutrient Analysis of Recipe"),
    p("By Tyler Burleigh, 3/9/2019"),
    h2("Instructions"),
    p("To use this app, simply enter a list of ingredients, each on a separate 
      line, and click Submit. After the recipe is processed, you will see how
      many grams of fat, protein, carbs, and how many calories are in the recipe!"),
    p("Credit: This app is made possible by the Nutritionix API 
      (https://developer.nutritionix.com)."),
    br(),
    textAreaInput("ingredients", "Ingredients:", "", height='150px', width='500px'),
    submitButton("Submit"),
    br(),
    br(),
    uiOutput("calories")
  )
)