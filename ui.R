library(shinydashboard)

dashboardPage(

    dashboardHeader(title="Housing Supply and Demand in the USA's Sun Belt",
                    titleWidth = 500),

    dashboardSidebar(
      
        sidebarUserPanel('Krishnan Chander'),
      
        dateRangeInput(inputId = 'Dates',
                     label = 'Date Range',
                     start = min(sunbelt_housing$Period.Begin),
                     end = max(sunbelt_housing$Period.End)),
        
        checkboxGroupInput(inputId = 'Metro.City',
                             label = 'Metro Area City',
                             choices = unique(sunbelt_housing$Metro.City),
                             selected = 'Atlanta'),
          
        radioButtons(inputId = 'Metric',
                       label = 'Housing Metric',
                       choices = col_choices)
          
        #img(src='arizona_houses.jpg', width = '450px', height = '300px')
    ),

    dashboardBody(
        box(
          plotOutput('newListingTrend')
        )
    )
)

