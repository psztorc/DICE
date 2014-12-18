#Restack big columns into rows
rm(list=ls())

#Parameters
ScalingFile <- c("Output/1_ScalingTable.csv")
InFiles <- c("Output/New2013Base_Loops.csv","Output/New2013Amp_Loops.csv") #,"New2013BaseL3t.csv" c("Output/New2013Seq.csv")


#
try(setwd('C:/Users/ps583/Documents/GitHub/DICE/models/gams'))

BigN <- length(InFiles)


RestackFile <- function(FileName="Output/New2013Base_Loops.csv") { #function of filename
  
  
  In <- read.csv(FileName, header = FALSE, stringsAsFactors=FALSE)
  ### In <- read.csv(InFile1,header = FALSE,stringsAsFactors=FALSE)
  print(paste("Restacking", FileName) )
  
  #Format Data
  n <- nrow(In)
  RunRows <- (1:n)[In[,1]=="New Run"]
  
  Set1 <- In[RunRows,1:10] #the data about a run
  Set2 <- In[-RunRows,]    #the run itself
  
  colnames(Set1) <- c(NA,"I","J","K",NA,NA,NA,Set1[1,5:7])
  Set1 <- Set1[,c(2:4,8:10)]
  
  RunDiff <- median(diff(RunRows)-1) #136 rows per run
  LHS <- Set1[rep(1:nrow(Set1),each=RunDiff),] #Repeat each row the relevant number of times (by repeating the index call)
  
  Full <- cbind(LHS,Set2)
  
  for(i in (1:ncol(Full))[-7]) mode(Full[,i]) <- "numeric"
  
  #Generate New Filename
  OutFileRS <- paste(substr(FileName,1,nchar(FileName)-4),"_Restacked",".csv",sep="")
  
  #Write Full Dataset
  write.table(Full,file=OutFileRS,sep=",",row.names=F)
  
  return(Full)
}






# Execution


print("Restacking Files...")
Data <- RestackFile("Output/New2013Base_Loops.csv")
DataA <- RestackFile("Output/New2013Amp_Loops.csv")
# # DataB <- RestackFile("Output/New2013BaseL3t.csv")
# DataC <- RestackFile("Output/New2013Seq.csv")
print("Done")

