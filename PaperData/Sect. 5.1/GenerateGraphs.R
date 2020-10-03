#!/usr/bin/env Rscript

library(ggplot2)
library(Rmisc) #needed for summarySE function
library(lattice)
library(plyr)
library(magrittr) #filter
require(scales)
library(ggpubr, warn.conflicts = FALSE) #Save legend


isAborts <- FALSE 
yLegend <- "Execution Time (sec)"
extensionFileName <- "_time"


######### Function to format total of aborts
FormatSI <- function(x, ...) {
  # https://www.moeding.net/2011/10/metric-prefixes-for-ggplot2-scales/
  function(x) {
    limits <- c(1e-24, 1e-21, 1e-18, 1e-15, 1e-12,
                1e-9,  1e-6,  1e-3,  1e0,   1e3,
                1e6,   1e9,   1e12,  1e15,  1e18,
                1e21,  1e24)
    prefix <- c("y",   "z",   "a",   "f",   "p",
                "n",   "µ",   "m",   " ",   "k",
                "M",   "G",   "T",   "P",   "E",
                "Z",   "Y")
    
    # Vector with array indices according to position in intervals
    i <- findInterval(abs(x), limits)
    
    # Set prefix to " " for very small values < 1e-24
    i <- ifelse(i==0, which(limits == 1e0), i)
    
    paste(format(round(x/limits[i], 1), trim=TRUE, scientific=FALSE, ...), prefix[i])  
  }
}

######### File with data to load
fileName <- "timeExec.txt"

########## read a table from the file, using TAB as separator
tg <- read.table(fileName, sep = ",")

#Legend <- "Mapping"
Legend <- ""
originalNames <- c("LINUX_DEFAULT", "TOPO_MATCH", "ONLINE2", "NUMALIZE")
newNames <- c("Linux", "Static", "Online", "Numalize-static")
colors <- c('#4572A7', '#AA4643', '#89A54E', '#80699B', '#3D96AE', '#DB843D', '#92A8CD', '#A47D7C', '#B5CA92')
colors2 <- c('#AA4643', '#89A54E', '#80699B', '#3D96AE', '#DB843D', '#92A8CD', '#A47D7C', '#B5CA92')
#black and white
#colors <- c('#f7f7f7','#cccccc','#969696','#636363','#252525')

########## Calculate average, standard deviation and other metrics 
tgc <- summarySE(tg, measurevar = "V3", groupvars = c("V1", "V2", "V4"))

#re-order colum
tgc$V4 <- factor(tgc$V4, levels = originalNames)

#Save summarized file to csv
write.csv(tgc, paste("Summary", extensionFileName, ".csv", sep = ""))

########## Get all app names from data
apps <- unique(tgc[c('V1')])

########## For each apps in the data, generate corresponding graph
for (i in 1: nrow(apps)) {
  appName <- apps[i, 1]
  
  #Filter data by appName
  toPlot <- subset(tgc, V1 == appName)
  
  graph <-
    ggplot(toPlot, aes(x = factor(V2), y = V3, fill = V4)) +
    theme_bw() + 
    theme(legend.position="bottom",
          plot.title = element_text(hjust = 0.5, face = "bold"),
          panel.border = element_blank(),  text = element_text(size=15),
          plot.subtitle = element_text(hjust = 0.5, face = "italic")) +    
    geom_bar(
      position = position_dodge(),
      stat = "identity",
      colour = "black",
      # Use black outlines,
      size = .3
    ) + 
    geom_errorbar(
      aes(ymin = V3 - sd, ymax = V3 + sd),
      size = .3,
      # Thinner lines
      width = .2,
      position = position_dodge(.9)
    ) +
   # ggtitle(appName) +
    #labs(title = appName, subtitle = paste(machine, "Machine")) +
    xlab("Number of Threads") +
    ylab(yLegend) +
    #annotate("text", x = Inf, y = Inf, label = "Less is better", vjust = 1.5, hjust = 1.1)    
    scale_fill_manual(values = colors, name = Legend, breaks = originalNames, labels = newNames)    
  
  #Save legend in a separate file
  if (appName == "Kmeans") {
  	legend <- get_legend(graph)
  	as_ggplot(legend)
  	ggsave(plot = legend, "legend.pdf", width = 16, height = 1, units = "cm", device = cairo_pdf,)    
  }
  
  #Remove legend and increase font size
 graph <- graph + theme(legend.position="none", text = element_text(size=15))
  #graph <- graph + theme(text = element_text(size=15))
  ggsave(plot = graph, file = paste(appName, extensionFileName, ".pdf", sep = ""), 
         device = cairo_pdf, width = 10, height = 6, units = "cm")    
}
