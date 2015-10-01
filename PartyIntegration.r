source("EuropeInput.R")
require(plyr)
path<-"Data\\"


#Country Lookup
lookup.countries <- read.csv(paste(path, "CountryNameStandardize.csv", sep =""), header = TRUE) 
lookup.parties<-ImportCHESlists()

summary(subset(lookup.parties,select=c(Country, party_name_short, CHES.party.id)))#, Logged.ParlGov.party.id
View(subset(lookup.parties,is.na(party_name_short)))


#ParlGov
data.cabinet <- read.csv(paste(path, "view_cabinet.csv", sep =""), header = TRUE) 
colnames(data.cabinet)[colnames(data.cabinet)=="country_name_short"] <- "Country"
data.cabinet<-StandardizeCountries(data.cabinet,lookup.countries)
data.cabinet$start_date<-as.Date(as.character(data.cabinet$start_date),format="%m/%d/%Y")
data.cabinet$election_date<-as.Date(as.character(data.cabinet$election_date),format="%m/%d/%Y")
colnames(data.cabinet)[colnames(data.cabinet)=="party_id"] <- "ParlGov.party.id"
data.cabinet<-subset(data.cabinet,
                     Country %in% unique(lookup.parties$Country)
)
data.cabinet<-subset(data.cabinet,start_date>=as.Date("1999-01-01") |
                         cabinet_id %in% subset(data.cabinet,start_date>=as.Date("1999-01-01"))$previous_cabinet_id 
)


# lookup.parties<-subset(lookup.parties,
#                      !Country %in% unique(data.cabinet$Country)
# )




translate.party.id <- read.csv(paste(path, "Lookup_Party_ID.csv", sep =""), header = TRUE, sep=",") 
translate.party.id<-arrange(translate.party.id,Country,CHES.party.id)


#Translator from ParlGov to CHES
data.cabinet<-plyr::join(data.cabinet, 
                         translate.party.id, 
                         by = c("Country", "ParlGov.party.id"),type="left"
)
colnames(data.cabinet)[colnames(data.cabinet)=="CHES.party.id"] <- "Logged.CHES.party.id"
summary(data.cabinet$Logged.CHES.party.id)
#Translator from CHES to  ParlGov
lookup.parties<-plyr::join(lookup.parties, 
                         translate.party.id, 
                         by = c("Country", "CHES.party.id"),type="left"
)
colnames(lookup.parties)[colnames(lookup.parties)=="ParlGov.party.id"] <- "Logged.ParlGov.party.id"
summary(lookup.parties$Logged.ParlGov.party.id)



#Identifying Cabinet Change years
CabinetChangeYears<-unique(subset(data.cabinet,select=c(Country,
                                                        election_date,
                                                        start_date,
                                                        cabinet_name,
                                                        caretaker,
                                                        election_id,
                                                        cabinet_id,
                                                        previous_cabinet_id))
                       )

CabinetChangeYears<-subset(CabinetChangeYears,Country %in% c("France", 
                                                             "Germany",
                                                             "Italy",
                                                             "Netherlands", 
                                                             "Poland", 
                                                             'United Kingdom',
                                                             "Spain", 
                                                             "Turkey", 
                                                             "Slovakia",
                                                             "Portugal"))

write.table(CabinetChangeYears
            ,file=paste("data\\Study_CabinetChangeYears.csv"
                        ,sep=""
            )
            #   ,header=TRUE
            , sep=","
            , row.names=FALSE
            , append=FALSE
)



cut2(data.cabinet$start_date,c(as.Date("2001-01-01")
                               ,as.Date("2003-06-01")
                               ,as.Date("2008-06-01")
                               ,as.Date("2012-06-01")))



CountryListTotal<-data.frame(Country=unique(lookup.parties$Country))
CountryListTotal$Category<-NA

CountryList2014<-unique(parties.2014$Country)
CountryList2007<-unique(parties.2007$Country)
CountryList2000to2010<-unique(subset(lookup.parties,!(year==2014 | year==2007))$Country)


Country2000to2014<-CountryList2014[CountryList2014 %in% CountryList2000to2010]
Country2014only<-CountryList2014[!CountryList2014 %in% CountryList2000to2010 & 
                                     !CountryList2014 %in% CountryList2007]
Country2007and2014<-CountryList2014[CountryList2014 %in% CountryList2007]
Country2007only<-CountryList2007[!CountryList2007 %in% CountryList2014]


CountryListTotal$Category[CountryListTotal$Country %in% Country2000to2014]<-"Complete"
CountryListTotal$Category[CountryListTotal$Country %in% Country2014only]<-"2014 only"
CountryListTotal$Category[CountryListTotal$Country %in% Country2007only]<-"2007 only"
CountryListTotal$Category[CountryListTotal$Country %in% Country2007and2014]<-"2007 and 2014"


View(CountryListTotal)




parties.1999<-subset(lookup.parties,year==1999)
parties.2002<-subset(lookup.parties,year==2002)
parties.2006<-subset(lookup.parties,year==2006)
parties.2010<-subset(lookup.parties,year==2010)
parties.2007<-subset(lookup.parties,year==2007)
parties.2014<-subset(lookup.parties,year==2014)


#Summarizing by party
ParlGov<-unique(subset(data.cabinet,
                       select=c(Country,
                                party_name_short,
                                party_name,
                                party_name_english,
                                ParlGov.party.id))
                )


CHES<-unique(subset(lookup.parties,select=c(Country,party_name_short,CHES.party.id)))
CHES<-arrange(CHES,Country,CHES.party.id)

UnmatchedParlGov<-subset(ParlGov,
                         !ParlGov$ParlGov.party.id %in% translate.party.id$ParlGov.party.id
                         )
UnmatchedCHES<-subset(CHES,
                      !CHES$CHES.party.id %in% 
                          subset(translate.party.id, is.na(ParlGov.party.id))$CHES.party.id
                      )
                          
                         
                         
AllUnmatched<-plyr::join(UnmatchedCHES, 
                         UnmatchedParlGov, 
                         by = c("Country", "party_name_short"),type="full"
                         )

AllUnmatched<-(arrange(AllUnmatched,Country,
             party_name_short)
     )


#Matching by name
Combined<-plyr::join(CHES, ParlGov,
                     by = c("Country", "party_name_short"),
                     type="left"
                     )

translate.party.id<-    FillInUncontroversialParlGov(translate.party.id,Combined)



write.table(translate.party.id
            ,file=paste("data\\Lookup_Party_ID.csv"
                        ,sep=""
            )
            #   ,header=TRUE
            , sep=","
            , row.names=FALSE
            , append=FALSE
)
