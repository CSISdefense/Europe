source("EuropeInput.R")

path<-"Data\\"

#Country Lookup
lookup.countries <- read.csv(paste(path, "CountryNameStandardize.csv", sep =""), header = TRUE) 


#CHES2014
lookup.parties2014 <- read.csv(paste(path, "2014_CHES_dataset_means.csv", sep =""),
#                                stringsAsFactors=FALSE,
                               header = TRUE,
na.strings =""
                               ) 
colnames(lookup.parties2014)[colnames(lookup.parties2014)=="cname"] <- "Country"
colnames(lookup.parties2014)[colnames(lookup.parties2014)=="party_name"] <- "party_name_short"


#CHES2007 Mini-survey
lookup.parties2007 <- read.csv(paste(path, "2007_ChapelHillSurvey_Candidates_means.csv", sep =""),
                               #                                stringsAsFactors=FALSE,
                               header = TRUE,
                               na.strings =""
) 
colnames(lookup.parties2007)[colnames(lookup.parties2007)=="country"] <- "CountryNum"
colnames(lookup.parties2007)[colnames(lookup.parties2007)=="country_abb"] <- "Country"
colnames(lookup.parties2007)[colnames(lookup.parties2007)=="party"] <- "party_name_short"

#CHES 1999-2010
lookup.parties <- read.csv(paste(path, "1999-2010_CHES_dataset_means.csv", sep =""), 
                           header = TRUE, 
#                            stringsAsFactors=FALSE,
                           sep="\t",
na.strings =""
                           ) 
colnames(lookup.parties2014)[colnames(lookup.parties2014)=="country"] <- "CountryNum"
colnames(lookup.parties)[colnames(lookup.parties)=="country"] <- "Country"
colnames(lookup.parties)[colnames(lookup.parties)=="party"] <- "party_name_short"

#Merging the three CHES sources
lookup.parties<-rbind.fill(lookup.parties,lookup.parties2007)
lookup.parties<-rbind.fill(lookup.parties,lookup.parties2014)
colnames(lookup.parties)[colnames(lookup.parties)=="party_id"] <- "CSES.party.id"
lookup.parties<-StandardizeCountries(lookup.parties,lookup.countries)
arrange(lookup.parties,Country,year)
summary(subset(lookup.parties,select=c(Country, party_name_short, CSES.party.id)))#, Logged.ParlGov.party.id
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



translate.party.id <- read.csv(paste(path, "Lookup_Party_ID.csv", sep =""), header = TRUE, sep=",") 
#Translator from ParlGov to CHES
data.cabinet<-plyr::join(data.cabinet, 
                         translate.party.id, 
                         by = c("Country", "ParlGov.party.id"),type="left"
)
colnames(data.cabinet)[colnames(data.cabinet)=="CSES.party.id"] <- "Logged.CSES.party.id"
summary(data.cabinet$Logged.CSES.party.id)
#Translator from CHES to  ParlGov
lookup.parties<-plyr::join(lookup.parties, 
                         translate.party.id, 
                         by = c("Country", "CSES.party.id"),type="left"
)
colnames(lookup.parties)[colnames(lookup.parties)=="ParlGov.party.id"] <- "Logged.ParlGov.party.id"
summary(lookup.parties$Logged.ParlGov.party.id)




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

ParlGov<-unique(subset(data.cabinet,
                       select=c(Country,
                                party_name_short,
                                party_name,
                                party_name_english,
                                ParlGov.party.id))
                )


CSES<-unique(subset(lookup.parties,select=c(Country,party_name_short,CSES.party.id)))


UnmatchedParlGov<-subset(ParlGov,
                         !ParlGov$ParlGov.party.id %in% translate.party.id$ParlGov.party.id
                         )
UnmatchedCSES<-subset(CSES,
                      !CSES$CSES.party.id %in% 
                          subset(translate.party.id, is.na(ParlGov.party.id))$CSES.party.id
                      )
                          
                         
                         
AllUnmatched<-plyr::join(UnmatchedCSES, 
                         UnmatchedParlGov, 
                         by = c("Country", "party_name_short"),type="full"
                         )

# View(arrange(AllUnmatched,Country,
#              party_name_short)
#      )



Combined<-plyr::join(CSES, ParlGov,
                     by = c("Country", "party_name_short"),
                     type="left"
                     )
Combined<-subset(Combined,
                 select=c(Country,ParlGov.party.id,CSES.party.id)
                 )
summary(Combined)

subset(Combined,is.na(ParlGov.party.id))
                 
write.table(Combined
            ,file=paste("data\\Lookup_Party_ID.csv"
                        ,sep=""
            )
            #   ,header=TRUE
            , sep=","
            , row.names=FALSE
            , append=FALSE
)
