# The columns that the study will focus on
columnsForStudy <- c("As.of.Date.in.Form.YYMMDD", 
                     "Market.and.Exchange.Names", 
                     "Commercial.Positions.Long..All.", 
                     "Commercial.Positions.Short..All.")

# Assets of interests for this study
assetList <- list("NASDAQ MINI - CHICAGO MERCANTILE EXCHANGE",
                  "E-MINI S&P 500 - CHICAGO MERCANTILE EXCHANGE",
                  "DJIA Consolidated - CHICAGO BOARD OF TRADE",
                  "WHEAT-SRW - CHICAGO BOARD OF TRADE",
                  "WTI FINANCIAL CRUDE OIL - NEW YORK MERCANTILE EXCHANGE",
                  "GOLD - COMMODITY EXCHANGE INC.",
                  "SILVER - COMMODITY EXCHANGE INC.",
                  "U.S. DOLLAR INDEX - ICE FUTURES U.S.",
                  "BITCOIN - CHICAGO MERCANTILE EXCHANGE",
                  "CORN - CHICAGO BOARD OF TRADE")

assetListAlt <- list("NASDAQ-100 STOCK INDEX (MINI) - CHICAGO MERCANTILE EXCHANGE",
                     "E-MINI S&P 500 STOCK INDEX - CHICAGO MERCANTILE EXCHANGE",
                     "",
                     "",
                     "",
                     "",
                     "",
                     "USD INDEX - ICE FUTURES U.S.",
                     "",
                     "")

# Id for each asset, used to simplify the file name
idList <- list("cot_nasdaq", 
               "cot_sp500",
               "cot_djia",
               "cot_wheat",
               "cot_crude_oil",
               "cot_gold",
               "cot_silver",
               "cot_usd",
               "cot_btc",
               "cot_corn")

YEAR_START <- 2019
YEAR_END <- as.integer(format(Sys.Date(), "%Y"))

URL_START <- "reports\\deacot"

URL_END <- "\\annual.txt"

PATH <- "data\\"

data <- data.frame(Date = character(), Asset = character(), Long = character(), Short = character(), stringsAsFactors = FALSE)

readCotData <- function(){
  
  # Loop though each asset and create a report for each year
  print("Reading historical COT data")
  print(paste("Study length :", YEAR_START, YEAR_END, sep = " "))
  
  for (i in 1:length(assetList)) {
    
    # The asset for this report
    asset <- assetList[[i]]
    assetAlt <- assetListAlt[[i]]
    
    # Id for the file name
    id <- idList[[i]]
    
    # Create data folder if it does not exist
    ifelse(!dir.exists(file.path(PATH)), dir.create(file.path(PATH)), FALSE)
    
    # Create file for storing current report
    fileName <- paste(idList[i], ".csv", sep = "")
    
    # Create new file at data/[filename].csv
    fileName <- paste(PATH, fileName, sep = "")
    
    # Fetch report for each year
    year <- YEAR_START
    
    print(paste("Fetching asset", asset, sep = " "))
    
    while (year <= YEAR_END) {
      print(paste("Fetching data for", year, sep = " "))
      
      # Create a dynamic path to COT data for each year
      url <- paste(URL_START, year, sep = "")
      url <- paste(url, URL_END, sep = "")
      
      # Read the report into a table
      table <- read.table(url, header = TRUE, sep = ",")
      
      # Create a table for only current asset
      assetTable <- subset(table, table$`Market.and.Exchange.Names` == asset)
      
      if(nrow(assetTable) == 0){
        print("Asset table is empty")
        print(paste("using alt name", assetAlt, sep = " "))
        assetTable <- subset(table, table$`Market.and.Exchange.Names` == assetAlt)
      }
      
      # Filter the columns of the asset
      study <- subset(assetTable, select = columnsForStudy)
      
      # Revers the read table
      revlist <- study[order(study$As.of.Date.in.Form.YYMMDD),]
      
    
      # write the table to file and append the data if the file already exists
      write.table(revlist, fileName, sep = "|",  append=TRUE, quote = FALSE, col.names = FALSE, row.names = FALSE)
      
      # prepare for next report
      year <- year + 1
    }
  }
  print("Completed")
}

# fetch the lates report from CFTC
fetchLatest <- function(){
  library(httr)
  
  url <- "https://www.cftc.gov/dea/newcot/deafut.txt"
  response <- GET(url, user_agent("MyApp/1.0"))
  
  # Check if the request was successful
  if (status_code(response) == 200) {
    raw_content <- content(response, "text")
    
    # Split the content into lines
    lines <- strsplit(raw_content, "\n")[[1]]
    
    # Iterate through each line and add to dataframe
    for (line in lines) {
      parts <- unlist(strsplit(line, ","))
      if (length(parts) > 12) {
        new_row <- data.frame(Date = parts[2], Asset = parts[1], Long = as.numeric(parts[12]), Short = as.numeric(parts[13]), stringsAsFactors = FALSE)
        assign("data", rbind(get("data"), new_row), envir = .GlobalEnv)
      }
    }
    
  } else {
    print("Failed to retrieve data\n")
  }
  
  print("Completed")
  
}

readData <- function(fileName){
  
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

plotCotData(-1)
