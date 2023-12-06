library(dplyr)

filenames = c('atlantaGA', 'austinTX', 'dallasTX', 'houstonTX',
              'jacksonvilleFL', 'lasvegasNV', 'losangelesCA', 'miamiFL', 
              'neworleansLA', 'orlandoFL', 'phoenixAZ', 'riversideCA',
              'sacramentoCA', 'sanantonioTX', 'sandiegoCA', 'sanfranciscoCA',
              'sanjoseCA', 'tampaFL', 'tucsonAZ')

full_df = data.frame()

for (s in filenames) {
  full_df = rbind(full_df,
                  read.csv(paste(c('./New Listings/', s, '.csv'), collapse='')) %>% 
                    inner_join(read.csv(paste(c('./Homes Sold/', s, '.csv'), collapse=''),
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

