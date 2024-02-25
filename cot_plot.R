readData <- function(fileName){
  
  # Path to the folder that contains the file
  PATH <- "data/"
  
  # Create a complete path to file ex "data/cot_sp500.csv"
  file = paste(PATH, fileName, sep="")
  
  table <- read.csv(file, header=FALSE, sep="|")
  
  return(table)
}

plotCotData <- function(monthsBack){
  
  table <- readData("cot_sp500.csv")
  title <- "COT SP500"
  
  if(monthsBack > 0){
    title <- paste(title, monthsBack, "months", sep = " ")
  } 

  plotData <- c()
  rawData <- c()
  xAxisData <- c()
  
  dataCount <- monthsBack * 4;
  
  if(monthsBack == -1){
    dataCount <- nrow(table)  
  }
  
  if(dataCount > nrow(table)){
    dataCount <- nrow(table)  
  }
  
  if(dataCount < 4){
    dataCount <- 4
  }
  
  start = (nrow(table) - dataCount) +1
  
  print(start)
  
  index <- 1
  
  for(i in start:nrow(table)) {
    value <- table[i, 3] - table[i, 4]
    rawData[index] <- as.numeric(value)
    xAxisData[index] <- table[i,1]
    index <- index+1
  }
  
  maxValue <- -10000000
  minValue <- 10000000
  
  for(i in 1:length(rawData)) {
    if(rawData[i] > maxValue){
      maxValue <- rawData[i]
    }
    
    if(rawData[i] < minValue){
      minValue <- rawData[i]
    }
  }
  
  # Find the mid point between the high and the low for the given timeframe
  midValue <- (maxValue + minValue) / 2
  
  # Normalize the data to the midpoint
  for(i in 1:length(rawData)) {
    plotData[i] <- rawData[i] - midValue
  }
  

  barplot(height=plotData, names=xAxisData,  col=ifelse(plotData>0,"green","red"), main = title)
}

plotCotData(6)