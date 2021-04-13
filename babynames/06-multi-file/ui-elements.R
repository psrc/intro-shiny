title <- titlePanel("U.S. Baby Names")
src <- p("Source:",
         tags$a(href = "https://www.ssa.gov/oact/babynames/limits.html",
                "Social Security Administration"))

# Paired with updateSelectizeInput() in the server. Choices will be generated server-side for efficiency.
txt_box <- selectizeInput('name', 
                          label = 'Enter names', 
                          choices = NULL, 
                          multiple = TRUE, 
                          options = list(placeholder = 'Type and select multiple names')
)

# apply a class called 'buffer' to the div wrapper
txt_disp <- div(textOutput("name_entered"), class = 'buffer')

# in lieu of tableOutput(), use DT's version
tbl_disp <- DTOutput("main_table")