
library("data.table")
library("ggplot2")


path <- getwd()
download.file(url = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
              , destfile = paste(path, "dataFiles.zip", sep = "/"))
unzip(zipfile = "dataFiles.zip")




options(scipen=999)

## This first line will likely take a few seconds. Be patient!
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

df <- subset(SCC, select = c("SCC", "Short.Name"))
NEI <- merge(NEI, df, by.x="SCC", by.y="SCC", all=TRUE)

rm(SCC)


## Q5
# How have emissions from motor vehicle sources changed from 1999–2008 
# in Baltimore City?

# Data prep
plot5 <- subset(NEI, fips == "24510" & type =="ON-ROAD", c("Emissions", "year","type"))
plot5 <- aggregate(Emissions ~ year, plot5, sum)

png(file = "plot5.png")

# Plot the chart
plot((Emissions / 1000) ~ year, 
     data = plot5, 
     type = "l", 
     #ylim = c(min(df1[ ,-1]), max(df1[ ,-1])),
     xlab = "Year",
     ylab = "Total emissions (/1000)",
     main = "Baltimore City PM2.5 Motor Vehicle Emissions",
     xaxt="n")
axis(side=1, at=c("1999", "2002", "2005", "2008"))

# Save the file.
dev.off()
