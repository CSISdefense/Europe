## Make sure you have installed the packages plm, plyr, and reshape
#install.packages("plm") #, repos="http://R-Forge.R-project.org")

CompilePubOpData <- function(filename, lag = 1) {
  ## start by setting up some items for later use.
  ## Namely, loading needed packages and setting a path to my files.
  require(plm)
  require(plyr)
  require(reshape)
  
  ## Set this path to the folder into which your git hub will download data
  #path <- "K:/Development/Europe/" #     path <- "C:/Users/MRiley/My Documents/Europe/"
  path <- "C:/Users/scohen/My Documents/Europe1/"
  
  ## Next I'm going to load all of my data. The data: in order is..
  ## public opinion, governance data from PolityIV, Terrorism data from GTD,
  ## data we compiled on conflicts and a country's membership to the EU,
  ## GDP per capita data (constant 2005 $), GDP data (also Const 2005 $), population data,
  ## data on NATO membership, spending data, and neighbor spending data.
  data.a <- read.csv(paste(path, filename, sep =""), header = TRUE) 
  data.gov <- read.csv(paste(path, "SSI_Govern.csv", sep =""), header = TRUE)
  data.ter <- read.csv(paste(path, "Terrorism Data.csv", sep =""), header = TRUE)
  data.intlcnf <- read.csv(paste(path, "SSI_IntlConfl.csv", sep =""), header = TRUE)
  data.cvlwr <- read.csv(paste(path, "SSI_CivilWar.csv", sep =""), header = TRUE)
  data.gdppc <- read.csv(paste(path, "SSI_GDPperCAP.csv", sep =""), header = TRUE)
  data.gdp <- read.csv(paste(path, "SSI_Const05_GDP.csv", sep =""), header = TRUE)
  data.pop <- read.csv(paste(path, "SSI_Population.csv", sep =""), header = TRUE)
  data.nato <- read.csv(paste(path, "SSI_NATO.csv", sep =""), header = TRUE)
  data.euds <- read.csv(paste(path, "EUDefenseSpending_EUROS.csv", sep =""), header = TRUE)
  data.nghspnd <- read.csv(paste(path, "SSIMilSpendingData.CSV", sep=""), header = TRUE, na.strings = "#VALUE!")
  
  
  #### This next section is where we change the column names of the data sets that don't need
  #### to be reshaped. 
  
  ## Then we change the coloumnames to make them more universal
  colnames(data.gov)[colnames(data.gov)=="country"] <- "Country"
  colnames(data.gov)[colnames(data.gov)=="year"] <- "Year"
  colnames(data.ter)[colnames(data.ter)=="country_txt"] <- "Country"
  colnames(data.ter)[colnames(data.ter)=="iyear"] <- "Year"
  data.euds <- rename(data.euds, c("X2001"="2001", "X2002"="2002", "X2003"="2003", "X2004"="2004", "X2005"="2005", "X2006"="2006", "X2007"="2007", "X2008"="2008", "X2009"="2009", "X2010"="2010", "X2011"="2011", "X2012"="2012", "X2013"="2013"))
  colnames(data.gdppc)[colnames(data.gdppc)=="United.Kingdom"] <- "UK"
  colnames(data.gdppc)[colnames(data.gdppc)=="Slovak.Republic"] <- "Slovakia"
  colnames(data.gdppc)[colnames(data.gdppc)=="Russian.Federation"] <- "Russia"
  colnames(data.pop)[colnames(data.pop)=="United.Kingdom"] <- "UK"
  colnames(data.pop)[colnames(data.pop)=="Slovak.Republic"] <- "Slovakia"
  colnames(data.pop)[colnames(data.pop)=="Russian.Federation"] <- "Russia"   
  colnames(data.euds)[colnames(data.euds)=="United Kingdom"] <- "UK"
  colnames(data.euds)[colnames(data.euds)=="Slovak.Republic"] <- "Slovakia"
  colnames(data.euds)[colnames(data.euds)=="Russian.Federation"] <- "Russia"
  colnames(data.euds)[colnames(data.euds)=="Serbia*"] <- "Serbia"
  
  #### In this next component, we will reshape and fit data so we can synthesize with with
  #### the other data that we have.
  
  ##reshaping EU defense spending data and creating log(GDP)
  data.gdp <- rename(data.gdp, c("X2000"="2000", "X2001"="2001", "X2002"="2002", "X2003"="2003", "X2004"="2004", "X2005"="2005", "X2006"     ="2006", "X2007"="2007", "X2008"="2008", "X2009"="2009", "X2010"="2010", "X2011"="2011", "X2012"="2012", "X2013"="2013"))
  data.gdp <- melt(data.gdp, id="Country")
  data.gdp <- rename(data.gdp, c("variable"="Year", "value"="GDP2005usd"))
  data.gdp <- arrange(data.gdp, Country)
  #data.gdp$logGDP <- log(data.gdp$GDP2005usd)
  
  ##reshaping neighbor spending data 
  data.nghspnd <- rename(data.nghspnd, c("X2000"="2000", "X2001"="2001", "X2002"="2002", "X2003"="2003", "X2004"="2004", "X2005"="2005", "X2006"     ="2006", "X2007"="2007", "X2008"="2008", "X2009"="2009", "X2010"="2010", "X2011"="2011", "X2012"="2012", "X2013"="2013"))
  data.nghspnd <- melt(data.nghspnd, id=c("COUNTRY", "Country.List"))
  data.nghspnd <- rename(data.nghspnd, c("COUNTRY"="Country","variable"="Year", "value"="neighspend"))
  data.nghspnd <- data.nghspnd[,c(1,3,4)]
  data.nghspnd <- arrange(data.nghspnd, Country)
  
  ## Reshaping international conflict data
  data.intlcnf <- melt(data.intlcnf, id = "Year")
  data.intlcnf <- rename(data.intlcnf, c("variable"="Country", "value"="IntlCnf"))
  data.intlcnf$Year <- as.integer(as.character(data.intlcnf$Year))
  data.intlcnf$Country <- as.character(data.intlcnf$Country)
  
  ## Reshaping civil war data
  data.cvlwr <- data.cvlwr[-c(1), ]
  data.cvlwr <- melt(data.cvlwr, id = "Year")
  data.cvlwr <- rename(data.cvlwr, c("variable"="Country", "value"="CivilWar"))
  data.cvlwr$Year <- as.integer(as.character(data.cvlwr$Year))
  data.cvlwr$Country <- as.character(data.cvlwr$Country)
  
  ## Combining Neighbor Spending and GDP data to create a threat ratio variable
  ## The value of this variable is NghSpnd/GDP
  threatvariable <- as.data.frame(NULL)
  c.loop <- unique(data.nghspnd$Country)
  t.loop <- unique(data.nghspnd$Year)
  
  for (i in c.loop) {
    numerator <- data.nghspnd[data.nghspnd$Country == i,]
    denominator <- data.gdp[data.gdp$Country == i,]
    for (t in t.loop){
      numerator.use <- numerator[numerator$Year == t,]
      denominator.use <- denominator[denominator$Year == t,]
      x <- (numerator.use[1,3]/denominator.use[1,3])*1000000
      row <- data.frame(Country = i, Year = t, ThreatRatio = x)
      threatvariable <- rbind(threatvariable, row)
    }
    
  }
  threatvariable$Country <- as.character(threatvariable$Country)
  threatvariable$Year <- as.integer(as.character(threatvariable$Year))
  
  
  ## We need to reshape and rename the EU defense spending data
  data.euds <- rename(data.euds, c("X2001"="2001", "X2002"="2002", "X2003"="2003", "X2004"="2004", "X2005"="2005", "X2006"     ="2006", "X2007"="2007", "X2008"="2008", "X2009"="2009", "X2010"="2010", "X2011"="2011", "X2012"="2012", "X2013"="2013"))
  data.euds <- melt(data.euds, id=c("Country", "Unit.Currency"))
  data.euds <- rename(data.euds, c("variable"="Year", "value"="DefSpnd"))
  data.euds <- data.euds[,c(1,3,4)]
  data.euds[,2] <- as.integer(as.character(data.euds[,2]))
  data.euds$Year <- data.euds$Year-lag
  data.euds[,3] <- data.euds[,3]*1000000
  data.euds$Country <- as.character(data.euds$Country)
  data.euds$Country[data.euds$Country == "United Kingdom"] <- "UK" 
  #data.euds$logeuds <- log(data.euds$DefSpnd)
  
  ## Also need to reshape the GDP per Capita data, and then rename some of the columns
  data.pcap <- melt(data.gdppc, id = "Year")
  colnames(data.pcap)[colnames(data.pcap)=="year"] <- "Year"
  colnames(data.pcap)[colnames(data.pcap)=="variable"] <- "Country"
  colnames(data.pcap)[colnames(data.pcap)=="value"] <- "GDPpCap"
  
  ## Also need to reshape the population data, and then rename some of the columns
  data.population <- melt(data.pop, id = "Year")
  colnames(data.population)[colnames(data.population)=="year"] <- "Year"
  colnames(data.population)[colnames(data.population)=="variable"] <- "Country"
  colnames(data.population)[colnames(data.population)=="value"] <- "Population"
  
  ## Also need to reshape the in NATO/alliance, and then rename some of the columns
  data.ally <- melt(data.nato, id = "Year")
  colnames(data.ally)[colnames(data.ally)=="year"] <- "Year"
  colnames(data.ally)[colnames(data.ally)=="variable"] <- "Country"
  colnames(data.ally)[colnames(data.ally)=="value"] <- "NATOally"
  
  
  ## This next section is to synthesize the terrorism data and boil it down to
  ## the information we actually need for the regression
  data.ter <- data.ter[,2:6]
  data.ter$Country <- as.character(data.ter$Country)
  data.ter$Country[data.ter$Country == "Great Britain"] <- "UK"
  countryloop <- sort(unique(data.ter$Country))
  timeloop <- sort(unique(data.ter$Year), decreasing= FALSE)
  attacks <- as.data.frame(NULL)
  
  
  complete.ter <- data.ter[complete.cases(data.ter),]
  #     ddply(complete.ter,
  #           .(Country,Year),
  #           summarise,
  #           attacks=nrow())
  for (i in countryloop){ 
    use <- complete.ter[complete.ter$Country== i,]
    for (t in timeloop){
      use.a <- use[use$Year == t,]
      row <- data.frame(Country=i, Year=t, Attacks=nrow(use.a), IntAt=sum(use.a[,3]), DomAt=nrow(use.a)-sum(use.a[,3]))
      attacks <- rbind(attacks, row)
      
    }
    
  }
  
  
  ## Now it is time to start combining the data, so we can run the regression
  out1 <- plyr::join(data.a, data.gov, by = c("Country", "Year"))
  out2 <- plyr::join(out1, data.intlcnf, by = c("Country", "Year"))
  out3 <- plyr::join(out2, data.cvlwr, by = c("Country", "Year"))
  out4 <- plyr::join(out3, data.pcap, by = c("Country", "Year"))
  out5 <- plyr::join(out4, data.population, by = c("Country", "Year"))
  out6 <- plyr::join(out5, data.ally, by = c("Country", "Year"))
  out7 <- plyr::join(out6, attacks, by = c("Country", "Year"))
  out8 <- plyr::join(out7, data.euds, by = c("Country", "Year"))
  output <- plyr::join(out8, threatvariable, by = c("Country", "Year"))
  
  View(output)  
  
  output
  
  
} 


########using US LEADER data

#install.packages("Hmisc")

setwd("C:/Users/scohen/My Documents/Europe1/") #Your working directory here!
source("SSIRegression.R")
require("Hmisc")

uslead.1lag <- CompilePubOpData("SSI_US_Leader_Data.csv", lag = 1)

View(use.incdec.1lag)

regdat <- uslead.1lag[34:152,]

regdat$NATOally[is.na(regdat$NATOally)]<-0

Dspend  <- regdat$DefSpnd
ThrtR <- regdat$ThreatRatio
IntAt <- regdat$IntAt
DomAt <- regdat$DomAt
CivWr <- regdat$CivilWar
IntWr <- regdat$IntlCnf
Pop <- regdat$Population
GDPpC <- regdat$GDPpCap
Dem <- regdat$democ
NATO <- regdat$NATOally
PubOp <- regdat$Spread

reg_df<-data.frame(
  Dspend  = regdat$DefSpnd,
  ThrtR = regdat$ThreatRatio,
  IntAt = regdat$IntAt,
  DomAt = regdat$DomAt,
  CivWr = regdat$CivilWar,
  IntWr=  regdat$IntlCnf,
  Pop =  regdat$Population,
  GDPpC = regdat$GDPpCap,
  Dem = regdat$democ,
  NATO = regdat$NATOally,
  PubOp =regdat$Spread
)



rcorr(as.matrix(reg_df))

results <- lm(Dspend ~ ThrtR + IntAt + DomAt +CivWr + IntWr + log(Pop) + log(GDPpC) +Dem +NATO +PubOp)

summary(results)

complete.cases(regdat)
comregdat <- regdat[complete.cases(regdat),]

View(comregdat)



uslead.1lag <- CompilePubOpData("SSI_US_Leader_Data.csv", lag = 1)

########REGRESSIONS
##load texreg
require(texreg)

#regdat <- uslead.1lag[34:152,]
#regdat <- comregdat

Dspend <- regdat$DefSpnd
ThrtR <- regdat$ThreatRatio
IntAt <- regdat$IntAt
DomAt <- regdat$DomAt
CivWr <- regdat$cvlwr
IntWr <- regdat$IntWr
Pop <- regdat$Population
GDPpC <- regdat$GDPpCap
Dem <- regdat$democ
NATO <- regdat$NATOally
PubOp <- regdat$Spread

###### MODELS: US global leadership  
####Linear Model
##adding each variable individually
Cresults1 <- lm(log(Dspend) ~ PubOp, regdat) 
Cresults2 <- lm(log(Dspend) ~ PubOp + ThrtR + IntAt, regdat)
Cresults3 <- lm(log(Dspend) ~ PubOp + ThrtR + IntAt + DomAt, regdat)
Cresults4 <- lm(log(Dspend) ~ PubOp + ThrtR + IntAt + DomAt + CivWr, regdat)
Cresults5 <- lm(log(Dspend) ~ PubOp + ThrtR + IntAt + DomAt + CivWr + IntWr, regdat)
Cresults6 <- lm(log(Dspend) ~ PubOp + ThrtR + IntAt + DomAt + CivWr + IntWr + log(Pop), regdat)
Cresults7 <- lm(log(Dspend) ~ PubOp + ThrtR + IntAt + DomAt + CivWr + IntWr + log(Pop) + log(GDPpC), regdat)
Cresults8 <- lm(log(Dspend) ~ PubOp + ThrtR + IntAt + DomAt + CivWr + IntWr + log(Pop) + log(GDPpC) + Dem, regdat)
Cresults9 <- lm(log(Dspend) ~ PubOp + ThrtR + IntAt + DomAt + CivWr + IntWr + log(Pop) + log(GDPpC) + Dem + NATO, regdat)
screenreg(list(Cresults1, Cresults2, Cresults3, Cresults4, Cresults5, Cresults6, Cresults7, Cresults8, Cresults9))

Aresults1 <- lm(log(Dspend) ~ PubOp + ThrtR + IntAt + DomAt + CivWr + IntWr + log(Pop) + log(GDPpC) + Dem + NATO, regdat)
screenreg(list(Aresults1))

###State Fixed Effects Model

Aresults2 <- plm(log(Dspend) ~ PubOp + ThrtR + IntAt + DomAt + CivWr + IntWr + log(Pop) + log(GDPpC) + Dem + NATO, data=regdat, index=c("Country", "Year"), model="within")
summary(Aresults2)
screenreg(list(Aresults1, Aresults2))

##Time Fixed Effects Model

Aresults3 <- plm(log(Dspend) ~ PubOp + ThrtR + IntAt + DomAt + CivWr + IntWr + log(Pop) + log(GDPpC) + Dem + NATO, data=regdat, index=c("Country", "Year"), effect="time")
summary(Aresults3)  
screenreg(list(Aresults1, Aresults2, Aresults3))

##State fixed and time fixed effects Model
##transforming the data for state AND time fixed effects
regdat2 <- pdata.frame(regdat, index = c("Country", "Year"), drop.index = TRUE, row.names = TRUE)

Aresults4 <- plm(log(Dspend) ~ PubOp +ThrtR + IntAt + DomAt + CivWr + IntWr + log(Pop) + log(GDPpC) + Dem + NATO, data = regdat2, model = "within")
summary(Aresults4)
screenreg(list(Aresults1, Aresults2, Aresults3, Aresults4))


############
##### MODELS: country is spending too much or too little 


DefSpnd_IncDec_Data.1lag <- CompilePubOpData("SSI_US_Leader_Data.csv", lag = 1)

regdat1 <- DefSpnd_IncDec_Data.1lag[34:152,]

complete.cases(regdat1)
comregdat1 <- regdat[complete.cases(regdat1),]

####Linear Model

Bresults1 <- lm(log(Dspend) ~ PubOp + ThrtR + IntAt + DomAt + CivWr + IntWr + log(Pop) + log(GDPpC) + Dem + NATO, regdat1)
screenreg(list(Bresults1))

###State Fixed Effects Model

Bresults2 <- plm(log(Dspend) ~ PubOp + ThrtR + IntAt + DomAt + CivWr + IntWr + log(Pop) + log(GDPpC) + Dem + NATO, data=regdat1, index=c("Country", "Year"), model="within")
summary(Bresults2)
screenreg(list(Bresults1, Bresults2))

##Time Fixed Effects Model

Bresults3 <- plm(log(Dspend) ~ PubOp + ThrtR + IntAt + DomAt + CivWr + IntWr + log(Pop) + log(GDPpC) + Dem + NATO, data=regdat1, index=c("Country", "Year"), effect="time")
summary(Bresults3)  
screenreg(list(Bresults1, Bresults2, Bresults3))

##PROBLEMS fixed and time fixed effects model returns ERROR: "Error in crossprod(t(X), beta) : non-conformable arguments"
##State fixed and time fixed effects Model

regdat3 <- pdata.frame(regdat1, index = c("Country", "Year"), drop.index = TRUE, row.names = TRUE)

Bresults4 <- plm(log(Dspend) ~ PubOp + ThrtR + IntAt + DomAt + CivWr + IntWr + log(Pop) + log(GDPpC) + Dem + NATO, data=regdat3, model="within")
summary(Bresults4)
screenreg(list(Bresults1, Bresults2, Bresults3, Bresults4))
