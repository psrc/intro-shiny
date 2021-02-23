library(shiny)
library(tidyverse)
library(here)
library(plotly)

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
  
  title,
  src,
  
  # sidebar layout with sidebarPanel and mainPanel
  sidebarLayout(
    sidebarPanel(
      txt_box,
      
      # add a button to clear text input
      actionButton("clear", label = "Clear Name"),
      
      txt_disp,
      
      # add a dropdown menu to select state
      # allow multiple selections
      selectInput("state",
                  label = 'Select State',
                  choices = unique(df$state),
                  selected = 'Washington',
                  multiple = TRUE),
      
      # add action button to delay reactivity
      actionButton("go", label = "Enter")
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
          # convert plot to a Plotly Output
          plotlyOutput("plot")
        )
      )
    )
  )
  
)


# Define server logic -----------------------------------------------------


server <- function(input, output, session) {
  
  clean_name <- reactive({
    input$name %>% 
      str_replace_all(" ", "") %>% 
      str_trim() %>% 
      str_to_title()
  })
  
  # using an observeEvent, update the textInput by clearing the typed name when the 
  # 'clear' button is clicked
  observeEvent(input$clear, {
    updateTextInput(session, "name",
                    value = ""
    )
  })
 
  # change reactive to an eventReactive. Delay reaction until action button is clicked
  # allow filtering of multiple states
  filtered_df <- eventReactive(input$go, {
    df %>% 
      filter(name == clean_name() & state %in% input$state)
  })
  
  output$name_entered <- renderText({
    c("You entered:", input$name)
  })
  
  output$main_table <- renderTable({
    filtered_df()
  })
  
  # render a plot with ggplotly
  output$plot <- renderPlotly({
    
    p <- filtered_df() %>% 
      ggplot(aes(x = year, y = count, color = state)) +
        geom_line() +
        facet_wrap(vars(sex), nrow = 2, scales = "free_y")
    
    ggplotly(p)
  })

}


#  Run the application  ---------------------------------------------------


shinyApp(ui = ui, server = server)
