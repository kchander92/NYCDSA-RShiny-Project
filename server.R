library(shiny)
library(dplyr)
library(ggplot2)

function(input, output, session) {

    output$newListingTrend <- renderPlot({

        sunbelt_housing %>%
          filter(Metro.City == input$Metro.City) %>%
          ggplot(aes(x = Period.End, y = adjusted_average_new_listings)) +
          geom_line() + geom_point()
    })

}
