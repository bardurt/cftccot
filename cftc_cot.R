ASSET_SP500 <- 'E-MINI S&P 500 - CHICAGO MERCANTILE EXCHANGE'
ASSET_NASDAQ <- 'NASDAQ MINI - CHICAGO MERCANTILE EXCHANGE'

# CFTC Commitment of Traders Report
url <- "https://www.cftc.gov/dea/newcot/deafut.txt"

# download the header file here [https://www.cftc.gov/MarketReports/CommitmentsofTraders/HistoricalViewable/cotvariableslegacy.html]
# ad copy the content to a csv file
pathToHeaderFile <- ''

# Path to store the study
pathToStorage <-  ''

# What asset are we looking for
assetToFind <- ASSET_SP500

# Read data from CFTC into a table
table <- read.table(url, sep = ",")

# Read the table headers into a data frame  
tableHeader <- read.csv(pathToHeaderFile, header = FALSE, sep = ",")

# Set the table headers to the CFTC data
colnames(table) <- tableHeader$V1

# Fetch the table row of the asset we are looking for
assetTable <- subset(table, table$`Market and Exchange Names` == assetToFind)

# Fetch only the columns of interest for the asset table
printPreview <- subset(assetTable, select = c("As of Date in Form YYMMDD", "Market and Exchange Names", "Commercial Positions-Long (All)","Commercial Positions-Short (All)"))

write.table(printPreview, pathToStorage, sep = "|", col.names = FALSE, row.names = FALSE)
