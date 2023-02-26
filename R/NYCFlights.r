# -*- coding: utf-8 -*-

# -- Sheet --

# # NYC Flight Analysis 2013


# ### Import Library


library(dplyr)
library(tidyverse)
library(lubridate)

# ### Import Dataset


df <- read.csv("flights.csv")

# ## Explore Dataset


head(df,10)


# Dataframe overview using dplyr library
glimpse(df)

# ### Filter Missing Values


sum(complete.cases(df))/nrow(df)

# **Summary of Missing Data**
# 
# 
# Complete Values = 97%
# 
# Missing Values = 3%
# 
# Remove missing values if less than 5% is acceptable


# ### Filter out Miss Values


df_clean <- drop_na(df)

# ## Analysis 5 Business Question
# 
# ### Q1:What is the most common departure time for flights departing from JFK airport?


# Get top 5 departure times by frequency
df_clean %>%
  group_by(dep_time) %>%
  summarise(n = n()) %>%
  arrange(desc(n)) %>%
  select(dep_time,n) %>%
  head(5) %>%
  rename("Number of lights" = n)

# > **Answer:** Flights tend to occur frequently during the early morning hours.


# ### Q2 What is the average delay time for flights departing from JFK airport?


# Get mean departure delay for flights from JFK
df_clean %>% 
    select(origin,dep_delay)%>%
    filter(origin == "JFK") %>%
    summarise(mean(dep_delay))

# >**Answer:** The mean departure delay for flights departing from JFK airport is approximately 12 minutes


# 


# ### Q3 How does the average delay time vary by destination for flights departing from JFK airport


# Filter flights from JFK, group by destination, 
# calculate mean departure delay, sort by mean delay
df_clean %>%
    select(origin,dest,dep_delay) %>%
    group_by(dest) %>%
    filter(origin == "JFK") %>%
    summarise(mean = mean(dep_delay)) %>%
    arrange(desc(mean))

    

# **>Answer:** The average delay time for flights departing from JFK varies by destination, with CVG having the highest delay and STT having the lowest. 
# 
# Some destinations have negative average delay, indicating flights arriving early.


# ### Q4.What is the variation in the number of flights departing from JFK airport based on the day of the week?


## Combine day-month-year together 
df_clean <- df_clean %>% 
  mutate(full_date = as.Date(paste(year, month, day, sep="-"), format = "%Y-%m-%d")) %>%
  mutate(weekday = weekdays(full_date)) %>% 
  mutate(full_date = format(full_date, "%Y-%m-%d")) 

# Get flight count by day of the week
df_clean %>% 
    group_by(weekday) %>%
    summarise(n= n()) %>%
    arrange(desc(n)) %>%
    rename("Number of Flights" = "n")

# >**Answer:** The number of flights departing from JFK varies by day of the week, with Monday having the most and Saturday having the least.


# ### Q5. Which airline has the highest on-time arrival rate at JFK airport?


# Find average delay time by carrier
df_clean %>%
    select(carrier,arr_delay) %>%
    group_by(carrier) %>%
    summarise(average_delay = mean(arr_delay)) %>%
    arrange(desc(average_delay))

# >**Answer:** AA has the highest on-time arrival rate at JFK with an average delay of 0.364 minutes. 


# ### Q6. How does the number of flights departing from JFK airport vary by month?


## Combine day-month-year together 
df_clean <- df_clean %>% 
  mutate(full_date = as.Date(paste(year, month, day, sep="-"), format = "%Y-%m-%d")) %>%
  mutate(month_string = months(full_date)) %>% 
  mutate(full_date = format(full_date, "%Y-%m-%d")) 

  df_clean

#Count flights by month, sort by count
df_clean %>% 
    group_by(month_string) %>%
    summarise(n= n()) %>%
    arrange(desc(n)) %>%
    rename("Number of Flights" = "n")

# **>Answer:** The number of flights from JFK varies by month, with August having the most and February having the least.


# ### Q7. What is the variation in the number of flights departing from JFK airport based on the destination?


#Count Flights by "JFK" Origin and group by dest, sort by count
df_clean %>%
    select(origin,dest) %>%
    filter(origin == "JFK") %>%
    group_by(dest) %>%
    summarise(n = n()) %>%
    arrange(desc(n)) %>%
    rename("Number of Flights" = n)

# **Answer:** LAX airport has the highest number of flights departing from JFK, while STL has the lowest number.




