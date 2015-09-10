## Make sure you have installed the packages plm, plyr, and reshape
#install.packages("plm") #, repos="http://R-Forge.R-project.org")



########using US LEADER data

# install.packages("Hmisc")
# We are assuming your working directory is the source file directory https://groups.google.com/forum/?fromgroups=#!topic/knitr/knM0VWoexT0
# setwd("C:/Users/Greg Sanders/Documents/Development/Europe") #Your working directory here!
# setwd("C:/Users/scohen/My Documents/Europe1/") #Your working directory here!
source("SSIRegression.R")
require("Hmisc")
require("texreg")
# debug(CompilePubOpData)


uslead.1lag <- CompilePubOpData("SSI_US_Leader_Data.csv", lag = 1)

View(uslead.1lag)

regdat <- uslead.1lag[34:152,]

regdat$NATOally[is.na(regdat$NATOally)]<-0

# Dspend  <- regdat$DefSpnd
# ThrtR <- regdat$ThreatRatio
# IntAt <- regdat$IntAt
# DomAt <- regdat$DomAt
# CivWr <- regdat$CivilWar
# IntWr <- regdat$IntlCnf
# Pop <- regdat$Population
# GDPpC <- regdat$GDPpCap
# Dem <- regdat$democ
# NATO <- regdat$NATOally
# PubOp <- regdat$Spread

reg_df<-data.frame(
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
  Year = regdat$Year
  
)



rcorr(as.matrix(subset(reg_df,select=-c(Country,Year))))

s1 <- lm(log(Dspend) ~ PubOp, data=reg_df)
s2 <- lm(log(Dspend) ~ PubOp + ThrtR, data=reg_df)
s3 <- lm(log(Dspend) ~ PubOp + ThrtR + IntAt, data=reg_df)
s4 <- lm(log(Dspend) ~ PubOp + ThrtR + IntAt + DomAt, data=reg_df)
s5 <- lm(log(Dspend) ~ PubOp + ThrtR + IntAt + DomAt +CivWr , data=reg_df)
s6 <- lm(log(Dspend) ~ PubOp + ThrtR + IntAt + DomAt +CivWr + IntWr, data=reg_df)
s7 <- lm(log(Dspend) ~ PubOp + ThrtR + IntAt + DomAt +CivWr + IntWr + log(Pop), data=reg_df)
s8 <- lm(log(Dspend) ~ PubOp + ThrtR + IntAt + DomAt +CivWr + IntWr + log(Pop) + log(GDPpC), data=reg_df)
s9 <- lm(log(Dspend) ~ PubOp + ThrtR + IntAt + DomAt +CivWr + IntWr + log(Pop) + log(GDPpC) +Dem , data=reg_df)
s10 <- lm(log(Dspend) ~ PubOp + ThrtR + IntAt + DomAt +CivWr + IntWr + log(Pop) + log(GDPpC) +Dem +NATO , data=reg_df)

screenreg(list(s1, s2, s3, s4, s5, s6, s7, s8, s9, s10))

complete.cases(regdat)
comregdat <- regdat[complete.cases(regdat),]

View(comregdat)



uslead.1lag <- CompilePubOpData("SSI_US_Leader_Data.csv", lag = 1)

########REGRESSIONS
##load texreg
require(texreg)

regdat <- uslead.1lag[34:152,]
regdat <- comregdat

# Dspend <- regdat$DefSpnd
# ThrtR <- regdat$ThreatRatio
# IntAt <- regdat$IntAt
# DomAt <- regdat$DomAt
# CivWr <- regdat$CivilWar
# IntWr <- regdat$IntlCnf
# Pop <- regdat$Population
# GDPpC <- regdat$GDPpCap
# Dem <- regdat$democ
# NATO <- regdat$NATOally
# PubOp <- regdat$Spread


summary(reg_df$Dspend)
summary(log(reg_df$Dspend))
summary(reg_df$ThrtR)
summary(reg_df$IntAt)
summary(reg_df$DomAt)
summary(reg_df$CivWr)
summary(reg_df$IntWr)
summary(reg_df$Pop)
summary(reg_df$GDPpC)
summary(reg_df$Dem)
summary(reg_df$NATO)
summary(reg_df$PubOp)
summary(log(reg_df$Pop))
summary(log(reg_df$GDPpC))




###### MODELS: US global leadership  
####Linear Model
library(MASS)


Aresults1 <- lm(log(Dspend) ~ ThrtR + IntAt + DomAt + CivWr + IntWr + Pop + log(GDPpC) + Dem + NATO + PubOp, data = reg_df)
screenreg(list(Aresults1))


CAresults1 <- lm(log(Dspend) ~ ThrtR + IntAt + DomAt + CivWr + IntWr + Pop + log(GDPpC) + Dem + NATO + PubOp, data = reg_df[complete.cases(reg_df),])
USstep <- stepAIC(CAresults1, direction = "backward")
USstep$anova
###State Fixed Effects Model

Aresults2 <- plm(log(Dspend) ~ ThrtR + IntAt + DomAt + CivWr + IntWr + Pop + log(GDPpC) + Dem + NATO + PubOp, data=reg_df, index=c("Country", "Year"), model="within")
summary(Aresults2)
screenreg(list(Aresults1, Aresults2))

##Time Fixed Effects Model

Aresults3 <- plm(log(Dspend) ~ ThrtR + IntAt + DomAt + CivWr + IntWr + Pop + log(GDPpC) + Dem + NATO + PubOp, data=reg_df, index=c("Country", "Year"), effect="time")
summary(Aresults3)  
screenreg(list(Aresults1, Aresults2, Aresults3))

##PROBLEMS fixed and time fixed effects model returns ERROR: "Error in crossprod(t(X), beta) : non-conformable arguments"
##State fixed and time fixed effects Model
# Aresults4 <- plm(log(Dspend) ~ ThrtR + IntAt + DomAt + CivWr + IntWr + Pop + GDPpC + Dem + NATO + PubOp, data=reg_df[complete.cases(reg_df),], index=c("Country", "Year"), effect="twoways", model="within")
# summary(Aresults4)
# screenreg(list(Aresults1, Aresults2, Aresults3))


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





####Linear Model

Bresults1 <- lm(log(Dspend) ~ ThrtR + IntAt + DomAt + CivWr + IntWr + Pop + log(GDPpC) + Dem + NATO + PubOp, regdat1)
screenreg(list(Bresults1))

###State Fixed Effects Model

Bresults2 <- plm(log(Dspend) ~ ThrtR + IntAt + DomAt + CivWr + IntWr + Pop + log(GDPpC) + Dem + NATO + PubOp, data=regdat1, index=c("Country", "Year"), model="within")
summary(Bresults2)
screenreg(list(Bresults1, Bresults2))

##Time Fixed Effects Model

Bresults3 <- plm(log(Dspend) ~ ThrtR + IntAt + DomAt + CivWr + IntWr + Pop + log(GDPpC) + Dem + NATO + PubOp, data=reg_df, index=c("Country", "Year"), effect="time")
summary(Bresults3)  
screenreg(list(Bresults1, Bresults2, Bresults3))

##PROBLEMS fixed and time fixed effects model returns ERROR: "Error in crossprod(t(X), beta) : non-conformable arguments"
##State fixed and time fixed effects Model
# Bresults4 <- plm(log(Dspend) ~ ThrtR + IntAt + DomAt + CivWr + IntWr + Pop + GDPpC + Dem + NATO + PubOp, data=reg_df[complete.cases(reg_df),], index=c("Country", "Year"), effect="twoways", model="within")
# summary(Bresults4)
# screenreg(list(Bresults1, Bresults2, Bresults3))


DefSpnd_IncDec_Data.1lag
