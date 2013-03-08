library(shiny)

source('setup.R')

# Define UI for miles per gallon application
shinyUI(pageWithSidebar(
  # Application title
  headerPanel("U.S. Unemployment"),
  
  sidebarPanel(
    selectInput('month', 'Month:', mths)
  ),
  
  #TODO: Add tabs, show a barplot in one.
  mainPanel(
    h3(textOutput("caption")),
    tabsetPanel(
      tabPanel("Map", plotOutput("map")), 
      tabPanel("Graph", plotOutput("graph")), 
      tabPanel("Table", tableOutput("table"))
    )
  )
))