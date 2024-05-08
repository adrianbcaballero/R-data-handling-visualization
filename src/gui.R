#load necessary libraries for user interface and data
library(shiny)
library(ggplot2)
library(dplyr)
library(tidyr)

#getting functions from the other file
source("data_analysis.R")

#userinterface
ui <- fluidPage(
  titlePanel("Programming Languages Usage Over Time"),
  sidebarLayout(
    sidebarPanel(
      selectInput("graphType", "Select Graph Type:", #dropdown menu for graph type
                  choices = c("Select Graph Type" = "", "Bar Graph" = "Bar", "Line Graph" = "Line", "Pie Chart" = "Pie")),
      uiOutput("graphOptions") #get the inputs based on what was chosen
    ),
    mainPanel(
      plotOutput("plot")
    )
  )
)

#server logic
server <- function(input, output, session) {
  data <- loadData()  #calls the function to load and prepare data
  
  #create the graph based on what was chosen
  output$graphOptions <- renderUI({
    if (input$graphType == "Bar" || input$graphType == "Pie") {
      yearChoices <- c("Select Year" = "", sort(unique(format(data$Date, "%Y"))))
      monthChoices <- c("Select Month" = "", month.name)  # yse built in month names
      
      wellPanel(
        selectInput("yearInput", "Select Year:", choices = yearChoices),
        selectInput("monthInput", "Select Month:", choices = monthChoices)
      )
    } else if (input$graphType == "Line") {
      selectInput("languageInput", "Select Language:", choices = c("Select Language" = "", unique(data$Language)))
    }
  })
  
  # creating the graph based on what was chosen
  output$plot <- renderPlot({
    if (!is.null(input$graphType) && input$graphType != "") {
      if (input$graphType == "Bar" || input$graphType == "Pie") {
        if (!is.null(input$yearInput) && !is.null(input$monthInput) && input$yearInput != "" && input$monthInput != "") {
          fullDate <- as.Date(paste(input$yearInput, match(input$monthInput, month.name), "01", sep="-"), "%Y-%m-%d") #sets the day as one to match format
          if (input$graphType == "Bar") {
            createBarGraph(fullDate, data) #calls bar graph function
          } else {
            createPieChart(fullDate, data) #calls pie chart function
          }
        }
      } else if (input$graphType == "Line") {
        if (!is.null(input$languageInput) && input$languageInput != "") {
          createLineGraph(input$languageInput, data) #calls line graph function
        }
      }
    }
  })
}


# Run the application using shiny
shinyApp(ui = ui, server = server)

