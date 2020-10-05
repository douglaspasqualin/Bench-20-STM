library(ggplot2)

csv <- read.table("mseDynamic.txt", sep = ",", header = TRUE)

#remove with ID zero (no MSE, first matrix collected)
table <- subset(csv, id != 0)

yticks <- c(0, 250, 500, 750, 1000, 1250, 1500)

graph <-
  ggplot(data = table, aes(x = id, y = mse, group = app)) +
  theme_bw() +
  theme(
    legend.position="bottom",
    legend.title = element_blank(),
    plot.title = element_text(hjust = 0.5, face = "bold"),
    panel.border = element_blank(),
    text = element_text(size = 15),
    plot.subtitle = element_text(hjust = 0.5, face = "italic")
  ) +
  geom_line(aes(
    linetype = app,
    group = factor(app),
    color = app
  ),
  size = 0.5) +
  geom_point(aes(color = app, shape = app), size = 2) +
  xlab("Execution phase") +
  ylab("MSE") +
  scale_shape_manual(values = c(4, 8, 15, 16, 17, 18, 21, 22, 3, 42))+ 
  scale_y_continuous(limits=c(0,1400), breaks=yticks, labels=yticks)

ggsave(plot = graph,  file = "Figure_7.pdf",  device = cairo_pdf,  width = 15,  height = 9,  units = "cm")
