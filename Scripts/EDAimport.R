library(readxl)
library(tidyverse)
library(csis360)


detect_footnote<-function(x, end=TRUE){
  #Note, this only catches 1-6
  if(end)
    return(substr(x,nchar(x),nchar(x)) %in% 
             c("¹","²","³","⁴","⁵",  "⁶"))
  else
    return(substr(x,1,1) %in% 
             c("¹","²","³","⁴","⁵",  "⁶"))
}

remove_footnote<-function(x){

  x[detect_footnote(x)]<-
    substr(x,1,nchar(x)-1)[detect_footnote(x)]
  str_trim(x)
}


import_eda<-function(file){
  tabs<-excel_sheets(file)
  eda<-data.frame()
  for (t in tabs ){
    d<-read_excel(file,sheet = t,na=c(":","c","e"))
    colnames(d)[1]<-"Row"
    d$CountryName<-t
    d$PartialCollaborative<-FALSE
    if("Since 2012, collaborative expenditure data are partial as some Member States are not able to provide the data." %in% d$Row |
       "¹ From 2012, collaborative expenditure data are partial as some Member States are not able to provide the data."  %in% d$Row |
       "Collaborative expenditure data are partial." %in% d$Row)
      d$PartialCollaborative<-TRUE
    d<-d[!d$Row %in% c("Symbols:","\":\" - not available","Values","Notes:",t,
                       "Since 2012, collaborative expenditure data are partial as some Member States are not able to provide the data.",
                       "¹ From 2012, collaborative expenditure data are partial as some Member States are not able to provide the data.",
                       "Collaborative expenditure data are partial.",
                       "\"c\" - confidential",
                       "\"e\" - estimated",
                       "% of Total Military Personnel" #Kludge this is data
    ) & !is.na(d$Row) & !detect_footnote(d$Row, end=FALSE),]
    eda<-rbind(eda,d)
  }
  eda$Row<-str_trim(eda$Row)
  eda
}

pivot_eda<-function(eda){
  data_cols<-colnames(eda)[!colnames(eda) %in% c("Row", "CountryName","PartialCollaborative")]
  eda<-eda %>% pivot_longer(cols=data_cols,names_to = "Year")
  eda$value<-eda$value*1000000 #Adjusting into millions Euros.
  dupes<-eda[duplicated(eda %>% select(Row, CountryName,Year,PartialCollaborative)),]
  if(nrow(dupes)>0){
    view(dupes)
    stop("Duplicates")
  }
  eda<-eda %>% pivot_wider(id_cols = c(CountryName,Year,PartialCollaborative),names_from = "Row")
  standardize_variable_names(eda)
}


eda2021<-import_eda(file.path("Data_Raw","defence-data-2021.xlsx"))
eda2017<-import_eda(file.path("Data_Raw","eda-collective-and-national-defence-data-2005-2017e-(excel).xlsx"))
edaUK<-import_eda(file.path("Data_Raw","eda-collective-and-national-defence-data-2017-2018.xlsx")) %>%
  filter(CountryName =="United Kingdom")


eda2021<-pivot_eda(eda2021)


skip2017<-c(
  "Operations Costs (Deployed)",
  "Defence Expenditure \"Outsourced\"",
  "Capital Investment \"Outsourced\"",
  "O&M \"Outsourced\"",
  "Total Civilian Personnel",
  "Total Military Personnel",
  "Army",
  "Maritime",
  "Air Force",
  "Other",
  "Other gendarmerie-type forces (optional)",
  "Defence Investment per Military",
  "Average Number of Troops Deployed",
  "Total Deployable (Land) Forces",
  "Total Sustainable (Land) Forces",
  "% of Total Deployable Forces"
)
eda2017$Row<-remove_footnote(eda2017$Row)
eda2017<-eda2017[!eda2017$Row  %in% skip2017,]
eda2017<-pivot_eda(eda2017) %>% filter(Year!="2017e")





# write.csv(colnames(eda2017),file="names.csv")
#   substr(colnames(eda2017),nchar(colnames(eda2017)),nchar(colnames(eda2017))) %in% 
#                     c("¹","²","³","⁴","⁵",  "⁶")




edaUK<-pivot_eda(edaUK)


eda<-rbind(eda2021,
           edaUK
           )

colnames(eda2021)[!colnames(eda2021) %in% colnames(eda2017)]
colnames(eda2017)[!colnames(eda2017) %in% colnames(eda2021)]

eda$DefPers<-NA
eda$DefCon<-NA
eda$DefOnM<-NA
eda$DefOth<-NA

eda<-rbind(eda2017,
           eda
)


eda$dYear<-as.Date(paste(eda$Year, "07","01",sep="-"))
EDAexp<-eda %>% select("CountryName","Year","dYear","DefExp","DefProc","DefRnD")
EDAexp$DefOth<-EDAexp$DefExp-EDAexp$DefProc-EDAexp$DefRnD
EDAexp<-EDAexp%>%select(-DefExp)
EDAexp<-EDAexp %>% pivot_longer(cols=c(DefOth,DefProc,DefRnD), names_to = "ColorOfMoney")

EDAproc<-eda %>% select("CountryName","Year","dYear","DefProc","CollabProc","EurCollabProc")
EDAproc$NatProc<-EDAproc$DefProc-EDAproc$CollabProc
EDAproc$OtherCollabProc<-EDAproc$CollabProc-EDAproc$EurCollabProc
EDAproc$NAproc<-NA
EDAproc$NAproc[is.na(EDAproc$CollabProc)] <-EDAproc$DefProc[is.na(EDAproc$CollabProc)]
EDAproc$NAcollabProc[is.na(EDAproc$EurCollabProc)] <-EDAproc$CollabProc[is.na(EDAproc$EurCollabProc)]
EDAproc<-EDAproc%>%select(-DefProc,-CollabProc)

EDAproc<-EDAproc %>% pivot_longer(cols=c(NatProc,NAproc,OtherCollabProc,EurCollabProc,NAcollabProc), names_to = "Collaboration")

colnames(eda)[colnames(eda)=="CollabRnD"]<-"CollabRnT"


colnames(eda)
EDARnD<-eda %>% select("CountryName","Year","dYear","DefRnD","DefRnT","CollabRnT","EurCollabRnT")
EDARnD$NatRnT<-EDARnD$DefRnT-EDARnD$CollabRnT
EDARnD$OtherCollabRnT<-EDARnD$CollabRnT-EDARnD$EurCollabRnT
EDARnD$NARnT<-NA
EDARnD$NARnT[is.na(EDARnD$CollabRnT)] <-EDARnD$DefRnT[is.na(EDARnD$CollabRnT)]
EDARnD$NARnD<-NA
EDARnD$NARnD[is.na(EDARnD$DefRnT)] <-EDARnD$DefRnT[is.na(EDARnD$DefRnT)]
EDARnD$OtherRnD <-EDARnD$DefRnD-EDARnD$DefRnT

EDARnD$NAcollabRnT[is.na(EDARnD$EurCollabRnT)] <-EDARnD$CollabRnT[is.na(EDARnD$EurCollabRnT)]
EDARnD<-EDARnD%>%select(-DefRnT,-CollabRnT)

EDARnT<-EDARnD %>% pivot_longer(cols=c(OtherRnD,NatRnT,OtherCollabRnT,EurCollabRnT,NARnT,NAcollabRnT,NARnD), names_to = "Collaboration")
EDARnD<-EDARnD %>% pivot_longer(cols=c(NatRnT,OtherCollabRnT,EurCollabRnT,NARnT,NAcollabRnT), names_to = "Collaboration")


save(eda,EDAexp,EDAproc,EDARnD,EDARnT,file=file.path("data","clean","EDA.rda"))
save(eda,EDAexp,EDAproc,EDARnD,EDARnT,file=file.path("..","FMS","data","clean","EDA.rda"))
write.csv(eda,file=file.path("data","clean","EDA.csv"))