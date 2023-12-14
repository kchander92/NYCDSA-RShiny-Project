library(shinydashboard)
library(dplyr)
library(ggplot2)

function(input, output, session) {
  
    filteredByCity <- reactive({
      sunbelt_housing %>%
        select(Period.End, Metro.City,
               adjusted_average_new_listings, adjusted_average_new_listings_yoy,
               adjusted_average_homes_sold, adjusted_average_homes_sold_yoy,
               Median.Sale.Price, Median.Sale.Price.Yoy) %>%
        filter(Metro.City %in%
                 c(input$Metro.CityAZ, input$Metro.CityCA, input$Metro.CityFL,
                   input$Metro.CityGA, input$Metro.CityLA, input$Metro.CityNV,
                   input$Metro.CityTX) &
                 Period.End >= input$Dates[1] &
                 Period.End <= input$Dates[2]) 
    })

    output$trends <- renderPlot({
      filteredByCity() %>% 
        ggplot(aes(x = filteredByCity()[['Period.End']],
                   y = filteredByCity()[[input$Metric]])) +
        geom_line(aes(color=Metro.City)) +
        labs(x='Period End Date',
             y=names(col_choices)[col_choices == input$Metric],
             title=paste(names(col_choices)[col_choices == input$Metric],
                         'by Metro City, 2020-2023')) +
        theme(plot.title = element_text(hjust = 0.5))
    })
    
    output$correlations <- renderPlot({
      filteredByCity() %>% 
        ggplot(aes(x = filteredByCity()[[input$xMetric]],
                   y = filteredByCity()[[input$yMetric]])) +
        geom_point(aes(color=Metro.City)) +
        labs(x=names(col_choices)[col_choices == input$xMetric],
             y=names(col_choices)[col_choices == input$yMetric],
             title=paste(names(col_choices)[col_choices == input$yMetric],
                         '.vs',
                         names(col_choices)[col_choices == input$xMetric],
                         'by Metro City, 2020-2023')) +
        theme(plot.title = element_text(hjust = 0.5))
    })

}
