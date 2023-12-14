library(shinydashboard)

dashboardPage(
  
  dashboardHeader(title="Housing Supply and Demand in the USA's Sun Belt",
                  titleWidth = 500),
  
  dashboardSidebar(
    sidebarMenu(
      menuItem('Time Trends by Metro Area',
               tabName = 'timeTrends'),
      menuItem('Correlations',
               tabName = 'correlations'),
      selected = TRUE
    )
  ),
  
  dashboardBody(
    
    fluidRow(
      tabItems(
        tabItem(
          tabName = 'timeTrends',
          box(
            plotOutput('trends'),
            radioButtons(inputId = 'Metric',
                         label = 'Housing Metric',
                         choices = col_choices)
          )
        ),
        
        tabItem(
          tabName = 'correlations',
          box(
            plotOutput('correlations'),
            fluidRow(
              column(
                width=6,
                radioButtons(inputId = 'xMetric',
                             label = 'xAxis.Metric',
                             choices = col_choices)
              ),
              column(
                width=6,
                radioButtons(inputId = 'yMetric',
                             label = 'yAxis.Metric',
                             choices = col_choices)
              )
            )
          )
        )
      ),
      
      box(
        fluidRow(
          column(
            width=3, 
            checkboxGroupInput(
              inputId = 'Metro.CityAZ',
              label = 'Arizona',
              choices = unique(filter(sunbelt_housing,
                                      Metro.State == 'AZ')$Metro.City))),
          
          column(
            width=3,
            checkboxGroupInput(
              inputId = 'Metro.CityGA',
              label = 'Georgia',
              choices = unique(filter(sunbelt_housing,
                                      Metro.State == 'GA')$Metro.City))),
          column(
            width=3,
            checkboxGroupInput(
              inputId = 'Metro.CityLA',
              label = 'Louisiana',
              choices = unique(filter(sunbelt_housing,
                                      Metro.State == 'LA')$Metro.City))),
          
          column(
            width=3,
            checkboxGroupInput(
              inputId = 'Metro.CityNV',
              label = 'Nevada',
              choices = unique(filter(sunbelt_housing,
                                      Metro.State == 'NV')$Metro.City)))),
        
        
        fluidRow(
          column(
            width=4,
            checkboxGroupInput(
              inputId = 'Metro.CityCA',
              label = 'California',
              choices = unique(filter(sunbelt_housing,
                                      Metro.State == 'CA')$Metro.City))),
          
          column(
            width=4,
            checkboxGroupInput(
              inputId = 'Metro.CityFL',
              label = 'Florida',
              choices = unique(filter(sunbelt_housing,
                                      Metro.State == 'FL')$Metro.City))),
          
          column(
            width=4,
            checkboxGroupInput(
              inputId = 'Metro.CityTX',
              label = 'Texas',
              choices = unique(filter(sunbelt_housing,
                                      Metro.State == 'TX')$Metro.City)))),
        
        dateRangeInput(
          inputId = 'Dates',
          label = 'Date Range',
          start = min(sunbelt_housing$Period.Begin),
          end = max(sunbelt_housing$Period.End))
      )
    )
  )
)

