# CFTC Commitment of Traders Report
url <- "https://www.cftc.gov/dea/newcot/deafut.txt"

# download the header file here [https://www.cftc.gov/MarketReports/CommitmentsofTraders/HistoricalViewable/cotvariableslegacy.html]
# ad copy the content to a csv file
pathToHeaderFile <- 'C:\\Users\\barth\\Desktop\\cot129.csv'

# Path to store the study
pathToStorage <-  'C:\\Users\\barth\\Desktop\\cot-nas.csv'

# What asset are we looking for
assetToFind = 'NASDAQ MINI - CHICAGO MERCANTILE EXCHANGE'

# Read data from CFTC into a table
table <- read.table(url, sep = ",")

# Read the table headers into a data frame  
tableHeader <- read.csv(pathToHeaderFile, header = FALSE, sep = ",")

# Set the table headers to the CFTC data
colnames(table) <- tableHeader$V1

summary <- subset(table, table$`Market and Exchange Names` == assetToFind)

preview <- subset(summary, select = c("As of Date in Form YYMMDD", "Market and Exchange Names", "Commercial Positions-Long (All)","Commercial Positions-Short (All)"))

write.table(preview, pathToStorage, sep = "|", col.names = FALSE, row.names = FALSE)



