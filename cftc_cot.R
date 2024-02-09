# List of assets for study
assetList <- list("NASDAQ MINI - CHICAGO MERCANTILE EXCHANGE", "E-MINI S&P 500 - CHICAGO MERCANTILE EXCHANGE")

# List of IDs associated to a given asset
idList <- list("nasdaq", "sp500")

itemsForStudy <- c("As of Date in Form YYMMDD", "Market and Exchange Names", "Commercial Positions-Long (All)","Commercial Positions-Short (All)")

# CFTC Commitment of Traders Report
url <- "https://www.cftc.gov/dea/newcot/deafut.txt"

# download the header file here [https://www.cftc.gov/MarketReports/CommitmentsofTraders/HistoricalViewable/cotvariableslegacy.html]
# and copy the content to a csv file
pathToHeaderFile <- ''

# Path to store the study
pathToStorage <-  ''

# Read data from CFTC into a table
table <- read.table(url, sep = ",")

# Read the table headers into a data frame  
tableHeader <- read.csv(pathToHeaderFile, header = FALSE, sep = ",")

# Set the table headers to the CFTC data
colnames(table) <- tableHeader$V1

# Loop through all the assets for this study
for (i in 1:length(assetList)) {
  
  asset = assetList[[i]]

  id = idList[[i]]

  fileName = paste(idList[i], ".csv", sep = "")
  file = paste(pathToStorage, fileName, sep = "")
  
  # Fetch the table row of the asset we are looking for
  assetTable <- subset(table, table$`Market and Exchange Names` == asset)
  
  # Fetch only the columns of interest for the asset table
  study <- subset(assetTable, select = itemsForStudy)
  
  # Write to table, append to bottom if already exist
  write.table(study, file, sep = "|",  append=TRUE, quote = FALSE, col.names = FALSE, row.names = FALSE)
}
