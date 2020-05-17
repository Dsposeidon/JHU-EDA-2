library("data.table")

path <- getwd()

download.file(url = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
              , destfile = paste(path, "dataFiles.zip", sep = "/"))
unzip(zipfile = "dataFiles.zip")


SC <- data.table::as.data.table(x = readRDS(file = "Source_Classification_Code.rds"))
N <- data.table::as.data.table(x = readRDS(file = "summarySCC_PM25.rds"))

N[, Emissions := lapply(.SD, as.numeric), .SDcols = c("Emissions")]
tolN <- NEI[fips=='24510', lapply(.SD, sum, na.rm = TRUE)
                , .SDcols = c("Emissions")
                , by = year]

png(filename='plot2.png')

barplot(tolN[, Emissions]
        , names = tolN[, year]
        , xlab = "Years", ylab = "Emissions"
        , main = "Emissions over the Years")

dev.off()
