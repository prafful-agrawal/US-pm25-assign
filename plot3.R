## Load the 'dplyr' and 'ggplot2' packages
library(dplyr)
library(ggplot2)

## Check and download the data if not yet downloaded
if(!file.exists("./data")) {dir.create("data")}                         # Check to see if the directory exists
if(!file.exists("./data/NEI_data.zip")) {
  url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
  download.file(url, destfile = "./data/NEI_data.zip")
}

## Unzip the dataset and store in 'data' directory
if(!file.exists("./data/summarySCC_PM25.rds") || !file.exists("./data/Source_Classification_Code.rds")) {
  unzip(zipfile = "./data/NEI_data.zip", exdir = "./data")
}

## Read the PM2.5 Emissions data
NEI <- readRDS("./data/summarySCC_PM25.rds")

## Read the Source Classification Code table
SCC <- readRDS("./data/Source_Classification_Code.rds")

## Calculate the total emissions grouped by type and year for Baltimore City, Maryland
tot_em <- NEI %>% filter(fips == "24510") %>% group_by(type, year) %>% summarise(total_emissions = sum(Emissions))

## Create the 'plot3.png'
png(file = "plot3.png", width = 1080, height = 480, units = "px")        # Open the PNG device
ttl <- "Total PM2.5 emissions in Baltimore City, Maryland from 1999 to 2008"
x_lab <- "Year"
y_lab <- "Total PM2.5 emissions (in Tons)"
years <- unique(tot_em$year)
g <- ggplot(tot_em, aes(year, total_emissions)) + geom_col() + facet_grid(.~type) + scale_x_continuous(breaks = years) + labs(title = ttl, x = x_lab, y = y_lab)
print(g)
dev.off()                                                               # Close the PNG device

## END