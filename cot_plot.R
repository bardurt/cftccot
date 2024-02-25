
# Path to the file
PATH <- "data/"

plotCotData <- function(){

  # Name of the file to read
  fileName <- "cot_sp500.csv"
  

  title <- "COT SP500"
  
  # Create a complete path to file ex "data/cot_sp500.csv"
  file = paste(PATH, fileName, sep="")
  
  table <- read.csv(file, header=FALSE, sep="|")
  
  plotData <- c()
  xAxisData <- c()
  
  for(i in 1:nrow(table)) {
    value <- table[i, 3] - table[i, 4]
    plotData[i] = as.numeric(value)
    xAxisData[i] = table[i,1]
    print(plotData[[i]])
  }
  
  barplot(height=plotData, names=xAxisData,  col=ifelse(plotData>0,"green","red"), main = title)
}

plotCotData()