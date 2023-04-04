  ## start by setting up some items for later use.
  ## Namely, loading needed packages and setting a path to my files.
  require(plm)
  require(plyr)
  require(reshape2)
  require(stringr)

  path<-"Data//"
  source("Scripts//EuropeInput.r")
  
  ## Next I'm going to load all of my data. The data: in order is..
  ## public opinion, governance data from PolityIV, Terrorism data from GTD,
  ## data we compiled on conflicts and a country's membership to the EU,
  ## GDP per capita data (constant 2005 $), GDP data (also Const 2005 $), population data,
  ## data on NATO membership, spending data, and neighbor spending data.
  
  
  lookup.countries <- read.csv(paste(path, "CountryNameStandardize.csv", sep =""), header = TRUE)
  lookup.currency <- read.csv(paste(path, "Lookup_CountryCurrency.csv", sep =""), header = TRUE) 
  lookup.exchange<-subset(InputExchange(path=path),Year==2014,select=-c(Year)) 
  lookup.exchange <-dplyr::full_join(lookup.currency, lookup.exchange, by = c("Currency"))
  #We're applying a variant of the World Bank Methodology for handling currency exchanges with constant LCU
  #https://datahelpdesk.worldbank.org/knowledgebase/articles/114943-what-is-your-constant-u-s-dollar-methodology
  
  
  
  #Parliamentary data 
  lookup.party.opinion2014 <- read.csv(paste(path, "2014_CHES_dataset_means.csv", sep =""), header = TRUE) 
  lookup.party.opinion <- read.csv(paste(path, "1999-2010_CHES_dataset_means.csv", sep =""), header = TRUE, sep="\t") 
  data.elite <- read.csv(paste(path, "elite_annual_aggregated.csv", sep=""), header = TRUE, na.strings = "#VALUE!")
  data.cabinet <- read.csv(paste(path, "view_cabinet.csv", sep =""), header = TRUE) 
  
  #Polling Data
  data.IncDec <- read.csv(paste(path, "TAT_DefSpnd_IncDec.csv", sep =""), header = TRUE) 
  data.USldr <- read.csv(paste(path, "TAT_US_leadership_subtotal.csv", sep =""), header = TRUE) 
  data.EUldr <- read.csv(paste(path, "TAT_EU_leadership_subtotal.csv", sep =""), header = TRUE) 
  data.EUldr.detail <- read.csv(paste(path, "TAT_EU_leadership_detail.csv", sep =""), header = TRUE) 
  data.EUfvr <- read.csv(paste(path, "TAT_EU_favorable_subtotal.csv", sep =""), header = TRUE) 
  data.NATOess <- read.csv(paste(path, "TAT_NATO_essential.csv", sep =""), header = TRUE) 
  data.EUcloserUS <- read.csv(paste(path, "TAT_EU_US_Closer.csv", sep =""), header = TRUE) 
  
  #Conflict and International Security
  data.gov <- read.csv(paste(path, "SSI_Govern.csv", sep =""), header = TRUE)
  data.ter <- read.csv(paste(path, "Terrorism Data.csv", sep =""), header = TRUE)
  data.intlcnf <- read.csv(paste(path, "SSI_IntlConfl.csv", sep =""), header = TRUE)
  data.cvlwr <- read.csv(paste(path, "SSI_CivilWar.csv", sep =""), header = TRUE)
  data.nato <- read.csv(paste(path, "SSI_NATO.csv", sep =""), header = TRUE)
  data.UNmission<-InputUNmission()
  load(paste(path,"124934_1ucdp-brd-conflict-2015.rdata",sep=""))
  ucdp.brd[grepl("Russia", ucdp.brd$SideA) |
             grepl("Russia", ucdp.brd$SideA2nd) |
             grepl("Russia", ucdp.brd$SideB) |
             grepl("Russia", ucdp.brd$SideB2nd),]
  #Only Georgia and some internal conflict qualify during the period, so leaving this measure out.
  data.ter <- read_csv(paste(path, "Terrorism Data.csv", sep =""))#, header = TRUE
  data.Russia<-LoadSIPRI("SIPRI-Milex-data-1988-2015",lookup.countries)
  data.Russia<-subset(data.Russia,Country=="USSR/Russia",select=c("Year","SIPRIdefSpend"))
  colnames(data.Russia)[colnames(data.Russia)=="SIPRIdefSpend"]<-"RussiaDefSpend_C"
  
  
  #Macroeconomic data from World Data Indicators
  data.gdpLCU<-ProcessWDI("API_NY.GDP.MKTP.KN_DS2_en_csv_v2",
                          "GDPlcu",
                          lookup.countries,
                          path=path) #GDP, constant LCU 2005
  data.gdppcLCU <-ProcessWDI("API_NY.GDP.PCAP.KN_DS2_en_csv_v2",
                             "GDPpCapLCU",
                             lookup.countries,
                             path=path) #GDP per Capita, constant LCU
  # data.deflator <-ProcessWDI("API_NY.GDP.DEFL.ZS_DS2_en_csv_v2",
  # "deflator",
  # lookup.countries,
  # path=path) #LCU deflator, variable year
  data.CashBalance <-ProcessWDI("API_GC.BAL.CASH.GD.ZS_DS2_en_csv_v2",
                                "CashBalance",
                                lookup.countries,
                                path=path) #Cash Surplus/Deficit , % of GDP
  data.TaxRevenue <-ProcessWDI("API_GC.TAX.TOTL.CN_DS2_en_csv_v2",
                               "Tax",
                               lookup.countries,
                               path=path) #Tax Revenue, Current LCU
  data.population <-ProcessWDI("API_SP.POP.TOTL_DS2_en_csv_v2",
                               "Population",
                               lookup.countries,
                               path=path)#Population
  lookup.countries <- read.csv(paste(path, "CountryNameStandardize.csv", sep =""), 
                               header = TRUE)
  #Eurostat government figures
  data.Eurostat<-ProcessEuroStat("gov_10dd_edpt1",lookup.countries,path)
  # data.Eurostat<-ProcessEuroStat("tsdde410",lookup.countries,path)
  
  #http://ec.europa.eu/eurostat/data/database?node_code=tipsgo10
  data.EUdebt_NGDP<-read.csv(paste(path,"SSI_Eurostat_Debt_GDP.csv",sep=""),na.string=":")
  data.EUdebt_NGDP<-melt(data.EUdebt_NGDP,id=c("geo.time"),value.name="EUdebt_NGDP")
  colnames(data.EUdebt_NGDP)[1]<-"Year"
  data.EUdebt_NGDP<-subset(data.EUdebt_NGDP,variable=="EU..27.countries.",select = c(Year,EUdebt_NGDP))
  data.EUdebt_NGDP$EUdebt_NGDP<-data.EUdebt_NGDP$EUdebt_NGDP/100 #Convert to true percent.
  
  #IMF macroeconomics
  data.IMF <- LoadIMF("WEOApr2016all",lookup.countries,path)
  data.NGDP<-ExtractIMF(data.IMF,"NGDP",RemoveEstimate=TRUE)
  data.NGDPPC<-ExtractIMF(data.IMF,"NGDPPC",RemoveEstimate=TRUE)
  data.GGSB_NPGDP<-ExtractIMF(data.IMF,"GGSB_NPGDP",RemoveEstimate=TRUE,"SDfc_NGDP")
  data.GGSB_NPGDP$SDfc_NGDP<-data.GGSB_NPGDP$SDfc_NGDP/100 #Convert to true percent.
  data.GGXCNL_NGDP<-ExtractIMF(data.IMF,"GGXCNL_NGDP",RemoveEstimate=TRUE,"Dfc_NGDP")
  data.GGXCNL_NGDP$Dfc_NGDP<-data.GGXCNL_NGDP$Dfc_NGDP/100 #Convert to true percent.
  data.GGXWDG_NGDP<-ExtractIMF(data.IMF,"GGXWDG_NGDP",RemoveEstimate=TRUE,"Debt_NGDP")
  data.GGXWDG_NGDP$Debt_NGDP<-data.GGXWDG_NGDP$Debt_NGDP/100 #Convert to true percent.
  
  data.GGR<-ExtractIMF(data.IMF,"GGR",RemoveEstimate=TRUE)
  
  data.deflator<-ExtractIMF(data.IMF,"NGDP_D",RemoveEstimate=TRUE)
  data.deflator<-ConvertDeflatorsToCommonBaseYear(data.deflator,
                                                  "NGDP_D",
                                                  2014
  )
  
  
  
  # Military Spending and Components
  data.euds <- ProcessDefenseSpend("European_Total_Current_LCU.csv",
                                   "DefSpend_C",
                                   lookup.countries,
                                   path)
  data.eueq <- ProcessDefenseSpend("European_Equipment_Current_LCU.csv",
                                   "EquSpend_C",
                                   lookup.countries,
                                   path)
  data.euinf <- ProcessDefenseSpend("European_Infrastructure_Current_LCU.csv",
                                    "InfSpend_C",
                                    lookup.countries,
                                    path)
  data.euoms <- ProcessDefenseSpend("European_O&M_Other_Current_LCU.csv",
                                    "OnMspend_C",lookup.countries,
                                    path)
  data.euper <- ProcessDefenseSpend("European_Personnel_Current_LCU.csv",
                                    "PerSpend_C",lookup.countries,
                                    path)
  
  
  
  
  # data.eurnd <- ProcessDefenseSpend("European_O&M_Other_Current_LCU.csv","RNDSpend",lookup.countries,path)
  
  data.nghspnd <- read.csv(paste(path, "SSIMilSpendingData.CSV", sep=""), header = TRUE, na.strings = "#VALUE!")
  
  
  #### This next section is where we change the column names of the data sets that don't need
  #### to be reshaped. 
  
  # Polling on Defense Spending
  colnames(data.IncDec)[colnames(data.IncDec)=="Increase"] <- "DefIncrease"
  colnames(data.IncDec)[colnames(data.IncDec)=="Decrease"] <- "DefDecrease"
  colnames(data.IncDec)[colnames(data.IncDec)=="Same"] <- "DefSame"
  colnames(data.IncDec)[colnames(data.IncDec)=="IDK"] <- "DefIDK"
  data.IncDec$DefSpread<-(data.IncDec$DefIncrease-data.IncDec$DefDecrease)/100
  data.IncDec<-StandardizeCountries(data.IncDec,lookup.countries)
  
  
  #Polling on US leadership
  colnames(data.USldr)[colnames(data.USldr)=="Increase"] <- "USldrIncrease"
  colnames(data.USldr)[colnames(data.USldr)=="Decrease"] <- "USldrDecrease"
  colnames(data.USldr)[colnames(data.USldr)=="Same"] <- "USldrSame"
  colnames(data.USldr)[colnames(data.USldr)=="IDK"] <- "USldrIDK"
  colnames(data.USldr)[colnames(data.USldr)=="Spread"] <- "USldrSpread"
  data.USldr$USldrSpread<-data.USldr$USldrSpread/100
  data.USldr<-StandardizeCountries(data.USldr,lookup.countries)
  
  ## Then we change the coloumnames to make them more universal
  colnames(data.gov)[colnames(data.gov)=="country"] <- "Country"
  colnames(data.gov)[colnames(data.gov)=="year"] <- "Year"
  data.gov<-StandardizeCountries(data.gov,lookup.countries)
  
  #Elite opinion
  colnames(data.elite)[colnames(data.elite)=="year"] <- "Year"
  data.elite$Cab_left_right <- as.numeric(as.character(data.elite$Cab_left_right))
  data.elite$Cab_liberty_authority <- as.numeric(as.character(data.elite$Cab_liberty_authority))
  data.elite$Cab_eu_anti_pro <- as.numeric(as.character(data.elite$Cab_eu_anti_pro))
  data.elite$left_right_ls_spread <- as.numeric(as.character(data.elite$left_right_ls_spread))
  data.elite$liberty_authority_ls_spread <- as.numeric(as.character(data.elite$liberty_authority_ls_spread))
  data.elite$eu_anti_pro_ls_spread <- as.numeric(as.character(data.elite$eu_anti_pro_ls_spread))
  
  
  
  #### In this next component, we will reshape and fit data so we can synthesize with with
  #### the other data that we have.
  
  ##reshaping EU defense spending data 
  
  ##reshaping neighbor spending data
  data.nghspnd<-RenameYearColumns(data.nghspnd)
  data.nghspnd <- melt(data.nghspnd, id=c("COUNTRY", "Country.List"), variable.name="Year",value.name="neighspend")
  data.nghspnd <- rename(data.nghspnd, c("COUNTRY"="Country"))
  data.nghspnd <- data.nghspnd[,c(1,3,4)]
  data.nghspnd<-StandardizeCountries(data.nghspnd,lookup.countries)
  
  data.nghspnd <- arrange(data.nghspnd, Country)
  
  ## Reshaping international conflict data
  data.intlcnf <- melt(data.intlcnf, id = "Year", variable.name="Country",value.name="IntlCnf")
  data.intlcnf$Year <- as.integer(as.character(data.intlcnf$Year))
  data.intlcnf<-StandardizeCountries(data.intlcnf,lookup.countries)
  
  ## Reshaping civil war data
  data.cvlwr <- melt(data.cvlwr, id = "Year", variable.name="Country",value.name="CivilWar")
  data.cvlwr$Year <- as.integer(as.character(data.cvlwr$Year))
  data.cvlwr<-StandardizeCountries(data.cvlwr,lookup.countries)
  
  
  #Reshaping cabinet data
  data.cabinet$Country<-data.cabinet$country_name_short
  data.cabinet<-StandardizeCountries(data.cabinet,lookup.countries)
  data.cabinet <- read.csv(paste(path, "view_cabinet.csv", sep =""), header = TRUE) 
  
  
  ## Reshaping EU leadership Data subtotal
  data.EUldr <- melt(data.EUldr, id = c("EU_leadership","Year"),variable.name="Country")
  data.EUldr<-dcast(data.EUldr, Country + Year ~ EU_leadership, value.var="value")
  data.EUldr$Year <- as.integer(as.character(data.EUldr$Year))
  data.EUldr<-StandardizeCountries(data.EUldr,lookup.countries)
  data.EUldr$EUldrSpread<-(data.EUldr[,"ST Desirable"]-data.EUldr[,"ST Undesirable"])/100
  
  ## Reshaping EU leadership detail (used to fill in for missing years of subtotal)
  data.EUldr.detail <- melt(data.EUldr.detail, id = c("EU_leadership","Year"),variable.name="Country")
  data.EUldr.detail<-dcast(data.EUldr.detail, Country + Year ~ EU_leadership, value.var="value")
  data.EUldr.detail$Year <- as.integer(as.character(data.EUldr.detail$Year))
  data.EUldr.detail<-StandardizeCountries(data.EUldr.detail,lookup.countries)
  data.EUldr.detail$EUldrSpreadDetail<-(data.EUldr.detail[,"Somewhat desirable"]+data.EUldr.detail[,"Very desirable"]-
                                          data.EUldr.detail[,"Somewhat undesirable"]-data.EUldr.detail[,"Very undesirable"])/100
  
  data.EUldr.detail<-subset(data.EUldr.detail,select=c(Country,Year,EUldrSpreadDetail))
  data.EUldr <- plyr::join(data.EUldr, data.EUldr.detail, by = c("Country", "Year"),type="full")
  data.EUldr$EUldrSpread[is.na(data.EUldr$EUldrSpread)]<-data.EUldr$EUldrSpreadDetail[is.na(data.EUldr$EUldrSpread)]
  data.EUldr<-subset(data.EUldr,select=c(Country,Year,EUldrSpread))
  
  ## Reshaping EU favorability polling question
  data.EUfvr <- melt(data.EUfvr, id = c("EU_favorable","Year"),variable.name="Country")
  data.EUfvr <- dcast(data.EUfvr, Country + Year ~ EU_favorable, value.var="value")
  data.EUfvr$Year <- as.integer(as.character(data.EUfvr$Year))
  data.EUfvr<-StandardizeCountries(data.EUfvr,lookup.countries)
  data.EUfvr$EUfvrSpread<-(data.EUfvr[,"ST Favorable"]-data.EUfvr[,"ST Unfavorable"])/100
  data.EUfvr<-subset(data.EUfvr,select=c(Country,Year,EUfvrSpread))
  
  ## Reshaping Nato Essential polling question
  data.NATOess <- melt(data.NATOess, id = c("NATO_essential","Year"),variable.name="Country")
  data.NATOess<-dcast(data.NATOess, Country + Year ~ NATO_essential, value.var="value")
  data.NATOess$Year <- as.integer(as.character(data.NATOess$Year))
  data.NATOess$Country <- as.character(data.NATOess$Country)
  data.NATOess<-StandardizeCountries(data.NATOess,lookup.countries)
  data.NATOess$NATOessSpread<-(data.NATOess[,"Still essential"]-data.NATOess[,"No longer essential"])/100
  data.NATOess<-subset(data.NATOess,select=c(Country,Year,NATOessSpread))
  
  ## Reshaping Nato-EU closeness polling question
  data.EUcloserUS <- melt(data.EUcloserUS, id = c("EU_US_Closer","Year"),variable.name="Country")
  data.EUcloserUS<-dcast(data.EUcloserUS, Country + Year ~ EU_US_Closer, value.var="value")
  data.EUcloserUS$Year <- as.integer(as.character(data.EUcloserUS$Year))
  data.EUcloserUS<-StandardizeCountries(data.EUcloserUS,lookup.countries)
  data.EUcloserUS$Country <- as.character(data.EUcloserUS$Country)
  data.EUcloserUS$EUcloserUSspread<-(data.EUcloserUS[,"Become closer"]-data.EUcloserUS[,"Take a more independent approach"])/100
  data.EUcloserUS<-subset(data.EUcloserUS,select=c(Country,Year,EUcloserUSspread))
  
  ## Combining Neighbor Spending and GDP data to create a threat ratio variable
  ## The value of this variable is NghSpnd/GDP
  threatvariable <- as.data.frame(NULL)
  c.loop <- unique(data.nghspnd$Country)
  t.loop <- unique(data.nghspnd$Year)
  
  for (i in c.loop) {
    numerator <- data.nghspnd[data.nghspnd$Country == i,]
    denominator <- data.gdpLCU[data.gdpLCU$Country == i,]
    for (t in t.loop){
      numerator.use <- numerator[numerator$Year == t,]
      denominator.use <- denominator[denominator$Year == t,]
      x <- (numerator.use[1,3]/denominator.use[1,3])*1000000
      row <- data.frame(Country = i, Year = t, ThreatRatio = x)
      threatvariable <- rbind(threatvariable, row)
    }
    
  }
  #     threatvariable$Country <- as.character(threatvariable$Country)
  threatvariable<-StandardizeCountries(threatvariable,lookup.countries)
  threatvariable$Year <- as.integer(as.character(threatvariable$Year))
  
  
  # The UCDP/PRIO Armed Conflict Dataset identifies four different types of conflict:
  # extrasystemic (1), interstate (2), internal (3) and internationalized internal (4).
  # See the UCDP/PRIO Armed Conflict Dataset codebook for specific definitions of the four types.
  data.GCivilwarBRD<-subset(ucdp.brd,TypeOfConflict %in% c(3,4)
  )
  data.GCivilwarBRD<-plyr::ddply(data.GCivilwarBRD,
                                 .(Year),
                                 summarise,
                                 GCivilWarBRD=sum(BdBest),
                                 lgCWbrd=log(sum(BdBest)))
  
  
  ## We need to reshape and rename the European R&D spending data
  # data.eurnd<-RenameYearColumns(data.eurnd)
  # data.eurnd <- melt(data.eurnd, id=c("Country", "Units.Currency"), variable.name="Year",value.name="RnDspnd")
  # data.eurnd$RnDspnd <- as.numeric(gsub(",","",str_trim(as.character(data.eurnd$RnDspnd))))
  # data.eurnd$Year <- as.integer(as.character(data.eurnd$Year))
  # data.eurnd$RnDspnd <- data.eurnd$RnDspnd*1000000
  # data.eurnd<-StandardizeCountries(data.eurnd,lookup.countries)
  # data.eurnd_lead<-data.eurnd
  # data.eurnd_lead$Year<-data.eurnd_lead$Year-1
  # colnames(data.eurnd_lead)[colnames(data.eurnd_lead)=="RnDspnd"] <- "RnDspnd_lead"
  # data.eurnd <- plyr::join(data.eurnd, data.eurnd_lead, by = c("Country", "Year"),type="full")
  # 
  
  
  
  ## Also need to reshape the in NATO/alliance, and then rename some of the columns
  data.ally <- melt(data.nato, id = "Year", variable.name="Country",value.name="NATOally")
  colnames(data.ally)[colnames(data.ally)=="year"] <- "Year"
  data.ally<-StandardizeCountries(data.ally,lookup.countries)
  
  
  ## This next section is to synthesize the terrorism data and boil it down to
  ## the information we actually need for the 
  colnames(data.ter)[colnames(data.ter)=="country_txt"] <- "Country"
  colnames(data.ter)[colnames(data.ter)=="iyear"] <- "Year"
  data.ter <- data.ter[,2:6]
  data.ter<-StandardizeCountries(data.ter,lookup.countries)
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
  
  
  
  #Polling
  output <- plyr::join(data.USldr, data.gov, by = c("Country", "Year"),type="full")
  output <- plyr::join(output, data.IncDec, by = c("Country", "Year"),type="full")
  output <- plyr::join(output, data.EUldr, by = c("Country", "Year"),type="full")
  output <- plyr::join(output, data.EUfvr, by = c("Country", "Year"),type="full")#17
  output <- plyr::join(output, data.NATOess, by = c("Country", "Year"),type="full")
  output <- plyr::join(output, data.EUcloserUS, by = c("Country", "Year"),type="full")
  
  #MacroEconomic
  
  #WDI from World Bank
  output <- plyr::join(output, data.gdppcLCU, by = c("Country", "Year"),type="full")
  output <- plyr::join(output, data.gdpLCU, by = c("Country", "Year"),type="full")
  output <- plyr::join(output, data.CashBalance, by = c("Country", "Year"),type="full")
  output <- plyr::join(output, data.TaxRevenue, by = c("Country", "Year"),type="full")
  output <- plyr::join(output, data.population, by = c("Country", "Year"),type="full")
  
  #WEO from IMF
  output <- plyr::join(output, data.NGDP, by = c("Country", "Year"),type="full")
  output <- plyr::join(output, data.NGDPPC, by = c("Country", "Year"),type="full")
  output <- plyr::join(output, data.GGSB_NPGDP, by = c("Country", "Year"),type="full")
  output <- plyr::join(output, data.GGXCNL_NGDP, by = c("Country", "Year"),type="full")
  output <- plyr::join(output, data.GGXWDG_NGDP, by = c("Country", "Year"),type="full")
  output <- plyr::join(output, data.GGR, by = c("Country", "Year"),type="full")
  output <- plyr::join(output, data.deflator, by = c("Country", "Year"),type="full")
  
  #Eurostat manually edited
  output <- plyr::join(output, data.EUdebt_NGDP, by = "Year",type="full")
  
  
  #Conflict and International Security
  output <- plyr::join(output, data.intlcnf, by = c("Country", "Year"),type="full")
  output <- plyr::join(output, data.cvlwr, by = c("Country", "Year"),type="full")
  output <- plyr::join(output, data.ally, by = c("Country", "Year"),type="full")
  output <- plyr::join(output, attacks, by = c("Country", "Year"),type="full")
  output <- plyr::join(output, data.UNmission, by = c("Country", "Year"),type="full")
  output <- plyr::join(output, data.GCivilwarBRD, by = "Year",type="full")
  output <- plyr::join(output, data.Russia, by = "Year",type="full")
  
  
  
  #Defense spending and components
  output <- plyr::join(output, data.euds, by = c("Country", "Year"),type="full")
  output <- plyr::join(output, data.eueq, by = c("Country", "Year"),type="full")
  output <- plyr::join(output, data.euinf, by = c("Country", "Year"),type="full")#80
  output <- plyr::join(output, data.euoms, by = c("Country", "Year"),type="full")
  output <- plyr::join(output, data.euper, by = c("Country", "Year"),type="full")
  # output <- plyr::join(output, data.eurnd, by = c("Country", "Year"),type="full")
  output <- plyr::join(output, threatvariable, by = c("Country", "Year"),type="full")
  
  #Parliamentary Data
  output <- plyr::join(output, data.elite, by = c("Country", "Year"),type="full")
  
  #Lookups
  # EuroToUSD<-subset(lookup.exchange,select=c(Year,EuroToLCU), Currency=="US.dollar")
  # colnames(EuroToUSD)[colnames(EuroToUSD)=="EuroToLCU"]<-"EuroToUSD"
  # output <-plyr::join(output, EuroToUSD, by = c("Year"),type="full")
  
  output <-plyr::join(output, lookup.exchange, by = c("Country"),type="full")
  
  #Remove Countries with no polling data
  output<-subset(output,Country %in% unique(output[!is.na(output$USldrSpread) | 
                                                     !is.na(output$DefSpread) |
                                                     !is.na(output$EUldrSpread) |
                                                     !is.na(output$EUfvrSpread) |
                                                     !is.na(output$NATOessSpread) |
                                                     !is.na(output$EUcloserUSspread) ,"Country"]))
  
  #Get rid of summary countries.
  output <- subset(output,!Country %in% c("EU 10","EU 7","USA","EU 11","EU 9","EU 12","EU 8", "EU 5")) 
  output$UNmilitaryPMil<-output$AvgUNmilitary / output$Population * 1000000
  
  # output$GDPpCapEU<-output$GDPpCap / output$EuroToUSD
  # output$GDP2005eu<-output$GDP2005usd / output$EuroToUSD
  
  
  #Order the data.frame
  output<-output[order(output$Country,output$Year),]
  
  #Transform Current LCU to Constant
  output$NGDP_R2014<-(output$NGDP/output$NGDP_D.2014)*100
  output$NGDPPC_R2014<-(output$NGDPPC/output$NGDP_D.2014)*100
  output$GGR_R2014<-(output$GGR/output$NGDP_D.2014)*100
  output$Tax_R2014<-(output$Tax/output$NGDP_D.2014)*100
  output$DefSpend_R<-(output$DefSpend_C/output$NGDP_D.2014)*100
  output$EquSpend_R<-(output$EquSpend_C/output$NGDP_D.2014)*100
  output$InfSpend_R<-(output$InfSpend_C/output$NGDP_D.2014)*100
  output$OnMspend_R<-(output$OnMspend_C/output$NGDP_D.2014)*100
  output$PerSpend_R<-(output$PerSpend_C/output$NGDP_D.2014)*100
  output$RussiaDefSpend_R<-(output$RussiaDefSpend_C/output$NGDP_D.2014)*100
  
  
  #Convert Constant 2014 LCu to Constant 2014 Euro
  output$NGDP_eu2014<-(output$NGDP_R2014/output$EuroToLCU)
  output$NGDPPC_eu2014<-(output$NGDPPC_R2014/output$EuroToLCU)
  output$GGR_eu2014<-(output$GGR_R2014/output$EuroToLCU)
  output$DefSpend<-(output$DefSpend_R/output$EuroToLCU)
  output$EquSpend<-(output$EquSpend_R/output$EuroToLCU)
  output$InfSpend<-(output$InfSpend_R/output$EuroToLCU)
  output$OnMspend<-(output$OnMspend_R/output$EuroToLCU)
  output$PerSpend<-(output$PerSpend_R/output$EuroToLCU)
  output$RussiaDefSpend<-(output$RussiaDefSpend_R/output$EuroToLCU)
  
  
  output<-IndicatorVariableTimeVariants(output,"DefSpend",CreateLeads=TRUE)
  output<-IndicatorVariableTimeVariants(output,"EquSpend",CreateLeads=TRUE)
  output<-IndicatorVariableTimeVariants(output,"InfSpend",CreateLeads=TRUE)
  output<-IndicatorVariableTimeVariants(output,"OnMspend",CreateLeads=TRUE)
  output<-IndicatorVariableTimeVariants(output,"PerSpend",CreateLeads=TRUE)
  output<-IndicatorVariableTimeVariants(output,"NGDP_eu2014")
  output<-IndicatorVariableTimeVariants(output,"NGDPPC_eu2014")
  output<-IndicatorVariableTimeVariants(output,"GGR_eu2014")
  output<-IndicatorVariableTimeVariants(output,"GDPpCapLCU")
  output<-IndicatorVariableTimeVariants(output,"Tax")
  output<-IndicatorVariableTimeVariants(output,"Population")
  output<-IndicatorVariableTimeVariants(output,"GCivilWarBRD")
  output<-IndicatorVariableTimeVariants(output,"RussiaDefSpend")
  
  
  # output<-ddply(output,
  #               .(Country),
  #               mutate,
  #               GDPpCapLCUdiff=c(NA,#The first value is NA because you can't do a diff with on the first year
  #                             diff(GDPpCapLCU,
  #                                  lag=1,
  #                                  difference=1)),
  #               GDP2005lcuDiff=c(NA,#The first value is NA because you can't do a diff with on the first year
  #                             diff(GDPlcu,
  #                                  lag=1,
  #                                  difference=1)),
  #               
  #               # GDPpCapEUdiff=c(NA,#The first value is NA because you can't do a diff with on the first year
  #               #                  diff(GDPpCapEU,
  #               #                       lag=1,
  #               #                       difference=1)),
  #               # GDP2005euDiff=c(NA,#The first value is NA because you can't do a diff with on the first year
  #               #                  diff(GDP2005eu,
  #               #                       lag=1,
  #               #                       difference=1)),
  #               TaxDiff=c(NA,#The first value is NA because you can't do a diff with on the first year
  #                             diff(Tax_R2014,
  #                                  lag=1,
  #                                  difference=1)),
  #               PopulationDiff=c(NA,#The first value is NA because you can't do a diff with on the first year
  #                                diff(Population,
  #                                     lag=1,
  #                                     difference=1))
  # )
  # 
  # output<-ddply(output,
  #               .(Country),
  #               mutate,
  #               GDPpCapLCUdelt=as.vector(Delt(GDPpCapLCU,
  #                                          k=1)),            
  #               GDP2005lcuDelt=as.vector(Delt(GDPlcu,
  #                                             k=1)),
  #               # GDPpCapEUdelt=as.vector(Delt(GDPpCapEU,
  #               #                               k=1)),            
  #               # GDP2005euDelt=as.vector(Delt(GDP2005eu,
  #               #                               k=1)),  
  #               TaxDelt=as.vector(Delt(Tax_R2014,
  #                                              k=1)),   
  #               PopulationDelt=as.vector(Delt(Population,
  #                                             k=1)))
  
  
  
  
  
  #Create Polling Lags
  polling_lag1<-subset(output,select=c(Country,Year,DefSpread,EUldrSpread,EUfvrSpread,NATOessSpread,EUcloserUSspread))
  polling_lag1$Year<-polling_lag1$Year+1
  colnames(polling_lag1)[colnames(polling_lag1)=="DefSpread"] <- "DefSpread_lag1"
  colnames(polling_lag1)[colnames(polling_lag1)=="EUldrSpread"] <- "EUldrSpread_lag1"
  colnames(polling_lag1)[colnames(polling_lag1)=="EUfvrSpread"] <- "EUfvrSpread_lag1"
  colnames(polling_lag1)[colnames(polling_lag1)=="NATOessSpread"] <- "NATOessSpread_lag1"
  colnames(polling_lag1)[colnames(polling_lag1)=="EUcloserUSspread"] <- "EUcloserUSspread_lag1"
  output <- plyr::join(output, polling_lag1, by = c("Country", "Year"),type="left")
  
  polling_lag2<-subset(output,select=c(Country,Year,DefSpread,EUldrSpread,EUfvrSpread,NATOessSpread,EUcloserUSspread))
  polling_lag2$Year<-polling_lag2$Year+2
  colnames(polling_lag2)[colnames(polling_lag2)=="DefSpread"] <- "DefSpread_lag2"
  colnames(polling_lag2)[colnames(polling_lag2)=="EUldrSpread"] <- "EUldrSpread_lag2"
  colnames(polling_lag2)[colnames(polling_lag2)=="EUfvrSpread"] <- "EUfvrSpread_lag2"
  colnames(polling_lag2)[colnames(polling_lag2)=="NATOessSpread"] <- "NATOessSpread_lag2"
  colnames(polling_lag2)[colnames(polling_lag2)=="EUcloserUSspread"] <- "EUcloserUSspread_lag2"
  output <- plyr::join(output, polling_lag2, by = c("Country", "Year"),type="left")
  
  
  
  
  output<-subset(output,Year>=min(output[!is.na(output$USldrSpread) | 
                                           !is.na(output$DefSpread) |
                                           !is.na(output$EUldrSpread) |
                                           !is.na(output$EUfvrSpread) |
                                           !is.na(output$NATOessSpread) |
                                           !is.na(output$EUcloserUSspread) 
                                         ,"Year"]))
  
  


