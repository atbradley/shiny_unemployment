library(shiny)

source('setup.R')

shinyUI(pageWithSidebar(
  headerPanel("U.S. Unemployment"),
  
  sidebarPanel(
    selectInput('month', 'Month:', mths)
  ),
  
  mainPanel(
    h3(textOutput("caption")),
    tabsetPanel(
      tabPanel("Map", plotOutput("map")), 
      tabPanel("Graph", plotOutput("graph")), 
      tabPanel("Table", tableOutput("table"))
    )
  )
))