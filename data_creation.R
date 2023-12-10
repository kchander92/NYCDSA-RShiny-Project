library(dplyr)
library(tidyr)
library(readr)
library(lubridate)

filenames = c('atlantaGA', 'austinTX', 'dallasTX', 'houstonTX',
              'jacksonvilleFL', 'lasvegasNV', 'losangelesCA', 'miamiFL', 
              'neworleansLA', 'orlandoFL', 'phoenixAZ', 'riversideCA',
              'sacramentoCA', 'sanantonioTX', 'sandiegoCA', 'sanfranciscoCA',
              'sanjoseCA', 'tampaFL', 'tucsonAZ')

full_df = data.frame()

for (s in filenames) {
  full_df = rbind(full_df,
                  read.csv(paste(c('./New Listings/', s, '.csv'), collapse='')) %>% 
                    inner_join(read.csv(paste(c('./Homes Sold/', s, '.csv'),collapse=''),
                                        fileEncoding = "UTF-16", sep = "\t"),
                               by=c('Day.of.Year', 'Year.of.Period.End')) %>%
                    inner_join(read.csv(paste(c('./Median Sale Price/', s, '.csv'), collapse=''),
                                        fileEncoding = "UTF-16", sep = "\t"),
                               by=c('Day.of.Year', 'Year.of.Period.End')))
}

full_df = full_df %>% select(-Duration, -Region.Type,
                             -Average.New.Listings.Yoy..tooltip.,
                             -Average.Homes.Sold.Yoy..tooltip.,
                             -Median.Sale.Price.Yoy..tooltip., -Last.Updated,
                             -Period.Begin.x, -Period.End.x, -Period.Begin.y,
                             -Period.End.y)

full_df$Region.Name = gsub(' metro area', '', full_df$Region.Name)

full_df = full_df %>% separate(Region.Name, c('Metro.City', 'Metro.State'), sep = ', ') %>%
  relocate(starts_with('Period'), .before = Day.of.Year) %>%
  mutate(Period.Begin = as.Date(Period.Begin, '%m/%d/%Y'),
         Period.End = as.Date(Period.End, '%m/%d/%Y')) %>%
  rename(Day = Day.of.Year, Year = Year.of.Period.End) %>%
  mutate(Month = month(Period.End)) %>%
  relocate(Month, .before = Year)

full_df$adjusted_average_homes_sold = as.numeric(gsub(',', '', full_df$adjusted_average_homes_sold))
full_df$Median.Sale.Price = as.numeric(gsub(',', '', full_df$Median.Sale.Price))

write.csv(full_df, file='sun_belt_housing_data.csv', row.names=F)