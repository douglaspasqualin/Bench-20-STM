library(ggplot2)

Legend <- "Input params:"
originalNames <- c("orig", "new")
newNames <- c("Default", "Small")
colors <- c('#808080', '#D3D3D3')

table <- read.table("mseCalculated.txt", sep = ",", header = TRUE)

#re-order colum
table$config <- factor(table$config, levels = originalNames)

table$app <- as.factor(table$app)

graph <- ggplot(table, aes(x=app, y=mse, fill=config)) + 
  #theme_bw() + 
  theme(legend.position="none",
        plot.title = element_text(hjust = 0.5, face = "bold"),
        panel.border = element_blank(),
        plot.subtitle = element_text(hjust = 0.5, face = "italic"),
        axis.text.x = element_text(angle = 45, hjust=1)) +        
  geom_boxplot() +
  xlab("Application") +
  ylab("MSE") +
  scale_fill_manual(values = colors, name = Legend, breaks = originalNames, labels = newNames)

graph <- graph + theme(legend.position="bottom", text = element_text(size=15))
ggsave(plot = graph, file = "0.graph.pdf", 
       device = cairo_pdf, width = 15, height = 9, units = "cm")
