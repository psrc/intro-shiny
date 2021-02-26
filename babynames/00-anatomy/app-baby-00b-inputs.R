library(shiny)
library(tidyverse)
library(here)

df <- data.table::fread(here('data', 'babynames.csv')) %>% as_tibble()


# Define UI for application -----------------------------------------------


ui <- fluidPage(
  
    titlePanel("U.S. Baby Names"),
    p("Source:", 
      tags$a(href = "https://www.ssa.gov/oact/babynames/limits.html", 
             "Social Security Administration")),
    
    textInput("name", 
              label = "Enter name",
              placeholder = "Jane"),
    
    textOutput("name_entered"),
    
    tableOutput("main_table")
  
)


# Define server logic -----------------------------------------------------


server <- function(input, output) {
  
  output$name_entered <- renderText({
    c("You entered:", input$name)
  })
  
  output$main_table <- renderTable({
    df %>% slice(1:20)
    })
  
    
}


#  Run the application  ---------------------------------------------------


shinyApp(ui = ui, server = server)
