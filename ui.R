library(shiny)

# Define UI for application that draws a histogram
fluidPage(

    # Application title
    titlePanel("Housing Supply and Demand in the USA's Sun Belt"),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            sliderInput("bins",
                        "Number of bins:",
                        min = 1,
                        max = 50,
                        value = 30),
            img(src='arizona_houses.jpg', width = '450px', height = '300px')
        ),

        # Show a plot of the generated distribution
        mainPanel(
        )
    )
)
