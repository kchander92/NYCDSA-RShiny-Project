library(shinydashboard)
library(dplyr)
library(ggplot2)

function(input, output, session) {
  
  filteredByCityTrend <- reactive({
    sunbelt_housing %>%
      select(
        Period.End, Metro.City,
        Metric = input$Metric) %>%
      filter(
        Metro.City %in%
          c(input$Metro.CityAZ1, input$Metro.CityCA1, input$Metro.CityFL1,
            input$Metro.CityGA1, input$Metro.CityLA1, input$Metro.CityNV1,
            input$Metro.CityTX1) &
          Period.End >= input$Dates1[1] &
          Period.End <= input$Dates1[2]) 
  })
  
  filteredByCityCorrs <- reactive({
    sunbelt_housing %>%
      select(
        Period.End, Metro.City,
        xMetric = input$xMetric, yMetric = input$yMetric) %>%
      filter(
        Metro.City %in%
          c(input$Metro.CityAZ2, input$Metro.CityCA2, input$Metro.CityFL2,
            input$Metro.CityGA2, input$Metro.CityLA2, input$Metro.CityNV2,
            input$Metro.CityTX2) &
          Period.End >= input$Dates2[1] &
          Period.End <= input$Dates2[2]) 
  })
  
  aggregateFunc <- reactive({
    switch(
      input$Statistic,
      'Mean' = mean,
      'Median' = median,
      'Maximum' = max,
      'Minimum' = min,
      'Range' = range,
      'Standard Deviation' = sd)
  })
  
  aggregateStats <- reactive({
    switch(
      input$timeFrame,
      'Month' = sunbelt_housing %>%
        select(
          Month, Year, Metro.City,
          adjusted_average_new_listings, adjusted_average_new_listings_yoy,
          adjusted_average_homes_sold, adjusted_average_homes_sold_yoy,
          Median.Sale.Price, Median.Sale.Price.Yoy) %>%
        filter(Month == input$Month & Year == input$Year) %>%
        group_by(Metro.City) %>%
        summarise())
  })
  
  output$timeTrends <- renderPlot({
    filteredByCityTrend() %>% 
      ggplot(aes(x = filteredByCityTrend()[['Period.End']],
                 y = Metric)) +
      geom_line(aes(color=Metro.City)) +
      labs(x='Period End Date',
           y=names(col_choices)[col_choices == input$Metric],
           title=paste(names(col_choices)[col_choices == input$Metric],
                       'by Metro City, 2020-2023')) +
      theme(plot.title = element_text(hjust = 0.5))
  })
  
  output$correlations <- renderPlot({
    filteredByCityCorrs() %>% 
      ggplot(aes(x = xMetric, y = yMetric)) +
      geom_point(aes(color=Metro.City)) +
      labs(x=names(col_choices)[col_choices == input$xMetric],
           y=names(col_choices)[col_choices == input$yMetric],
           title=paste(names(col_choices)[col_choices == input$yMetric],
                       '.vs',
                       names(col_choices)[col_choices == input$xMetric],
                       'by Metro City, 2020-2023')) +
      theme(plot.title = element_text(hjust = 0.5))
  })
  
  output$barPlot <- renderPlot({
    
  })
}
