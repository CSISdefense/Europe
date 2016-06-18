require(plyr)
require(Hmisc)
require(quantmod)
require(reshape2)
require(stringr)
## Make sure you have installed the packages plm, plyr, and reshape

RemoveDuplicates<-function(df,column){
    duplicatelist<-unique(df[duplicated(df[,column]),column])
    df[ !df[,column] %in% duplicatelist,]
}
# debug(ProcessWDI)
ProcessWDI<-function(filename,IndicatorName,lookup.countries,path="Data\\"){
    #Read in file, this assumes zip and filename are the same, may want to abstract in future
    df<-read.csv(unz(paste(path, filename, ".zip", sep =""),
                                paste(filename,".csv", sep="")), #GDP per Capita, constant LCU
                            header=TRUE,
                            skip=4,
                            check.names = FALSE)
    #Get rid of the blank column often at the end of file
    # if(all(is.na(df[,colnames(df)==""]))){
        df<-df[ , -which(names(df) %in% c(""))]
    # }
    #Reshape data
    df <- melt(df, id = c("Country Name","Country Code","Indicator Name","Indicator Code"),
               variable.name="Year",value.name=IndicatorName)
    #Rename columns and format
    df$Year<-as.numeric(levels(df$Year))[df$Year]
    colnames(df)[colnames(df)=="Country Name"] <- "Country"
    df<-StandardizeCountries(df,lookup.countries)
    df <- arrange(df, Country,Year)
    #Drop unnecessary columns
    df<-df[ , -which(names(df) %in% c("Country Code","Indicator Name","Indicator Code"))]
    
    df
}

InputExchange<-function(path="Data\\",file="ECBexchangeRates.csv"){
    lookup.exchange <- read.csv(paste(path,file, sep =""), 
                                header = TRUE,
                                skip=4
    ) 
    colnames(lookup.exchange)[2:ncol(lookup.exchange)]<-
        str_sub(colnames(lookup.exchange)[2:ncol(lookup.exchange)],start=3,-3)
    colnames(lookup.exchange)[1]<-"Year"
    lookup.exchange<-melt(lookup.exchange,id=c("Year"),variable.name="Currency",value.name="EuroToLCU")
    lookup.exchange
}


InputUNmission<-function(path="Data\\",file="data_tcc.csv"){
    #IPI Peacekeeping Database
    #http://www.providingforpeacekeeping.org/contributions/
    data.UNmission <- read.csv(paste(path,file, sep =""), 
                                header = TRUE
    ) 
    data.UNmission$Date<-as.Date(as.character(data.UNmission$Date),"%Y-%m-%d")
    data.UNmission$Year<-as.numeric(format(data.UNmission$Date,'%Y'))
    data.UNmission$Troop.Contributions[is.na(data.UNmission$Troop.Contributions)]<-0
    data.UNmission$EOM.Contributions[is.na(data.UNmission$EOM.Contributions)]<-0
    data.UNmission<-ddply(data.UNmission,.(Contributor,Year), summarise, 
                          AvgUNmilitary = mean(Troop.Contributions)+mean(EOM.Contributions))
    colnames(data.UNmission)[colnames(data.UNmission)=="Contributor"]<-"Country"
    data.UNmission              
}





FillInUncontroversialParlGov<-function(translate.party.id,NewMatches){
    
    
    NewMatches<-subset(NewMatches,
                       select=c(ParlGov.party.id,CHES.party.id)
    )
    NewMatches<-subset(NewMatches,!is.na(ParlGov.party.id))
    NewMatches<-unique(NewMatches)
    duplicated(NewMatches$ParlGov.party.id)
    summary(NewMatches)
    NewMatches<-RemoveDuplicates(NewMatches,"ParlGov.party.id")
    NewMatches<-RemoveDuplicates(NewMatches,"CHES.party.id")
    
    
    translate.party.id<-plyr::join(translate.party.id, NewMatches,
                                   by = c("CHES.party.id"),
                                   type="left"
    )
    translate.party.id$ParlGov.party.id[is.na(translate.party.id$ParlGov.party.id)]<-
        translate.party.id[is.na(translate.party.id$ParlGov.party.id),ncol(translate.party.id)]
    translate.party.id<-translate.party.id[,1:ncol(translate.party.id)-1]
    translate.party.id
    
}


ImportCHES<-function(path="Data\\"){
    #Country Lookup
    lookup.countries <- read.csv(paste(path, "CountryNameStandardize.csv", sep =""), 
                                 header = TRUE) 
    
    
    #CHES2014
    lookup.party.opinion2014 <- read.csv(paste(path, "2014_CHES_dataset_means.csv", sep =""),
                                         #                                stringsAsFactors=FALSE,
                                         header = TRUE,
                                         na.strings =""
    ) 
    colnames(lookup.party.opinion2014)[colnames(lookup.party.opinion2014)=="cname"] <- "Country"
    colnames(lookup.party.opinion2014)[colnames(lookup.party.opinion2014)=="party_name"] <- "party_name_short"
    colnames(lookup.party.opinion2014)[colnames(lookup.party.opinion2014)=="country"] <- "CountryNum"
    lookup.party.opinion2014$year<-2014
    
    #CHES2007 Mini-survey
    lookup.party.opinion2007 <- read.csv(paste(path, "2007_ChapelHillSurvey_Candidates_means.csv", sep =""),
                                         #                                stringsAsFactors=FALSE,
                                         header = TRUE,
                                         na.strings =""
    ) 
    colnames(lookup.party.opinion2007)[colnames(lookup.party.opinion2007)=="country"] <- "CountryNum"
    colnames(lookup.party.opinion2007)[colnames(lookup.party.opinion2007)=="country_abb"] <- "Country"
    colnames(lookup.party.opinion2007)[colnames(lookup.party.opinion2007)=="party"] <- "party_name_short"
    
    #CHES 1999-2010
    lookup.party.opinion <- read.csv(paste(path, "1999-2010_CHES_dataset_means.csv", sep =""), 
                                     header = TRUE, 
                                     #                            stringsAsFactors=FALSE,
                                     sep="\t",
                                     na.strings =""
    ) 
    colnames(lookup.party.opinion)[colnames(lookup.party.opinion)=="country"] <- "Country"
    colnames(lookup.party.opinion)[colnames(lookup.party.opinion)=="party"] <- "party_name_short"
    
    
    
    #CHES.detail.2010
    CHES.detail.2010 <- read.csv(paste(path, "1999-2010_CHES_codebook.txt", sep =""),
                                 sep="\t",
                                 header = TRUE, 
                                 strip.white=TRUE,
                                 encoding="UTF-8") 
    CHES.detail.2010<-StandardizeCountries(CHES.detail.2010,lookup.countries)
    colnames(CHES.detail.2010)[colnames(CHES.detail.2010)=="Party.ID"] <- "CHES.party.id"
    colnames(CHES.detail.2010)[colnames(CHES.detail.2010)=="Party.Abbrev"] <- "CHES.Party.Abbrev"
    colnames(CHES.detail.2010)[colnames(CHES.detail.2010)=="Party.Name"] <- "CHES.Party.Name"
    colnames(CHES.detail.2010)[colnames(CHES.detail.2010)=="Party.Name..English."] <- "CHES.Party.Name.English"
    #     CHES.detail.2010$CHES.year<-2010
    #     compare.party<-plyr::join(translate.party.id, CHES.detail.2010, by = c("Country","CHES.party.id"),type="left")
    
    #CHES.detail.2007
    CHES.detail.2007 <- read.csv(paste(path, "2007_CHES_codebook.txt", sep =""),
                                 sep="\t",
                                 header = TRUE, 
                                 strip.white=TRUE,
                                 encoding="UTF-8") 
    CHES.detail.2007<-StandardizeCountries(CHES.detail.2007,lookup.countries)
    colnames(CHES.detail.2007)[colnames(CHES.detail.2007)=="Party.ID"] <- "CHES.party.id"
    colnames(CHES.detail.2007)[colnames(CHES.detail.2007)=="Party.Abbr"] <- "CHES.Party.Abbrev"
    colnames(CHES.detail.2007)[colnames(CHES.detail.2007)=="Party.Name"] <- "CHES.Party.Name"
    colnames(CHES.detail.2007)[colnames(CHES.detail.2007)=="Party.Name..English."] <- "CHES.Party.Name.English"
    #     compare.party<-plyr::join(translate.party.id, CHES.detail.2007, by = c("Country","CHES.party.id"),type="left")
    # CHES.detail.2007$CHES.year<-2010
    
    #CHES.detail.2014
    CHES.detail.2014 <- read.csv(paste(path, "2014_CHES_codebook.txt", sep =""),
                                 sep="\t",
                                 header = TRUE, 
                                 strip.white=TRUE,
                                 encoding="UTF-8") 
    CHES.detail.2014<-StandardizeCountries(CHES.detail.2014,lookup.countries)
    colnames(CHES.detail.2014)[colnames(CHES.detail.2014)=="Party.ID"] <- "CHES.party.id"
    colnames(CHES.detail.2014)[colnames(CHES.detail.2014)=="Party.Abbrev"] <- "CHES.Party.Abbrev"
    colnames(CHES.detail.2014)[colnames(CHES.detail.2014)=="Party.Name"] <- "CHES.Party.Name"
    colnames(CHES.detail.2014)[colnames(CHES.detail.2014)=="Party.Name..English."] <- "CHES.Party.Name.English"
    # CHES.detail.2014$CHES.year<-2014
    
    #     compare.party<-plyr::join(translate.party.id, CHES.detail.2014, by = c("Country","CHES.party.id"),type="left")
    
    
    
    
    CHES.detail<-rbind(CHES.detail.2007,CHES.detail.2010)
    CHES.detail<-unique(rbind(CHES.detail,subset(CHES.detail.2014,!CHES.party.id %in% unique(CHES.detail$CHES.party.id))))
    CHES.detail<-arrange(CHES.detail,CHES.party.id)
    
    
    
    #Merging the three CHES sources
    lookup.party.opinion<-rbind.fill(lookup.party.opinion,lookup.party.opinion2007)
    lookup.party.opinion<-rbind.fill(lookup.party.opinion,lookup.party.opinion2014)
    colnames(lookup.party.opinion)[colnames(lookup.party.opinion)=="party_id"] <- "CHES.party.id"
    lookup.party.opinion<-StandardizeCountries(lookup.party.opinion,lookup.countries)
    lookup.party.opinion$Country<-as.factor(lookup.party.opinion$Country)
    lookup.party.opinion<-arrange(lookup.party.opinion,Country,year)
    lookup.party.opinion<-plyr::join(lookup.party.opinion, 
                                     CHES.detail, 
                                     by = c("Country","CHES.party.id"),
                                     type="left"
    )
    if(any(is.na(lookup.party.opinion$party_name_short))) break ("Missing Short Name")
    
    #Manually consolidate entries for Partito Democratico della Sinistra; Democratici di Sinistra
    #Which use different codes in different years
    lookup.party.opinion$CHES.party.id[lookup.party.opinion$CHES.party.id==842]<-802
    
    #Manually consolidate entries for Staatkundig Gereformeerde Partij
    #Which use different codes in different years
    lookup.party.opinion$CHES.party.id[lookup.party.opinion$CHES.party.id==1006]<-1019
    
    
    lookup.party.opinion
}


ImportParlGov<-function(lookup.party.opinion,path="Data\\"){
    data.cabinet <- read.csv(paste(path, 
                                   "ParlGovCabinet.txt", 
                                   sep =""),
                             header = TRUE,
                             sep="\t",
                             encoding="UTF-8")
    colnames(data.cabinet)[colnames(data.cabinet)=="country_name"] <- "Country"
    
    lookup.countries <- read.csv(paste(path, "CountryNameStandardize.csv", sep =""), header = TRUE) 
    data.cabinet<-StandardizeCountries(data.cabinet,lookup.countries)
    data.cabinet$start_date<-as.Date(as.character(data.cabinet$start_date),format="%Y-%m-%d")
    data.cabinet$election_date<-as.Date(as.character(data.cabinet$election_date),format="%Y-%m-%d")
    colnames(data.cabinet)[colnames(data.cabinet)=="party_id"] <- "ParlGov.party.id"
    data.cabinet<-subset(data.cabinet,
                         Country %in% unique(lookup.party.opinion$Country)
    )
    data.cabinet<-subset(data.cabinet,start_date>=as.Date("1999-01-01") |
                             cabinet_id %in% subset(data.cabinet,start_date>=as.Date("1999-01-01"))$previous_cabinet_id 
    )
    data.cabinet
    
    
    
    cut2(data.cabinet$start_date,c(as.Date("2001-01-01")
                                   ,as.Date("2003-06-01")
                                   ,as.Date("2008-06-01")
                                   ,as.Date("2012-06-01")))
    
    
    parties.1999<-subset(lookup.party.opinion,year==1999)
    parties.2002<-subset(lookup.party.opinion,year==2002)
    parties.2006<-subset(lookup.party.opinion,year==2006)
    parties.2010<-subset(lookup.party.opinion,year==2010)
    parties.2007<-subset(lookup.party.opinion,year==2007)
    parties.2014<-subset(lookup.party.opinion,year==2014)
    
    CountryListTotal<-data.frame(Country=unique(lookup.party.opinion$Country))
    CountryListTotal$Category<-NA
    
    CountryList2014<-unique(parties.2014$Country)
    CountryList2007<-unique(parties.2007$Country)
    CountryList2000to2010<-unique(subset(lookup.party.opinion,!(year==2014 | year==2007))$Country)
    
    
    Country2000to2014<-CountryList2014[CountryList2014 %in% CountryList2000to2010]
    Country2014only<-CountryList2014[!CountryList2014 %in% CountryList2000to2010 & 
                                         !CountryList2014 %in% CountryList2007]
    Country2007and2014<-CountryList2014[CountryList2014 %in% CountryList2007]
    Country2007only<-CountryList2007[!CountryList2007 %in% CountryList2014]
    
    
    CountryListTotal$Category[CountryListTotal$Country %in% Country2000to2014]<-"Complete"
    CountryListTotal$Category[CountryListTotal$Country %in% Country2014only]<-"2014 only"
    CountryListTotal$Category[CountryListTotal$Country %in% Country2007only]<-"2007 only"
    CountryListTotal$Category[CountryListTotal$Country %in% Country2007and2014]<-"2007 and 2014"
    data.cabinet$Country<-as.factor(data.cabinet$Country)
    #     data.cabinet$CHESyear<-NA
    data.cabinet[data.cabinet$Country %in% CountryListTotal[CountryListTotal$Category == "Complete","Country"],"CHESyear"]<-
        as.character(cut2(data.cabinet[data.cabinet$Country %in% CountryListTotal[CountryListTotal$Category == "Complete","Country"],]$start_date,c(as.Date("2001-01-01")
                                                                                                                                                    ,as.Date("2003-06-01")
                                                                                                                                                    ,as.Date("2008-06-01")
                                                                                                                                                    ,as.Date("2012-06-01"))
        ))
    
    data.cabinet[data.cabinet$Country %in% CountryListTotal[CountryListTotal$Category == "2014 only","Country"],"CHESyear"]<-2014
    data.cabinet[data.cabinet$Country %in% CountryListTotal[CountryListTotal$Category == "2007 only","Country"],"CHESyear"]<-2007
    #Turkey isn't in the current data set
    #     data.cabinet[data.cabinet$Country %in% CountryListTotal[CountryListTotal$Category == "2007 and 2014","Country"],"CHESyear"]<-
    #         cut2(data.cabinet[data.cabinet$Country %in% CountryListTotal[CountryListTotal$Category == "2007 and 2014","Country"],]$start_date,
    #              c(as.Date("2011-01-01")))
    
    
    
    #     
    #     data.cabinet<-plyr::join(data.cabinet, CountryListTotal,
    #                                    by = c("Country"),
    #                                    type="left"
    #     )
    data.cabinet$CHESyear[data.cabinet$CHESyear=="[1995-04-13,2001-01-01)"]<-1999
    data.cabinet$CHESyear[data.cabinet$CHESyear=="[2001-01-01,2003-06-01)"]<-2002
    data.cabinet$CHESyear[data.cabinet$CHESyear=="[2003-06-01,2008-06-01)"]<-2006
    data.cabinet$CHESyear[data.cabinet$CHESyear=="[2008-06-01,2012-06-01)"]<-2010
    data.cabinet$CHESyear[data.cabinet$CHESyear=="[2012-06-01,2012-06-20]"]<-2014
    data.cabinet$CHESyear<-as.numeric(data.cabinet$CHESyear)
    unique(data.cabinet$CHESyear)
    
    ParlGovParty<- read.csv(paste(path, "ParlGovParty.txt", sep =""), 
                            header = TRUE, 
                            sep="\t",
                            encoding="UTF-8") 
    colnames(ParlGovParty)[colnames(ParlGovParty)=="chess"] <- "Recommended.CHES.party.id"
    colnames(ParlGovParty)[colnames(ParlGovParty)=="party_id"] <- "ParlGov.party.id"
    
    
    colnames(ParlGovParty)[colnames(ParlGovParty)=="party_name"] <- "Parlgov.Party.Name"
    colnames(ParlGovParty)[colnames(ParlGovParty)=="party_name_english"] <- "Parlgov.Party.Name.English"
    colnames(ParlGovParty)[colnames(ParlGovParty)=="party_name_short"] <- "Parlgov.Party.Abbrev"
    colnames(ParlGovParty)[colnames(ParlGovParty)=="country_name"] <- "Country"
    colnames(ParlGovParty)[colnames(ParlGovParty)=="left_right"] <- "Summary_left_right"
    
    ParlGovParty<-StandardizeCountries(ParlGovParty,lookup.countries)    
    
    data.cabinet<-plyr::join(data.cabinet, ParlGovParty, by = c("Country",
                                                                
                                                                "ParlGov.party.id"),type="left")
    
    if(any(xor(is.na(data.cabinet$left_right ),  
               is.na(data.cabinet$Summary_left_right))) | any(data.cabinet$left_right != data.cabinet$Summary_left_right,na.rm=TRUE)){
        break("The individual left_right value was not equal to the collective value")
    }
    #Having verified perfect matching, we can now remove redundant fields.
    data.cabinet<-data.cabinet[,names(data.cabinet)[!duplicated(names(data.cabinet))]]
    data.cabinet<-subset(data.cabinet,select=-c(Summary_left_right))
    
    
    data.cabinet
}


ImportTranslatePartyID<-function(lookup.party.opinion,
                                 data.cabinet,
                                 path="Data\\"){
    
    translate.party.id <- read.csv(paste(path, "TranslatePartyIDcompareNames.txt", sep =""), 
                                   header = TRUE, 
                                   sep="\t"
                                   #                                    ,encoding="UTF-8"
    ) 
    
    #Manually consolidate entries for Partito Democratico della Sinistra; Democratici di Sinistra
    #Which use different codes in different years
    translate.party.id$CHES.party.id[translate.party.id$CHES.party.id==842]<-802
    
    #Manually consolidate entries for Staatkundig Gereformeerde Partij
    #Which use different codes in different years
    translate.party.id$CHES.party.id[translate.party.id$CHES.party.id==1006]<-1019
    
    translate.party.id<-unique(subset(translate.party.id,
                                      select=-c(Parlgov.Party.Abbrev,
                                                Parlgov.Party.Name,
                                                Parlgov.Party.Name.English,
                                                CHES.Party.Abbrev,
                                                CHES.Party.Name,
                                                CHES.Party.Name.English)))
    
    translate.party.id<-arrange(translate.party.id,
                                Country,
                                CHES.party.id)
    
    #Add new CHES details (this rarely applies)
    #     missingCHESdetails<-subset(compare.party,is.na(CHES.Party.Abbrev) & !is.na(CHES.party.id)
    #                                ,select=-c(
    #                                    CHES.Party.Abbrev,
    #                                    CHES.Party.Name,
    #                                    CHES.Party.Name.English
    #                                ))
    #     
    #     
    #     if(nrow(missingCHESdetails)>0){
    CHES.detail<-unique(subset(lookup.party.opinion,
                               select=c(Country,
                                        CHES.party.id,
                                        CHES.Party.Abbrev,
                                        CHES.Party.Name,
                                        CHES.Party.Name.English))
    )
    #Get rid of duplicates (802/842 and 1006/1019 after consolidation)
    CHES.detail<-CHES.detail[!duplicated(CHES.detail$CHES.party.id),]
    
    translate.party.id<-plyr::join(translate.party.id,                                      
                                   CHES.detail, by = c("Country","CHES.party.id"),type="left")
    #         
    #         missingCHESdetails<-plyr::join(missingCHESdetails, CHES.detail, by = c("Country","CHES.party.id"),type="left")
    #         translate.party.id<-rbind(subset(translate.party.id,!is.na(CHES.Party.Abbrev) |  is.na(CHES.party.id)
    #                                          ),
    #                                   missingCHESdetails
    #                                   )
    #         
    #     }
    #     
    
    
    
    
    #Add new ParlGov details (this applies when new matches are made)
    #     missingParlGovdetails<-subset(translate.party.id,is.na(Parlgov.Party.Abbrev) & !is.na(ParlGov.party.id)
    #                                ,select=-c(
    #                                    Parlgov.Party.Abbrev,
    #                                    Parlgov.Party.Name,
    #                                    Parlgov.Party.Name.English
    #                                ))
    #     
    #     
    
    #Summarizing by party
    ParlGovParty<- read.csv(paste(path, "ParlGovParty.txt", sep =""), 
                            header = TRUE, 
                            sep="\t",
                            encoding="UTF-8") 
    colnames(ParlGovParty)[colnames(ParlGovParty)=="chess"] <- "Recommended.CHES.party.id"
    colnames(ParlGovParty)[colnames(ParlGovParty)=="party_id"] <- "ParlGov.party.id"
    
    colnames(ParlGovParty)[colnames(ParlGovParty)=="party_name"] <- "Parlgov.Party.Name"
    colnames(ParlGovParty)[colnames(ParlGovParty)=="party_name_english"] <- "Parlgov.Party.Name.English"
    colnames(ParlGovParty)[colnames(ParlGovParty)=="party_name_short"] <- "Parlgov.Party.Abbrev"
    colnames(ParlGovParty)[colnames(ParlGovParty)=="country_name"] <- "Country"
    lookup.countries <- read.csv(paste(path, "CountryNameStandardize.csv", sep =""), header = TRUE) 
    ParlGovParty<-StandardizeCountries(ParlGovParty,lookup.countries)    
    
    translate.party.id<-plyr::join(translate.party.id,  
                                   subset(ParlGovParty,select=c(Recommended.CHES.party.id,ParlGov.party.id)), 
                                   by = c("ParlGov.party.id"),type="left")
    
    
    
    translate.party.id<-plyr::join(translate.party.id,  
                                   subset(ParlGovParty,select=c(ParlGov.party.id,
                                                                Parlgov.Party.Abbrev,
                                                                Parlgov.Party.Name,
                                                                Parlgov.Party.Name.English
                                   )), 
                                   by = c("ParlGov.party.id"),type="left")
    
    
    
    
    #     if(nrow(missingParlGovdetails)>0){
    #         missingParlGovdetails<-plyr::join(missingParlGovdetails, ParlGov, by = c("Country","ParlGov.party.id"),type="left")
    #         translate.party.id<-rbind(subset(translate.party.id,!is.na(Parlgov.Party.Abbrev) |  is.na(ParlGov.party.id)),
    #                                          missingParlGovdetails
    #         )
    #         
    #     }
    
    
    #     translate.party.id$ParlGov.party.id[is.na(translate.party.id$ParlGov.party.id)]<-
    #         translate.party.id$Official.ParlGov.id[is.na(translate.party.id$ParlGov.party.id)]
    translate.party.id$Disagreement<-FALSE
    translate.party.id$Disagreement[translate.party.id$CHES.party.id!=
                                        translate.party.id$Recommended.CHES.party.id]<-TRUE
    
    
    #Order columns 
    translate.party.id<-unique(translate.party.id[c("Country",
                                                    "CHES.party.id",
                                                    "ParlGov.party.id",
                                                    "Recommended.CHES.party.id",
                                                    "Disagreement",
                                                    "Verified",
                                                    "Abnormalities",
                                                    "CHES.Party.Abbrev",
                                                    "Parlgov.Party.Abbrev",
                                                    "CHES.Party.Name",
                                                    "Parlgov.Party.Name",
                                                    "CHES.Party.Name.English",
                                                    "Parlgov.Party.Name.English"
    )])
    
    #Order rows
    translate.party.id<-arrange(translate.party.id,
                                CHES.party.id,
                                Country,CHES.party.id)
    
    
    
    minimal.translate<-subset(translate.party.id,select=c(CHES.party.id,ParlGov.party.id))
    repeats<-translate.party.id[!is.na(translate.party.id$ParlGov.party.id) & 
                                    translate.party.id$ParlGov.party.id %in% 
                                    unique(minimal.translate$ParlGov.party.id[duplicated(
                                        minimal.translate$ParlGov.party.id,na.rm=TRUE)]),]
    
    if(nrow(repeats)>0) stop("Repeats in TranslatePartyIDcompareNames.txt")
    
    data.cabinet.translate<-plyr::join(data.cabinet, 
                                       translate.party.id, 
                                       by = c("ParlGov.party.id"),type="left"
    )
    
    many.to.one.same.cabinet<-subset(data.cabinet.translate,!is.na(CHES.party.id)&
                                         CHES.party.id %in% 
                                         unique(data.cabinet.translate$CHES.party.id[
                                             duplicated(subset(data.cabinet.translate,select=c(CHES.party.id,
                                                                                               cabinet_id)))]))
    
    if(nrow(many.to.one.same.cabinet)>0) stop("Multiple parties associated with one CHES entry in a single cabinet")
    
    
    write.table(translate.party.id
                ,file=paste("data\\TranslatePartyIDcompareNames.txt"
                            ,sep=""
                )
                #   ,header=TRUE
                , sep="\t"
                , row.names=FALSE
                , append=FALSE
    )
    
    colnames(ParlGovParty)[colnames(ParlGovParty)=="CHES.party.id"] <- "Official.CHES.party.id"    
    ParlGovParty<-plyr::join(ParlGovParty, subset(translate.party.id,
                                                  !is.na(ParlGov.party.id),
                                                  select=c("Country",
                                                           "CHES.party.id",
                                                           "ParlGov.party.id"))
                             , by = c("Country","ParlGov.party.id"),type="left")
    
    colnames(ParlGovParty)[colnames(ParlGovParty)=="CHES.party.id"] <- "CSIS.CHES.party.id"
    
    write.table(ParlGovParty
                ,file=paste("data\\ParlGovPartyListWithCSISmatches.txt"
                            ,sep=""
                )
                #   ,header=TRUE
                , sep="\t"
                , row.names=FALSE
                , append=FALSE
    )
    
    translate.party.id
}


ImportEliteAnnual<-function(path="Data\\"){
    
    #Country Lookup
    lookup.countries <- read.csv(paste(path, "CountryNameStandardize.csv", sep =""), header = TRUE) 
    lookup.party.opinion<-ImportCHES()
    
    summary(subset(lookup.party.opinion,select=c(Country, party_name_short, CHES.party.id)))#, Logged.ParlGov.party.id
    
    
    #ParlGov
    data.cabinet<-ImportParlGov(lookup.party.opinion)
    
    #              ,]
    # View(subset(data.cabinet,is.na(CHESyear)))
    
    
    # lookup.party.opinion<-subset(lookup.party.opinion,
    #                      !Country %in% unique(data.cabinet$Country)
    # )
    
    
    data.cabinet<-ddply(data.cabinet,
                        .(Country,cabinet_id,cabinet_party,is.na(left_right)),
                        mutate,
                        CabinetShare=ifelse(cabinet_party==1 & !is.na(left_right),seats/sum(seats),0),
                        OppositionShare=ifelse(cabinet_party==0  & !is.na(left_right),seats/sum(seats),0),
                        UnlabeledParliamentShare=ifelse(is.na(left_right),seats/election_seats_total,0))
    
    
    ddply(data.cabinet,.(Country,cabinet_id,is.na(left_right)), summarise, 
          CabinetShare = sum(CabinetShare),
          OppositionShare=sum(OppositionShare))
    
    #Caretaker governments where there is no cabinet
    subset(data.cabinet,cabinet_id %in% c(1039,1045,1139))
    
    #Governments with left_right but not others. These all start pre-2000 and luckily aren't relevant for our purposes.
    subset(data.cabinet,cabinet_id %in% c(38,1099,1100,1101))
    
    
    
    
    
    
    cabinet_aggregated<-   ddply(data.cabinet,.(Country,cabinet_id), summarise, 
                                 Cab_left_right = sum(ifelse(CabinetShare>0,left_right*CabinetShare,0)),
                                 Opp_left_right = sum(ifelse(OppositionShare>0,left_right*OppositionShare,0)),
                                 Cab_liberty_authority = sum(ifelse(CabinetShare>0,liberty_authority*CabinetShare,0)),
                                 Opp_liberty_authority = sum(ifelse(OppositionShare>0,liberty_authority*OppositionShare,0)),
                                 Cab_eu_anti_pro = sum(ifelse(CabinetShare>0,eu_anti_pro*CabinetShare,0)),
                                 Opp_eu_anti_pro = sum(ifelse(OppositionShare>0,eu_anti_pro*OppositionShare,0)),
                                 CabinetChecksum=sum(CabinetShare),
                                 OppositionChecksum=sum(OppositionShare),
                                 UnlabeledParliamentShare=sum(UnlabeledParliamentShare))
    
    #Imput opposition values for the caretaker governments that do not have a cabinet
    cabinet_aggregated$CabinetChecksum[cabinet_aggregated$Cab_left_right==0 &
                                           cabinet_aggregated$CabinetChecksum==0]<-1
    
    cabinet_aggregated$Cab_left_right[cabinet_aggregated$Cab_left_right==0]<-
        cabinet_aggregated$Opp_left_right[cabinet_aggregated$Cab_left_right==0]
    cabinet_aggregated$Cab_liberty_authority[cabinet_aggregated$Cab_liberty_authority==0]<-
        cabinet_aggregated$Opp_liberty_authority[cabinet_aggregated$Cab_liberty_authority==0]
    cabinet_aggregated$Cab_eu_anti_pro[cabinet_aggregated$Cab_eu_anti_pro==0]<-
        cabinet_aggregated$Opp_eu_anti_pro[cabinet_aggregated$Cab_eu_anti_pro==0]
    
    cabinet_aggregated<-   ddply(cabinet_aggregated,.(Country,cabinet_id), mutate, 
                                 left_right_ls_spread= (Cab_left_right - Opp_left_right )^2,
                                 liberty_authority_ls_spread = (Cab_liberty_authority - Opp_liberty_authority)^2,
                                 eu_anti_pro_ls_spread = (Cab_eu_anti_pro-Opp_eu_anti_pro)^2)
    
    
    CheckSum<-subset(cabinet_aggregated,CabinetChecksum<=0.999999 | OppositionChecksum <=0.999999)
    
    if(nrow(CheckSum)>0) stop("Checksum error in production of Cabinet.Aggregated")
    
    weighted.party <- read.csv(paste(path, 
                                     "viewcalc_country_year_share.csv", 
                                     sep =""),
                               header = TRUE,
                               encoding="UTF-8")
    
    weighted.party<-subset(weighted.party,id_type=="cabinet" & 
                               id %in% data.cabinet$cabinet_id &
                               year >= 2000 &
                               year <= 2014
                           ,select=-c(id_type))
    colnames(weighted.party)[colnames(weighted.party)=="id"] <- "cabinet_id"
    colnames(weighted.party)[colnames(weighted.party)=="share"] <- "cabinet.annual.share"
    
    
    weighted.party<-plyr::join(weighted.party, 
                               cabinet_aggregated, 
                               by = c("cabinet_id"),type="left"
    )
    weighted.party<-arrange(weighted.party,Country,year)
    
    CheckSum<-subset(weighted.party,CabinetChecksum<=0.999999 | OppositionChecksum <=0.999999)
    
    if(nrow(CheckSum)>0) stop("Checksum error in production of weighted.party")
    
    
    
    
    
    elite_annual_aggregated<-   ddply(weighted.party,.(Country,year), summarise, 
                                      Cab_left_right = sum(Cab_left_right*cabinet.annual.share),
                                      Opp_left_right = sum(Opp_left_right*cabinet.annual.share),
                                      left_right_ls_spread = sum(left_right_ls_spread*cabinet.annual.share),
                                      Cab_liberty_authority = sum(Cab_liberty_authority*cabinet.annual.share),
                                      Opp_liberty_authority = sum(Opp_liberty_authority*cabinet.annual.share),
                                      liberty_authority_ls_spread = sum(liberty_authority_ls_spread*cabinet.annual.share),
                                      Cab_eu_anti_pro = sum(Cab_eu_anti_pro*cabinet.annual.share),
                                      Opp_eu_anti_pro = sum(Opp_eu_anti_pro*cabinet.annual.share),
                                      eu_anti_pro_ls_spread = sum(eu_anti_pro_ls_spread*cabinet.annual.share),
                                      CabinetChecksum=sum(CabinetChecksum*cabinet.annual.share),
                                      OppositionChecksum=sum(OppositionChecksum*cabinet.annual.share),
                                      UnlabeledParliamentShare=sum(UnlabeledParliamentShare*cabinet.annual.share))
    
    elite_annual_aggregated<-arrange(elite_annual_aggregated,Country,year)
    
    CheckSum<-subset(elite_annual_aggregated,CabinetChecksum<=0.999999 | OppositionChecksum <=0.999999)
    
    #If there are incomplete years, e.g. Croatia in 2000, mark them as NA.
    if(nrow(CheckSum)>0){
        elite_annual_aggregated[elite_annual_aggregated$CabinetChecksum<=0.999999 | 
                                    elite_annual_aggregated$OppositionChecksum <=0.999999
                                ,c("Cab_left_right",
                                   "Opp_left_right",
                                   "left_right_ls_spread",
                                   "Cab_liberty_authority",
                                   "Opp_liberty_authority",
                                   "liberty_authority_ls_spread",
                                   "Cab_eu_anti_pro",
                                   "Opp_eu_anti_pro",
                                   "eu_anti_pro_ls_spread" )]<-NA
        
        
    } 
    
    
    
    
    write.table(elite_annual_aggregated
                ,file=paste("data\\elite_annual_aggregated.csv"
                            ,sep=""
                )
                #   ,header=TRUE
                , sep=","
                , row.names=FALSE
                , append=FALSE
    )
    
    elite_annual_aggregated
}


RenameYearColumns<-function(inputDF){
    #     inputDF <- rename(inputDF, c("X2000"="2000", 
    #                                            "X2001"="2001",
    #                                            "X2002"="2002",
    #                                            "X2003"="2003",
    #                                            "X2004"="2004",
    #                                            "X2005"="2005", 
    #                                            "X2006"="2006",
    #                                            "X2007"="2007",
    #                                            "X2008"="2008",
    #                                            "X2009"="2009", 
    #                                            "X2010"="2010", 
    #                                            "X2011"="2011", 
    #                                            "X2012"="2012", 
    #                                            "X2013"="2013"))
    colnames(inputDF)[colnames(inputDF)=="X2000"] <- "2000"
    colnames(inputDF)[colnames(inputDF)=="X2001"] <- "2001"
    colnames(inputDF)[colnames(inputDF)=="X2002"] <- "2002"
    colnames(inputDF)[colnames(inputDF)=="X2003"] <- "2003"
    colnames(inputDF)[colnames(inputDF)=="X2004"] <- "2004"
    colnames(inputDF)[colnames(inputDF)=="X2005"] <- "2005"
    colnames(inputDF)[colnames(inputDF)=="X2006"] <- "2006"
    colnames(inputDF)[colnames(inputDF)=="X2007"] <- "2007"
    colnames(inputDF)[colnames(inputDF)=="X2008"] <- "2008"
    colnames(inputDF)[colnames(inputDF)=="X2009"] <- "2009"
    colnames(inputDF)[colnames(inputDF)=="X2010"] <- "2010"
    colnames(inputDF)[colnames(inputDF)=="X2011"] <- "2011"
    colnames(inputDF)[colnames(inputDF)=="X2012"] <- "2012"
    colnames(inputDF)[colnames(inputDF)=="X2013"] <- "2013"
    colnames(inputDF)[colnames(inputDF)=="X2014"] <- "2014"
    colnames(inputDF)[colnames(inputDF)=="X2015"] <- "2015"
    if("CAGR.2001.2013" %in% colnames(inputDF)) inputDF<-subset(inputDF,select=-c(CAGR.2001.2013))
    if("Selected.Countries" %in% colnames(inputDF)) inputDF<-subset(inputDF,select=-c(Selected.Countries))
    inputDF
}


StandardizeCountries<-function(inputDF,lookup.countries){
    lookup.countries$Join.Country<-toupper(lookup.countries$Join.Country)
    inputDF$Join.Country<-toupper(as.character(inputDF$Country))
    inputDF$Join.Country<-gsub("\\n", "", inputDF$Join.Country)  
    inputDF<-plyr::join(inputDF, lookup.countries, by = c("Join.Country"),type="left")
    inputDF$Country<-as.character(inputDF$Country)
    inputDF$Country[!is.na(inputDF$Country.CSIS)]<-as.character(inputDF$Country.CSIS[!is.na(inputDF$Country.CSIS)])
    subset(inputDF,select=-c(Country.CSIS,Join.Country))
}




CompilePubOpDataOmnibus <- function(path="Data\\") {
    ## start by setting up some items for later use.
    ## Namely, loading needed packages and setting a path to my files.
    require(plm)
    require(plyr)
    require(reshape2)
    require(stringr)
    
        ## Next I'm going to load all of my data. The data: in order is..
    ## public opinion, governance data from PolityIV, Terrorism data from GTD,
    ## data we compiled on conflicts and a country's membership to the EU,
    ## GDP per capita data (constant 2005 $), GDP data (also Const 2005 $), population data,
    ## data on NATO membership, spending data, and neighbor spending data.
    
    
    lookup.countries <- read.csv(paste(path, "CountryNameStandardize.csv", sep =""), header = TRUE) 
    lookup.exchange<-InputExchange(path=path)
    
    
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
    data.NATO.EU <- read.csv(paste(path, "TAT_NATO_EU_Closer.csv", sep =""), header = TRUE) 
    
    #Conflict and International Security
    data.gov <- read.csv(paste(path, "SSI_Govern.csv", sep =""), header = TRUE)
    data.ter <- read.csv(paste(path, "Terrorism Data.csv", sep =""), header = TRUE)
    data.intlcnf <- read.csv(paste(path, "SSI_IntlConfl.csv", sep =""), header = TRUE)
    data.cvlwr <- read.csv(paste(path, "SSI_CivilWar.csv", sep =""), header = TRUE)
    data.nato <- read.csv(paste(path, "SSI_NATO.csv", sep =""), header = TRUE)
    data.UNmission<-InputUNmission()
    
    
    
    
    #Macroeconomic data from World Data Indicators
    data.gdpLCU<-ProcessWDI("API_NY.GDP.MKTP.KN_DS2_en_csv_v2",
                            "GDPlcu",
                            lookup.countries,
                            path=path) #GDP, constant LCU 2005
    data.gdppcLCU <-ProcessWDI("API_NY.GDP.PCAP.KN_DS2_en_csv_v2",
                               "GDPpCapLCU",
                               lookup.countries,
                               path=path) #GDP per Capita, constant LCU
    data.gdpUSD<-ProcessWDI("API_NY.GDP.MKTP.KD_DS2_en_csv_v2",
                            "GDP2005usd",
                            lookup.countries,
                            path=path) #GDP, constant LCU 2005
    data.gdppcUSD <-ProcessWDI("API_NY.GDP.PCAP.KD_DS2_en_csv_v2",
                               "GDPpCapUSD",
                               lookup.countries,
                               path=path)
    data.deflator <-ProcessWDI("API_NY.GDP.DEFL.ZS_DS2_en_csv_v2",
                               "deflator",
                               lookup.countries,
                               path=path) #LCU deflator, variable year
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
    
    
    
    
    
    # Military Spending and Components
    data.euds <- read.csv(paste(path, "European_Total_Constant_Euros.csv", sep =""), header = TRUE)
    data.eueq <- read.csv(paste(path, "European_Equipment_Constant_Euros.csv", sep =""), header = TRUE)
    data.euinf <- read.csv(paste(path, "European_Infrastructure_Constant_Euros.csv", sep =""), header = TRUE)
    data.euoms <- read.csv(paste(path, "European_O&M_Other_Constant_Euros.csv", sep =""), header = TRUE)
    data.euper <- read.csv(paste(path, "European_Personnel_Constant_Euros.csv", sep =""), header = TRUE)
    data.eurnd <- read.csv(paste(path, "European_R&D_Constant_Euros.csv", sep =""), header = TRUE)
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
    
    
 
    # lookup.exchange<-InputExchange()
    # EuroToUSD<-subset(lookup.exchange,select=c(Year,EuroToLCU), Currency=="US.dollar")
    # colnames(EuroToUSD)[colnames(EuroToUSD)=="EuroToLCU"]<-"EuroToUSD"
    # data.gdpLCU <-plyr::join(data.gdpLCU, EuroToUSD, by = c("Year"),type="full")
    # output$GDPpCapEU<-output$GDPpCap / output$EuroToUSD
    # data.gdpLCU$GDP2005eu<-data.gdpLCU$GDP2005usd / data.gdpLCU$EuroToUSD
    
    
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
    data.NATO.EU <- melt(data.NATO.EU, id = c("NATO_EU_Closer","Year"),variable.name="Country")
    data.NATO.EU<-dcast(data.NATO.EU, Country + Year ~ NATO_EU_Closer, value.var="value")
    data.NATO.EU$Year <- as.integer(as.character(data.NATO.EU$Year))
    data.NATO.EU<-StandardizeCountries(data.NATO.EU,lookup.countries)
    data.NATO.EU$Country <- as.character(data.NATO.EU$Country)
    data.NATO.EU$NATO.EUspread<-(data.NATO.EU[,"Become closer"]-data.NATO.EU[,"Take a more independent approach"])/100
    data.NATO.EU<-subset(data.NATO.EU,select=c(Country,Year,NATO.EUspread))
    
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
    
    
    ## We need to reshape and rename the European defense spending data
    data.euds<-RenameYearColumns(data.euds)
    data.euds<-subset(data.euds,select=-c(Region,X2001.2011,X2001.2010,X2001.2013))
    data.euds <- melt(data.euds, id=c("Country", "Unit.Currency"), variable.name="Year",value.name="DefSpnd")
    data.euds$DefSpnd <- as.numeric(gsub(",","",str_trim(as.character(data.euds$DefSpnd))))
    data.euds$Year <- as.integer(as.character(data.euds$Year))
    data.euds$DefSpnd <- data.euds$DefSpnd*1000000
    data.euds<-StandardizeCountries(data.euds,lookup.countries)
    
    data.euds<-ddply(data.euds,
                     .(Country),
                     mutate,
                     DefSpendDiff=c(NA,#The first value is NA because you can't do a diff with on the first year
                                    diff(DefSpnd,
                                         lag=1,
                                         difference=1)),
                     DefSpendDelt=  Delt(DefSpnd,
                                         k=1) 
    )
    
    
    data.euds_lead<-data.euds
    data.euds_lead$Year<-data.euds_lead$Year-1
    colnames(data.euds_lead)[colnames(data.euds_lead)=="DefSpnd"] <- "DefSpnd_lead"
    colnames(data.euds_lead)[colnames(data.euds_lead)=="DefSpendDiff"] <- "DefSpendDiff_lead"
    colnames(data.euds_lead)[colnames(data.euds_lead)=="DefSpendDelt"] <- "DefSpendDelt_lead"
    data.euds <- plyr::join(data.euds, data.euds_lead, by = c("Country", "Year","Unit.Currency"),type="full")
    
    
    ## We need to reshape and rename the European equipment spending data
    data.eueq<-RenameYearColumns(data.eueq)
    data.eueq<-subset(data.eueq,select=-c(Region,X2001.2011,X2001.2010,X2001.2010))
    data.eueq <- melt(data.eueq, id=c("Country", "Unit.Currency"), variable.name="Year",value.name="EquSpnd")
    data.eueq$EquSpnd <- as.numeric(gsub(",","",str_trim(as.character(data.eueq$EquSpnd))))
    data.eueq$Year <- as.integer(as.character(data.eueq$Year))
    data.eueq$EquSpnd <- data.eueq$EquSpnd*1000000
    data.eueq<-StandardizeCountries(data.eueq,lookup.countries)
    data.eueq<-ddply(data.eueq,
                     .(Country),
                     mutate,
                     EquSpendDiff=c(NA,#The first value is NA because you can't do a diff with on the first year
                                    diff(EquSpnd,
                                         lag=1,
                                         difference=1)),
                     EquSpendDelt_lead=  Delt(EquSpnd,
                                         k=1) 
    )
    
    
    
    data.eueq_lead<-data.eueq
    data.eueq_lead$Year<-data.eueq_lead$Year-1
    colnames(data.eueq_lead)[colnames(data.eueq_lead)=="EquSpnd"] <- "EquSpnd_lead"
    colnames(data.eueq_lead)[colnames(data.eueq_lead)=="EquSpendDiff"] <- "EquSpendDiff_lead"
    colnames(data.eueq_lead)[colnames(data.eueq_lead)=="EquSpendDelt_lead"] <- "EquSpendDelt_lead"
    
    data.eueq <- plyr::join(data.eueq, data.eueq_lead, by = c("Country", "Year","Unit.Currency"),type="full")
    
    ## We need to reshape and rename the European infrastructure spending data
    data.euinf<-RenameYearColumns(data.euinf)
    data.euinf <- melt(data.euinf, id=c("Country", "Unit.Currency"), variable.name="Year",value.name="InfSpnd")
    data.euinf$InfSpnd <- as.numeric(gsub(",","",str_trim(as.character(data.euinf$InfSpnd))))
    data.euinf$Year <- as.integer(as.character(data.euinf$Year))
    data.euinf$InfSpnd <- data.euinf$InfSpnd*1000000
    data.euinf<-StandardizeCountries(data.euinf,lookup.countries)
    data.euinf_lead<-data.euinf
    data.euinf_lead$Year<-data.euinf_lead$Year-1
    colnames(data.euinf_lead)[colnames(data.euinf_lead)=="InfSpnd"] <- "InfSpnd_lead"
    data.euinf <- plyr::join(data.euinf, data.euinf_lead, by = c("Country", "Year"),type="full")
    
    ## We need to reshape and rename the European O&M and Other spending data
    data.euoms<-RenameYearColumns(data.euoms)
    
    
    data.euoms <- melt(data.euoms, id=c("Country", "Unit.Currency"), variable.name="Year",value.name="OnMspnd")
    data.euoms$OnMspnd <- as.numeric(gsub(",","",str_trim(as.character(data.euoms$OnMspnd))))
    data.euoms$Year <- as.integer(as.character(data.euoms$Year))
    data.euoms$OnMspnd <- data.euoms$OnMspnd*1000000
    data.euoms<-StandardizeCountries(data.euoms,lookup.countries)
    data.euoms<-ddply(data.euoms,
                      .(Country),
                      mutate,
                      OnMspendDiff=c(NA,#The first value is NA because you can't do a diff with on the first year
                                     diff(OnMspnd,
                                          lag=1,
                                          difference=1)),
                      OnMspendDelt_lead=  Delt(OnMspnd,
                                          k=1)
    )
    
    data.euoms_lead<-data.euoms
    data.euoms_lead$Year<-data.euoms_lead$Year-1
    colnames(data.euoms_lead)[colnames(data.euoms_lead)=="OnMspnd"] <- "OnMspnd_lead"
    colnames(data.euoms_lead)[colnames(data.euoms_lead)=="OnMspendDiff"] <- "OnMspendDiff_lead"
    colnames(data.euoms_lead)[colnames(data.euoms_lead)=="OnMspendDelt_lead"] <- "OnMspendDelt_lead"
    data.euoms <- plyr::join(data.euoms, data.euoms_lead, by = c("Country", "Year"),type="full")
    
    
    
    
    
    
    
    
    
    ## We need to reshape and rename the European personnel spending data
    data.euper<-RenameYearColumns(data.euper)
    data.euper <- melt(data.euper, id=c("Country", "Unit.Currency"), variable.name="Year",value.name="PerSpnd")
    data.euper$PerSpnd <- as.numeric(gsub(",","",str_trim(as.character(data.euper$PerSpnd))))
    data.euper$Year <- as.integer(as.character(data.euper$Year))
    data.euper$PerSpnd <- data.euper$PerSpnd*1000000
    data.euper<-StandardizeCountries(data.euper,lookup.countries)
    data.euper_lead<-data.euper
    data.euper_lead$Year<-data.euper_lead$Year-1
    colnames(data.euper_lead)[colnames(data.euper_lead)=="PerSpnd"] <- "PerSpnd_lead"
    data.euper <- plyr::join(data.euper, data.euper_lead, by = c("Country", "Year"),type="full")
    
    ## We need to reshape and rename the European R&D spending data
    data.eurnd<-RenameYearColumns(data.eurnd)
    data.eurnd <- melt(data.eurnd, id=c("Country", "Unit.Currency"), variable.name="Year",value.name="RnDspnd")
    data.eurnd$RnDspnd <- as.numeric(gsub(",","",str_trim(as.character(data.eurnd$RnDspnd))))
    data.eurnd$Year <- as.integer(as.character(data.eurnd$Year))
    data.eurnd$RnDspnd <- data.eurnd$RnDspnd*1000000
    data.eurnd<-StandardizeCountries(data.eurnd,lookup.countries)
    data.eurnd_lead<-data.eurnd
    data.eurnd_lead$Year<-data.eurnd_lead$Year-1
    colnames(data.eurnd_lead)[colnames(data.eurnd_lead)=="RnDspnd"] <- "RnDspnd_lead"
    data.eurnd <- plyr::join(data.eurnd, data.eurnd_lead, by = c("Country", "Year"),type="full")
    
    
    
    
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
    output <- plyr::join(output, data.NATO.EU, by = c("Country", "Year"),type="full")
    
    #MacroEconomic
    output <- plyr::join(output, data.gdppcLCU, by = c("Country", "Year"),type="full")
    output <- plyr::join(output, data.gdpLCU, by = c("Country", "Year"),type="full")
    output <- plyr::join(output, data.gdppcUSD, by = c("Country", "Year"),type="full")
    output <- plyr::join(output, data.gdpUSD, by = c("Country", "Year"),type="full")
    
    output <- plyr::join(output, data.CashBalance, by = c("Country", "Year"),type="full")
    output <- plyr::join(output, data.TaxRevenue, by = c("Country", "Year"),type="full")
    output <- plyr::join(output, data.population, by = c("Country", "Year"),type="full")
    output <- plyr::join(output, data.deflator, by = c("Country", "Year"),type="full")
    
    #Conflict and International Security
    output <- plyr::join(output, data.intlcnf, by = c("Country", "Year"),type="full")
    output <- plyr::join(output, data.cvlwr, by = c("Country", "Year"),type="full")
    output <- plyr::join(output, data.ally, by = c("Country", "Year"),type="full")
    output <- plyr::join(output, attacks, by = c("Country", "Year"),type="full")
    output <- plyr::join(output, data.UNmission, by = c("Country", "Year"),type="full")
    
    
    
    #Defense spending and components
    output <- plyr::join(output, data.euds, by = c("Country", "Year"),type="full")
    output <- plyr::join(output, data.eueq, by = c("Country", "Year"),type="full")
    output <- plyr::join(output, data.euinf, by = c("Country", "Year"),type="full")#80
    output <- plyr::join(output, data.euoms, by = c("Country", "Year"),type="full")
    output <- plyr::join(output, data.euper, by = c("Country", "Year"),type="full")
    output <- plyr::join(output, data.eurnd, by = c("Country", "Year"),type="full")
    output <- plyr::join(output, threatvariable, by = c("Country", "Year"),type="full")
    
    #Parliamentary Data
    output <- plyr::join(output, data.elite, by = c("Country", "Year"),type="full")
    
    #Lookups
    # EuroToUSD<-subset(lookup.exchange,select=c(Year,EuroToLCU), Currency=="US.dollar")
    # colnames(EuroToUSD)[colnames(EuroToUSD)=="EuroToLCU"]<-"EuroToUSD"
    # output <-plyr::join(output, EuroToUSD, by = c("Year"),type="full")
    
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
    output$UNmilitaryPMil<-output$AvgUNmilitary / output$Population * 1000000
    
    # output$GDPpCapEU<-output$GDPpCap / output$EuroToUSD
    # output$GDP2005eu<-output$GDP2005usd / output$EuroToUSD
    
    
    #Order the data.frame
    output<-output[order(output$Country,output$Year),]
    
    #Transform Current LCU
    output$TaxK<-(output$Tax/output$deflator)*100
    
    output<-ddply(output,
                  .(Country),
                  mutate,
                  GDPpCapLCUdiff=c(NA,#The first value is NA because you can't do a diff with on the first year
                                diff(GDPpCapLCU,
                                     lag=1,
                                     difference=1)),
                  GDP2005lcuDiff=c(NA,#The first value is NA because you can't do a diff with on the first year
                                diff(GDPlcu,
                                     lag=1,
                                     difference=1)),
                  GDPpCapUSDdiff=c(NA,#The first value is NA because you can't do a diff with on the first year
                                   diff(GDPpCapUSD,
                                        lag=1,
                                        difference=1)),
                  GDP2005usdDff=c(NA,#The first value is NA because you can't do a diff with on the first year
                                   diff(GDP2005usd,
                                        lag=1,
                                        difference=1)),
                  
                  # GDPpCapEUdiff=c(NA,#The first value is NA because you can't do a diff with on the first year
                  #                  diff(GDPpCapEU,
                  #                       lag=1,
                  #                       difference=1)),
                  # GDP2005euDiff=c(NA,#The first value is NA because you can't do a diff with on the first year
                  #                  diff(GDP2005eu,
                  #                       lag=1,
                  #                       difference=1)),
                  TaxDiff=c(NA,#The first value is NA because you can't do a diff with on the first year
                                diff(TaxK,
                                     lag=1,
                                     difference=1)),
                  PopulationDiff=c(NA,#The first value is NA because you can't do a diff with on the first year
                                   diff(Population,
                                        lag=1,
                                        difference=1))
    )
    
    output<-ddply(output,
                  .(Country),
                  mutate,
                  GDPpCapLCUdelt=as.vector(Delt(GDPpCapLCU,
                                             k=1)),            
                  GDP2005lcuDelt=as.vector(Delt(GDPlcu,
                                                k=1)),
                  GDPpCapLCUdelt=as.vector(Delt(GDPpCapUSD,
                                                k=1)),            
                  GDP2005usdDelt=as.vector(Delt(GDP2005usd,
                                                k=1)),    
                  # GDPpCapEUdelt=as.vector(Delt(GDPpCapEU,
                  #                               k=1)),            
                  # GDP2005euDelt=as.vector(Delt(GDP2005eu,
                  #                               k=1)),  
                  TaxDelt=as.vector(Delt(TaxK,
                                                 k=1)),   
                  PopulationDelt=as.vector(Delt(Population,
                                                k=1)))
    
    
    
    
    
    #Create Polling Lags
    polling_lag1<-subset(output,select=c(Country,Year,DefSpread,EUldrSpread,EUfvrSpread,NATOessSpread,NATO.EUspread))
    polling_lag1$Year<-polling_lag1$Year+1
    colnames(polling_lag1)[colnames(polling_lag1)=="DefSpread"] <- "DefSpread_lag1"
    colnames(polling_lag1)[colnames(polling_lag1)=="EUldrSpread"] <- "EUldrSpread_lag1"
    colnames(polling_lag1)[colnames(polling_lag1)=="EUfvrSpread"] <- "EUfvrSpread_lag1"
    colnames(polling_lag1)[colnames(polling_lag1)=="NATOessSpread"] <- "NATOessSpread_lag1"
    colnames(polling_lag1)[colnames(polling_lag1)=="NATO.EUspread"] <- "NATO.EUspread_lag1"
    output <- plyr::join(output, polling_lag1, by = c("Country", "Year"),type="left")
    
    polling_lag2<-subset(output,select=c(Country,Year,DefSpread,EUldrSpread,EUfvrSpread,NATOessSpread,NATO.EUspread))
    polling_lag2$Year<-polling_lag2$Year+2
    colnames(polling_lag2)[colnames(polling_lag2)=="DefSpread"] <- "DefSpread_lag2"
    colnames(polling_lag2)[colnames(polling_lag2)=="EUldrSpread"] <- "EUldrSpread_lag2"
    colnames(polling_lag2)[colnames(polling_lag2)=="EUfvrSpread"] <- "EUfvrSpread_lag2"
    colnames(polling_lag2)[colnames(polling_lag2)=="NATOessSpread"] <- "NATOessSpread_lag2"
    colnames(polling_lag2)[colnames(polling_lag2)=="NATO.EUspread"] <- "NATO.EUspread_lag2"
    output <- plyr::join(output, polling_lag2, by = c("Country", "Year"),type="left")
    
    
    
    
    output<-subset(output,Year>=min(output[!is.na(output$USldrSpread) | 
                                               !is.na(output$DefSpread) |
                                               !is.na(output$EUldrSpread) |
                                               !is.na(output$EUfvrSpread) |
                                               !is.na(output$NATOessSpread) |
                                               !is.na(output$NATO.EUspread) 
                                           ,"Year"]))
    
    
    output
} 

