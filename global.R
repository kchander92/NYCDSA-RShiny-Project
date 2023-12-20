library(dplyr)
library(tidyr)
library(readr)
library(lubridate)

# The sunbelt_housing data frame is meant to contain all the Redfin data over
# the years 2020-2023 pertaining to new housing units, number of units sold, and
# median sale price in the 19 most populous metro areas of the American Sun Belt.

filenames = c('atlantaGA', 'austinTX', 'dallasTX', 'houstonTX',
              'jacksonvilleFL', 'lasvegasNV', 'losangelesCA', 'miamiFL', 
              'neworleansLA', 'orlandoFL', 'phoenixAZ', 'riversideCA',
              'sacramentoCA', 'sanantonioTX', 'sandiegoCA', 'sanfranciscoCA',
              'sanjoseCA', 'tampaFL', 'tucsonAZ')

sunbelt_housing = data.frame()

for (s in filenames) {
  sunbelt_housing = rbind(sunbelt_housing,
                  read.csv(paste(c('./New Listings/', s, '.csv'), collapse='')) %>% 
                    inner_join(read.csv(paste(c('./Homes Sold/', s, '.csv'),collapse=''),
                                        fileEncoding = "UTF-16", sep = "\t"),
                               by=c('Day.of.Year', 'Year.of.Period.End')) %>%
                    inner_join(read.csv(paste(c('./Median Sale Price/', s, '.csv'), collapse=''),
                                        fileEncoding = "UTF-16", sep = "\t"),
                               by=c('Day.of.Year', 'Year.of.Period.End')))
}

rm(filenames, s)

sunbelt_housing = sunbelt_housing %>% select(-Duration, -Region.Type,
                             -Average.New.Listings.Yoy..tooltip.,
                             -Average.Homes.Sold.Yoy..tooltip.,
                             -Median.Sale.Price.Yoy..tooltip., -Last.Updated,
                             -Period.Begin.x, -Period.End.x, -Period.Begin.y,
                             -Period.End.y)

sunbelt_housing$Region.Name = gsub(' metro area', '', sunbelt_housing$Region.Name)

sunbelt_housing = sunbelt_housing %>% separate(Region.Name, c('Metro.City', 'Metro.State'), sep = ', ') %>%
  relocate(starts_with('Period'), .before = Day.of.Year) %>%
  mutate(Period.Begin = as.Date(Period.Begin, '%m/%d/%Y'),
         Period.End = as.Date(Period.End, '%m/%d/%Y')) %>%
  rename(Day = Day.of.Year, Year = Year.of.Period.End) %>%
  mutate(Month = month(Period.End, label = TRUE)) %>%
  relocate(Month, .before = Year) %>%
  mutate(adjusted_average_new_listings_yoy = adjusted_average_new_listings_yoy * 100,
         adjusted_average_homes_sold_yoy = adjusted_average_homes_sold_yoy * 100,
         Median.Sale.Price.Yoy = Median.Sale.Price.Yoy * 100)

sunbelt_housing$adjusted_average_homes_sold = as.numeric(gsub(',', '', sunbelt_housing$adjusted_average_homes_sold))
sunbelt_housing$Median.Sale.Price = as.numeric(gsub(',', '', sunbelt_housing$Median.Sale.Price))

# A column labeling the federal funds interest rate as set by the Federal Reserve
# is added to the data frame based on when the rates were changed.

interest_rate_changes = as.Date(c(min(sunbelt_housing$Period.End),
                                  '2020-03-03', '2020-03-16', '2022-03-17',
                                  '2022-05-05', '2022-06-16', '2022-07-27',
                                  '2022-09-21', '2022-11-02', '2022-12-14',
                                  '2023-02-01', '2023-03-22', '2023-05-03',
                                  '2023-07-26',
                                  max(sunbelt_housing$Period.End) + 1))

federal_funds_rate = c('1.50% to 1.75%', '1.0% to 1.25% (-)', '0% to 0.25% (-)', 
                       '0.25% to 0.50% (+)', '0.75% to 1.00% (+)', 
                       '1.50% to 1.75% (+)', '2.25% to 2.50% (+)',
                       '3.00% to 3.25% (+)', '3.75% to 4.00% (+)',
                       '4.25% to 4.50% (+)', '4.50% to 4.75% (+)', 
                       '4.75% to 5.00% (+)', '5.00% to 5.25% (+)',
                       '5.25% to 5.50% (+)')

sunbelt_housing$interest.rate.range = cut(sunbelt_housing$Period.End,
                                          breaks = interest_rate_changes,
                                          labels = federal_funds_rate)

rm(interest_rate_changes, federal_funds_rate)

# The col_choices list contains mappings of labels used in radio button inputs
# in the app's UI to their corresponding column label in the sunbelt_housing
# data frame.

col_choices = list('Average New Listings' = 'adjusted_average_new_listings',
                   'Average Homes Sold' = 'adjusted_average_homes_sold',
                   'Median Sale Price ($)' = 'Median.Sale.Price',
                   'Average New Listings %YoY Change' = 'adjusted_average_new_listings_yoy',
                   'Average Homes Sold %YoY Change' = 'adjusted_average_homes_sold_yoy',
                   'Median Sale Price %YoY Change' = 'Median.Sale.Price.Yoy')