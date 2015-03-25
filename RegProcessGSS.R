setwd("K:/Development/Europe") #Your working directory here!
source("SSIRegression.R")


uslead.1lag <- CompilePubOpData("SSI_US_Leader_Data.csv", lag = 1)

View(use.incdec.1lag)

regdat <- uslead.1lag[34:152,]


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


results <- lm(Dspend ~ ThrtR + IntAt + DomAt +CivWr + IntWr + log(Pop) + log(GDPpC) +Dem +NATO +PubOp)
                  
summary(results)

complete.cases(regdat)
comregdat <- regdat[complete.cases(regdat),]

View(comregdat)
