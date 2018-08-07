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



