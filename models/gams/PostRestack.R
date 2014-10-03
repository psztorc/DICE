

#Relevant Inputs and Outputs from the Big File
ExtractList <- c(
  "Output (Net of Damages and Abatement, trillion USD pa) ",
  "Consumption (trillion USD per year)",
  "Population (millions)",
  "Industrial Emissions (GTCO2 per year)",
  "Atmospheric concentration of carbon (GTC)",
  "Atmospheric concentration of carbon (ppm)",
  "Total Increase in Forcing (Watts per Meter2, preindustrial)",
  "Atmospheric Temperature (deg C above preindustrial)",
  "Climate damages (trillion USD)",
  "Interest Rate (Real Rate of Return)",
  "Abatement cost (trillion USD)",
  "Social Cost of Carbon"
)


GetInput <- function(df,Period=2100) {                            
  RelYear <- (1:ncol(df))[(as.numeric(df[2,])==Period)]   #Relevant Year
  RelCol <- c(1:7, RelYear)                    #Inputs and Labels + Year
  RelCol <- RelCol[!is.na(RelCol)]             #remove na
  
  RelRow <- (1:nrow(df))[df[,7] %in% ExtractList]
  
  return(df[RelRow,RelCol])
}

WriteTablesFunc <- function(ModelList, namelist,jjj) {
  
  for(k in 1:length(namelist)) {
    
    if(class(ModelList[[k]])=="lm") {
      temp <- cbind(summary(ModelList[[k]])$coef,Blank=" ","DV"=namelist[k])
      if(k==1) OutList <- temp
      if(k>1) OutList <- rbind(OutList," ",temp)
    
    print(paste(jjj,k," Model Written to File", jjj,k))
    }
    
  }
  
  OutList <- rbind(c("IV Title","Coef","SE","T val","p-value","DV"), " ", OutList)
  
  OutFileM <- paste("Output/4_Subsets/",BigList[jjj],OutFile3,".csv",sep="")
  
  write.table(OutList,file=OutFileM,sep=",",col.names=NA)
  
}

Norm <- function(x) {
  if(sd(x,na.rm=TRUE) == 0) return(x)
  if(sd(x,na.rm=TRUE) != 0) return( (x-mean(x,na.rm=TRUE))/sd(x,na.rm=TRUE) )
}

DeNorm <- function(x,mu,s) {
  if(sd(x,na.rm=TRUE) == 0) return(x)
  if(sd(x,na.rm=TRUE) != 0) return( (x*s) + mu )
}

CreateModels <- function(jjj,Year=2100) {   #function of index
  SubSet <- GetInput(RestackedSets[[jjj]],Year)
  
  SmallSets <- as.list(1:length(ExtractList))
  Models <- as.list(1:length(ExtractList))
  
  
  
  for(j in 1:length(ExtractList)) {
    
    SmallSets[[j]] <- SubSet[(SubSet[,7]==ExtractList[j]),]
    

    #Normalize IVs
    mode(SmallSets[[j]][[4]]) <- "numeric"
    IV1 <- Norm( SmallSets[[j]][[4]] ) #normalize IV 1
    mode(SmallSets[[j]][[5]]) <- "numeric"
    IV2 <- Norm( SmallSets[[j]][[5]] ) #normalize IV 2
    mode(SmallSets[[j]][[6]]) <- "numeric"
    IV3 <- Norm( SmallSets[[j]][[6]] ) #normalize IV 3
    
    #Normalize DV
    mode(SmallSets[[j]][[8]]) <- "numeric"
    DV <- Norm( SmallSets[[j]][[8]] )
    
    #Rename
    df2 <- data.frame(DV,IV1,IV2,IV3)
    names(df2) <- c(ExtractList[j],"TFP","gPop","TSP")
    
    
    Models[[j]] <- try( lm(df2[,1]~poly(TFP,degree=2) + 
        poly(gPop,degree=2) +
        poly(TSP,degree=2), data=df2) 
    )
      
    if("try-error" %in% class(Models[[j]])) Models[[j]] <- j
    
    
    #try(print(Models[[j]]))
    
  }
  
  WriteTablesFunc(Models,ExtractList,jjj)
  
  return(Models)
  
  
}


#Edit interemediate table
EditIntermediateTable <- function(DataSource=1) {
  
  gmsScaling <- read.csv(ScalingFile,header = FALSE,stringsAsFactors=FALSE)
  base <- RestackedSets[[DataSource]]
  InputList <- c(
    "Population (millions)",
    "Total Factor Productivity"
#    "Temperature Sensitivity Coefficient (temp increase per doubling CO2)"
  )
  
  for(iS in 1:length(InputList)) {
    temp <- subset(x=base,subset=base[,7]==InputList[iS])
    utemp <- unique(temp[,-1:-6])
    if(iS==1) values <- utemp
    if(iS>1)values <- rbind.fill(values,utemp)
  }
  outfile <- rbind(gmsScaling,values)
  write.table(outfile,file=paste("Output/",OutFile2,sep=""),sep=",",row.names=TRUE,col.names=FALSE)
  return(values)
}

GWP <- Data[Data$V1=="Gross Output (trillion USD)",] #GWP Extract
Pop <- Data[Data$V1=="Population (millions)",]       #Pop Extract
PcY <- GWP                       #GWP[,8:(ncol(Data))]/Pop[,8:(ncol(Data))]     #Per Capita GDP for all t

# PcY.r <- cbind(GWP[,1:6],
#                "Pcy2010"=PcY[,"V2"],#V2 corresponds to period 1, year 2010
#                "Pcy2015"=PcY[,"V3"],#V3 corresponds to period 2, year 2015
#                "PcY.r1"=  ( PcY[,"V3"]/PcY[,1] ),
#                "Pcy2100"=PcY[,"V20"],#V20 corresponds to period 19, year 2100
#                "PcY.r2"=  ( PcY[,"V20"]/PcY[,1] ),
#                "PcY.r1E1.05"=  ( PcY[,"V20"]/PcY[,1] )^(1/5),
#                "PcY.r2E1.90"=  ( PcY[,"V20"]/PcY[,1] )^(1/90))

PcY.r <- cbind(GWP[,1:6],
               "Pcy2010"=PcY[,"V2"],#V2 corresponds to period 1, year 2010
               "Pcy2015"=PcY[,"V3"],#V3 corresponds to period 2, year 2015
               "PcY.r1"=  ( PcY[,"V3"]/PcY[,"V2"] ),
               "Pcy2100"=PcY[,"V20"],#V20 corresponds to period 19, year 2100
               "PcY.r2"=  ( PcY[,"V20"]/PcY[,"V2"] ),
               "APY_2010_2015"=  ( PcY[,"V20"]/PcY[,"V2"] )^(1/5),
               "APY_2010_2100"=  ( PcY[,"V20"]/PcY[,"V2"] )^(1/90))


for(i in 1:5) {
  for(j in 1:5) {
    Subset <- PcY.r[PcY.r$I==i,]
    Subset2 <- Subset[Subset$K==j,]
    #print(Subset2)
    MidVal <- Subset2[Subset2$J==3,"APY_2010_2100"]
    Subset2$Ratio <- Subset2[,"APY_2010_2100"]/MidVal
    Subset2$Rate <- Subset2$Ratio - 1
    if((i*j)==1) Out <- Subset2
    if((i*j)!=1) Out <- rbind(Out,Subset2)
  }
}


#PreOut <- rbind(GWP,Pop,
#      cbind(GWP[,1:6],"V1"="Inc Per Capita",PcY))
#
#write.table(PreOut,file="Output/TFP1.csv",sep=",",row.names=F)
write.table(Out,file="Output/TFP2.csv",sep=",",row.names=F)

#Subset
Both <- rbind(Data,DataA)
SubBoth <- Both[,c(1:8,10,12,14,16,18,20,22,24,26)] #The MUP years
Out3 <- cbind( "Group1"="DICE","Group2"="Yale",SubBoth,"Mode"=rep(c("Base","Ampere"),each=(nrow(SubBoth)/2) ) )
Out3 <- Out3[(Out3$V1 %in% ExtractList),]
write.table(Out3,file="Output/DICE_Both_MUP_format.csv",sep=",",row.names=F)