plotData <- function(date) {
  data <- c(unemp[unemp$Date==date, -1])
  data <- data[order(names(data))]
  data <- t(as.data.frame(data))
  
  data <- data.frame(State=rownames(data), Unemployment=data[,1])
  data <- join(data, state.abbr)
  
  data
}

monthnames <- c('January', 'February', 'March',
                'April', 'May', 'June',
                'July', 'August', 'September', 
                'October', 'November', 'December')

dfile <- 'unemployment.csv'
nowts <- as.integer(Sys.time())



if ( !file.exists(dfile) | 
  nowts - as.integer(file.info('unemployment.csv')$ctime) > (60*60*24*7 ) )   {
  fsource <- 'http://www.quandl.com/api/v1/datasets/USER_14Z/151.csv'
  #fsource <- 'http://www.quandl.com/api/v1/datasets/USER_14Z/150.csv'
  download.file(fsource, dfile)
}

unemp <- read.csv(dfile, stringsAsFactors=F)
colnames(unemp) <- sub('URN...Value', '', colnames(unemp))

#Set the min and max values for the plot' color scale.
lmts = c(min(unemp[, -1]), max(unemp[, -1]))

mths <- setNames(as.list(unemp$Date), 
                 sub("([0-9]{4})-0?(1?[0-9])-[0-9]{2}", "\\2/\\1", unemp$Date))

for ( m in 1:12) {
  names(mths) <-sub(paste('^', m, '/', sep=''),
                    paste(monthnames[m], ' ', sep=''), 
                    names(mths))
}

state.abbr <- 'state.abbr.csv'

if ( !file.exists(state.abbr) ) {
  fsource <- 'http://www.fonz.net/blog/wp-content/uploads/2008/04/states.csv'
  download.file(fsource, state.abbr)
}

state.abbr <- read.csv(state.abbr, stringsAsFactors=F)
state.abbr$State <- tolower(state.abbr$State)
names(state.abbr) = c('region', 'State')
states <- map_data("state")

map_theme <- theme(
  line = element_blank(), 
  rect = element_blank(),
  strip.text = element_blank(),
  axis.text = element_blank(),
  axis.title = element_blank())