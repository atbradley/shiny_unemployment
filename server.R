library(shiny)

for ( pkg in c('maps', 'plyr', 'ggplot2')) {
  if ( !library(pkg, logical.return=T, character.only=T) ) {
    install.packages(pkg, repos="http://cran.us.r-project.org")
    library(pkg, character.only=T)
  }
}

source('setup.R')

shinyServer(function(input, output) {
  # Return the formula text for printing as a caption
  output$caption <- renderText({
    print(mths)
    paste("U.S. Unemployment,", 
          sub("([0-9]{4})-0?(1?[0-9])-[0-9]{2}", "\\2/\\1", input$month))
  })
  
  output$map <- renderPlot({
    data <- plotData(input$month)
    states.w <- subset(states, region %in% data$region)
    
    plt <- ggplot(data, aes(map_id = region)) + map_theme +
      geom_map(aes(fill = Unemployment), map = states.w) + 
      scale_fill_continuous(limits=lmts, high="#b50900", low="#fcdad9") +
      expand_limits(x = states.w$long, y = states.w$lat) +
      geom_path(data=states.w,
                aes(long,lat,group=group),
                colour="white",linetype='solid', lwd=1) +
                  coord_fixed()
    
    print(plt)
  })
  
  output$graph <- renderPlot({
    data <- plotData(input$month)
    plt = ggplot(data) + 
          geom_histogram(aes(x=Unemployment), binwidth=1,
                         fill='#b50900', colour='white')
    print(plt)
  })
  
  output$table <- renderTable({ 
    data <- plotData(input$month) 
    data.frame(State=toupper(data$region), Rate=data$Unemployment)
  })
})