library(dplyr)

args <- commandArgs(trailingOnly = TRUE)

fileName <- args[1]

tg <- read.table(fileName, sep = "\t", header = FALSE)

#calculate cache line
tg$cache <- as.vector(trunc(tg$V1 / 64))

#calculate page
tg$page <- as.vector(trunc(tg$V1 / 4096))

sprintf("Filename: %s", fileName)
sprintf("Distinct Addresses: %d", length(unique(tg$V1)))
sprintf("Distinct cache lines: %d", length(unique(tg$cache)))
sprintf("Distinct pages: %d", length(unique(tg$page)))
totalAccesses <- sum(tg$V3)
sprintf("Total accesses: %d", totalAccesses)
totalAccessesDuplicatedCacheLines <- totalAccesses - sum(tg[!(duplicated(tg$cache)|duplicated(tg$cache, fromLast=TRUE)),3])
sprintf("Percent of lines with false sharing: %f", (totalAccessesDuplicatedCacheLines * 100) / totalAccesses)
