

DF <- data.frame( 
  TFP.Factor=c( .99, .995, 1.0, 1.005, 1.010 ) ,
  TFP.Factor.GAMS=c( 0.992324056, 0.996162028, 1.0000000, 1.003837972, 1.007675944 )
)


plot(TFP.Factor.GAMS~TFP.Factor, data=DF)

m1 <- lm(TFP.Factor.GAMS~TFP.Factor,data=DF)
m2 <- lm(TFP.Factor.GAMS~TFP.Factor+ I(TFP.Factor^2),data=DF)
summary(m1)
summary(m2)


NewData <- data.frame(
  "TmpCoef.Value"=runif(Nsample, 1.5,5.5), 
  "TFP.Factor"=runif(Nsample,min=.99,max=1.01),
  "Pop.Factor"=runif(Nsample,min=.99,max=1.01)) 

NewData$TFP.LA <- predict(m2,newdata = NewData)

GAMS_Inputs <- NewData

#recenter
NewData$TmpCoef.Value <- NewData$TmpCoef.Value - 2.9
NewData$Pop.Factor <- NewData$Pop.Factor - 1
NewData$TFP.Factor <- NewData$TFP.Factor - 1 
NewData$TFP.Factor.LA <- NewData$TFP.Factor - predict(m2,newdata = data.frame(TFP.Factor = 1))

NewData

NewData$Output <- predict(object=AllSurfaces$Base$LQI$DICE$A1.Output,newdata=NewData) + 491.227569400
NewData$Temperature <- predict(object=AllSurfaces$Base$LQI$DICE$F2.Temperature,newdata=NewData) + 3.854605214

# Gams results:
1150.631
3.581

# ??