

setwd("K:/Development/Europe") #Your working directory here!
source("SSIRegression.R")
require("Hmisc")

uslead.1lag <- CompilePubOpData("SSI_US_Leader_Data.csv", lag = 1)

View(use.incdec.1lag)

regdat <- uslead.1lag[34:152,]

regdat$NATOally[is.na(regdat$NATOally)]<-0

Dspend  <- regdat$DefSpnd
ThrtR <- regdat$ThreatRatio
IntAt <- regdat$IntAt
DomAt <- regdat$DomAt
CivWr <- regdat$CivilWar
IntWr <- regdat$IntlCnf
Pop <- regdat$Population
GDPpC <- regdat$GDPpCap
Dem <- regdat$democ
NATO <- regdat$NATOally
PubOp <- regdat$Spread

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
    PubOp =regdat$Spread
)



rcorr(as.matrix(reg_df))

results <- lm(Dspend ~ ThrtR + IntAt + DomAt +CivWr + IntWr + log(Pop) + log(GDPpC) +Dem +NATO +PubOp)

summary(results)

complete.cases(regdat)
comregdat <- regdat[complete.cases(regdat),]

View(comregdat)
