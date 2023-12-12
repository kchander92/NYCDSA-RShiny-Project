library(shiny)
library(dplyr)
library(ggplot2)

function(input, output, session) {
  
    trendsByCity = reactive({
      sunbelt_housing %>%
        select(Period.End, Metro.City,
               adjusted_average_new_listings, adjusted_average_new_listings_yoy,
               adjusted_average_homes_sold, adjusted_average_homes_sold_yoy,
               Median.Sale.Price, Median.Sale.Price.Yoy) %>%
        filter(Metro.City %in% input$Metro.City) 
    })

    output$newListingTrend <- renderPlot({
      trendsByCity() %>% 
        ggplot(aes(x = trendsByCity()[['Period.End']],
                   y = trendsByCity()[[input$Metric]])) +
        geom_line(aes(color=Metro.City)) +
        labs(x='Period End Date',
             y=names(col_choices)[col_choices == input$Metric],
             title=paste(names(col_choices)[col_choices == input$Metric],
                         'by Metro City, 2020-2023')) +
        theme(plot.title = element_text(hjust = 0.5))
    })

}
