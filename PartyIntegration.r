source("EuropeInput.R")


path<-"Data\\"

lookup.parties2014 <- read.csv(paste(path, "2014_CHES_dataset_means.csv", sep =""), header = TRUE) 
lookup.parties <- read.csv(paste(path, "1999-2010_CHES_dataset_means.csv", sep =""), header = TRUE, sep="\t") 


lookup.party.id <- read.csv(paste(path, "Lookup_Party_ID.csv", sep =""), header = TRUE, sep=",") 

lookup.countries <- read.csv(paste(path, "CountryNameStandardize.csv", sep =""), header = TRUE) 
data.cabinet <- read.csv(paste(path, "view_cabinet.csv", sep =""), header = TRUE) 

names(data.cabinet)




ParlGov<-unique(subset(data.cabinet,select=c(country_name,party_name_short,party_name,party_name_english,party_id)))
ParlGov$Country<-ParlGov$country_name
ParlGov<-StandardizeCountries(ParlGov,lookup.countries)
colnames(ParlGov)[colnames(ParlGov)=="party_id"] <- "ParlGov.party.id"

CSES<-unique(subset(lookup.parties,select=c(country,party,party_id)))
colnames(CSES)[colnames(CSES)=="country"] <- "Country"
colnames(CSES)[colnames(CSES)=="party_id"] <- "CSES.party.id"
colnames(CSES)[colnames(CSES)=="party"] <- "party_name_short"
CSES<-StandardizeCountries(CSES,lookup.countries)


UnmatchedParlGov<-subset(ParlGov,!ParlGov$ParlGov.party.id %in% lookup.party.id$ParlGov.party.id)



Combined<-plyr::join(CSES, ParlGov, by = c("Country", "party_name_short"),type="left")
Combined<-subset(Combined,select=c(Country,ParlGov.party.id,CSES.party.id))

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



names(lookup.parties)