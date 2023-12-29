library(shinydashboard)
library(dplyr)
library(ggplot2)

function(input, output, session) {
  
  filteredByCityTrend <- reactive({
    sunbelt_housing %>%
      select(
        Period.End, Metro.City, interest.rate.range,
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
        Period.End, Metro.City, interest.rate.range,
        xMetric = input$xMetric, yMetric = input$yMetric) %>%
      filter(
        Metro.City %in%
          c(input$Metro.CityAZ2, input$Metro.CityCA2, input$Metro.CityFL2,
            input$Metro.CityGA2, input$Metro.CityLA2, input$Metro.CityNV2,
            input$Metro.CityTX2) &
          Period.End >= input$Dates2[1] &
          Period.End <= input$Dates2[2]) 
  })
  
  aggregateStats <- reactive({
    switch(
      input$timeFrame,
      'Month' = sunbelt_housing %>%
        filter(Month == input$Month & Year == input$Year),
      'Year' = sunbelt_housing %>%
        filter(Year == input$Year)) %>%
      select(Month, Year, Metro.City, Metric = input$aggMetric) %>%
      group_by(Metro.City) %>%
      summarise(Stat = switch(
        input$Statistic,
        'Mean' = mean,
        'Median' = median,
        'Maximum' = max,
        'Minimum' = min,
        'Standard Deviation' = sd)(Metric)) %>%
      arrange(desc(Stat))
  })
  
  violinSubset <- reactive({
    sunbelt_housing %>%
      select(Metro.City, Metric = input$violinMetric)
  })
  
  corrMatrix <- reactive({
    corrs = data.frame(cor(sunbelt_housing %>% select(Period.End, Metro.City,
                                                      Metric = input$corrMetric) %>%
                             pivot_wider(names_from = Metro.City, values_from = Metric) %>%
                             select(-Period.End)), row.names = NULL)
    corrs[corrs < input$minThreshold] = 0
    cbind(City = colnames(corrs), corrs) %>%
      pivot_longer(cols = colnames(corrs), names_to = 'City2', values_to = 'Corr')
  })
  
  interestRateData <- reactive({
    sunbelt_housing %>%
      filter(Metro.City == input$MetroCity) %>%
      select(interest.rate.range, Metric = input$interestMetric)
  })
  
  output$timeTrends <- renderPlot({
    filteredByCityTrend() %>% 
      ggplot(aes(x = filteredByCityTrend()[['Period.End']],
                 y = Metric)) +
      geom_line(aes(color = Metro.City)) +
      labs(x='Period End Date',
           y=names(col_choices)[col_choices == input$Metric],
           title=paste(names(col_choices)[col_choices == input$Metric],
                       'by Metro City, 2020-2023')) +
      theme(plot.title = element_text(hjust = 0.5))
  })
  
  output$correlations <- renderPlot({
    filteredByCityCorrs() %>% 
      ggplot(aes(x = xMetric, y = yMetric)) +
      geom_point(aes(color = Metro.City)) +
      labs(x=names(col_choices)[col_choices == input$xMetric],
           y=names(col_choices)[col_choices == input$yMetric],
           title=paste(names(col_choices)[col_choices == input$yMetric],
                       '.vs',
                       names(col_choices)[col_choices == input$xMetric],
                       'by Metro City, 2020-2023')) +
      theme(plot.title = element_text(hjust = 0.5))
  })
  
  output$barPlot <- renderPlot({
    aggregateStats() %>%
      ggplot(aes(x = reorder(Metro.City, -Stat), y = Stat)) +
      geom_col(aes(fill = Metro.City), show.legend = FALSE) +
      labs(x = 'Metro City', y = input$Statistic,
           title = paste(names(col_choices)[col_choices == input$aggMetric],
                         paste(switch(
                           input$timeFrame, 'Month' = paste(input$Month, input$Year),
                           'Year' = input$Year),
                           input$Statistic),
                         sep = ', ')) +
      theme(plot.title = element_text(hjust = 0.5),
            axis.text.x = element_text(angle = 30, vjust = 0.6))
  })
  
  output$violinPlot <- renderPlot({
    violinSubset() %>%
      ggplot(aes(x = Metro.City, y = Metric)) +
      geom_violin() +
      labs(x = 'Metro City', y = names(col_choices)[col_choices == input$violinMetric],
           title = names(col_choices)[col_choices == input$violinMetric]) +
      theme(plot.title = element_text(hjust = 0.5),
            axis.text.x = element_text(angle = 30, vjust = 0.6))
  })

  output$interestRateDist <- renderPlot({
    interestRateData() %>%
      ggplot(aes(x = interest.rate.range, y = Metric)) + geom_boxplot() +
      labs(x = 'Interest Rate Range',
           y = names(col_choices)[col_choices == input$interestMetric],
           title = paste(names(col_choices)[col_choices == input$interestMetric],
                         'in', input$MetroCity,
                         'by Interest Rate')) +
      theme(plot.title = element_text(hjust = 0.5),
            axis.text.x = element_text(angle = 60, vjust = 0.6))
  })
}
