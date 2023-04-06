library(readxl)
library(tidyverse)
library(csis360)

import_eda<-function(file){
  tabs<-excel_sheets(file)
  eda<-data.frame()
  for (t in tabs ){
    d<-read_excel(file,sheet = t,na=":")
    colnames(d)[1]<-"Row"
    d$CountryName<-t
    d$PartialCollaborative<-FALSE
    if("Since 2012, collaborative expenditure data are partial as some Member States are not able to provide the data." %in% d$Row |
       "Collaborative expenditure data are partial." %in% d$Row)
      d$PartialCollaborative<-TRUE
    d<-d[!d$Row %in% c("Symbols:","\":\" - not available","Values","Notes:",t,
                       "Since 2012, collaborative expenditure data are partial as some Member States are not able to provide the data.",
                       "Collaborative expenditure data are partial.") & !is.na(d$Row),]
    eda<-rbind(eda,d)
  }
  eda
}

pivot_eda<-function(eda){
  data_cols<-colnames(eda)[!colnames(eda) %in% c("Row", "CountryName","PartialCollaborative")]
  eda<-eda %>% pivot_longer(cols=data_cols,names_to = "Year")
  eda<-eda %>% pivot_wider(id_cols = c(CountryName,Year,PartialCollaborative),names_from = "Row")
  standardize_variable_names(eda)
}

eda2021<-import_eda(file.path("Data_Raw","defence-data-2021.xlsx"))
eda2017<-import_eda(file.path("Data_Raw","eda-collective-and-national-defence-data-2005-2017e-(excel).xlsx"))
edaUK<-import_eda(file.path("Data_Raw","eda-collective-and-national-defence-data-2017-2018.xlsx")) %>%
  filter(CountryName =="United Kingdom")
eda2021<-pivot_eda(eda2021)
edaUK<-pivot_eda(edaUK)
eda<-rbind(eda2021,
           edaUK)




rm(d)

colnames(eda)
library(csis360)
eda<-standardize_variable_names(eda)
EDAexp<-eda %>% select("CountryName","Year","DefExp","DefProc","DefRnD")
EDAexp$DefOth<-EDAexp$DefExp-EDAexp$DefProc-EDAexp$DefRnD
EDAexp<-EDAexp%>%select(-DefExp)
EDAexp<-EDAexp %>% pivot_longer(cols=c(DefOth,DefProc,DefRnD), names_to = "ColorOfMoney")


EDAproc<-eda %>% select("CountryName","Year","DefProc","CollabProc","EurCollabProc")
EDAproc$NatProc<-EDAproc$DefProc-EDAproc$CollabProc
EDAproc$OtherCollabProc<-EDAproc$CollabProc-EDAproc$EurCollabProc
EDAproc$NAproc<-NA
EDAproc$NAproc[is.na(EDAproc$CollabProc)] <-EDAproc$DefProc[is.na(EDAproc$CollabProc)]
EDAproc$NAcollabProc[is.na(EDAproc$EurCollabProc)] <-EDAproc$CollabProc[is.na(EDAproc$EurCollabProc)]
EDAproc<-EDAproc%>%select(-DefProc,-CollabProc)

EDAproc<-EDAproc %>% pivot_longer(cols=c(NAproc,OtherCollabProc,EurCollabProc,NAcollabProc), names_to = "Collaboration")

colnames(eda)[colnames(eda)=="CollabRnD"]<-"CollabRnT"


EDARnT<-eda %>% select("CountryName","Year","DefRnT","CollabRnT","EurCollabRnT")
EDARnT$NatRnT<-EDARnT$DefRnT-EDARnT$CollabRnT
EDARnT$OtherCollabRnT<-EDARnT$CollabRnT-EDARnT$EurCollabRnT
EDARnT$NARnT<-NA
EDARnT$NARnT[is.na(EDARnT$CollabRnT)] <-EDARnT$DefRnT[is.na(EDARnT$CollabRnT)]
EDARnT$NAcollabRnT[is.na(EDARnT$EurCollabRnT)] <-EDARnT$CollabRnT[is.na(EDARnT$EurCollabRnT)]
EDARnT<-EDARnT%>%select(-DefRnT,-CollabRnT)

EDARnT<-EDARnT %>% pivot_longer(cols=c(NatRnT,OtherCollabRnT,EurCollabRnT,NARnT,NAcollabRnT), names_to = "Collaboration")


save(eda,EDAexp,EDAproc,EDARnT,file=file.path("data","clean","EDA.rda"))
save(eda,EDAexp,EDAproc,EDARnT,file=file.path("..","FMS","data","clean","EDA.rda"))
write.csv(eda,file=file.path("data","clean","EDA.csv"))