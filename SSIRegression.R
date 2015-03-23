## Make sure you have installed the packages plm, plyr, and reshape

SSIRegress <- function(filename, regtype, depvar, indvar..., lag = 1) {
    ## start by setting up some items for later use.
    ## Namely, loading needed packages and setting a path to my files.
    require(plm)
    require(plyr)
    require(reshape)
    
    ## Set this path to the folder into which your git hub will download data
    path <- "C:/Users/MRiley/My Documents/Europe/"
    
    ## Next I'm going to load all of my data
    ## Public Opinion Data
    data.a <- read.csv(paste(path, filename, sep =""), header = TRUE) 
    data.gov <- read.csv(paste(path, "SSI_Govern.csv", sep =""), header = TRUE)
    data.ter <- read.csv(paste(path, "Terrorism Data.csv", sep =""), header = TRUE)
    data.conf <- read.csv(paste(path, "Conflict_And_EUmemberstate_Data.csv", sep =""), header = TRUE)
    data.gdppc <- read.csv(paste(path, "SSI_GDPperCAP.csv", sep =""), header = TRUE)
    data.thrt <- read.csv(paste(path, "SSI_Threat.csv", sep =""), header = TRUE, na.strings = "#VALUE!")
    data.pop <- read.csv(paste(path, "SSI_Population.csv", sep =""), header = TRUE)
    data.nato <- read.csv(paste(path, "SSI_NATO.csv", sep =""), header = TRUE)
    data.euds <- read.csv(paste(path, "EUDefenseSpending_EUROS.csv", sep =""), header = TRUE)
    
    ##Samantha's addition of total GDP and nieghborspending variable
      ##entering in total GDP per country data
  data.gdp <- read.csv(paste(path, "TotalGDP_EuCountries.csv", sep=""), header = TRUE)
  
  #changing Column Names 
  data.gdp1 <- rename(data.gdp, c("X2000"="2000", "X2001"="2001", "X2002"="2002", "X2003"="2003", "X2004"="2004", "X2005"="2005", "X2006"     ="2006", "X2007"="2007", "X2008"="2008", "X2009"="2009", "X2010"="2010", "X2011"="2011", "X2012"="2012", "X2013"="2013"))
  
  ##reshaping EU defense spending data 
  data.gdp2 <- melt(data.gdp1, id=c("Country.Name", "Country.Code", "Indicator.Name", "Indicator.Code"))
  
  ##Naming the year column 
  data.gdp3 <- rename(data.gdp2, c("Country.Name"="Country", "variable"="Year", "value"="GDP2005usd"))
  
  ##Sort by country
  data.gdp <- arrange(data.gdp3, Country)
  
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  
  ##entering in Neighbor Spending data
  
  data.neighspend <- read.csv(paste(path, "COPY1_SSIMilSpendingData.CSV", sep=""), header = TRUE)
  
  ##changing column names
  data.neighspend1 <- rename(data.neighspend, c("X2000"="2000", "X2001"="2001", "X2002"="2002", "X2003"="2003", "X2004"="2004", "X2005"="2005", "X2006"     ="2006", "X2007"="2007", "X2008"="2008", "X2009"="2009", "X2010"="2010", "X2011"="2011", "X2012"="2012", "X2013"="2013"))
  
  ##reshaping data
  data.neighspend2 <- melt(data.neighspend1, id=c("COUNTRY", "Country.List"))
  
  ##naming the year column
  data.neighspend3 <- rename(data.neighspend2, c("variable"="Year", "value"="neighspend"))
  
  ##sort by country
  data.neighspend4 <- arrange(data.neighspend3, COUNTRY)

    
    
    ## Then we change the coloumnames to make them more universal
    colnames(data.gov)[colnames(data.gov)=="country"] <- "Country"
    colnames(data.gov)[colnames(data.gov)=="year"] <- "Year"
    colnames(data.ter)[colnames(data.ter)=="country_txt"] <- "Country"
    colnames(data.ter)[colnames(data.ter)=="iyear"] <- "Year"
    colnames(data.conf)[colnames(data.conf)=="country"] <- "Country"
    colnames(data.conf)[colnames(data.conf)=="year"] <- "Year"
    colnames(data.thrt)[colnames(data.thrt)=="COUNTRY"] <- "Country"
    colnames(data.thrt)[colnames(data.thrt)=="YEAR"] <- "Year"
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
    
    ## We need to reshape and rename the EU defense spending data
    data.euds <- melt(data.euds, id=c("Country", "Unit.Currency"))
        data.euds <- rename(data.euds, c("variable"="Year", "value"="Total Defense Expenditures"))
        data.euds <- data.euds[,c(1,3,4)]
        data.euds[,2] <- as.integer(as.character(data.euds[,2]))
        data.euds[,3] <- data.euds[,3]*1000000
        
    
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
    countryloop <- sort(unique(data.ter$Country))
    timeloop <- sort(unique(data.ter$Year), decreasing= FALSE)
    data.terror <- NULL
    attacks <- as.data.frame(NULL)
    output.a <- NULL
    sumdom <- NULL
    sumint <- NULL
    countrybinder <- NULL
    
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
    out2 <- plyr::join(out1, data.conf, by = c("Country", "Year"))
    out3 <- plyr::join(out2, data.pcap, by = c("Country", "Year"))
    out4 <- plyr::join(out3, data.population, by = c("Country", "Year"))
    out5 <- plyr::join(out4, data.ally, by = c("Country", "Year"))
    out6 <- plyr::join(out5, data.thrt, by = c("Country", "Year"))
    out7 <- plyr::join(out6, attacks, by = c("Country", "Year"))
    out8 <- plyr::join(out7, data.euds, by = c("Country", "Year"))
    View(out8)  

} 


SSIRegress("SSI_DefSpnd_IncDec.csv")


