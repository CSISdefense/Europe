## Make sure you have installed the packages plm, plyr, and reshape

SSIRegress <- function(filename, regtype, depvar, indvar..., lag = 1) {
    ## start by setting up some items for later use.
    ## Namely, loading needed packages and setting a path to my files.
    require(plm)
    require(plyr)
    require(reshape)
    path <- "K:/2015-03 SSI Public Opinion/"
    
    ## Next I'm going to load all of my data, will follow by combining
    data.a <- read.csv(paste(path, filename, sep =""), header = TRUE) 
    data.gov <- read.csv(paste(path, "SSI_Govern.csv", sep =""), header = TRUE)
    data.ter <- read.csv(paste(path, "Terrorism Data.csv", sep =""), header = TRUE)
    data.conf <- read.csv(paste(path, "Conflict_And_EUmemberstate_Data.csv", sep =""), header = TRUE)
    data.gdppc <- read.csv(paste(path, "SSI_GDPperCAP.csv", sep =""), header = TRUE)
    data.thrt <- read.csv(paste(path, "SSI_Threat.csv", sep =""), header = TRUE)
    data.pop <- read.csv(paste(path, "SSI_Population.csv", sep =""), header = TRUE)
    data.nato <- read.csv(paste(path, "SSI_NATO.csv", sep =""), header = TRUE)
    
    
    colnames(data.gov)[colnames(data.gov)=="country"] <- "Country"
    colnames(data.gov)[colnames(data.gov)=="year"] <- "Year"
    colnames(data.ter)[colnames(data.ter)=="country_txt"] <- "Country"
    colnames(data.ter)[colnames(data.ter)=="iyear"] <- "Year"
    colnames(data.conf)[colnames(data.conf)=="country"] <- "Country"
    colnames(data.conf)[colnames(data.conf)=="year"] <- "Year"
    colnames(data.thrt)[colnames(data.thrt)=="COUNTRY"] <- "Country"
    colnames(data.thrt)[colnames(data.thrt)=="YEAR"] <- "Year"
    
    data.ter <- data.ter[,2:6]
    countryloop <- sort(unique(data.ter$Country))
    timeloop <- sort(unique(data.ter$Year), decreasing= FALSE)
    data.terror <- NULL
    attacks <- as.data.frame(NULL)
    output.a <- NULL
    sumdom <- NULL
    sumint <- NULL
    countrybinder <- NULL
    
    #     for (i in countryloop){ 
    #         good <- complete.cases(data.ter[data.ter$Country== i,])
    #         use <- data.ter[good,]    
    #         for (t in timeloop){
    #             use.a <- use[use$Year == t,]
    #             row <- c(t, nrow(use.a))
    #             attacks <- rbind(attacks, row)
    #             
    #         }
    #         countrybinder[i] <- rep(i, times = 35)
    #         output <- cbind(countrybinder[i], attacks)
    #     }
    #     
    
    data.pcap <- melt(data.gdppc, id = "Year")
    colnames(data.pcap)[colnames(data.pcap)=="year"] <- "Year"
    colnames(data.pcap)[colnames(data.pcap)=="variable"] <- "Country"
    colnames(data.pcap)[colnames(data.pcap)=="value"] <- "GDPpCap"
    
    data.population <- melt(data.pop, id = "Year")
    colnames(data.population)[colnames(data.population)=="year"] <- "Year"
    colnames(data.population)[colnames(data.population)=="variable"] <- "Country"
    colnames(data.population)[colnames(data.population)=="value"] <- "Population"
    
    data.ally <- melt(data.nato, id = "Year")
    colnames(data.ally)[colnames(data.ally)=="year"] <- "Year"
    colnames(data.ally)[colnames(data.ally)=="variable"] <- "Country"
    colnames(data.ally)[colnames(data.ally)=="value"] <- "NATOally"
    
    ## Now it is time to start combining my data
    out1 <- join(data.a, data.gov, by = c("Country", "Year"))
    out2 <- join(out1, data.conf, by = c("Country", "Year"))
    out3 <- join(out2, data.pcap, by = c("Country", "Year"))
    out4 <- join(out3, data.population, by = c("Country", "Year"))
    out5 <- join(out4, data.ally, by = c("Country", "Year"))
    out6 <- join(out5, data.thrt, by = c("Country", "Year"))
    View(out6)    
    
} 


SSIRegress("SSI_DefSpnd_IncDec.csv")


