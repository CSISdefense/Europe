## Make sure you have installed the packages plm, plyr, and reshape

CompilePubOpDataOmnibus <- function(path="Data\\") {
    ## start by setting up some items for later use.
    ## Namely, loading needed packages and setting a path to my files.
    require(plm)
    require(plyr)
    require(reshape2)
    require(stringr)
    
    ## Don't do this in the source file, do it in the file that calls this.
    ## Set this path to the folder into which your git hub will download data

    
    ## Next I'm going to load all of my data. The data: in order is..
    ## public opinion, governance data from PolityIV, Terrorism data from GTD,
    ## data we compiled on conflicts and a country's membership to the EU,
    ## GDP per capita data (constant 2005 $), GDP data (also Const 2005 $), population data,
    ## data on NATO membership, spending data, and neighbor spending data.

    data.IncDec <- read.csv(paste(path, "SSI_DefSpnd_IncDec.csv", sep =""), header = TRUE) 
    data.USldr <- read.csv(paste(path, "TAT_US_leadership_subtotal.csv", sep =""), header = TRUE) 
    data.EUldr <- read.csv(paste(path, "TAT_EU_leadership_subtotal.csv", sep =""), header = TRUE) 
    data.EUldr.detail <- read.csv(paste(path, "TAT_EU_leadership_detail.csv", sep =""), header = TRUE) 
    data.EUfvr <- read.csv(paste(path, "TAT_EU_favorable_subtotal.csv", sep =""), header = TRUE) 
    data.NATOess <- read.csv(paste(path, "TAT_NATO_essential.csv", sep =""), header = TRUE) 
    data.NATO.EU <- read.csv(paste(path, "TAT_NATO_EU_Closer.csv", sep =""), header = TRUE) 
    data.cabinet <- read.csv(paste(path, "view_cabinet.csv", sep =""), header = TRUE) 
    lookup.parties <- read.csv(paste(path, "2014_CHES_dataset_means.csv", sep =""), header = TRUE) 
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
    
# browser()
colnames(data.IncDec)[colnames(data.IncDec)=="Increase"] <- "DefIncrease"
colnames(data.IncDec)[colnames(data.IncDec)=="Decrease"] <- "DefDecrease"
colnames(data.IncDec)[colnames(data.IncDec)=="Same"] <- "DefSame"
colnames(data.IncDec)[colnames(data.IncDec)=="IDK"] <- "DefIDK"
colnames(data.IncDec)[colnames(data.IncDec)=="Spread"] <- "DefSpread"
colnames(data.USldr)[colnames(data.USldr)=="Increase"] <- "USldrIncrease"
colnames(data.USldr)[colnames(data.USldr)=="Decrease"] <- "USldrDecrease"
colnames(data.USldr)[colnames(data.USldr)=="Same"] <- "USldrSame"
colnames(data.USldr)[colnames(data.USldr)=="IDK"] <- "USldrIDK"
colnames(data.USldr)[colnames(data.USldr)=="Spread"] <- "USldrSpread"

    ## Then we change the coloumnames to make them more universal
    colnames(data.gov)[colnames(data.gov)=="country"] <- "Country"
    colnames(data.gov)[colnames(data.gov)=="year"] <- "Year"
    colnames(data.ter)[colnames(data.ter)=="country_txt"] <- "Country"
    colnames(data.ter)[colnames(data.ter)=="iyear"] <- "Year"
    data.euds <- rename(data.euds, c("X2001"="2001", 
                                     "X2002"="2002",
                                     "X2003"="2003", 
                                     "X2004"="2004",
                                     "X2005"="2005",
                                     "X2006"="2006", 
                                     "X2007"="2007", 
                                     "X2008"="2008", 
                                     "X2009"="2009", 
                                     "X2010"="2010", 
                                     "X2011"="2011", 
                                     "X2012"="2012", 
                                     "X2013"="2013")
                        )
    colnames(data.gdppc)[colnames(data.gdppc)=="United.Kingdom"] <- "UK"
    colnames(data.gdppc)[colnames(data.gdppc)=="Slovak.Republic"] <- "Slovakia"
colnames(data.ter)[colnames(data.ter)=="Slovak.Republic"] <- "Slovakia"
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
    
  ##reshaping EU defense spending data 
    data.gdp <- rename(data.gdp, c("X2000"="2000", 
                                   "X2001"="2001", 
                                   "X2002"="2002", 
                                   "X2003"="2003", 
                                   "X2004"="2004", 
                                   "X2005"="2005", 
                                   "X2006"="2006", 
                                   "X2007"="2007", 
                                   "X2008"="2008", 
                                   "X2009"="2009", 
                                   "X2010"="2010", 
                                   "X2011"="2011", 
                                   "X2012"="2012", 
                                   "X2013"="2013"))
    data.gdp <- melt(data.gdp, id="Country", variable.name="Year",value.name="GDP2005usd")
    data.gdp <- arrange(data.gdp, Country)
  
    ##reshaping neighbor spending data
    data.nghspnd <- rename(data.nghspnd, c("X2000"="2000", 
                                           "X2001"="2001",
                                           "X2002"="2002",
                                           "X2003"="2003",
                                           "X2004"="2004",
                                           "X2005"="2005", 
                                           "X2006"="2006",
                                           "X2007"="2007",
                                           "X2008"="2008",
                                           "X2009"="2009", 
                                           "X2010"="2010", 
                                           "X2011"="2011", 
                                           "X2012"="2012", 
                                           "X2013"="2013"))
    data.nghspnd <- melt(data.nghspnd, id=c("COUNTRY", "Country.List"), variable.name="Year",value.name="neighspend")
    data.nghspnd <- rename(data.nghspnd, c("COUNTRY"="Country"))
    data.nghspnd <- data.nghspnd[,c(1,3,4)]
    data.nghspnd <- arrange(data.nghspnd, Country)

    ## Reshaping international conflict data
    data.intlcnf <- melt(data.intlcnf, id = "Year", variable.name="Country",value.name="IntlCnf")
    data.intlcnf$Year <- as.integer(as.character(data.intlcnf$Year))
    data.intlcnf$Country <- as.character(data.intlcnf$Country)

    ## Reshaping civil war data
    data.cvlwr <- melt(data.cvlwr, id = "Year", variable.name="Country",value.name="CivilWar")
    data.cvlwr$Year <- as.integer(as.character(data.cvlwr$Year))
    data.cvlwr$Country <- as.character(data.cvlwr$Country)


## Reshaping EU leadership Data subtotal
data.EUldr <- melt(data.EUldr, id = c("EU_leadership","Year"),variable.name="Country")
data.EUldr<-dcast(data.EUldr, Country + Year ~ EU_leadership, value.var="value")
data.EUldr$Year <- as.integer(as.character(data.EUldr$Year))
data.EUldr$Country <- as.character(data.EUldr$Country)
data.EUldr$EUldrSpread<-data.EUldr[,"ST Desirable"]-data.EUldr[,"ST Undesirable"]

## Reshaping EU leadership detail (used to fill in for missing years of subtotal)
data.EUldr.detail <- melt(data.EUldr.detail, id = c("EU_leadership","Year"),variable.name="Country")
data.EUldr.detail<-dcast(data.EUldr.detail, Country + Year ~ EU_leadership, value.var="value")
data.EUldr.detail$Year <- as.integer(as.character(data.EUldr.detail$Year))
data.EUldr.detail$Country <- as.character(data.EUldr.detail$Country)
data.EUldr.detail$EUldrSpreadDetail<-data.EUldr.detail[,"Somewhat desirable"]+data.EUldr.detail[,"Very desirable"]-
    data.EUldr.detail[,"Somewhat undesirable"]-data.EUldr.detail[,"Very undesirable"]

data.EUldr.detail<-subset(data.EUldr.detail,select=c(Country,Year,EUldrSpreadDetail))
data.EUldr <- plyr::join(data.EUldr, data.EUldr.detail, by = c("Country", "Year"),type="full")
data.EUldr$EUldrSpread[is.na(data.EUldr$EUldrSpread)]<-data.EUldr$EUldrSpreadDetail[is.na(data.EUldr$EUldrSpread)]
data.EUldr<-subset(data.EUldr,select=c(Country,Year,EUldrSpread))

## Reshaping EU favorability polling question
data.EUfvr <- melt(data.EUfvr, id = c("EU_favorable","Year"),variable.name="Country")
data.EUfvr <- dcast(data.EUfvr, Country + Year ~ EU_favorable, value.var="value")
data.EUfvr$Year <- as.integer(as.character(data.EUfvr$Year))
data.EUfvr$Country <- as.character(data.EUfvr$Country)
data.EUfvr$EUfvrSpread<-data.EUfvr[,"ST Favorable"]-data.EUfvr[,"ST Unfavorable"]
data.EUfvr<-subset(data.EUfvr,select=c(Country,Year,EUfvrSpread))

## Reshaping Nato Essential polling question
data.NATOess <- melt(data.NATOess, id = c("NATO_essential","Year"),variable.name="Country")
data.NATOess<-dcast(data.NATOess, Country + Year ~ NATO_essential, value.var="value")
data.NATOess$Year <- as.integer(as.character(data.NATOess$Year))
data.NATOess$Country <- as.character(data.NATOess$Country)
data.NATOess$NATOessSpread<-data.NATOess[,"Still essential"]-data.NATOess[,"No longer essential"]
data.NATOess<-subset(data.NATOess,select=c(Country,Year,NATOessSpread))

## Reshaping Nato-EU closeness polling question
data.NATO.EU <- melt(data.NATO.EU, id = c("NATO_EU_Closer","Year"),variable.name="Country")
data.NATO.EU<-dcast(data.NATO.EU, Country + Year ~ NATO_EU_Closer, value.var="value")
data.NATO.EU$Year <- as.integer(as.character(data.NATO.EU$Year))
data.NATO.EU$Country <- as.character(data.NATO.EU$Country)
data.NATO.EU$NATO.EUspread<-data.NATO.EU[,"Become closer"]-data.NATO.EU[,"Take a more independent approach"]
data.NATO.EU<-subset(data.NATO.EU,select=c(Country,Year,NATO.EUspread))

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
    data.euds <- melt(data.euds, id=c("Country", "Unit.Currency"), variable.name="Year",value.name="DefSpnd")
#     data.euds <- rename(data.euds, c("variable"="Year", "value"="DefSpnd"))
    data.euds$DefSpnd <- as.numeric(gsub(",","",str_trim(as.character(data.euds$DefSpnd))))
    data.euds$Year <- as.integer(as.character(data.euds$Year))
    data.euds$DefSpnd <- data.euds$DefSpnd*1000000
    data.euds$Country <- as.character(data.euds$Country)
    data.euds$Country[data.euds$Country == "United Kingdom"] <- "UK" 

    data.euds_lead<-data.euds
    data.euds_lead$Year<-data.euds_lead$Year-1
colnames(data.euds)[colnames(data.euds)=="DefSpnd"] <- "DefSpnd_lead"

  
    ## Also need to reshape the GDP per Capita data, and then rename some of the columns
    data.pcap <- melt(data.gdppc, id = "Year", variable.name="Country",value.name="GDPpCap")
    colnames(data.pcap)[colnames(data.pcap)=="year"] <- "Year"
#     colnames(data.pcap)[colnames(data.pcap)=="variable"] <- "Country"
#     colnames(data.pcap)[colnames(data.pcap)=="value"] <- "GDPpCap"
#   
    ## Also need to reshape the population data, and then rename some of the columns
    data.population <- melt(data.pop, id = "Year", variable.name="Country",value.name="Population")
    colnames(data.population)[colnames(data.population)=="year"] <- "Year"
#     colnames(data.population)[colnames(data.population)=="variable"] <- "Country"
#     colnames(data.population)[colnames(data.population)=="value"] <- "Population"
  
    ## Also need to reshape the in NATO/alliance, and then rename some of the columns
    data.ally <- melt(data.nato, id = "Year", variable.name="Country",value.name="NATOally")
    colnames(data.ally)[colnames(data.ally)=="year"] <- "Year"
#     colnames(data.ally)[colnames(data.ally)=="variable"] <- "Country"
#     colnames(data.ally)[colnames(data.ally)=="value"] <- "NATOally"
#     data.ally$NATOally[is.na(data.ally$NATOally)]<-0
    
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

output <- plyr::join(data.USldr, data.gov, by = c("Country", "Year"),type="full")
output <- plyr::join(output, data.IncDec, by = c("Country", "Year"),type="full")
output <- plyr::join(output, data.EUldr, by = c("Country", "Year"),type="full")
output <- plyr::join(output, data.EUfvr, by = c("Country", "Year"),type="full")
output <- plyr::join(output, data.NATOess, by = c("Country", "Year"),type="full")
output <- plyr::join(output, data.NATO.EU, by = c("Country", "Year"),type="full")
output <- plyr::join(output, data.intlcnf, by = c("Country", "Year"),type="full")
output <- plyr::join(output, data.cvlwr, by = c("Country", "Year"),type="full")
output <- plyr::join(output, data.pcap, by = c("Country", "Year"),type="full")
output <- plyr::join(output, data.population, by = c("Country", "Year"),type="full")
output <- plyr::join(output, data.ally, by = c("Country", "Year"),type="full")
output <- plyr::join(output, attacks, by = c("Country", "Year"),type="full")
output <- plyr::join(output, data.euds, by = c("Country", "Year"),type="full")
output <- plyr::join(output, data.euds_lead, by = c("Country", "Year"),type="full")
    output <- plyr::join(output, threatvariable, by = c("Country", "Year"),type="full")


# View(output)  

#Remove Years that took place before any polling data is available.
output<-subset(output,Year>=min(output[!is.na(output$USldrSpread) | 
                                           !is.na(output$DefSpread) |
                                           !is.na(output$EUldrSpread) |
                                           !is.na(output$EUfvrSpread) |
                                           !is.na(output$NATOessSpread) |
                                           !is.na(output$NATO.EUspread) 
                                           ,"Year"]))


#Remove Countries with no polling data
output<-subset(output,Country %in% unique(output[!is.na(output$USldrSpread) | 
           !is.na(output$DefSpread) |
               !is.na(output$DefSpread) |
               !is.na(output$EUldrSpread) |
               !is.na(output$EUfvrSpread) |
               !is.na(output$NATOessSpread) |
               !is.na(output$NATO.EUspread) ,"Country"]))

#Get rid of summary countries.
output <- subset(output,!Country %in% c("EU 10","EU 7","USA","EU 11","EU 9","EU 12","EU 8", "EU 5")) 


#Order the data.frame
output<-output[order(output$Country,output$Year),]


} 

