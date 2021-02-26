library(shiny)
library(tidyverse)
library(here)

df <- data.table::fread(here('data', 'babynames.csv')) %>% as_tibble()


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
  
  title,
  src,
  
  # A sidebarLayout with sidebarPanel and mainPanel
  sidebarLayout(
    sidebarPanel(
      txt_box,
      txt_disp
    ),
    mainPanel(
      tbl_disp
    )
  )
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
