function(input, output, session) {
    # There are overlapping issues between the chart and legend when using ggplot2's facet_grid & ggplotly.
    # This function was adapted from https://github.com/ropensci/plotly/issues/1224
    layout_ggplotly <- function(gg, x = -0.1, y = -0.05, x_legend=1.05, y_legend=0.95, mar=list(l=50, r=0)){
        # The 1 and 2 goes into the list that contains the options for the x and y axis labels respectively
        gg[['x']][['layout']][['annotations']][[1]][['y']] <- x
        gg[['x']][['layout']][['annotations']][[2]][['x']] <- y
        gg[['x']][['layout']][['legend']][['y']] <- y_legend
        gg[['x']][['layout']][['legend']][['x']] <- x_legend
        gg %>% layout(margin = mar)
    }
    
    # Paired with selectizeInput() to generate the list of names in the dropdown menu server-side.
    updateSelectizeInput(
        session, 
        'name', 
        server = TRUE,
        choices = names,
        selected = c('John', 'Jane')
    )
    
    # using an observeEvent, update the textInput by clearing the typed name when the 
    # 'clear' button is clicked
    observeEvent(input$clear, {
        updateTextInput(session, 
                        "name",
                        value = ""
        )
    })
    
    # change reactive to an eventReactive. Delay reaction until action button is clicked
    # allow filtering of multiple states
    filtered_df <- eventReactive(input$go, {
        df_sub <- df[name %chin% input$name & state %chin% input$state]

        print(df_sub)
    })

    output$name_entered <- renderText({
        c("You entered:", input$name)
    })
    
    ## render DT ----
    # in lieu of renderTable(), use DT's version
    output$main_table <- renderDT({
        
        # remove last three columns
        df <- filtered_df()[, 1:(ncol(df)-3)]
        
        # customize the appearance of the DT
        datatable(df,
                  rownames = FALSE,
                  colnames = str_to_title(str_replace_all(colnames(df), "_", " ")),
                  options = list(pageLength = 20,
                                 lengthMenu = c(20, 60, 100),
                                 dom = 'ltipr' # default is 'lftipr'
                  ),
                  filter = 'top'
        ) %>%
            # conditional styling of cell text
            formatStyle('name',
                        'sex',
                        color = styleEqual(unique(df$sex), c('dodgerblue', 'orange'))
            ) %>% 
            # add a color bar to a numeric column.
            formatStyle('count',
                        background = styleColorBar(df$count, 'rgba(0, 128, 255, .2)'),
                        backgroundSize = '100% 90%',
                        backgroundRepeat = 'no-repeat',
                        backgroundPosition = 'center'
            )
        
    })
    
    ## render a plot with ggplotly ----
    output$plot <- renderPlotly({
        
        p <- ggplot(filtered_df(), aes(x = year, y = count, color = name)) +
            geom_line() +
            scale_y_continuous(labels = scales::label_comma()) +
            facet_grid(cols = vars(sex), rows = vars(state), scales = 'free_y') +
            labs(y = 'Count') +
            theme(legend.title = element_blank()) 
        
        ggplotly(p, height = 800) %>%
            layout_ggplotly()
    })
    
}

