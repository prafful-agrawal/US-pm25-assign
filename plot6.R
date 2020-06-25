## Load the 'dplyr' and 'lattice' packages
library(dplyr)
library(lattice)

## Check and download the data if not yet downloaded
if(!file.exists("./data")) {dir.create("data")}                             # Check to see if the directory exists
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

## Extract the SCCs for mobile on-road vehicles
SCCs <- SCC[grepl("^Mobile - On-Road.*Vehicles$", SCC$EI.Sector), 'SCC']

## Calculate the total emissions grouped by year for Baltimore City, Maryland and Los Angeles County, California
tot_em <- NEI %>% filter(fips %in% c("24510", "06037"), SCC %in% SCCs) %>% group_by(fips, year) %>% summarise(total_emissions = sum(Emissions)) %>%
  mutate(norm_total_emissions = total_emissions/max(total_emissions)) %>%   # Normalize the data for comparision
  mutate(city = ifelse(fips == "24510", "Baltimore City, Maryland", "Los Angeles County, California"))

## Create the 'plot6.png'
png(file = "plot6.png", width = 1080, height = 480, units = "px")            # Open the PNG device
ttl <- "Total Motor vehicle related PM2.5 emissions in Baltimore City, Maryland\nand Los Angeles County, California from 1999 to 2008"
x_lab <- "Year"
y_lab <- "Normalized Total PM2.5 emissions"
barchart(norm_total_emissions ~ as.character(year) | city, tot_em, horizontal = FALSE, main = ttl, xlab = x_lab, ylab = y_lab)
dev.off()                                                                   # Close the PNG device

## END