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
  
  # sidebar layout with sidebarPanel and mainPanel
  sidebarLayout(
    sidebarPanel(
      txt_box,
      txt_disp,
      # add a dropdown menu to select state
      selectInput("state",
                  label = 'Select State',
                  choices = unique(df$state))
    ),
    mainPanel(
      fluidRow(
        column(
          width = 6,
          h3("Table"),
          tbl_disp
        ),
        column(
          width = 6,
          # add a place holder for a plot
          h3("Plot"),
          plotOutput("plot")
        )
      )
    )
  )
  
)


# Define server logic -----------------------------------------------------


server <- function(input, output) {
  
  filtered_df <- reactive({
    df %>% 
      filter(name == input$name & state == input$state)
  })
  
  output$name_entered <- renderText({
    c("You entered:", input$name)
  })
  
  output$main_table <- renderTable({
    filtered_df()
  })
  
  
}


#  Run the application  ---------------------------------------------------


shinyApp(ui = ui, server = server)
