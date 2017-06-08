library('ggplot2')
library('jsonlite')

# read command line arguments
args <- commandArgs(trailingOnly = TRUE)

ggdata <- fromJSON(args[1])

outputName <- args[2]

gg_color_hue <- function(n) {
 hues = seq(15, 375, length=n+1)
 hcl(h=hues, l=65, c=100)[1:n]
 }

plotColors = gg_color_hue(2)

# Create the error plot.
plot <- ggplot(ggdata, aes(x=components, y=mean)) + xlab("Components") + ylab("Error [mm]") +
  geom_ribbon(fill=plotColors[2], alpha=0.5, aes( ymax = mean + standardDeviation, ymin = mean - standardDeviation))  +
  geom_line(color=plotColors[1], size=0.3, aes(y = mean)) +
  scale_y_continuous() +
  scale_x_continuous(breaks=min(ggdata$components):max(ggdata$components))

plot <- plot + theme_bw(base_size = 12, base_family = "Helvetica")
plot <- plot +
#increase size of gridlines
theme(panel.grid.major = element_line(size = .5, color = "grey"),
#increase size of axis lines
axis.line = element_line(size=.7, color = "black"),
#Adjust legend position to maximize space, use a vector of proportion
#across the plot and up the plot where you want the legend.
#You can also use "left", "right", "top", "bottom", for legends on t
#he side of the plot
legend.text = element_text(size=9),
#increase the font size
text = element_text(size=9))

# svg(file = outputName, width= 4.5, height = 3)
pdf(file = outputName, width = 4.5, height = 3)

# Generate the CDF.
plot

dev.off()
