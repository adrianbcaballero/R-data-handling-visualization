library(ggplot2)
library(dplyr)
library(tidyr)

#function to get data for plotting
loadData <- function() {
  data <- read.csv("Popularity of Programming Languages from 2004 to 2023.csv")
  
  #convert date assuming its first day of the month
  data$Date <- as.Date(paste(data$Date, "01"), format="%B %Y %d")
  
  data <- data %>%
    pivot_longer(cols = -Date, names_to = "Language", values_to = "Popularity")  # re format data for easier plotting
  return(data)
}


#function to create a bar graph for a specific month
createBarGraph <- function(date, data) {
  # Ensure date is in the correct format and matches the data
  target_date <- as.Date(date, format="%Y-%m-%d") 
  subset_data <- data %>% filter(Date == target_date)
  ggplot(subset_data, aes(x=Language, y=Popularity, fill=Language)) +
    geom_bar(stat="identity") +
    theme_minimal() +
    labs(title=paste("Popularity of Programming Languages in", format(target_date, "%B %Y")), x="Language", y="Popularity (%)")
}


#function to create a line graph for a specific language
createLineGraph <- function(language, data) {
  subset_data <- data %>% filter(Language == language)
  ggplot(subset_data, aes(x=Date, y=Popularity, color=Language)) +
    geom_line() +
    theme_light() +
    labs(title=paste("Trend of", language, "Over Time"), x="Date", y="Popularity (%)")
}

#function to create a pie chart for a specific month
createPieChart <- function(date, data) {
  subset_data <- data %>% filter(Date == as.Date(date, format="%B %Y"))
  ggplot(subset_data, aes(x="", y=Popularity, fill=Language)) +
    geom_bar(width=1, stat="identity") +
    coord_polar(theta="y") +
    theme_void() +
    labs(title=paste("Distribution of Programming Languages in", format(as.Date(date, format="%B %Y"), "%B %Y")))
}


