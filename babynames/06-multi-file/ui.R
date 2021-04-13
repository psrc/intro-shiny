source('ui-elements.R')

fluidPage(
    # link the CSS file to the app
    tags$head(
        tags$link(rel = "stylesheet", type = "text/css", href = "stylesheet.css")
    ),
    
    # use bslib's previewer and theme functions
    # theme = bs_theme() %>% bs_theme_preview(),
    theme = bs_theme(primary = "#FF00F3", 
                     heading_font = font_google("Pacifico"), 
                     spacer = "2rem"),
    
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
                        selected = c('Washington', 'Oregon', 'California', 'Idaho'),
                        multiple = TRUE),
            
            # add action button to delay reactivity
            actionButton("go", label = "Enter"),
            
            width = 3
        ),
        mainPanel(
            fluidRow(
                column(
                    width = 5,
                    h3("Table"),
                    tbl_disp
                ),
                column(
                    width = 7,
                    # add a place holder for a plot
                    h3("Plot"),
                    # convert plot to a Plotly Output
                    plotlyOutput("plot")
                )
            ),
            width = 9
        )
    )

 
)

