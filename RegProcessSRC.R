## Make sure you have installed the packages plm, plyr, and reshape
#install.packages("plm") #, repos="http://R-Forge.R-project.org")
# 
# CompilePubOpData <- function(filename, lag = 1) {
#   ## start by setting up some items for later use.
#   ## Namely, loading needed packages and setting a path to my files.
#   require(plm)
#   require(plyr)
#   require(reshape)
# 
#   ## Set this path to the folder into which your git hub will download data
#   #path <- "K:/Development/Europe/" #     path <- "C:/Users/MRiley/My Documents/Europe/"
#   path <- "C:/Users/scohen/My Documents/Europe1/"
#   
#   ## Next I'm going to load all of my data. The data: in order is..
#   ## public opinion, governance data from PolityIV, Terrorism data from GTD,
#   ## data we compiled on conflicts and a country's membership to the EU,
#   ## GDP per capita data (constant 2005 $), GDP data (also Const 2005 $), population data,
#   ## data on NATO membership, spending data, and neighbor spending data.
#   data.a <- read.csv(paste(path, filename, sep =""), header = TRUE) 
#   data.gov <- read.csv(paste(path, "SSI_Govern.csv", sep =""), header = TRUE)
#   data.ter <- read.csv(paste(path, "Terrorism Data.csv", sep =""), header = TRUE)
#   data.intlcnf <- read.csv(paste(path, "SSI_IntlConfl.csv", sep =""), header = TRUE)
#   data.cvlwr <- read.csv(paste(path, "SSI_CivilWar.csv", sep =""), header = TRUE)
#   data.gdppc <- read.csv(paste(path, "SSI_GDPperCAP.csv", sep =""), header = TRUE)
#   data.gdp <- read.csv(paste(path, "SSI_Const05_GDP.csv", sep =""), header = TRUE)
#   data.pop <- read.csv(paste(path, "SSI_Population.csv", sep =""), header = TRUE)
#   data.nato <- read.csv(paste(path, "SSI_NATO.csv", sep =""), header = TRUE)
#   data.euds <- read.csv(paste(path, "EUDefenseSpending_EUROS.csv", sep =""), header = TRUE)
#   data.nghspnd <- read.csv(paste(path, "SSIMilSpendingData.CSV", sep=""), header = TRUE, na.strings = "#VALUE!")
#   
#   
#   #### This next section is where we change the column names of the data sets that don't need
#   #### to be reshaped. 
#   
#   ## Then we change the coloumnames to make them more universal
#   colnames(data.gov)[colnames(data.gov)=="country"] <- "Country"
#   colnames(data.gov)[colnames(data.gov)=="year"] <- "Year"
#   colnames(data.ter)[colnames(data.ter)=="country_txt"] <- "Country"
#   colnames(data.ter)[colnames(data.ter)=="iyear"] <- "Year"
#   data.euds <- rename(data.euds, c("X2001"="2001", "X2002"="2002", "X2003"="2003", "X2004"="2004", "X2005"="2005", "X2006"="2006", "X2007"="2007", "X2008"="2008", "X2009"="2009", "X2010"="2010", "X2011"="2011", "X2012"="2012", "X2013"="2013"))
#   colnames(data.gdppc)[colnames(data.gdppc)=="United.Kingdom"] <- "UK"
#   colnames(data.gdppc)[colnames(data.gdppc)=="Slovak.Republic"] <- "Slovakia"
#   colnames(data.gdppc)[colnames(data.gdppc)=="Russian.Federation"] <- "Russia"
#   colnames(data.pop)[colnames(data.pop)=="United.Kingdom"] <- "UK"
#   colnames(data.pop)[colnames(data.pop)=="Slovak.Republic"] <- "Slovakia"
#   colnames(data.pop)[colnames(data.pop)=="Russian.Federation"] <- "Russia"   
#   colnames(data.euds)[colnames(data.euds)=="United Kingdom"] <- "UK"
#   colnames(data.euds)[colnames(data.euds)=="Slovak.Republic"] <- "Slovakia"
#   colnames(data.euds)[colnames(data.euds)=="Russian.Federation"] <- "Russia"
#   colnames(data.euds)[colnames(data.euds)=="Serbia*"] <- "Serbia"
#   
#   #### In this next component, we will reshape and fit data so we can synthesize with with
#   #### the other data that we have.
#   
#   ##reshaping EU defense spending data and creating log(GDP)
#   data.gdp <- rename(data.gdp, c("X2000"="2000", "X2001"="2001", "X2002"="2002", "X2003"="2003", "X2004"="2004", "X2005"="2005", "X2006"     ="2006", "X2007"="2007", "X2008"="2008", "X2009"="2009", "X2010"="2010", "X2011"="2011", "X2012"="2012", "X2013"="2013"))
#   data.gdp <- melt(data.gdp, id="Country")
#   data.gdp <- rename(data.gdp, c("variable"="Year", "value"="GDP2005usd"))
#   data.gdp <- arrange(data.gdp, Country)
#   #data.gdp$logGDP <- log(data.gdp$GDP2005usd)
#   
#   ##reshaping neighbor spending data 
#   data.nghspnd <- rename(data.nghspnd, c("X2000"="2000", "X2001"="2001", "X2002"="2002", "X2003"="2003", "X2004"="2004", "X2005"="2005", "X2006"     ="2006", "X2007"="2007", "X2008"="2008", "X2009"="2009", "X2010"="2010", "X2011"="2011", "X2012"="2012", "X2013"="2013"))
#   data.nghspnd <- melt(data.nghspnd, id=c("COUNTRY", "Country.List"))
#   data.nghspnd <- rename(data.nghspnd, c("COUNTRY"="Country","variable"="Year", "value"="neighspend"))
#   data.nghspnd <- data.nghspnd[,c(1,3,4)]
#   data.nghspnd <- arrange(data.nghspnd, Country)
#   
#   ## Reshaping international conflict data
#   data.intlcnf <- melt(data.intlcnf, id = "Year")
#   data.intlcnf <- rename(data.intlcnf, c("variable"="Country", "value"="IntlCnf"))
#   data.intlcnf$Year <- as.integer(as.character(data.intlcnf$Year))
#   data.intlcnf$Country <- as.character(data.intlcnf$Country)
#   
#   ## Reshaping civil war data
#   data.cvlwr <- data.cvlwr[-c(1), ]
#   data.cvlwr <- melt(data.cvlwr, id = "Year")
#   data.cvlwr <- rename(data.cvlwr, c("variable"="Country", "value"="CivilWar"))
#   data.cvlwr$Year <- as.integer(as.character(data.cvlwr$Year))
#   data.cvlwr$Country <- as.character(data.cvlwr$Country)
#   
#   ## Combining Neighbor Spending and GDP data to create a threat ratio variable
#   ## The value of this variable is NghSpnd/GDP
#   threatvariable <- as.data.frame(NULL)
#   c.loop <- unique(data.nghspnd$Country)
#   t.loop <- unique(data.nghspnd$Year)
#   
#   for (i in c.loop) {
#     numerator <- data.nghspnd[data.nghspnd$Country == i,]
#     denominator <- data.gdp[data.gdp$Country == i,]
#     for (t in t.loop){
#       numerator.use <- numerator[numerator$Year == t,]
#       denominator.use <- denominator[denominator$Year == t,]
#       x <- (numerator.use[1,3]/denominator.use[1,3])*1000000
#       row <- data.frame(Country = i, Year = t, ThreatRatio = x)
#       threatvariable <- rbind(threatvariable, row)
#     }
#     
#   }
#   threatvariable$Country <- as.character(threatvariable$Country)
#   threatvariable$Year <- as.integer(as.character(threatvariable$Year))
#   
#   
#   ## We need to reshape and rename the EU defense spending data
#   data.euds <- rename(data.euds, c("X2001"="2001", "X2002"="2002", "X2003"="2003", "X2004"="2004", "X2005"="2005", "X2006"     ="2006", "X2007"="2007", "X2008"="2008", "X2009"="2009", "X2010"="2010", "X2011"="2011", "X2012"="2012", "X2013"="2013"))
#   data.euds <- melt(data.euds, id=c("Country", "Unit.Currency"))
#   data.euds <- rename(data.euds, c("variable"="Year", "value"="DefSpnd"))
#   data.euds <- data.euds[,c(1,3,4)]
#   data.euds[,2] <- as.integer(as.character(data.euds[,2]))
#   data.euds$Year <- data.euds$Year-lag
#   data.euds[,3] <- data.euds[,3]*1000000
#   data.euds$Country <- as.character(data.euds$Country)
#   data.euds$Country[data.euds$Country == "United Kingdom"] <- "UK" 
#   #data.euds$logeuds <- log(data.euds$DefSpnd)
#   
#   ## Also need to reshape the GDP per Capita data, and then rename some of the columns
#   data.pcap <- melt(data.gdppc, id = "Year")
#   colnames(data.pcap)[colnames(data.pcap)=="year"] <- "Year"
#   colnames(data.pcap)[colnames(data.pcap)=="variable"] <- "Country"
#   colnames(data.pcap)[colnames(data.pcap)=="value"] <- "GDPpCap"
#   
#   ## Also need to reshape the population data, and then rename some of the columns
#   data.population <- melt(data.pop, id = "Year")
#   colnames(data.population)[colnames(data.population)=="year"] <- "Year"
#   colnames(data.population)[colnames(data.population)=="variable"] <- "Country"
#   colnames(data.population)[colnames(data.population)=="value"] <- "Population"
#   
#   ## Also need to reshape the in NATO/alliance, and then rename some of the columns
#   data.ally <- melt(data.nato, id = "Year")
#   colnames(data.ally)[colnames(data.ally)=="year"] <- "Year"
#   colnames(data.ally)[colnames(data.ally)=="variable"] <- "Country"
#   colnames(data.ally)[colnames(data.ally)=="value"] <- "NATOally"
#   
#   
#   ## This next section is to synthesize the terrorism data and boil it down to
#   ## the information we actually need for the regression
#   data.ter <- data.ter[,2:6]
#   data.ter$Country <- as.character(data.ter$Country)
#   data.ter$Country[data.ter$Country == "Great Britain"] <- "UK"
#   countryloop <- sort(unique(data.ter$Country))
#   timeloop <- sort(unique(data.ter$Year), decreasing= FALSE)
#   attacks <- as.data.frame(NULL)
#   
#   
#   complete.ter <- data.ter[complete.cases(data.ter),]
#   #     ddply(complete.ter,
#   #           .(Country,Year),
#   #           summarise,
#   #           attacks=nrow())
#   for (i in countryloop){ 
#     use <- complete.ter[complete.ter$Country== i,]
#     for (t in timeloop){
#       use.a <- use[use$Year == t,]
#       row <- data.frame(Country=i, Year=t, Attacks=nrow(use.a), IntAt=sum(use.a[,3]), DomAt=nrow(use.a)-sum(use.a[,3]))
#       attacks <- rbind(attacks, row)
#       
#     }
#     
#   }
  
  
  ## Now it is time to start combining the data, so we can run the regression
#   out1 <- plyr::join(data.a, data.gov, by = c("Country", "Year"))
#   out2 <- plyr::join(out1, data.intlcnf, by = c("Country", "Year"))
#   out3 <- plyr::join(out2, data.cvlwr, by = c("Country", "Year"))
#   out4 <- plyr::join(out3, data.pcap, by = c("Country", "Year"))
#   out5 <- plyr::join(out4, data.population, by = c("Country", "Year"))
#   out6 <- plyr::join(out5, data.ally, by = c("Country", "Year"))
#   out7 <- plyr::join(out6, attacks, by = c("Country", "Year"))
#   out8 <- plyr::join(out7, data.euds, by = c("Country", "Year"))
#   output <- plyr::join(out8, threatvariable, by = c("Country", "Year"))
#   
#   View(output)  
#   
#   output
#   
#   
<<<<<<< HEAD
=======
# } 

>>>>>>> 6b369eef5855697e09f5598e18be55c8cb15c9d5


<<<<<<< HEAD

########using US LEADER data
=======
setwd("C:/Users/scohen/My Documents/Europe/Europe/") #Your working directory here!
source("SSIRegression.R")
require("Hmisc")

##Set working directory:
setwd("C:/Users/scohen/My Documents/Europe/Europe/") #Your working directory here!
#setwd("C:/Users/MRiley/My Documents/Europe/") #Your working directory here!
>>>>>>> 6b369eef5855697e09f5598e18be55c8cb15c9d5

##load necessary packages 
source("SSIRegression.R")
require(Hmisc)
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
=======
Aresults1 <- lm(log(Dspend) ~ PubOp, regdat) 
Aresults2 <- lm(log(Dspend) ~ PubOp + ThrtR, regdat)
Aresults3 <- lm(log(Dspend) ~ PubOp + ThrtR + IntAt, regdat)
Aresults4 <- lm(log(Dspend) ~ PubOp + ThrtR + IntAt + DomAt, regdat)
Aresults5 <- lm(log(Dspend) ~ PubOp + ThrtR + IntAt + DomAt + CivWr, regdat)
Aresults6 <- lm(log(Dspend) ~ PubOp + ThrtR + IntAt + DomAt + CivWr + IntWr, regdat)
Aresults7 <- lm(log(Dspend) ~ PubOp + ThrtR + IntAt + DomAt + CivWr + IntWr + log(Pop), regdat)
Aresults8 <- lm(log(Dspend) ~ PubOp + ThrtR + IntAt + DomAt + CivWr + IntWr + log(Pop) + log(GDPpC), regdat)
Aresults9 <- lm(log(Dspend) ~ PubOp + ThrtR + IntAt + DomAt + CivWr + IntWr + log(Pop) + log(GDPpC) + Dem, regdat)
Aresults10 <- lm(log(Dspend) ~ PubOp + ThrtR + IntAt + DomAt + CivWr + IntWr + log(Pop) + log(GDPpC) + Dem + NATO, regdat)
screenreg(list(Aresults1, Aresults2, Aresults3, Aresults4, Aresults5, Aresults6, Aresults7, Aresults8, Aresults9, Aresults10))

>>>>>>> 6b369eef5855697e09f5598e18be55c8cb15c9d5
##Fixed effects model
USleadFixedResults1 <- plm(log(Dspend) ~ PubOp + ThrtR + IntAt + DomAt + CivWr + IntWr + log(Pop) + log(GDPpC) + Dem + NATO, data=USleadDat, index=c("Country", "Year"), model="within")
summary(USleadFixedResults1)
# plot(USleadFixedResults1)

##Comparing OLS results to Fixed effects model results
<<<<<<< HEAD
screenreg(list(USleadResults9, USleadFixedResults1))

##Testing to see if Uit is capturing characteristics that are individually specific
#and don't change over time (Mit) using Ftest
pFtest(USleadFixedResults1, USleadResults9)
=======
screenreg(list(Aresults10, Bresults1))

##Testing to see if Uit is capturing characteristics that are individually specific
#and don't change over time (Mit) using Ftest
pFtest(Bresults1, Aresults10)
>>>>>>> 6b369eef5855697e09f5598e18be55c8cb15c9d5

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
  
##Comparing OLS to Fixed effect model
screenreg(list(DefInc1Results9, DefIncFixedResults1))

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
=======
Cresults1 <- lm(log(Dspend) ~ PubOp, regdat1) 
Cresults2 <- lm(log(Dspend) ~ PubOp + ThrtR, regdat1)
Cresults3 <- lm(log(Dspend) ~ PubOp + ThrtR + IntAt, regdat1)
Cresults4 <- lm(log(Dspend) ~ PubOp + ThrtR + IntAt + DomAt, regdat)
Cresults5 <- lm(log(Dspend) ~ PubOp + ThrtR + IntAt + DomAt + CivWr, regdat1)
Cresults6 <- lm(log(Dspend) ~ PubOp + ThrtR + IntAt + DomAt + CivWr + IntWr, regdat1)
Cresults7 <- lm(log(Dspend) ~ PubOp + ThrtR + IntAt + DomAt + CivWr + IntWr + log(Pop), regdat1)
Cresults8 <- lm(log(Dspend) ~ PubOp + ThrtR + IntAt + DomAt + CivWr + IntWr + log(Pop) + log(GDPpC), regdat1)
Cresults9 <- lm(log(Dspend) ~ PubOp + ThrtR + IntAt + DomAt + CivWr + IntWr + log(Pop) + log(GDPpC) + Dem, regdat1)
Cresults10 <- lm(log(Dspend) ~ PubOp + ThrtR + IntAt + DomAt + CivWr + IntWr + log(Pop) + log(GDPpC) + Dem + NATO, regdat1)
screenreg(list(Cresults1, Cresults2, Cresults3, Cresults4, Cresults5, Cresults6, Cresults7, Cresults8, Cresults9, Cresults10))
>>>>>>> 6b369eef5855697e09f5598e18be55c8cb15c9d5

##Fixed Effect model
DefIncFixedResults1 <- plm(log(Dspend) ~ PubOp + ThrtR + IntAt + DomAt + CivWr + IntWr + log(Pop) + log(GDPpC) + Dem + NATO, data=IncDec2Dat, index=c("Country", "Year"), model="within")
summary(DefIncFixedResults1)

##Comparing OLS to Fixed effect model
screenreg(list(DefInc2Results9, DefIncFixedResults1))

##Testing to see if Uit is capturing characteristics that are individually specific
#and don't change over time (Mit) using Ftest
pFtest(DefIncFixedResults1, DefInc2Results9)
