library('ggplot2')
library('reshape2')
library('plyr')
library('jsonlite')

# read command line arguments
args <- commandArgs(trailingOnly = TRUE)

ggdata <- fromJSON(args[1])

threshold <- as.numeric(args[2])
outputName <- args[3]

# replace distances above threshold by NA
ggdata[ggdata > threshold] <- NA

# melt data and remove NA values
ggdata <- melt(ggdata, na.rm = TRUE)

# Set the data frame, & add ecdf() data.
ggdata <- ddply(ggdata, .(variable), transform, ecd=ecdf(value)(value))

# Create the error plot.
cdf <- ggplot(ggdata, aes(x=value, y=ecd, colour=variable)) + xlab("Error [mm]") + ylab("Percentage") +
      labs(color = NULL) +
      scale_y_continuous(labels=function(x)x*100) +
      guides(colour=FALSE)

cdf <- cdf + theme_bw(base_size = 12, base_family = "Helvetica")

cdf <- cdf +
  #increase size of gridlines
  theme(panel.grid.major = element_line(size = .5, color = "grey"),
  #increase size of axis lines
  axis.line = element_line(size=.7, color = "black"),
  #Adjust legend position to maximize space, use a vector of proportion
  #across the plot and up the plot where you want the legend.
  #You can also use "left", "right", "top", "bottom", for legends on t
  #he side of the plot
  legend.position = c(.75,.5),
  legend.text = element_text(size=9),
  #increase the font size
  text = element_text(size=9)) +
  geom_line(size=0.8)

svg(file = outputName, width= 4.5, height = 3)

# Generate the CDF.
cdf

dev.off()
