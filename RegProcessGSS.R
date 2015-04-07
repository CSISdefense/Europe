## Make sure you have installed the packages plm, plyr, and reshape
#install.packages("plm") #, repos="http://R-Forge.R-project.org")


########using US LEADER data

#install.packages("Hmisc")


setwd("K:/Development/Europe/") #Your working directory here!
source("SSIRegression.R")
require(Hmisc)
require(texreg)
require(ggplot2)

    path <- "K:/Development/Europe/" #     path <- "C:/Users/MRiley/My Documents/Europe/"

uslead.1lag <- CompilePubOpData("SSI_US_Leader_Data.csv", lag = 1)


regdat <- uslead.1lag[34:152,]

regdat$NATOally[is.na(regdat$NATOally)]<-0



leader_df<-data.frame(
  Dspend  = regdat$DefSpnd,
  ThrtR = regdat$ThreatRatio,
  IntAt = regdat$IntAt,
  DomAt = regdat$DomAt,
  CivWr = regdat$CivilWar,
  IntWr=  regdat$IntlCnf,
  Pop =  regdat$Population,
  GDPpC = regdat$GDPpCap,
  Dem = regdat$democ,
  NATO = regdat$NATOally,
  PubOp =regdat$Spread,
  Country = regdat$Country,
  Year= regdat$Year
  
)



rcorr(as.matrix(subset(leader_df,select=-c(Country,Year))))



complete.cases(leader_df)
comleader_df <- leader_df[complete.cases(leader_df),]

View(comleader_df)


summary(leader_df$Dspend)
summary(log(leader_df$Dspend))
summary(leader_df$ThrtR)
summary(leader_df$IntAt)
summary(leader_df$DomAt)
summary(leader_df$CivWr)
summary(leader_df$IntWr)
summary(leader_df$Pop)
summary(leader_df$GDPpC)
summary(leader_df$Dem)
summary(leader_df$NATO)
summary(leader_df$PubOp)
summary(log(leader_df$Pop))
summary(log(leader_df$GDPpC))




###### MODELS: US global leadership  
####Linear Model
# =======
###### MODELS: US global leadership 
## descriptive statistics 

summary(leader_df)


####Linear Model
##adding each variable individually
Cresults1 <- lm(log(Dspend) ~ PubOp, leader_df) 
Cresults2 <- lm(log(Dspend) ~ PubOp + ThrtR + IntAt, leader_df)
Cresults3 <- lm(log(Dspend) ~ PubOp + ThrtR + IntAt + DomAt, leader_df)
Cresults4 <- lm(log(Dspend) ~ PubOp + ThrtR + IntAt + DomAt + CivWr, leader_df)
Cresults5 <- lm(log(Dspend) ~ PubOp + ThrtR + IntAt + DomAt + CivWr + IntWr, leader_df)
Cresults6 <- lm(log(Dspend) ~ PubOp + ThrtR + IntAt + DomAt + CivWr + IntWr + log(Pop), leader_df)
Cresults7 <- lm(log(Dspend) ~ PubOp + ThrtR + IntAt + DomAt + CivWr + IntWr + log(Pop) + log(GDPpC), leader_df)
Cresults8 <- lm(log(Dspend) ~ PubOp + ThrtR + IntAt + DomAt + CivWr + IntWr + log(Pop) + log(GDPpC) + Dem, leader_df)
Cresults9 <- lm(log(Dspend) ~ PubOp + ThrtR + IntAt + DomAt + CivWr + IntWr + log(Pop) + log(GDPpC) + Dem + NATO, leader_df)
screenreg(list(Cresults1, Cresults2, Cresults3, Cresults4, Cresults5, Cresults6, Cresults7, Cresults8, Cresults9))

Aresults1 <- lm(log(Dspend) ~ PubOp + ThrtR + IntAt + DomAt + CivWr + IntWr + log(Pop) + log(GDPpC) + Dem + NATO, leader_df)
screenreg(list(Aresults1))

plot(Aresults1)

###State Fixed Effects Model

Aresults2 <- plm(log(Dspend) ~ PubOp + ThrtR + IntAt + DomAt + CivWr + IntWr + log(Pop) + log(GDPpC) + Dem + NATO, data=leader_df, index=c("Country", "Year"), model="within")
summary(Aresults2)
screenreg(list(Aresults1, Aresults2))

# plot(Aresults2)

##Time Fixed Effects Model

Aresults3 <- plm(log(Dspend) ~ PubOp + ThrtR + IntAt + DomAt + CivWr + IntWr + log(Pop) + log(GDPpC) + Dem + NATO, data=leader_df, index=c("Country", "Year"), effect="time")
summary(Aresults3)  
screenreg(list(Aresults1, Aresults2, Aresults3))

# plot(Aresults3)

##State fixed and time fixed effects Model
##transforming the data for state AND time fixed effects
leader_pdf <- pdata.frame(leader_df, index = c("Country", "Year"), drop.index = TRUE, row.names = TRUE)

cleader_pdf <- pdata.frame(leader_df[complete.cases(leader_df),], index = c("Country", "Year"), drop.index = TRUE, row.names = TRUE)

# Aresults4 <- plm(log(Dspend) ~ PubOp +ThrtR + IntAt + DomAt + CivWr + IntWr + log(Pop) + log(GDPpC) + Dem + NATO
#                  , data = cleader_pdf 
#                  , model = "within"
#                  , effect= "twoways")
# summary(Aresults4)
# screenreg(list(Aresults1, Aresults2, Aresults3,Aresults4))
# 
# plot(Aresults4)

############
##### MODELS: country is spending too much or too little 


DefSpnd_IncDec_Data.1lag <- CompilePubOpData("SSI_DefSpnd_IncDec.csv", lag = 1)

regdat1 <- DefSpnd_IncDec_Data.1lag[1:74,]

Dspend <- regdat1$DefSpnd
ThrtR <- regdat1$ThreatRatio
IntAt <- regdat1$IntAt
DomAt <- regdat1$DomAt
CivWr <- regdat1$CivilWar
IntWr <- regdat1$IntlCnf
Pop <- regdat1$Population
GDPpC <- regdat1$GDPpCap
Dem <- regdat1$democ
NATO <- regdat1$NATOally
PubOp <- regdat1$Spread


summary(Dspend)
summary(log(Dspend))
summary(ThrtR)
summary(IntAt)
summary(DomAt)
summary(CivWr)
summary(IntWr)
summary(Pop)
summary(GDPpC)
summary(Dem)
summary(NATO)
summary(PubOp)
summary(log(Pop))
summary(log(GDPpC))





# =======
##summary statistics


    summary(regdat1)

# complete.cases(regdat1)
# comregdat1 <- regdat[complete.cases(regdat1),]


Bresults1 <- lm(log(Dspend) ~ ThrtR + IntAt + DomAt + CivWr + IntWr + Pop + log(GDPpC) + Dem + NATO + PubOp
                , regdat1)
# =======


####Linear Model adding each variable individually 

Dresults1 <- lm(log(Dspend) ~ PubOp, regdat1) 
Dresults2 <- lm(log(Dspend) ~ PubOp + ThrtR + IntAt, regdat1)
Dresults3 <- lm(log(Dspend) ~ PubOp + ThrtR + IntAt + DomAt, regdat1)
Dresults4 <- lm(log(Dspend) ~ PubOp + ThrtR + IntAt + DomAt + CivWr, regdat1)
Dresults5 <- lm(log(Dspend) ~ PubOp + ThrtR + IntAt + DomAt + CivWr + IntWr, regdat1)
Dresults6 <- lm(log(Dspend) ~ PubOp + ThrtR + IntAt + DomAt + CivWr + IntWr + log(Pop), regdat1)
Dresults7 <- lm(log(Dspend) ~ PubOp + ThrtR + IntAt + DomAt + CivWr + IntWr + log(Pop) + log(GDPpC), regdat1)
Dresults8 <- lm(log(Dspend) ~ PubOp + ThrtR + IntAt + DomAt + CivWr + IntWr + log(Pop) + log(GDPpC) + Dem, regdat1)
Dresults9 <- lm(log(Dspend) ~ PubOp + ThrtR + IntAt + DomAt + CivWr + IntWr + log(Pop) + log(GDPpC) + Dem + NATO, regdat1)
screenreg(list(Dresults1, Dresults2, Dresults3, Dresults4, Dresults5, Dresults6, Dresults7, Dresults8, Dresults9))



Bresults1 <- lm(log(Dspend) ~ PubOp + ThrtR + IntAt + DomAt + CivWr + IntWr + log(Pop) + log(GDPpC) + Dem + NATO, regdat1)
# >>>>>>> 522e1eefcf78d4602a81c2d7756905322b1359bc
screenreg(list(Bresults1))

plot(Bresults1)

###State Fixed Effects Model

# <<<<<<< HEAD
Bresults2 <- plm(log(Dspend) ~ ThrtR + IntAt + DomAt + CivWr + IntWr + Pop + log(GDPpC) + Dem + NATO + PubOp, data=regdat1, index=c("Country", "Year"), model="within")
# =======
Bresults2 <- plm(log(Dspend) ~ PubOp + ThrtR + IntAt + DomAt + CivWr + IntWr + log(Pop) + log(GDPpC) + Dem + NATO, data=regdat1, index=c("Country", "Year"), model="within")
# >>>>>>> 522e1eefcf78d4602a81c2d7756905322b1359bc
summary(Bresults2)
screenreg(list(Bresults1, Bresults2))

# plot(Bresults2)

##Time Fixed Effects Model

# <<<<<<< HEAD
Bresults3 <- plm(log(Dspend) ~ ThrtR + IntAt + DomAt + CivWr + IntWr + Pop + log(GDPpC) + Dem + NATO + PubOp, data=regdat1, index=c("Country", "Year"), effect="time")
# =======
Bresults3 <- plm(log(Dspend) ~ PubOp + ThrtR + IntAt + DomAt + CivWr + IntWr + log(Pop) + log(GDPpC) + Dem + NATO, data=regdat1, index=c("Country", "Year"), effect="time")
# >>>>>>> 522e1eefcf78d4602a81c2d7756905322b1359bc
summary(Bresults3)  
screenreg(list(Bresults1, Bresults2, Bresults3))

# plot(Bresults3)

##PROBLEMS fixed and time fixed effects model returns ERROR: "Error in crossprod(t(X), beta) : non-conformable arguments"
##State fixed and time fixed effects Model
# <<<<<<< HEAD
Bresults4 <- plm(log(Dspend) ~ ThrtR + IntAt + DomAt + CivWr + IntWr + Pop + GDPpC + Dem + NATO + PubOp, data=regdat1, index=c("Country", "Year"), effect="twoways", model="within")
# summary(Bresults4)
screenreg(list(Bresults1, Bresults2, Bresults3))


DefSpnd_IncDec_Data.1lag
# =======
# 
# regdat3 <- pdata.frame(regdat1, index = c("Country", "Year"), drop.index = TRUE, row.names = TRUE)
# 
# Bresults4 <- plm(log(Dspend) ~ PubOp + ThrtR + IntAt + DomAt + CivWr + IntWr + log(Pop) + log(GDPpC) + Dem + NATO, data=regdat3, model="within")
# summary(Bresults4)
# screenreg(list(Bresults1, Bresults2, Bresults3, Bresults4))

# plot(Bresults4)

##showing error
# Bresults5 <- plm(log(Dspend) ~ PubOp + ThrtR + IntAt + DomAt + CivWr + IntWr + log(Pop) + log(GDPpC) + Dem + NATO, data=regdat1, index=c("Country", "Year"), model="within", effect="twoways")
# summary(Bresults5)
# >>>>>>> 522e1eefcf78d4602a81c2d7756905322b1359bc
