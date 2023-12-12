library(dplyr)
library(tidyr)
library(readr)
library(lubridate)

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
  mutate(Month = month(Period.End)) %>%
  relocate(Month, .before = Year)

sunbelt_housing$adjusted_average_homes_sold = as.numeric(gsub(',', '', sunbelt_housing$adjusted_average_homes_sold))
sunbelt_housing$Median.Sale.Price = as.numeric(gsub(',', '', sunbelt_housing$Median.Sale.Price))

col_choices = list('Average New Listings' = 'adjusted_average_new_listings',
                   'Average Homes Sold' = 'adjusted_average_homes_sold',
                   'Median Sale Price' = 'Median.Sale.Price',
                   'Average New Listings YoY Change' = 'adjusted_average_new_listings_yoy',
                   'Average Homes Sold YoY Change' = 'adjusted_average_homes_sold_yoy',
                   'Median Sale Price YoY Change' = 'Median.Sale.Price.Yoy')