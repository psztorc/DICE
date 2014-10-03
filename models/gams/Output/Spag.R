
#Diagnostic Plots

#Pre Load
rm(list=ls())
Use <- function(package) {
  if(suppressWarnings(!require(package,character.only=TRUE))) install.packages(package,repos="http://cran.case.edu/")
  require(package,character.only=TRUE)
}


SpaghettiPlot <- function(Data,Title) {
  Use('reshape')
  mDat <- melt(Data,
               id.vars=names(Data)[c(1:4,8)],
               measure.vars=names(Data)[-1:-8])
  
  cast(mDat,formula=Mode+variable~Var,fun.aggregate=length)
  Mean <- cast(mDat,formula=Mode+variable+Var~.,fun.aggregate=mean)
  Sd <- cast(mDat,formula=Mode+variable+Var~.,fun.aggregate=sd)
  CoV <- cast(mDat,formula=Mode+variable+Var~.,fun.aggregate=function(x) sd(x)/mean(x))
  
  print(Title)
  print(Mean)
  print(Sd)
  
  
  FixNumerics <- function(DataIn) {
    DataIn$Time <- as.numeric(   unlist(strsplit(as.character(DataIn$variable),"Y")) [seq(2,length(DataIn$variable),by=2)] ) #remove y, convert to number
    DataIn$Value <- as.numeric( DataIn[["(all)"]] ) 
    return(DataIn)
  }
  
  CoV <- FixNumerics(CoV)
  Mean <- FixNumerics(Mean)
  Sd <- FixNumerics(Sd)
  
  Use('ggplot2')
  
  P1 <- ggplot(CoV,aes(x=Time,colour=Var,shape=Var,linetype=Mode,y=Value)) +
    geom_point() + geom_line() +
    theme(legend.position="bottom") +
    labs(title = Title)
  
  print(P1)
}

SpaghettiPlot2 <- function(Data,Title) {
  Use('reshape')
  mDat <- melt(Data,
               id.vars=names(Data)[c(1:4,18)],
               measure.vars=names(Data)[c(-1:-8,-18)])
  
  cast(mDat,formula=Mode+variable~Group,fun.aggregate=length)
  Mean <- cast(mDat,formula=Mode+variable+Group~.,fun.aggregate=mean)
  Sd <- cast(mDat,formula=Mode+variable+Group~.,fun.aggregate=sd)
  CoV <- cast(mDat,formula=Mode+variable+Group~.,fun.aggregate=function(x) sd(x)/mean(x))
  
  print(Title)
  print(Mean)
  print(Sd)
  
  
  FixNumerics <- function(DataIn) {
    DataIn$Time <- as.numeric(   unlist(strsplit(as.character(DataIn$variable),"Y")) [seq(2,length(DataIn$variable),by=2)] ) #remove y, convert to number
    DataIn$Value <- as.numeric( DataIn[["(all)"]] ) 
    return(DataIn)
  }
  
  CoV <- FixNumerics(CoV)
  Mean <- FixNumerics(Mean)
  Sd <- FixNumerics(Sd)
  
  Use('ggplot2')
  
  P1 <- ggplot(CoV,aes(x=Time,colour=Group,shape=Group,linetype=Mode,y=Value)) +
    geom_point() + geom_line() +
    theme(legend.position="bottom") +
    labs(title = Title)
  
  print(P1)
}

# # Alt + s + w  Enter
# setwd("C:/Users/ps583/Dropbox/Paul S Yale Work/Paul - Bill - Shared Folder/Dice 2013 and Climate/Latest/MUP Project")
# 
# # #Load Data
# Dat <- read.csv('MUPR-Final-Alldata-120913.csv')
# 
# 140*125*2
# 
# head(Dat)
# 
# VarList <- unique(Dat$Var)
# 
# VarSubset <- VarList[c(130,111,135,100,137,138)]
# VarSubset
# 
# Subset <- Dat[ (Dat$Var %in% VarSubset),]
# Subset <- Subset[,1:50] #Year 2100
# 
# dim(Dat)
# dim(Subset)
# 
# length(VarSubset)*125*2
# 
# head(Subset)
# names(Subset)
# # [1] "Mode"                              "I"                                 "J"                                 "K"                                
# # [5] "Temperature.Sensitivity.Parameter" "Total.Factor.Productivity.Growth"  "Population.Level"                  "Var"                              
# # [9] "Y2010"                             "Y2015"                             "Y2020"                             "Y2025"                            
# # [13] "Y2030"                             "Y2035"                             "Y2040"                             "Y2045"                            
# # [17] "Y2050"                             "Y2055"                             "Y2060"                             "Y2065"                            
# # [21] "Y2070"                             "Y2075"                             "Y2080"                             "Y2085"                            
# # [25] "Y2090"                             "Y2095"                             "Y2100"                             "Y2105"                            
# # [29] "Y2110"                             "Y2115"                             "Y2120"                             "Y2125"                            
# # [33] "Y2130"                             "Y2135"                             "Y2140"                             "Y2145"                            
# # [37] "Y2150"                             "Y2155"                             "Y2160"                             "Y2165"                            
# # [41] "Y2170"                             "Y2175"                             "Y2180"                             "Y2185"                            
# # [45] "Y2190"                             "Y2195"                             "Y2200"                             "Y2205"



#Load II
setwd("C:/Users/ps583/Dropbox/Paul S Yale Work/Paul - Bill - Shared Folder/Dice 2013 and Climate/Latest/MUP Project")
Dat <- read.csv('mergedv9_2Dice.csv')
dim(Dat)
Dat <- Dat[  !(Dat$Group=="DICE"&Dat$Round=="First"),]
dim(Dat)

VarList <- unique(Dat$Category)

VarSubset <- VarList[c(1,4,5,7,9,11)]
VarSubset

Subset <- Dat[ (Dat$Category %in% VarSubset),]
Subset <- Subset[,c(21,3:9,11:20,1)] #Years
names(Subset) <- c("Mode","I","J","K","Temperature.Sensitivity.Parameter","Total.Factor.Productivity.Growth", "Population.Level",
                   "Var","Y2010","Y2020","Y2030","Y2040","Y2050","Y2060","Y2070","Y2080","Y2090","Y2100","Group")  #harmonize




pdf(file="CoVs.pdf",width=11,height=8.5)
for(i in unique(Subset$Group)) {
  SubsetII <- Subset[Subset$Group==i,-19]
  SpaghettiPlot(SubsetII,paste(i))
}
dev.off()


#Special Case - GCAM
pdf(file="CoV_GCAM.pdf",width=11,height=8.5)
SubsetGCAM <- Subset[Subset$Group=="GCAM",]
head(SubsetGCAM)
SubsetGCAMII <- SubsetGCAM[,c(-18,-19)]
SpaghettiPlot(SubsetGCAMII,'GCAM excl 2100')
dev.off()




# Reverse
pdf(file="CoVsByY.pdf",width=11,height=8.5)
for(i in unique(Subset$Var)) {
  SubsetII <- Subset[Subset$Var==i,-8]
  SpaghettiPlot2(SubsetII,paste(i))
}
dev.off()













