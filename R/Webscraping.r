## Import Library
install.packages("tidyverse")
install.packages("rvest")

library(tidyverse)
library(rvest) # scrape data from internet

## 1 Model Scraping Test
url <- read_html("https://specphone.com/Samsung-Galaxy-A04s.html")

att <- url %>% 
  html_nodes("div.topic") %>%
  html_text2()

detail <- url %>% 
  html_nodes("div.detail") %>%
  html_text2()

data.frame(attribute = att,
           detail = detail)


# All Samsung Smartphone
samsung_url <- read_html("https://specphone.com/brand/Samsung")


# links to all samsung smartphone
links <- samsung_url %>%
  html_nodes("li.mobile-brand-item a") %>%
  html_attr("href")


full_links <- paste0("https://specphone.com", links)


result <- data.frame()


## Loops All URLs
for (link in full_links[1:10]){
  ss_topic <- link %>%
    read_html() %>%
    html_nodes("div.topic") %>%
    html_text2()
  
  ss_detail <- link %>%
    read_html() %>%
    html_nodes("div.detail") %>%
    html_text2()
  
  tmp <- data.frame(attribute = ss_topic,
                    value = ss_detail)
  
  result <- bind_rows(result, tmp)
  print("Progress..")
}

print(head(result),3)


## Write csv
write_csv(result, "results_ss_phone.csv")
