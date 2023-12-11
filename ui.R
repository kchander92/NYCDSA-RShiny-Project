library(shiny)

# Define UI for application that draws a histogram
fluidPage(

    # Application title
    titlePanel("Housing Supply and Demand in the USA's Sun Belt"),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
#          selectizeInput(inputId = 'Metro.City',
#                         label = 'Metro Area City',
#                         choices = unique(sunbelt_housing$Metro.City)),
          checkboxGroupInput(inputId = 'Metro.City',
                             label = h3('Metro Area City'),
                             choices = unique(sunbelt_housing$Metro.City),
                             selected = 'Atlanta'),
          img(src='arizona_houses.jpg', width = '450px', height = '300px')
        ),

        # Show a plot of the generated distribution
        mainPanel(
          plotOutput('newListingTrend')
        )
    )
)
