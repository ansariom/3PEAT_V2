#!/usr/bin/Rscript

args <- commandArgs(trailingOnly = TRUE)
if (length(args) < 3) {
    cat("Usage ./filter_peaks.R [peaks.csv] [filter_by_file] [outfile] \n")
    quit(save="no", status=1)
}


#myargs <- args[4:length(args)]
peaks_file <- args[1]
filter_file <- args[2]
outfile <- args[3]

indata1 <- read.delim(peaks_file, sep = ",", header = T)
head(indata1)
indata2 <- read.table(filter_file, sep = "\t", header = F)
head(indata2)
outdata <- merge(indata1, indata2, by.x="id", by.y="V1")

outdata$id <- NULL
outdata$V2 <- NULL
outdata$V3 <- NULL
outdata$V4 <-NULL

write.table(file = outfile, x = outdata, col.names = T, row.names = FALSE, quote = F, sep=",")
