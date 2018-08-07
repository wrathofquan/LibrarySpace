library(tidyverse)


files <- list.files(pattern='*.csv', recursive = TRUE)


# set folder and file lists
folder <- "/Users/joshuaquan/Downloads/monthly_2018/monthly_2018/"     # path to folder that holds multiple .csv files
file_list <- list.files(path=folder, pattern="*.csv") # create list of all .csv files in folder

#load into separate dataframes
# for (i in 1:length(file_list)){
#   assign(file_list[i], 
#          read.csv(paste(folder, file_list[i], sep=''))
#   )}

### load into single dataframe
data <- 
  do.call("rbind", 
          lapply(file_list, 
                 function(x) 
                   read.csv(paste(folder, x, sep=''), 
                            stringsAsFactors = TRUE)))


## remove sensor rows. wtf is this anyway?

data <- data %>% 
  filter(!str_detect(Entrance,"Sensor"))


data <- data %>% 
  filter(!str_detect(," "))

## write to csv

write_csv(data, 'monthly_2018.csv')


## annual totals

annuals <- data %>% 
  group_by(Facility) %>% 
  summarize(sum(Entries))


annual_counter <- read_csv("sqft_counter_2017-2018 .csv")

counter <- annual_counter %>%  mutate(sqft_log2 = log2(sqft),
                           counter_log2 = log2(annual_counter))

write_csv(counter, "counter_sqft_2018.csv")



### work with hourly data

hourly <- read_xlsx("./counter-hourly/counter.xlsx")


## What's the busiest day for each library?

busiest_day <- hourly %>%
  group_by(Facility, day1 = floor_date(Date, "day")) %>%
  summarize(count = sum(Entries)) %>%
  group_by(Facility, day1) %>%
  summarize(count = max(count)) %>% 
  filter(Facility %in% c("MOFF Library", "DOE Library", "DOE STACKS", "BANC Library")) %>% 
  filter(count > 0)

write_excel_csv(busiest_day, 'hourly_aggregate-2017-2018.csv')

# %>%
#   top_n(n = 15) %>%
#   arrange(desc(count), Facility ) 

#quick chart
busiest_day %>% 
  ggplot(aes(x= day1, y = count, color=Facility)) + geom_point() + ggtitle("Daily Counter Totals, July 2017-2018")

