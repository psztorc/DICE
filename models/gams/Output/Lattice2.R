

rm(list=ls())

Use <- function(package) {
  if(suppressWarnings(!require(package,character.only=TRUE))) install.packages(package,repos="http://cran.case.edu/")
  require(package,character.only=TRUE)
}
# Working Directory
try(setwd("C:/Users/ps583/Dropbox/Paul S Yale Work/Paul - Bill - Shared Folder/DICE 2014/Output"))

# Data Source
filename <- c('LatIm_Reduced.csv')
Full <- try(read.csv(file=filename,header=TRUE))

Full$Group <- Full$Round
LatestOnly <- FALSE

ExtractList <- unique(Full$Category) #c("Forcings at CO2 doubling (Watts per Meter 2)", "Atmospheric concentration of carbon (ppm)", "Cumulative Emissions to date", "Hotelling Rent on Carbon Fuels (2005 USD / tCO2)", "Atmospheric Temperature (deg C above preindustrial)", "Total Increase in Forcing (Watts per Meter2, preindustrial)", "Gross Output (trillion USD)", "Climate damages (trillion USD)", "Output post-damages yet pre-abatement", "Abatement cost (trillion USD)", "Output (Net of Damages and Abatement, trillion USD pa) ", "Total Carbon Emissions (GTCO2 per year)", "World Emissions Intensity (sigma)", "Gross Investment (trillion 2005USD per year)", "Capital (trillion 2005USD per year)", "Consumption (trillion USD per year)", "Savings Rate (proportion of gross output)", "Carbon Price (per t CO2)", "Emissions Control Rate (total)", "Social Cost of Carbon")
Labels <- ExtractList

Base <- Full[Full$Mode == "Base",]
Ampere <- Full[Full$Mode == "Ampere",]


Use('ggplot2')
Use('RColorBrewer')
Use("extrafont")

LatticeFilename <- "Lattices_DICE_Scenarios.pdf"


LatticePlot <- function(FullData, Yvar, Year, Mode, TLab, Xaxis, LockVerticalAxisAcrossYears = TRUE) {
  
  DataM <- FullData[FullData$Mode==Mode,]
  
  # Check for enough data
  
  if(nrow(DataM)<10) {
    print("Insufficient Pre-subset Data")
    return(NULL)
  }
  
  if(.5 < ( sum(is.na(DataM))/prod(dim(DataM)) ) )  {
    print("Insufficient Pre-subset Data")
    return(NULL)
  }
  
  # Ignore cases 2 and 4
  DataT <- TrimTo3x3(DataM,Xaxis)
  
  
  
  #Setting the Y var across all years
  L <- min(DataT[DataT$Category==Yvar, names(DataT) %in% c("X2020.Value","X2050.Value","X2100.Value")],na.rm=TRUE)  #making limits the same across all years
  H <- max(DataT[DataT$Category==Yvar, names(DataT) %in% c("X2020.Value","X2050.Value","X2100.Value")],na.rm=TRUE)  #making limits the same across all years
  
  
  if(L=="-Inf") {
    print("Log of negative taken - abandoning")
    return(NULL)
  }
  
  
  #Ignore time periods
  DataT2 <- DataT
  
  # Only the specific Y variable we need.
  Slice <- DataT2[DataT2$Category==Yvar,] 
  
  # Force ordering of TFP in later graph.
  if(Xaxis %in% c("TmpCoef.Value","Pop.Factor")) Slice$TFP.Factor <- factor(Slice$TFP.Factor,levels=c(1.01,1,.99),ordered=TRUE) #correct order
  
  # Do we still have enough data?
  if(nrow(Slice)<10) {
    print("Insufficient Post-subset Data")
    return(NULL)
  }
  
  # Alter labels to make graph instruction automatic
  RelYear <- paste("X",Year,".Value", sep="")
  names(Slice)[names(Slice)==RelYear] <- "Y"
  Slice$Group <- factor(Slice$Group)
  # Discriminate Plot x and Facets based on user's request
  
  if(Xaxis == "TmpCoef.Value"){
    pLattice <- ggplot(Slice,aes(colour=Group,x=TmpCoef.Value,y=Y,shape=Group,linetype=Group)) +
      facet_grid(facets= TFP.Factor~Pop.Factor,drop=FALSE,labeller=label_both,scales="free") 
  }
  
  if(Xaxis == "TFP.Factor"){
    pLattice <- ggplot(Slice,aes(colour=Group,x=TFP.Factor,y=Y,shape=Group,linetype=Group)) +
      facet_grid(facets= TmpCoef.Value~Pop.Factor,drop=FALSE,labeller=label_both,scales="free") 
  }
  
  
  if(Xaxis == "Pop.Factor"){
    pLattice <- ggplot(Slice,aes(colour=Group,x=Pop.Factor,y=Y,shape=Group,linetype=Group)) +
      facet_grid(facets= TFP.Factor~TmpCoef.Value,drop=FALSE,labeller=label_both,scales="free") 
  }
  
  Plot <- pLattice +  
    theme_bw() +
    geom_point(size=2.5) + 
    geom_line(size=.5) +   
    labs(title=paste(Mode,TLab,Year)) +
    xlab(Xaxis)
  
  if(LockVerticalAxisAcrossYears) {
    Plot <- Plot + scale_y_continuous(limits = c(L, H)) # + # making limits the same across all years
  }
  
  if(LatestOnly) { 
    Plot <- Plot +
      MyColScale +
      MyShapeScale
  }
  
  return(Plot)
}



TrimTo3x3 <- function(Data,Xaxis="TmpCoef.Value") {
  # Ignore cases 2 and 4, do this right before the lattice plot
  TemporaryData <- Data
  
  if( Xaxis != "TFP.Factor") TemporaryData <- TemporaryData[TemporaryData$TFP.Index!=2 & TemporaryData$TFP.Index!=4,]
  if( Xaxis != "Pop.Factor") TemporaryData <- TemporaryData[TemporaryData$Pop.Index!=2 & TemporaryData$Pop.Index!=4,]
  
  # Temperature Sensitivity - erasing 5 instead of 4 because there are many missing 5's.
  if( Xaxis != "TmpCoef.Value") {
    TemporaryData <- TemporaryData[TemporaryData$TmpCoef.Index!=2 & TemporaryData$TmpCoef.Index!=5,]
    # Just lose all the data on values, as it produces ugly lattices
    TemporaryData$TmpCoef.Value <- TemporaryData$TmpCoef.Index
    # Reorder (1,3,4) becomes (4,3,1)
    TemporaryData$TmpCoef.Value[TemporaryData$TmpCoef.Index==4] <- "Low"
    TemporaryData$TmpCoef.Value[TemporaryData$TmpCoef.Index==3] <- "Medium"
    TemporaryData$TmpCoef.Value[TemporaryData$TmpCoef.Index==1] <- "High"
    
    if(Xaxis == "TFP.Factor") TemporaryData$TmpCoef.Value <- factor(TemporaryData$TmpCoef.Value,levels=c("High","Medium","Low"),ordered=TRUE)
    if(Xaxis == "Pop.Factor") TemporaryData$TmpCoef.Value <- factor(TemporaryData$TmpCoef.Value,levels=c("Low","Medium","High"),ordered=TRUE)
  }
  
  
  return(TemporaryData)
}





pdf(file=LatticeFilename,width=10,height=7.5)



for(l in c("TmpCoef.Value") ) { #, "TFP.Factor", "Pop.Factor") ) {
  for(i in c("Base","Ampere")) {
    for(j in ExtractList) {
      Label <- j
      for(k in c("2020","2050","2100")) {
        print(paste(l,i,j,k,Label,sep=" - "))
        print( LatticePlot(FullData = Full, Yvar = j, Year = k, Mode = i, TLab = Label, Xaxis = l)  )
      }
    }
  }
}

dev.off()

#  For ratios












