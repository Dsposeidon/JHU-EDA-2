library("data.table")
library("ggplot2")


path <- getwd()
download.file(url = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
              , destfile = paste(path, "dataFiles.zip", sep = "/"))
unzip(zipfile = "dataFiles.zip")


N <- data.table::as.data.table(x = readRDS("summarySCC_PM25.rds"))
SC <- data.table::as.data.table(x = readRDS("Source_Classification_Code.rds"))


combusRelated <- grepl("comb", SC[, SCC.Level.One], ignore.case=TRUE)
coalRelated <- grepl("coal", SC[, SCC.Level.Four], ignore.case=TRUE) 
combustionSC <- SC[combusRelated & coalRelated, SCC]
combustionN <- N[N[,SCC] %in% combustionSC]

png("plot4.png")

ggplot(combustionN,aes(x = factor(year),y = Emissions/10^5)) +
  geom_bar(stat="identity", fill ="#FF9999", width=0.75) +
  labs(x="year", y=expression("Total PM"[2.5]*" Emission (10^5 Tons)")) + 
  labs(title=expression("PM"[2.5]*" Coal Combustion Source Emissions Across US from 1999-2008"))

dev.off()
