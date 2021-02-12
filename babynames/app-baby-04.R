library(shiny)
library(tidyverse)
library(here)

df <- read_csv(here('data', 'babynames.csv'))


# Define UI for application -----------------------------------------------


title <- titlePanel("U.S. Baby Names")
src <- p("Source:",
         tags$a(href = "https://www.ssa.gov/oact/babynames/limits.html",
                "Social Security Administration"))
txt_box <- textInput("name", 
          label = "Enter name",
          placeholder = "Jane")
txt_disp <- textOutput("name_entered")
tbl_disp <- tableOutput("main_table")

ui <- fluidPage(

  # sidebar layout with sidebarPanel and mainPanel


)


# Define server logic -----------------------------------------------------


server <- function(input, output) {
  
  output$name_entered <- renderText({
    c("You entered:", input$name)
  })
  
  output$main_table <- renderTable({
    df %>% slice(1:10)
    })
  
    
}


#  Run the application  ---------------------------------------------------


shinyApp(ui = ui, server = server)
