columnsForStudy <- c("As.of.Date.in.Form.YYMMDD", 
                     "Market.and.Exchange.Names", 
                     "Commercial.Positions.Long..All.", 
                     "Commercial.Positions.Short..All.")


assetList <- list("NASDAQ MINI - CHICAGO MERCANTILE EXCHANGE",
                  "E-MINI S&P 500 - CHICAGO MERCANTILE EXCHANGE",
                  "WHEAT-SRW - CHICAGO BOARD OF TRADE",
                  "WTI FINANCIAL CRUDE OIL - NEW YORK MERCANTILE EXCHANGE",
                  "GOLD - COMMODITY EXCHANGE INC.",
                  "SILVER - COMMODITY EXCHANGE INC.")

idList <- list("cot_nasdaq", 
               "cot_sp500",
               "cot_wheat",
               "cot_crude_oil",
               "cot_gold",
               "cot_silver")

YEAR_START = 2019
YEAR_END = 2024

URL_START = "C:\\Users\\barth\\Desktop\\coding\\r\\cot\\cftccot\\reports\\deacot"

URL_END = "\\annual.txt"

PATH = "C:\\Users\\barth\\Desktop\\coding\\r\\cot\\cftccot\\data\\"

# Loop though each asset and create a report for each year
print("Starting")
for (i in 1:length(assetList)) {
  
  # The asset for this report
  asset = assetList[[i]]
  
  # Id for the file name
  id = idList[[i]]
  
  # Create file for storing current report
  fileName = paste(idList[i], ".csv", sep = "")
  fileName = paste(PATH, fileName, sep = "")
  
  # Fetch report for each year
  year = YEAR_START
  
  while (year < YEAR_END) {
    
    # Create a dynamic path to COT data for each year
    url <- paste(URL_START, year, sep = "")
    url <- paste(url, URL_END, sep = "")
    
    # Read the report into a table
    table <- read.table(url, header = TRUE, sep = ",")
    
    # Create a table for only current asset
    assetTable <- subset(table, table$`Market.and.Exchange.Names` == asset)
    
    # Filter the colums of the asset
    study <- subset(assetTable, select = itemsForStudy)
    
    # Revers the read table
    revlist <- study[order(study$As.of.Date.in.Form.YYMMDD),]
    
    # write the table to file and append the data if the file already exists
    write.table(revlist, fileName, sep = "|",  append=TRUE, quote = FALSE, col.names = FALSE, row.names = FALSE)
    
    # prepare for next report
    year <- year + 1
  }
}
print("Completed")