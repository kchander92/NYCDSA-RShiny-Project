library(shinydashboard)

optionsBoxTrend <- box(
  fluidRow(
    column(
      width=3, 
      checkboxGroupInput(
        inputId = 'Metro.CityAZ1',
        label = 'Arizona',
        choices = unique(filter(sunbelt_housing,
                                Metro.State == 'AZ')$Metro.City))),
    
    column(
      width=3,
      checkboxGroupInput(
        inputId = 'Metro.CityGA1',
        label = 'Georgia',
        choices = unique(filter(sunbelt_housing,
                                Metro.State == 'GA')$Metro.City))),
    column(
      width=3,
      checkboxGroupInput(
        inputId = 'Metro.CityLA1',
        label = 'Louisiana',
        choices = unique(filter(sunbelt_housing,
                                Metro.State == 'LA')$Metro.City))),
    
    column(
      width=3,
      checkboxGroupInput(
        inputId = 'Metro.CityNV1',
        label = 'Nevada',
        choices = unique(filter(sunbelt_housing,
                                Metro.State == 'NV')$Metro.City)))),
  
  
  fluidRow(
    column(
      width=3,
      checkboxGroupInput(
        inputId = 'Metro.CityCA1',
        label = 'California',
        choices = unique(filter(sunbelt_housing,
                                Metro.State == 'CA')$Metro.City))),
    
    column(
      width=3,
      checkboxGroupInput(
        inputId = 'Metro.CityFL1',
        label = 'Florida',
        choices = unique(filter(sunbelt_housing,
                                Metro.State == 'FL')$Metro.City))),
    
    column(
      width=3,
      checkboxGroupInput(
        inputId = 'Metro.CityTX1',
        label = 'Texas',
        choices = unique(filter(sunbelt_housing,
                                Metro.State == 'TX')$Metro.City)))),
  
  dateRangeInput(
    inputId = 'Dates1',
    label = 'Date Range',
    start = min(sunbelt_housing$Period.Begin),
    end = max(sunbelt_housing$Period.End))
)

optionsBoxCorrs <- box(
  fluidRow(
    column(
      width=3, 
      checkboxGroupInput(
        inputId = 'Metro.CityAZ2',
        label = 'Arizona',
        choices = unique(filter(sunbelt_housing,
                                Metro.State == 'AZ')$Metro.City))),
    
    column(
      width=3,
      checkboxGroupInput(
        inputId = 'Metro.CityGA2',
        label = 'Georgia',
        choices = unique(filter(sunbelt_housing,
                                Metro.State == 'GA')$Metro.City))),
    column(
      width=3,
      checkboxGroupInput(
        inputId = 'Metro.CityLA2',
        label = 'Louisiana',
        choices = unique(filter(sunbelt_housing,
                                Metro.State == 'LA')$Metro.City))),
    
    column(
      width=3,
      checkboxGroupInput(
        inputId = 'Metro.CityNV2',
        label = 'Nevada',
        choices = unique(filter(sunbelt_housing,
                                Metro.State == 'NV')$Metro.City)))),
  
  
  fluidRow(
    column(
      width=3,
      checkboxGroupInput(
        inputId = 'Metro.CityCA2',
        label = 'California',
        choices = unique(filter(sunbelt_housing,
                                Metro.State == 'CA')$Metro.City))),
    
    column(
      width=3,
      checkboxGroupInput(
        inputId = 'Metro.CityFL2',
        label = 'Florida',
        choices = unique(filter(sunbelt_housing,
                                Metro.State == 'FL')$Metro.City))),
    
    column(
      width=3,
      checkboxGroupInput(
        inputId = 'Metro.CityTX2',
        label = 'Texas',
        choices = unique(filter(sunbelt_housing,
                                Metro.State == 'TX')$Metro.City)))),
  
  dateRangeInput(
    inputId = 'Dates2',
    label = 'Date Range',
    start = min(sunbelt_housing$Period.Begin),
    end = max(sunbelt_housing$Period.End))
)

dashboardPage(
  
  dashboardHeader(
    title="Housing Supply and Demand in the USA's Sun Belt",
    titleWidth = 500),
  
  dashboardSidebar(
    sidebarUserPanel(
      h4('Krishnan Chander')
    ),
    
    sidebarMenu(
      menuItem(
        'Time Trends by Metro Area',
        tabName = 'timeTrends'),
      menuItem(
        'Correlations',
        tabName = 'correlations'),
      menuItem(
        'Aggregate Statistics',
        tabName = 'barPlot'),
      selected = TRUE
    )
  ),
  
  dashboardBody(
    
    fluidRow(
      tabItems(
        tabItem(
          tabName = 'timeTrends',
          box(
            plotOutput('timeTrends'),
            radioButtons(
              inputId = 'Metric',
              label = 'Housing Metric',
              choices = col_choices)
          ),
          optionsBoxTrend
        ),
        
        tabItem(
          tabName = 'correlations',
          box(
            plotOutput('correlations'),
            fluidRow(
              column(
                width=6,
                radioButtons(
                  inputId = 'xMetric',
                  label = 'X-Axis',
                  choices = col_choices)
              ),
              column(
                width=6,
                radioButtons(
                  inputId = 'yMetric',
                  label = 'Y-Axis',
                  choices = col_choices)
              )
            )
          ),
          optionsBoxCorrs
        ),
        
        tabItem(
          tabName = 'barPlot',
          box(
            plotOutput('barPlot'),
            
            fluidRow(
              column(
                width = 6,
                radioButtons(
                  inputId = 'aggMetric',
                  label = 'Metric',
                  choices = col_choices
                )
              ),
              
              column(
                width = 6,
                radioButtons(
                  inputId = 'Statistic',
                  label = 'Statistic',
                  choices = c('Mean', 'Median', 'Maximum', 'Minimum',
                              'Standard Deviation')
                )
              )
            ),
            
            fluidRow(
              column(
                width = 4,
                selectizeInput(
                  inputId = 'Month',
                  label = 'Month',
                  choices = unique(sunbelt_housing$Month)
                )
              ),
              
              column(
                width = 4,
                selectizeInput(
                  inputId = 'Year',
                  label = 'Year',
                  choices = unique(sunbelt_housing$Year)
                )
              ),
              
              column(
                width = 4,
                radioButtons(
                  inputId = 'timeFrame',
                  label = 'By:',
                  choices = c('Month', 'Year')
                )
              )
            ),
            width = 8
          )
        )
      )
    )
  )
)