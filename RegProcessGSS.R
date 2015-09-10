## Make sure you have installed the packages plm, plyr, and reshape
#install.packages("plm") #, repos="http://R-Forge.R-project.org")
# 



########using US LEADER data

##load necessary packages 
source("SSIRegression.R")
require("Hmisc")
require(texreg)
require(plm)


#-----------------US LEADERSHIP DATA-----------------------------------------------

##load data using function
uslead.1lag <- CompilePubOpData("SSI_US_Leader_Data.csv", lag = 1)

USleadDat <- subset(uslead.1lag,!Country %in% c("EU 10","EU 7","USA","EU 11","EU 9","EU 12","EU 8"))
  
##Update NATO data
USleadDat$NATOally[is.na(USleadDat$NATOally)]<-0


##create data frame to test for correlation between variables
USleadDat<-data.frame(
  Dspend  = USleadDat$DefSpnd,
  ThrtR = USleadDat$ThreatRatio,
  IntAt = USleadDat$IntAt,
  DomAt = USleadDat$DomAt,
  CivWr = USleadDat$CivilWar,
  IntWr=  USleadDat$IntlCnf,
  Pop =  USleadDat$Population,
  GDPpC = USleadDat$GDPpCap,
  Dem = USleadDat$democ,
  NATO = USleadDat$NATOally,
  PubOp =USleadDat$Spread,
  
  Country = USleadDat$Country,
  Year = USleadDat$Year
  
)

##Test correlation between variables 
rcorr(as.matrix(subset(USleadDat,select=-c(Country,Year))))

##Summary statistics of data
summary(USleadDat)

##OLS models
##Adding each variable individually 
USleadResults1 <- lm(log(Dspend) ~ PubOp, USleadDat) 
USleadResults2 <- lm(log(Dspend) ~ PubOp + ThrtR + IntAt, USleadDat)
USleadResults3 <- lm(log(Dspend) ~ PubOp + ThrtR + IntAt + DomAt, USleadDat)
USleadResults4 <- lm(log(Dspend) ~ PubOp + ThrtR + IntAt + DomAt + CivWr, USleadDat)
USleadResults5 <- lm(log(Dspend) ~ PubOp + ThrtR + IntAt + DomAt + CivWr + IntWr, USleadDat)
USleadResults6 <- lm(log(Dspend) ~ PubOp + ThrtR + IntAt + DomAt + CivWr + IntWr + log(Pop), USleadDat)
USleadResults7 <- lm(log(Dspend) ~ PubOp + ThrtR + IntAt + DomAt + CivWr + IntWr + log(Pop) + log(GDPpC), USleadDat)
USleadResults8 <- lm(log(Dspend) ~ PubOp + ThrtR + IntAt + DomAt + CivWr + IntWr + log(Pop) + log(GDPpC) + Dem, USleadDat)
USleadResults9 <- lm(log(Dspend) ~ PubOp + ThrtR + IntAt + DomAt + CivWr + IntWr + log(Pop) + log(GDPpC) + Dem + NATO, USleadDat)
screenreg(list(USleadResults1, USleadResults2, USleadResults3, USleadResults4, USleadResults5, USleadResults6, USleadResults7, USleadResults8, USleadResults9))
plot(USleadResults9)
##Fixed effects model
USleadFixedResults1 <- plm(log(Dspend) ~ PubOp + ThrtR + IntAt + DomAt + CivWr + IntWr + log(Pop) + log(GDPpC) + Dem + NATO, data=USleadDat, index=c("Country", "Year"), model="within")
summary(USleadFixedResults1)
# plot(USleadFixedResults1)

##Comparing OLS results to Fixed effects model results
screenreg(list(USleadResults9, USleadFixedResults1),
          custom.model.names=c("USlead OLS","USlead Fixed Effects"))

##Testing to see if Uit is capturing characteristics that are individually specific
#and don't change over time (Mit) using Ftest
pFtest(USleadFixedResults1, USleadResults9)

#--------------------COUNTRY SPENDING TOO MUCH/TOO LITTLE DATA-------------------------

##load data using function
DefSpnd_IncDec1_Data.1lag <- CompilePubOpData("SSI_DefSpnd_IncDec.csv", lag = 1)

  ##subest data we want
  
      
  IncDec1Dat <- subset(DefSpnd_IncDec_Data.1lag,!Country %in% c("EU 10","EU 7","USA","EU 11","EU 9","EU 12","EU 8"))
  
#   IncDec1Dat <- DefSpnd_IncDec1_Data.1lag[34:152,]
  IncDec1Dat$NATOally[is.na(IncDec1Dat$NATOally)]<-0
  
  IncDec1Dat<-data.frame(
      Dspend  = IncDec1Dat$DefSpnd,
      ThrtR = IncDec1Dat$ThreatRatio,
      IntAt = IncDec1Dat$IntAt,
      DomAt = IncDec1Dat$DomAt,
      CivWr = IncDec1Dat$CivilWar,
      IntWr=  IncDec1Dat$IntlCnf,
      Pop =  IncDec1Dat$Population,
      GDPpC = IncDec1Dat$GDPpCap,
      Dem = IncDec1Dat$democ,
      NATO = IncDec1Dat$NATOally,
      PubOp =IncDec1Dat$Spread,
      
      Country = IncDec1Dat$Country,
      Year = IncDec1Dat$Year
  )
  
  
##summary statistics
summary(IncDec1Dat)

###Linear Model adding each variable individually 
DefInc1Results1 <- lm(log(Dspend) ~ PubOp, IncDec1Dat) 
DefInc1Results2 <- lm(log(Dspend) ~ PubOp + ThrtR + IntAt, IncDec1Dat)
DefInc1Results3 <- lm(log(Dspend) ~ PubOp + ThrtR + IntAt + DomAt, IncDec1Dat)
DefInc1Results4 <- lm(log(Dspend) ~ PubOp + ThrtR + IntAt + DomAt + CivWr, IncDec1Dat)
DefInc1Results5 <- lm(log(Dspend) ~ PubOp + ThrtR + IntAt + DomAt + CivWr + IntWr, IncDec1Dat)
DefInc1Results6 <- lm(log(Dspend) ~ PubOp + ThrtR + IntAt + DomAt + CivWr + IntWr + log(Pop), IncDec1Dat)
DefInc1Results7 <- lm(log(Dspend) ~ PubOp + ThrtR + IntAt + DomAt + CivWr + IntWr + log(Pop) + log(GDPpC), IncDec1Dat)
DefInc1Results8 <- lm(log(Dspend) ~ PubOp + ThrtR + IntAt + DomAt + CivWr + IntWr + log(Pop) + log(GDPpC) + Dem, IncDec1Dat)
DefInc1Results9 <- lm(log(Dspend) ~ PubOp + ThrtR + IntAt + DomAt + CivWr + IntWr + log(Pop) + log(GDPpC) + Dem + NATO, IncDec1Dat)
screenreg(list(DefInc1Results1, DefInc1Results2, DefInc1Results3, DefInc1Results4, DefInc1Results5, DefInc1Results6, DefInc1Results7, DefInc1Results8, DefInc1Results9))

plot(DefInc1Results9)

##Fixed Effect model
DefIncFixedResults1 <- plm(log(Dspend) ~ PubOp + ThrtR + IntAt + DomAt + CivWr + IntWr + log(Pop) + log(GDPpC) + Dem + NATO, data=IncDec1Dat, index=c("Country", "Year"), model="within")
summary(DefIncFixedResults1)

DefIncFixedResults1a <- plm(log(Dspend) ~ PubOp + ThrtR + IntAt + DomAt + CivWr + IntWr + log(Pop) + log(GDPpC) + Dem + NATO + log(Pop):log(GDPpC), data=IncDec1Dat, index=c("Country", "Year"), model="within")
summary(DefIncFixedResults1a)

##Comparing OLS to Fixed effect model
screenreg(list(DefInc1Results9, DefIncFixedResults1),
          custom.model.names=c("Inc-Dec OLS","Inc-Dec Fixed Effects"))

##Testing to see if Uit is capturing characteristics that are individually specific
#and don't change over time (Mit) using Ftest
pFtest(DefIncFixedResults1, DefInc1Results9)







#Lag 2
DefSpnd_IncDec_Data.2lag <- CompilePubOpData("SSI_DefSpnd_IncDec.csv", lag = 2)

##subest data we want


IncDec2Dat <- subset(DefSpnd_IncDec_Data.2lag,!Country %in% c("EU 10","EU 7","USA","EU 11","EU 9","EU 12","EU 8"))

#   IncDec2Dat <- DefSpnd_IncDec2_Data.1lag[34:152,]
IncDec2Dat$NATOally[is.na(IncDec2Dat$NATOally)]<-0

IncDec2Dat<-data.frame(
    Dspend  = IncDec2Dat$DefSpnd,
    ThrtR = IncDec2Dat$ThreatRatio,
    IntAt = IncDec2Dat$IntAt,
    DomAt = IncDec2Dat$DomAt,
    CivWr = IncDec2Dat$CivilWar,
    IntWr=  IncDec2Dat$IntlCnf,
    Pop =  IncDec2Dat$Population,
    GDPpC = IncDec2Dat$GDPpCap,
    Dem = IncDec2Dat$democ,
    NATO = IncDec2Dat$NATOally,
    PubOp =IncDec2Dat$Spread,
    
    Country = IncDec2Dat$Country,
    Year = IncDec2Dat$Year
)


##summary statistics
summary(IncDec2Dat)

###Linear Model adding each variable individually 
DefInc2Results1 <- lm(log(Dspend) ~ PubOp, IncDec2Dat) 
DefInc2Results2 <- lm(log(Dspend) ~ PubOp + ThrtR + IntAt, IncDec2Dat)
DefInc2Results3 <- lm(log(Dspend) ~ PubOp + ThrtR + IntAt + DomAt, IncDec2Dat)
DefInc2Results4 <- lm(log(Dspend) ~ PubOp + ThrtR + IntAt + DomAt + CivWr, IncDec2Dat)
DefInc2Results5 <- lm(log(Dspend) ~ PubOp + ThrtR + IntAt + DomAt + CivWr + IntWr, IncDec2Dat)
DefInc2Results6 <- lm(log(Dspend) ~ PubOp + ThrtR + IntAt + DomAt + CivWr + IntWr + log(Pop), IncDec2Dat)
DefInc2Results7 <- lm(log(Dspend) ~ PubOp + ThrtR + IntAt + DomAt + CivWr + IntWr + log(Pop) + log(GDPpC), IncDec2Dat)
DefInc2Results8 <- lm(log(Dspend) ~ PubOp + ThrtR + IntAt + DomAt + CivWr + IntWr + log(Pop) + log(GDPpC) + Dem, IncDec2Dat)
DefInc2Results9 <- lm(log(Dspend) ~ PubOp + ThrtR + IntAt + DomAt + CivWr + IntWr + log(Pop) + log(GDPpC) + Dem + NATO, IncDec2Dat)
screenreg(list(DefInc2Results1, DefInc2Results2, DefInc2Results3, DefInc2Results4, DefInc2Results5, DefInc2Results6, DefInc2Results7, DefInc2Results8, DefInc2Results9))

plot(DefInc2Results9)

##Fixed Effect model
DefIncFixedResults2 <- plm(log(Dspend) ~ PubOp + ThrtR + IntAt + DomAt + CivWr + IntWr + log(Pop) + log(GDPpC) + Dem + NATO, data=IncDec2Dat, index=c("Country", "Year"), model="within")
summary(DefIncFixedResults2)

##Comparing OLS to Fixed effect model
screenreg(list(DefInc2Results9, DefIncFixedResults2))

DefIncFixedResults3 <- plm(log(Dspend) ~ PubOp + IntAt + DomAt + CivWr + IntWr + log(GDPpC) + Dem + NATO, data=IncDec2Dat, index=c("Country", "Year"), model="within")
summary(DefIncFixedResults2)
screenreg(list(DefInc2Results9, DefIncFixedResults2,DefIncFixedResults3))



##Testing to see if Uit is capturing characteristics that are individually specific
#and don't change over time (Mit) using Ftest
pFtest(DefIncFixedResults1, DefInc2Results9)
