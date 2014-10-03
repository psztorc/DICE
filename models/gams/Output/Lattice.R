
#DICE Lattice

setwd("C:/Users/ps583/Dropbox/Paul S Yale Work/Paul - Bill - Shared Folder/Dice 2013 and Climate/Latest/MUP Project/Dice MUP/Output")

rm(list=ls())
DataIn <- read.csv("SCC.csv")
names(DataIn)[1:6] <- c("TSP.Index","TFP.Index","Pop.Index","TmpCoef.Value","TFP.Factor","Pop.Factor")
library('ggplot2')
library('RColorBrewer')
theme_set(theme_bw(base_size = 12))


LatticePlot <- function(DataIn,Title) {
  Data <- TrimTo3x3(DataIn)
  
#   MyColors <- brewer.pal(length(levels(Data$Mode)),"Set2")
#   names(MyColors) <- levels(Data$Mode)
#   MyColScale <- scale_colour_manual(name = "Mode",values = MyColors)
  
  HollowShapes <- c(1, 2, 0, 3, 7, 8)
  names(HollowShapes) <- unique(Data$Group)
  MyShapeScale <- scale_shape_manual(values=HollowShapes)

  Data$TFP.Factor <- factor(Data$TFP.Factor,levels=c(1.01,1,.99),ordered=TRUE) #correct order
  
  pLat <- ggplot(Data,aes(colour=Mode,x=TmpCoef.Value,y=V3,shape=Mode,linetype=Mode)) + #X2100.Value, Y2100r
    theme_bw() +
    facet_grid(facets= TFP.Factor~Pop.Factor,drop=FALSE,labeller=label_both,scales="free") +
    geom_point(size=2) + 
    geom_line(size=.5) +   
    labs(title=Title) +
#     MyColScale +
    MyShapeScale
  return(pLat)
}

TrimTo3x3 <- function(Data) {
  datS1 <- Data[Data$TFP.Index!=2,]
  datS2 <- datS1[datS1$TFP.Index!=4,]
  
  datS3 <- datS2[datS2$Pop.Index!=2,]
  datS4 <- datS3[datS3$Pop.Index!=4,]
  return(datS4)
}

p1 <- LatticePlot(DataIn,"Social Cost of Carbon")
pdf(file="DiceLattice.pdf")
print(p1)
dev.off()
