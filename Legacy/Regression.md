

```r
# install.packages("Hmisc")
# We are assuming your working directory is the source file directory https://groups.google.com/forum/?fromgroups=#!topic/knitr/knM0VWoexT0
# setwd("C:/Users/Greg Sanders/Documents/Development/Europe") #Your working directory here!
# setwd("C:/Users/scohen/My Documents/Europe1/") #Your working directory here!
source("SSIRegression.R")
<<<<<<< HEAD
require(Hmisc)
=======
require("Hmisc")
>>>>>>> 6b369eef5855697e09f5598e18be55c8cb15c9d5
```

```
## Loading required package: Hmisc
## Loading required package: grid
## Loading required package: lattice
## Loading required package: survival
<<<<<<< HEAD
## Loading required package: splines
=======
>>>>>>> 6b369eef5855697e09f5598e18be55c8cb15c9d5
## Loading required package: Formula
## Loading required package: ggplot2
## 
## Attaching package: 'Hmisc'
## 
## The following objects are masked from 'package:base':
## 
##     format.pval, round.POSIXt, trunc.POSIXt, units
```

```r
<<<<<<< HEAD
require(texreg)
=======
require("texreg")
>>>>>>> 6b369eef5855697e09f5598e18be55c8cb15c9d5
```

```
## Loading required package: texreg
## Version:  1.34
## Date:     2014-10-31
## Author:   Philip Leifeld (University of Konstanz)
## 
## Please cite the JSS article in your publications -- see citation("texreg").
```

```r
<<<<<<< HEAD
=======
# debug(CompilePubOpData)


>>>>>>> 6b369eef5855697e09f5598e18be55c8cb15c9d5
require(MASS)
```

```
## Loading required package: MASS
```

```r
<<<<<<< HEAD
# debug(CompilePubOpData)
=======
########REGRESSIONS
##load texreg
require(texreg)
>>>>>>> 6b369eef5855697e09f5598e18be55c8cb15c9d5
```



```r
<<<<<<< HEAD
uslead.1lag <- CompilePubOpData("SSI_US_Leader_Data.csv", lag = 1)
=======
polls1lag <- CompilePubOpDataOmnibus(lag = 1)
>>>>>>> 6b369eef5855697e09f5598e18be55c8cb15c9d5
```

```
## Loading required package: plm
## Loading required package: plyr
## 
## Attaching package: 'plyr'
## 
## The following objects are masked from 'package:Hmisc':
## 
##     is.discrete, summarize
## 
## Loading required package: reshape2
```

```r
<<<<<<< HEAD
regdat <- uslead.1lag[34:152,]

regdat$NATOally[is.na(regdat$NATOally)]<-0

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
=======
# uslead.1lag <- CompilePubOpData("SSI_US_Leader_Data.csv", lag = 1)

# regdat <- uslead.1lag[34:152,]

polls1lag$NATOally[is.na(polls1lag$NATOally)]<-0



reg_df<-subset(polls1lag,select=c( DefSpnd,
                                   ThreatRatio,
                                   IntAt,
                                   DomAt,
                                   CivilWar,
                                   IntlCnf,
                                   Population,
                                   GDPpCap,
                                   democ,
                                   NATOally,
                                   DefSpread,
                                   USldrSpread,
                                   Country,
                                   Year)
               )
colnames(reg_df)[colnames(reg_df)=="DefSpnd"] <- "Dspend"
colnames(reg_df)[colnames(reg_df)=="ThreatRatio"] <- "ThrtR"
colnames(reg_df)[colnames(reg_df)=="CivilWar"] <- "CivWr"
colnames(reg_df)[colnames(reg_df)=="NATOally"] <- "NATO"
colnames(reg_df)[colnames(reg_df)=="IntlCnf"] <- "IntWr"
colnames(reg_df)[colnames(reg_df)=="Population"] <- "Pop"
colnames(reg_df)[colnames(reg_df)=="GDPpCap"] <- "GDPpC"
colnames(reg_df)[colnames(reg_df)=="democ"] <- "Dem"
colnames(reg_df)[colnames(reg_df)=="DefSpread"] <- "OpDef"
colnames(reg_df)[colnames(reg_df)=="USldrSpread"] <- "OpUSl"
names(reg_df)
```

```
##  [1] "Dspend"  "ThrtR"   "IntAt"   "DomAt"   "CivWr"   "IntWr"   "Pop"    
##  [8] "GDPpC"   "Dem"     "NATO"    "OpDef"   "OpUSl"   "Country" "Year"
>>>>>>> 6b369eef5855697e09f5598e18be55c8cb15c9d5
```


```r
rcorr(as.matrix(subset(reg_df,select=-c(Country,Year))))
```

```
<<<<<<< HEAD
##        Dspend ThrtR IntAt DomAt CivWr IntWr   Pop GDPpC   Dem  NATO PubOp
## Dspend   1.00 -0.51  0.37 -0.13 -0.17 -0.16  0.70  0.47 -0.11  0.15  0.05
## ThrtR   -0.51  1.00 -0.16 -0.14 -0.08  0.05 -0.29 -0.61  0.13  0.10  0.04
## IntAt    0.37 -0.16  1.00 -0.05  0.01 -0.11  0.26  0.13 -0.23  0.07 -0.02
## DomAt   -0.13 -0.14 -0.05  1.00  0.58  0.21  0.20 -0.30 -0.34  0.05 -0.38
## CivWr   -0.17 -0.08  0.01  0.58  1.00  0.66  0.30 -0.52 -0.80  0.06 -0.53
## IntWr   -0.16  0.05 -0.11  0.21  0.66  1.00  0.18 -0.44 -0.67  0.05 -0.37
## Pop      0.70 -0.29  0.26  0.20  0.30  0.18  1.00 -0.01 -0.38  0.28 -0.29
## GDPpC    0.47 -0.61  0.13 -0.30 -0.52 -0.44 -0.01  1.00  0.35 -0.32  0.40
## Dem     -0.11  0.13 -0.23 -0.34 -0.80 -0.67 -0.38  0.35  1.00 -0.08  0.57
## NATO     0.15  0.10  0.07  0.05  0.06  0.05  0.28 -0.32 -0.08  1.00 -0.01
## PubOp    0.05  0.04 -0.02 -0.38 -0.53 -0.37 -0.29  0.40  0.57 -0.01  1.00
## 
## n
##        Dspend ThrtR IntAt DomAt CivWr IntWr Pop GDPpC Dem NATO PubOp
## Dspend    119    95    96    96    96    96  96    96  96   96    96
## ThrtR      95   119   104   104   104   104 104   104 104  104   104
## IntAt      96   104   119   106   106   106 106   106 106  106   106
## DomAt      96   104   106   119   106   106 106   106 106  106   106
## CivWr      96   104   106   106   119   117 106   106 106  117   117
## IntWr      96   104   106   106   117   119 106   106 106  117   117
## Pop        96   104   106   106   106   106 119   106 106  106   106
## GDPpC      96   104   106   106   106   106 106   119 106  106   106
## Dem        96   104   106   106   106   106 106   106 119  106   106
## NATO       96   104   106   106   117   117 106   106 106  119   119
## PubOp      96   104   106   106   117   117 106   106 106  119   119
=======
##        Dspend ThrtR IntAt DomAt CivWr IntWr   Pop GDPpC   Dem  NATO OpDef
## Dspend   1.00 -0.51  0.37 -0.13 -0.17 -0.16  0.70  0.47 -0.11  0.15  0.06
## ThrtR   -0.51  1.00 -0.16 -0.14 -0.08  0.05 -0.29 -0.61  0.13  0.10  0.37
## IntAt    0.37 -0.16  1.00 -0.05  0.01 -0.11  0.26  0.13 -0.23  0.07  0.04
## DomAt   -0.13 -0.14 -0.05  1.00  0.58  0.21  0.20 -0.30 -0.34  0.05  0.20
## CivWr   -0.17 -0.08  0.01  0.58  1.00  0.66  0.30 -0.52 -0.80  0.06  0.21
## IntWr   -0.16  0.05 -0.11  0.21  0.66  1.00  0.18 -0.44 -0.67  0.05  0.13
## Pop      0.70 -0.29  0.26  0.20  0.30  0.18  1.00 -0.01 -0.38  0.28  0.04
## GDPpC    0.47 -0.61  0.13 -0.30 -0.52 -0.44 -0.01  1.00  0.35 -0.32 -0.26
## Dem     -0.11  0.13 -0.23 -0.34 -0.80 -0.67 -0.38  0.35  1.00 -0.16 -0.07
## NATO     0.15  0.10  0.07  0.05  0.06  0.05  0.28 -0.32 -0.16  1.00 -0.07
## OpDef    0.06  0.37  0.04  0.20  0.21  0.13  0.04 -0.26 -0.07 -0.07  1.00
## OpUSl    0.05  0.04 -0.02 -0.38 -0.53 -0.37 -0.29  0.40  0.54 -0.28 -0.06
##        OpUSl
## Dspend  0.05
## ThrtR   0.04
## IntAt  -0.02
## DomAt  -0.38
## CivWr  -0.53
## IntWr  -0.37
## Pop    -0.29
## GDPpC   0.40
## Dem     0.54
## NATO   -0.28
## OpDef  -0.06
## OpUSl   1.00
## 
## n
##        Dspend ThrtR IntAt DomAt CivWr IntWr Pop GDPpC Dem NATO OpDef OpUSl
## Dspend    163    95    96    96    96    96  96    96  96   96    51    96
## ThrtR      95   163   104   104   104   104 104   104 104  104    59   104
## IntAt      96   104   163   106   106   106 106   106 106  106    61   106
## DomAt      96   104   106   163   106   106 106   106 106  106    61   106
## CivWr      96   104   106   106   163   117 106   106 106  117    61   117
## IntWr      96   104   106   106   117   163 106   106 106  117    61   117
## Pop        96   104   106   106   106   106 163   106 106  106    61   106
## GDPpC      96   104   106   106   106   106 106   163 106  106    61   106
## Dem        96   104   106   106   106   106 106   106 163  116    66   116
## NATO       96   104   106   106   117   117 106   106 116  163    77   163
## OpDef      51    59    61    61    61    61  61    61  66   77   163    77
## OpUSl      96   104   106   106   117   117 106   106 116  163    77   163
>>>>>>> 6b369eef5855697e09f5598e18be55c8cb15c9d5
## 
## P
##        Dspend ThrtR  IntAt  DomAt  CivWr  IntWr  Pop    GDPpC  Dem   
## Dspend        0.0000 0.0002 0.1898 0.0965 0.1194 0.0000 0.0000 0.2817
## ThrtR  0.0000        0.0959 0.1635 0.4362 0.6138 0.0025 0.0000 0.1876
## IntAt  0.0002 0.0959        0.5960 0.9374 0.2799 0.0080 0.1684 0.0198
## DomAt  0.1898 0.1635 0.5960        0.0000 0.0346 0.0351 0.0020 0.0004
## CivWr  0.0965 0.4362 0.9374 0.0000        0.0000 0.0015 0.0000 0.0000
## IntWr  0.1194 0.6138 0.2799 0.0346 0.0000        0.0622 0.0000 0.0000
## Pop    0.0000 0.0025 0.0080 0.0351 0.0015 0.0622        0.8918 0.0000
## GDPpC  0.0000 0.0000 0.1684 0.0020 0.0000 0.0000 0.8918        0.0003
## Dem    0.2817 0.1876 0.0198 0.0004 0.0000 0.0000 0.0000 0.0003       
<<<<<<< HEAD
## NATO   0.1503 0.2952 0.4887 0.6112 0.5162 0.6113 0.0032 0.0010 0.4081
## PubOp  0.5980 0.6816 0.8574 0.0000 0.0000 0.0000 0.0024 0.0000 0.0000
##        NATO   PubOp 
## Dspend 0.1503 0.5980
## ThrtR  0.2952 0.6816
## IntAt  0.4887 0.8574
## DomAt  0.6112 0.0000
## CivWr  0.5162 0.0000
## IntWr  0.6113 0.0000
## Pop    0.0032 0.0024
## GDPpC  0.0010 0.0000
## Dem    0.4081 0.0000
## NATO          0.9268
## PubOp  0.9268
```

```r
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
=======
## NATO   0.1503 0.2952 0.4887 0.6112 0.5162 0.6113 0.0032 0.0010 0.0863
## OpDef  0.6865 0.0035 0.7543 0.1243 0.1023 0.3057 0.7726 0.0432 0.5997
## OpUSl  0.5980 0.6816 0.8574 0.0000 0.0000 0.0000 0.0024 0.0000 0.0000
##        NATO   OpDef  OpUSl 
## Dspend 0.1503 0.6865 0.5980
## ThrtR  0.2952 0.0035 0.6816
## IntAt  0.4887 0.7543 0.8574
## DomAt  0.6112 0.1243 0.0000
## CivWr  0.5162 0.1023 0.0000
## IntWr  0.6113 0.3057 0.0000
## Pop    0.0032 0.7726 0.0024
## GDPpC  0.0010 0.0432 0.0000
## Dem    0.0863 0.5997 0.0000
## NATO          0.5722 0.0003
## OpDef  0.5722        0.5826
## OpUSl  0.0003 0.5826
```

```r
s1 <- lm(log(Dspend) ~ OpUSl, data=reg_df)
s2 <- lm(log(Dspend) ~ OpUSl + ThrtR, data=reg_df)
s3 <- lm(log(Dspend) ~ OpUSl + ThrtR + IntAt, data=reg_df)
s4 <- lm(log(Dspend) ~ OpUSl + ThrtR + IntAt + DomAt, data=reg_df)
s5 <- lm(log(Dspend) ~ OpUSl + ThrtR + IntAt + DomAt +CivWr , data=reg_df)
s6 <- lm(log(Dspend) ~ OpUSl + ThrtR + IntAt + DomAt +CivWr + IntWr, data=reg_df)
s7 <- lm(log(Dspend) ~ OpUSl + ThrtR + IntAt + DomAt +CivWr + IntWr + log(Pop), data=reg_df)
s8 <- lm(log(Dspend) ~ OpUSl + ThrtR + IntAt + DomAt +CivWr + IntWr + log(Pop) + log(GDPpC), data=reg_df)
s9 <- lm(log(Dspend) ~ OpUSl + ThrtR + IntAt + DomAt +CivWr + IntWr + log(Pop) + log(GDPpC) +Dem , data=reg_df)
s10 <- lm(log(Dspend) ~ OpUSl + ThrtR + IntAt + DomAt +CivWr + IntWr + log(Pop) + log(GDPpC) +Dem +NATO , data=reg_df)
>>>>>>> 6b369eef5855697e09f5598e18be55c8cb15c9d5

screenreg(list(s1, s2, s3, s4, s5, s6, s7, s8, s9, s10))
```

```
## 
## =========================================================================================================================
##              Model 1    Model 2    Model 3    Model 4    Model 5    Model 6    Model 7    Model 8    Model 9    Model 10 
## -------------------------------------------------------------------------------------------------------------------------
## (Intercept)  23.71 ***  24.14 ***  24.01 ***  24.07 ***  24.07 ***  24.07 ***   4.18 ***  -2.61       2.84       2.76    
##              (0.10)     (0.11)     (0.12)     (0.13)     (0.13)     (0.13)     (0.88)     (1.43)     (1.77)     (1.80)   
<<<<<<< HEAD
## PubOp        -0.00      -0.00      -0.00      -0.00      -0.00      -0.00       0.00       0.00       0.00 **    0.00 ** 
=======
## OpUSl        -0.00      -0.00      -0.00      -0.00      -0.00      -0.00       0.00       0.00       0.00 **    0.00 ** 
>>>>>>> 6b369eef5855697e09f5598e18be55c8cb15c9d5
##              (0.00)     (0.00)     (0.00)     (0.00)     (0.00)     (0.00)     (0.00)     (0.00)     (0.00)     (0.00)   
## ThrtR                   -5.25 ***  -4.80 ***  -4.94 ***  -4.94 ***  -5.02 ***  -3.96 ***  -1.11      -1.33 *    -1.30 *  
##                         (0.91)     (0.88)     (0.90)     (0.90)     (0.92)     (0.36)     (0.59)     (0.54)     (0.55)   
## IntAt                               0.35 **    0.33 **    0.33 **    0.34 **    0.09       0.08       0.01       0.01    
##                                    (0.12)     (0.12)     (0.12)     (0.12)     (0.05)     (0.04)     (0.04)     (0.04)   
## DomAt                                         -0.01      -0.01      -0.01      -0.01 *    -0.01 *    -0.01      -0.01    
##                                               (0.01)     (0.02)     (0.02)     (0.01)     (0.01)     (0.01)     (0.01)   
## CivWr                                                    -0.28      -0.48      -0.61 **    0.11      -0.61 *    -0.60 *  
##                                                          (0.39)     (0.56)     (0.21)     (0.22)     (0.26)     (0.26)   
## IntWr                                                                0.27       0.06       0.20       0.03       0.03    
##                                                                     (0.52)     (0.20)     (0.17)     (0.16)     (0.16)   
## log(Pop)                                                                        1.14 ***   1.13 ***   1.11 ***   1.11 ***
##                                                                                (0.05)     (0.04)     (0.04)     (0.04)   
## log(GDPpC)                                                                                 0.64 ***   0.56 ***   0.57 ***
##                                                                                           (0.11)     (0.11)     (0.11)   
## Dem                                                                                                  -0.42 ***  -0.42 ***
##                                                                                                      (0.09)     (0.09)   
## NATO                                                                                                             0.07    
##                                                                                                                 (0.19)   
## -------------------------------------------------------------------------------------------------------------------------
## R^2           0.00       0.27       0.33       0.34       0.34       0.35       0.90       0.93       0.94       0.94    
## Adj. R^2     -0.01       0.25       0.31       0.31       0.31       0.30       0.90       0.92       0.94       0.94    
## Num. obs.    96         95         95         95         95         95         95         95         95         95       
## =========================================================================================================================
## *** p < 0.001, ** p < 0.01, * p < 0.05
```

```r
<<<<<<< HEAD
complete.cases(regdat)
```

```
##   [1]  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE
##  [12] FALSE FALSE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE
##  [23]  TRUE  TRUE FALSE FALSE FALSE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE
##  [34]  TRUE  TRUE  TRUE  TRUE  TRUE FALSE FALSE  TRUE  TRUE  TRUE  TRUE
##  [45]  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE FALSE FALSE  TRUE  TRUE
##  [56]  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE FALSE FALSE
##  [67]  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE FALSE
##  [78] FALSE FALSE FALSE  TRUE  TRUE FALSE FALSE  TRUE  TRUE  TRUE  TRUE
##  [89]  TRUE  TRUE  TRUE  TRUE  TRUE FALSE FALSE  TRUE  TRUE  TRUE  TRUE
## [100]  TRUE  TRUE  TRUE  TRUE FALSE FALSE FALSE  TRUE  TRUE  TRUE  TRUE
## [111]  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE FALSE FALSE
```

```r
comregdat <- regdat[complete.cases(regdat),]

summary(reg_df$Dspend)
```

```
##      Min.   1st Qu.    Median      Mean   3rd Qu.      Max.      NA's 
## 3.094e+09 1.015e+10 1.832e+10 2.911e+10 5.001e+10 7.929e+10        23
```

```r
summary(log(reg_df$Dspend))
```

```
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
##   21.85   23.04   23.63   23.71   24.64   25.10      23
```

```r
summary(reg_df$ThrtR)
```

```
##     Min.  1st Qu.   Median     Mean  3rd Qu.     Max.     NA's 
## 0.000473 0.038630 0.054910 0.081450 0.076150 0.351000       15
```

```r
summary(reg_df$IntAt)
```

```
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
##   0.000   0.000   0.000   0.283   0.000   4.000      13
```

```r
summary(reg_df$DomAt)
```

```
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
##   0.000   0.000   0.000   4.792   2.000 141.000      13
```

```r
summary(reg_df$CivWr)
```

```
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
## 0.00000 0.00000 0.00000 0.09402 0.00000 1.00000       2
```

```r
summary(reg_df$IntWr)
```

```
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
## 0.00000 0.00000 0.00000 0.05983 0.00000 1.00000       2
```

```r
summary(reg_df$Pop)
```

```
##     Min.  1st Qu.   Median     Mean  3rd Qu.     Max.     NA's 
##  9449000 38120000 58290000 48670000 64620000 82530000       13
```

```r
summary(reg_df$GDPpC)
```

```
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
##    6047   20470   34340   31780   42110   59590      13
```

```r
summary(reg_df$Dem)
=======
complete.cases(reg_df)
```

```
##   [1] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
##  [12] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
##  [23] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
##  [34]  TRUE  TRUE  TRUE FALSE FALSE FALSE  TRUE FALSE FALSE  TRUE  TRUE
##  [45] FALSE FALSE  TRUE  TRUE  TRUE FALSE FALSE FALSE  TRUE FALSE FALSE
##  [56]  TRUE  TRUE FALSE FALSE FALSE  TRUE  TRUE  TRUE FALSE FALSE FALSE
##  [67]  TRUE FALSE FALSE  TRUE  TRUE FALSE FALSE  TRUE  TRUE  TRUE FALSE
##  [78] FALSE FALSE  TRUE FALSE FALSE  TRUE  TRUE FALSE FALSE  TRUE  TRUE
##  [89]  TRUE FALSE FALSE FALSE  TRUE FALSE FALSE  TRUE  TRUE FALSE FALSE
## [100]  TRUE  TRUE FALSE FALSE FALSE  TRUE FALSE FALSE  TRUE  TRUE FALSE
## [111] FALSE FALSE FALSE  TRUE  TRUE FALSE FALSE  TRUE FALSE FALSE FALSE
## [122]  TRUE FALSE FALSE  TRUE  TRUE FALSE FALSE  TRUE FALSE FALSE FALSE
## [133]  TRUE FALSE FALSE  TRUE FALSE FALSE FALSE  TRUE  TRUE  TRUE FALSE
## [144] FALSE FALSE  TRUE FALSE FALSE  TRUE  TRUE FALSE FALSE FALSE FALSE
## [155] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
```

```r
comregdat <- reg_df[complete.cases(reg_df),]

View(comregdat)
```


```r
summary(reg_df)
```

```
##      Dspend              ThrtR             IntAt           DomAt        
##  Min.   :3.094e+09   Min.   :0.00047   Min.   :0.000   Min.   :  0.000  
##  1st Qu.:1.015e+10   1st Qu.:0.03863   1st Qu.:0.000   1st Qu.:  0.000  
##  Median :1.832e+10   Median :0.05491   Median :0.000   Median :  0.000  
##  Mean   :2.911e+10   Mean   :0.08145   Mean   :0.283   Mean   :  4.792  
##  3rd Qu.:5.001e+10   3rd Qu.:0.07615   3rd Qu.:0.000   3rd Qu.:  2.000  
##  Max.   :7.929e+10   Max.   :0.35100   Max.   :4.000   Max.   :141.000  
##  NA's   :67          NA's   :59        NA's   :57      NA's   :57       
##      CivWr             IntWr              Pop               GDPpC      
##  Min.   :0.00000   Min.   :0.00000   Min.   : 9449213   Min.   : 6047  
##  1st Qu.:0.00000   1st Qu.:0.00000   1st Qu.:38121860   1st Qu.:20473  
##  Median :0.00000   Median :0.00000   Median :58291144   Median :34343  
##  Mean   :0.09402   Mean   :0.05983   Mean   :48666674   Mean   :31783  
##  3rd Qu.:0.00000   3rd Qu.:0.00000   3rd Qu.:64619966   3rd Qu.:42106  
##  Max.   :1.00000   Max.   :1.00000   Max.   :82534176   Max.   :59593  
##  NA's   :46        NA's   :46        NA's   :57         NA's   :57     
##       Dem             NATO            OpDef            OpUSl        
##  Min.   : 8.00   Min.   :0.0000   Min.   :-51.00   Min.   :-71.000  
##  1st Qu.:10.00   1st Qu.:0.0000   1st Qu.:-28.00   1st Qu.:-20.000  
##  Median :10.00   Median :1.0000   Median :-11.00   Median :  9.000  
##  Mean   : 9.75   Mean   :0.6933   Mean   :-11.36   Mean   :  3.288  
##  3rd Qu.:10.00   3rd Qu.:1.0000   3rd Qu.:  3.00   3rd Qu.: 21.000  
##  Max.   :10.00   Max.   :1.0000   Max.   : 35.00   Max.   : 78.000  
##  NA's   :47                       NA's   :86                        
##         Country        Year     
##  EU 7       :13   Min.   :2002  
##  France     :13   1st Qu.:2006  
##  Germany    :13   Median :2009  
##  Italy      :13   Mean   :2009  
##  Netherlands:13   3rd Qu.:2012  
##  Poland     :13   Max.   :2014  
##  (Other)    :85
```

```r
summary(log(reg_df$Dspend))
>>>>>>> 6b369eef5855697e09f5598e18be55c8cb15c9d5
```

```
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
<<<<<<< HEAD
##   8.000  10.000  10.000   9.726  10.000  10.000      13
```

```r
summary(reg_df$NATO)
```

```
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
##  0.0000  1.0000  1.0000  0.9496  1.0000  1.0000
```

```r
summary(reg_df$PubOp)
```

```
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
## -71.000 -23.500   2.000  -2.824  20.000  53.000
=======
##   21.85   23.04   23.63   23.71   24.64   25.10      67
>>>>>>> 6b369eef5855697e09f5598e18be55c8cb15c9d5
```

```r
summary(log(reg_df$Pop))
```

```
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
<<<<<<< HEAD
##   16.06   17.46   17.88   17.51   17.98   18.23      13
=======
##   16.06   17.46   17.88   17.51   17.98   18.23      57
>>>>>>> 6b369eef5855697e09f5598e18be55c8cb15c9d5
```

```r
summary(log(reg_df$GDPpC))
```

```
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
<<<<<<< HEAD
##   8.707   9.927  10.440  10.220  10.650  11.000      13
```

```r
View(comregdat)
```






```r
###### MODELS: US global leadership  



Aresults1 <- lm(log(Dspend) ~ ThrtR + IntAt + DomAt + CivWr + IntWr + Pop + log(GDPpC) + Dem + NATO + PubOp, data = reg_df)
=======
##   8.707   9.927  10.440  10.220  10.650  11.000      57
```

```r
###### MODELS: US global leadership  
####Linear Model



Aresults1 <- lm(log(Dspend) ~ ThrtR + IntAt + DomAt + CivWr + IntWr + Pop + log(GDPpC) + Dem + NATO + OpUSl, data = reg_df)
>>>>>>> 6b369eef5855697e09f5598e18be55c8cb15c9d5
screenreg(list(Aresults1))
```

```
## 
## ======================
##              Model 1  
## ----------------------
## (Intercept)  19.36 ***
##              (2.15)   
## ThrtR         0.24    
##              (0.72)   
## IntAt         0.01    
##              (0.05)   
## DomAt         0.01    
##              (0.01)   
## CivWr        -0.82 *  
##              (0.34)   
## IntWr         0.07    
##              (0.21)   
## Pop           0.00 ***
##              (0.00)   
## log(GDPpC)    0.70 ***
##              (0.14)   
## Dem          -0.48 ***
##              (0.12)   
## NATO          0.41    
##              (0.24)   
<<<<<<< HEAD
## PubOp         0.00 *  
=======
## OpUSl         0.00 *  
>>>>>>> 6b369eef5855697e09f5598e18be55c8cb15c9d5
##              (0.00)   
## ----------------------
## R^2           0.90    
## Adj. R^2      0.89    
## Num. obs.    95       
## ======================
## *** p < 0.001, ** p < 0.01, * p < 0.05
```

```r
<<<<<<< HEAD
CAresults1 <- lm(log(Dspend) ~ ThrtR + IntAt + DomAt + CivWr + IntWr + Pop + log(GDPpC) + Dem + NATO + PubOp, data = reg_df[complete.cases(reg_df),])
=======
CAresults1 <- lm(log(Dspend) ~ ThrtR + IntAt + DomAt + CivWr + IntWr + Pop + log(GDPpC) + Dem + NATO + OpUSl, data = reg_df[complete.cases(reg_df),])
>>>>>>> 6b369eef5855697e09f5598e18be55c8cb15c9d5
USstep <- stepAIC(CAresults1, direction = "backward")
```

```
<<<<<<< HEAD
## Start:  AIC=-208.95
## log(Dspend) ~ ThrtR + IntAt + DomAt + CivWr + IntWr + Pop + log(GDPpC) + 
##     Dem + NATO + PubOp
## 
##              Df Sum of Sq    RSS      AIC
## - IntAt       1     0.005  8.360 -210.887
## - ThrtR       1     0.011  8.366 -210.824
## - IntWr       1     0.012  8.366 -210.817
## - DomAt       1     0.068  8.422 -210.185
## <none>                     8.355 -208.950
## - NATO        1     0.280  8.635 -207.821
## - PubOp       1     0.453  8.808 -205.935
## - CivWr       1     0.569  8.924 -204.686
## - Dem         1     1.508  9.862 -195.189
## - log(GDPpC)  1     2.406 10.760 -186.911
## - Pop         1    36.987 45.341  -50.268
## 
## Step:  AIC=-210.89
## log(Dspend) ~ ThrtR + DomAt + CivWr + IntWr + Pop + log(GDPpC) + 
##     Dem + NATO + PubOp
## 
##              Df Sum of Sq    RSS      AIC
## - IntWr       1     0.010  8.370 -212.777
## - ThrtR       1     0.011  8.371 -212.767
## - DomAt       1     0.067  8.427 -212.129
## <none>                     8.360 -210.887
## - NATO        1     0.282  8.642 -209.733
## - PubOp       1     0.473  8.833 -207.664
## - CivWr       1     0.608  8.968 -206.223
## - Dem         1     1.824 10.184 -194.139
## - log(GDPpC)  1     2.406 10.767 -188.856
## - Pop         1    37.990 46.350  -50.177
## 
## Step:  AIC=-212.78
## log(Dspend) ~ ThrtR + DomAt + CivWr + Pop + log(GDPpC) + Dem + 
##     NATO + PubOp
## 
##              Df Sum of Sq    RSS      AIC
## - ThrtR       1     0.010  8.380 -214.668
## - DomAt       1     0.072  8.442 -213.967
## <none>                     8.370 -212.777
## - NATO        1     0.278  8.648 -211.674
## - PubOp       1     0.497  8.867 -209.301
## - CivWr       1     0.607  8.977 -208.126
## - Dem         1     1.960 10.330 -194.790
## - log(GDPpC)  1     2.434 10.804 -190.524
## - Pop         1    37.988 46.358  -52.161
## 
## Step:  AIC=-214.67
## log(Dspend) ~ DomAt + CivWr + Pop + log(GDPpC) + Dem + NATO + 
##     PubOp
## 
##              Df Sum of Sq    RSS      AIC
## - DomAt       1     0.069  8.448 -215.892
## <none>                     8.380 -214.668
## - NATO        1     0.271  8.650 -213.647
## - PubOp       1     0.508  8.888 -211.073
## - CivWr       1     0.925  9.305 -206.717
## - Dem         1     1.997 10.377 -196.360
## - log(GDPpC)  1     8.038 16.418 -152.775
## - Pop         1    38.591 46.970  -52.914
## 
## Step:  AIC=-215.89
## log(Dspend) ~ CivWr + Pop + log(GDPpC) + Dem + NATO + PubOp
## 
##              Df Sum of Sq    RSS      AIC
## <none>                     8.448 -215.892
## - NATO        1     0.274  8.723 -214.856
## - PubOp       1     0.452  8.900 -212.942
## - CivWr       1     0.948  9.396 -207.793
## - Dem         1     1.978 10.426 -197.910
## - log(GDPpC)  1     8.447 16.895 -152.049
## - Pop         1    38.587 47.035  -54.783
=======
## Start:  AIC=-100.64
## log(Dspend) ~ ThrtR + IntAt + DomAt + CivWr + IntWr + Pop + log(GDPpC) + 
##     Dem + NATO + OpUSl
## 
##              Df Sum of Sq     RSS      AIC
## - IntWr       1    0.0055  4.3081 -102.576
## - IntAt       1    0.0074  4.3100 -102.555
## - ThrtR       1    0.0129  4.3155 -102.491
## - DomAt       1    0.0188  4.3214 -102.422
## <none>                     4.3026 -100.640
## - NATO        1    0.2062  4.5088 -100.300
## - CivWr       1    0.3391  4.6417  -98.847
## - OpUSl       1    0.3641  4.6667  -98.578
## - Dem         1    0.8245  5.1271  -93.874
## - log(GDPpC)  1    1.1310  5.4336  -90.971
## - Pop         1   19.7342 24.0368  -16.622
## 
## Step:  AIC=-102.58
## log(Dspend) ~ ThrtR + IntAt + DomAt + CivWr + Pop + log(GDPpC) + 
##     Dem + NATO + OpUSl
## 
##              Df Sum of Sq     RSS      AIC
## - IntAt       1    0.0061  4.3143 -104.505
## - ThrtR       1    0.0133  4.3215 -104.421
## - DomAt       1    0.0168  4.3250 -104.381
## <none>                     4.3081 -102.576
## - NATO        1    0.2022  4.5103 -102.283
## - CivWr       1    0.3354  4.6436 -100.827
## - OpUSl       1    0.3710  4.6792 -100.445
## - Dem         1    0.9067  5.2148  -95.026
## - log(GDPpC)  1    1.1571  5.4652  -92.681
## - Pop         1   19.7446 24.0528  -18.589
## 
## Step:  AIC=-104.5
## log(Dspend) ~ ThrtR + DomAt + CivWr + Pop + log(GDPpC) + Dem + 
##     NATO + OpUSl
## 
##              Df Sum of Sq     RSS      AIC
## - ThrtR       1    0.0127  4.3270 -106.357
## - DomAt       1    0.0174  4.3317 -106.303
## <none>                     4.3143 -104.505
## - NATO        1    0.2087  4.5230 -104.142
## - CivWr       1    0.3809  4.6952 -102.274
## - OpUSl       1    0.3856  4.6999 -102.224
## - log(GDPpC)  1    1.1869  5.5012  -94.353
## - Dem         1    1.2011  5.5154  -94.224
## - Pop         1   19.9562 24.2705  -20.138
## 
## Step:  AIC=-106.36
## log(Dspend) ~ DomAt + CivWr + Pop + log(GDPpC) + Dem + NATO + 
##     OpUSl
## 
##              Df Sum of Sq     RSS      AIC
## - DomAt       1    0.0179  4.3449 -108.151
## <none>                     4.3270 -106.357
## - NATO        1    0.2226  4.5496 -105.849
## - OpUSl       1    0.3846  4.7116 -104.100
## - CivWr       1    0.4074  4.7344 -103.859
## - Dem         1    1.1923  5.5193  -96.189
## - log(GDPpC)  1    4.7786  9.1056  -71.157
## - Pop         1   20.6731 25.0001  -20.657
## 
## Step:  AIC=-108.15
## log(Dspend) ~ CivWr + Pop + log(GDPpC) + Dem + NATO + OpUSl
## 
##              Df Sum of Sq     RSS      AIC
## <none>                     4.3449 -108.151
## - NATO        1    0.2255  4.5704 -107.621
## - OpUSl       1    0.4168  4.7617 -105.571
## - CivWr       1    0.4796  4.8245 -104.915
## - Dem         1    1.2697  5.6147  -97.332
## - log(GDPpC)  1    4.9809  9.3258  -71.962
## - Pop         1   20.6861 25.0311  -22.595
>>>>>>> 6b369eef5855697e09f5598e18be55c8cb15c9d5
```

```r
USstep$anova
```

```
## Stepwise Model Path 
## Analysis of Deviance Table
## 
## Initial Model:
## log(Dspend) ~ ThrtR + IntAt + DomAt + CivWr + IntWr + Pop + log(GDPpC) + 
<<<<<<< HEAD
##     Dem + NATO + PubOp
## 
## Final Model:
## log(Dspend) ~ CivWr + Pop + log(GDPpC) + Dem + NATO + PubOp
## 
## 
##      Step Df    Deviance Resid. Df Resid. Dev       AIC
## 1                               84   8.354742 -208.9495
## 2 - IntAt  1 0.005462725        85   8.360204 -210.8874
## 3 - IntWr  1 0.009711905        86   8.369916 -212.7771
## 4 - ThrtR  1 0.009603550        87   8.379520 -214.6682
## 5 - DomAt  1 0.068741291        88   8.448261 -215.8920
=======
##     Dem + NATO + OpUSl
## 
## Final Model:
## log(Dspend) ~ CivWr + Pop + log(GDPpC) + Dem + NATO + OpUSl
## 
## 
##      Step Df    Deviance Resid. Df Resid. Dev       AIC
## 1                               39   4.302604 -100.6401
## 2 - IntWr  1 0.005535075        40   4.308139 -102.5759
## 3 - IntAt  1 0.006148149        41   4.314287 -104.5045
## 4 - ThrtR  1 0.012717383        42   4.327004 -106.3574
## 5 - DomAt  1 0.017930504        43   4.344935 -108.1506
>>>>>>> 6b369eef5855697e09f5598e18be55c8cb15c9d5
```

```r
###State Fixed Effects Model

<<<<<<< HEAD
Aresults2 <- plm(log(Dspend) ~ ThrtR + IntAt + DomAt + CivWr + IntWr + Pop + log(GDPpC) + Dem + NATO + PubOp, data=reg_df, index=c("Country", "Year"), model="within")
=======
Aresults2 <- plm(log(Dspend) ~ ThrtR + IntAt + DomAt + CivWr + IntWr + Pop + log(GDPpC) + Dem + NATO + OpUSl, data=reg_df, index=c("Country", "Year"), model="within")
>>>>>>> 6b369eef5855697e09f5598e18be55c8cb15c9d5
summary(Aresults2)
```

```
## Oneway (individual) effect Within Model
## 
## Call:
## plm(formula = log(Dspend) ~ ThrtR + IntAt + DomAt + CivWr + IntWr + 
<<<<<<< HEAD
##     Pop + log(GDPpC) + Dem + NATO + PubOp, data = reg_df, model = "within", 
=======
##     Pop + log(GDPpC) + Dem + NATO + OpUSl, data = reg_df, model = "within", 
>>>>>>> 6b369eef5855697e09f5598e18be55c8cb15c9d5
##     index = c("Country", "Year"))
## 
## Unbalanced Panel: n=10, T=2-11, N=95
## 
## Residuals :
##    Min. 1st Qu.  Median 3rd Qu.    Max. 
## -0.1880 -0.0480  0.0022  0.0542  0.2020 
## 
## Coefficients :
##               Estimate  Std. Error t-value  Pr(>|t|)    
## ThrtR      -1.9536e+00  2.1609e+00 -0.9041  0.368776    
## IntAt       1.1832e-02  1.4635e-02  0.8085  0.421308    
## DomAt      -1.3565e-03  2.3796e-03 -0.5701  0.570287    
## IntWr      -5.9844e-02  6.8669e-02 -0.8715  0.386199    
## Pop        -5.6332e-08  1.1330e-08 -4.9720 3.921e-06 ***
## log(GDPpC)  4.0790e-01  7.4231e-02  5.4950 4.869e-07 ***
## Dem        -1.2311e-01  1.2815e-01 -0.9607  0.339714    
<<<<<<< HEAD
## PubOp      -1.7567e-03  5.2701e-04 -3.3334  0.001321 ** 
=======
## OpUSl      -1.7567e-03  5.2701e-04 -3.3334  0.001321 ** 
>>>>>>> 6b369eef5855697e09f5598e18be55c8cb15c9d5
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Total Sum of Squares:    1.2864
## Residual Sum of Squares: 0.55697
## R-Squared      :  0.56703 
##       Adj. R-Squared :  0.4596 
## F-statistic: 12.6054 on 8 and 77 DF, p-value: 2.156e-11
```

```r
screenreg(list(Aresults1, Aresults2))
```

```
## 
## =================================
##              Model 1    Model 2  
## ---------------------------------
## (Intercept)  19.36 ***           
##              (2.15)              
## ThrtR         0.24      -1.95    
##              (0.72)     (2.16)   
## IntAt         0.01       0.01    
##              (0.05)     (0.01)   
## DomAt         0.01      -0.00    
##              (0.01)     (0.00)   
## CivWr        -0.82 *             
##              (0.34)              
## IntWr         0.07      -0.06    
##              (0.21)     (0.07)   
## Pop           0.00 ***  -0.00 ***
##              (0.00)     (0.00)   
## log(GDPpC)    0.70 ***   0.41 ***
##              (0.14)     (0.07)   
## Dem          -0.48 ***  -0.12    
##              (0.12)     (0.13)   
## NATO          0.41               
##              (0.24)              
<<<<<<< HEAD
## PubOp         0.00 *    -0.00 ** 
=======
## OpUSl         0.00 *    -0.00 ** 
>>>>>>> 6b369eef5855697e09f5598e18be55c8cb15c9d5
##              (0.00)     (0.00)   
## ---------------------------------
## R^2           0.90       0.57    
## Adj. R^2      0.89       0.46    
## Num. obs.    95         95       
## =================================
## *** p < 0.001, ** p < 0.01, * p < 0.05
```

```r
##Time Fixed Effects Model

<<<<<<< HEAD
Aresults3 <- plm(log(Dspend) ~ ThrtR + IntAt + DomAt + CivWr + IntWr + Pop + log(GDPpC) + Dem + NATO + PubOp, data=reg_df, index=c("Country", "Year"), effect="time")
=======
Aresults3 <- plm(log(Dspend) ~ ThrtR + IntAt + DomAt + CivWr + IntWr + Pop + log(GDPpC) + Dem + NATO + OpUSl, data=reg_df, index=c("Country", "Year"), effect="time")
>>>>>>> 6b369eef5855697e09f5598e18be55c8cb15c9d5
summary(Aresults3)  
```

```
## Oneway (time) effect Within Model
## 
## Call:
## plm(formula = log(Dspend) ~ ThrtR + IntAt + DomAt + CivWr + IntWr + 
<<<<<<< HEAD
##     Pop + log(GDPpC) + Dem + NATO + PubOp, data = reg_df, effect = "time", 
=======
##     Pop + log(GDPpC) + Dem + NATO + OpUSl, data = reg_df, effect = "time", 
>>>>>>> 6b369eef5855697e09f5598e18be55c8cb15c9d5
##     index = c("Country", "Year"))
## 
## Unbalanced Panel: n=10, T=2-11, N=95
## 
## Residuals :
##     Min.  1st Qu.   Median  3rd Qu.     Max. 
## -0.59400 -0.16600  0.00297  0.14100  0.54800 
## 
## Coefficients :
##               Estimate  Std. Error t-value  Pr(>|t|)    
## ThrtR       6.1407e-01  7.2932e-01  0.8420   0.40251    
## IntAt       3.9464e-03  5.4823e-02  0.0720   0.94281    
## DomAt       1.4949e-02  6.7420e-03  2.2173   0.02967 *  
## CivWr      -6.0648e-01  3.4564e-01 -1.7546   0.08346 .  
## IntWr      -3.1676e-01  2.2228e-01 -1.4251   0.15834    
## Pop         3.2746e-08  1.5196e-09 21.5485 < 2.2e-16 ***
## log(GDPpC)  7.2261e-01  1.5579e-01  4.6383 1.482e-05 ***
## Dem        -6.2601e-01  1.2863e-01 -4.8668 6.238e-06 ***
## NATO        2.2135e-01  2.2812e-01  0.9703   0.33505    
<<<<<<< HEAD
## PubOp       9.2845e-03  2.2128e-03  4.1958 7.469e-05 ***
=======
## OpUSl       9.2845e-03  2.2128e-03  4.1958 7.469e-05 ***
>>>>>>> 6b369eef5855697e09f5598e18be55c8cb15c9d5
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Total Sum of Squares:    85.466
## Residual Sum of Squares: 5.899
## R-Squared      :  0.93098 
##       Adj. R-Squared :  0.72518 
## F-statistic: 99.8121 on 10 and 74 DF, p-value: < 2.22e-16
```

```r
screenreg(list(Aresults1, Aresults2, Aresults3))
```

```
## 
## ============================================
##              Model 1    Model 2    Model 3  
## --------------------------------------------
## (Intercept)  19.36 ***                      
##              (2.15)                         
## ThrtR         0.24      -1.95       0.61    
##              (0.72)     (2.16)     (0.73)   
## IntAt         0.01       0.01       0.00    
##              (0.05)     (0.01)     (0.05)   
## DomAt         0.01      -0.00       0.01 *  
##              (0.01)     (0.00)     (0.01)   
## CivWr        -0.82 *               -0.61    
##              (0.34)                (0.35)   
## IntWr         0.07      -0.06      -0.32    
##              (0.21)     (0.07)     (0.22)   
## Pop           0.00 ***  -0.00 ***   0.00 ***
##              (0.00)     (0.00)     (0.00)   
## log(GDPpC)    0.70 ***   0.41 ***   0.72 ***
##              (0.14)     (0.07)     (0.16)   
## Dem          -0.48 ***  -0.12      -0.63 ***
##              (0.12)     (0.13)     (0.13)   
## NATO          0.41                  0.22    
##              (0.24)                (0.23)   
<<<<<<< HEAD
## PubOp         0.00 *    -0.00 **    0.01 ***
=======
## OpUSl         0.00 *    -0.00 **    0.01 ***
>>>>>>> 6b369eef5855697e09f5598e18be55c8cb15c9d5
##              (0.00)     (0.00)     (0.00)   
## --------------------------------------------
## R^2           0.90       0.57       0.93    
## Adj. R^2      0.89       0.46       0.73    
## Num. obs.    95         95         95       
## ============================================
## *** p < 0.001, ** p < 0.01, * p < 0.05
```

```r
##PROBLEMS fixed and time fixed effects model returns ERROR: "Error in crossprod(t(X), beta) : non-conformable arguments"
##State fixed and time fixed effects Model
<<<<<<< HEAD
# Aresults4 <- plm(log(Dspend) ~ ThrtR + IntAt + DomAt + CivWr + IntWr + Pop + GDPpC + Dem + NATO + PubOp, data=reg_df[complete.cases(reg_df),], index=c("Country", "Year"), effect="twoways", model="within")
# summary(Aresults4)
# screenreg(list(Aresults1, Aresults2, Aresults3))


############
##### MODELS: country is spending too much or too little 
```


```r
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
```

```
##      Min.   1st Qu.    Median      Mean   3rd Qu.      Max.      NA's 
## 7.189e+08 5.170e+09 1.401e+10 2.373e+10 4.207e+10 6.771e+10        13
```

```r
summary(log(Dspend))
```

```
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
##   20.39   22.37   23.36   23.23   24.46   24.94      13
```

```r
summary(ThrtR)
```

```
##      Min.   1st Qu.    Median      Mean   3rd Qu.      Max.      NA's 
## 0.0004729 0.0396600 0.0573600 0.1256000 0.0830900 0.8880000         3
```

```r
summary(IntAt)
```

```
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
##  0.0000  0.0000  0.0000  0.3088  0.0000  4.0000       6
```

```r
summary(DomAt)
```

```
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
##   0.000   0.000   0.000   4.956   1.250 141.000       6
```

```r
summary(CivWr)
```

```
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
## 0.00000 0.00000 0.00000 0.08219 0.00000 1.00000       1
```

```r
summary(IntWr)
```

```
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
##  0.0000  0.0000  0.0000  0.0411  0.0000  1.0000       1
```

```r
summary(Pop)
```

```
##      Min.   1st Qu.    Median      Mean   3rd Qu.      Max. 
##   5372000  16240000  46300000  43230000  63590000 143200000
```

```r
summary(GDPpC)
```

```
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
##    6047   13650   30150   28630   40510   59590
```

```r
summary(Dem)
```

```
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
##   5.000   9.000  10.000   9.635  10.000  10.000
```

```r
summary(NATO)
```

```
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
##       1       1       1       1       1       1       4
```

```r
summary(PubOp)
```

```
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
##  -51.00  -30.00  -11.50  -11.68    3.00   35.00
```

```r
summary(log(Pop))
```

```
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
##   15.50   16.60   17.65   17.26   17.97   18.78
```

```r
summary(log(GDPpC))
```

```
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
##   8.707   9.521  10.310  10.080  10.610  11.000
```






```r
####Linear Model

Bresults1 <- lm(log(Dspend) ~ ThrtR + IntAt + DomAt + CivWr + IntWr + Pop + log(GDPpC) + Dem + NATO + PubOp, regdat1)
=======
# Aresults4 <- plm(log(Dspend) ~ ThrtR + IntAt + DomAt + CivWr + IntWr + Pop + GDPpC + Dem + NATO + OpUSl, data=reg_df[complete.cases(reg_df),], index=c("Country", "Year"), effect="twoways", model="within")
# summary(Aresults4)
# screenreg(list(Aresults1, Aresults2, Aresults3))
```




```r
############
##### MODELS: country is spending too much or too little 


####Linear Model

Bresults1 <- lm(log(Dspend) ~ ThrtR + IntAt + DomAt + CivWr + IntWr + Pop + log(GDPpC) + Dem + NATO + OpDef, reg_df)
>>>>>>> 6b369eef5855697e09f5598e18be55c8cb15c9d5
screenreg(list(Bresults1))
```

```
## 
## ======================
##              Model 1  
## ----------------------
<<<<<<< HEAD
## (Intercept)  15.70 ***
##              (1.62)   
## ThrtR        -1.18 ** 
##              (0.36)   
## IntAt         0.05    
##              (0.06)   
## DomAt        -0.01    
##              (0.01)   
## CivWr        -0.40    
##              (0.29)   
## IntWr         0.39    
##              (0.24)   
## Pop           0.00 ***
##              (0.00)   
## log(GDPpC)    0.78 ***
##              (0.12)   
## Dem          -0.14    
##              (0.13)   
## PubOp         0.01 ***
##              (0.00)   
## ----------------------
## R^2           0.95    
## Adj. R^2      0.93    
## Num. obs.    54       
=======
## (Intercept)  18.78 ***
##              (2.52)   
## ThrtR        -0.93    
##              (0.90)   
## IntAt         0.02    
##              (0.06)   
## DomAt        -0.01    
##              (0.01)   
## CivWr        -0.52    
##              (0.43)   
## IntWr         0.03    
##              (0.27)   
## Pop           0.00 ***
##              (0.00)   
## log(GDPpC)    0.67 ***
##              (0.17)   
## Dem          -0.38 *  
##              (0.15)   
## NATO          0.51 *  
##              (0.25)   
## OpDef         0.01 ***
##              (0.00)   
## ----------------------
## R^2           0.93    
## Adj. R^2      0.91    
## Num. obs.    50       
>>>>>>> 6b369eef5855697e09f5598e18be55c8cb15c9d5
## ======================
## *** p < 0.001, ** p < 0.01, * p < 0.05
```

```r
###State Fixed Effects Model

<<<<<<< HEAD
Bresults2 <- plm(log(Dspend) ~ ThrtR + IntAt + DomAt + CivWr + IntWr + Pop + log(GDPpC) + Dem + NATO + PubOp, data=regdat1, index=c("Country", "Year"), model="within")
```

```
## series NATOally is constant and has been removed
```

```r
=======
Bresults2 <- plm(log(Dspend) ~ ThrtR + IntAt + DomAt + CivWr + IntWr + Pop + log(GDPpC) + Dem + NATO + OpDef, data=reg_df, index=c("Country", "Year"), model="within")
>>>>>>> 6b369eef5855697e09f5598e18be55c8cb15c9d5
summary(Bresults2)
```

```
## Oneway (individual) effect Within Model
## 
## Call:
## plm(formula = log(Dspend) ~ ThrtR + IntAt + DomAt + CivWr + IntWr + 
<<<<<<< HEAD
##     Pop + log(GDPpC) + Dem + NATO + PubOp, data = regdat1, model = "within", 
##     index = c("Country", "Year"))
## 
## Unbalanced Panel: n=12, T=2-6, N=56
## 
## Residuals :
##      Min.   1st Qu.    Median   3rd Qu.      Max. 
## -2.58e-01 -7.63e-02  1.46e-15  7.13e-02  3.53e-01 
## 
## Coefficients :
##               Estimate  Std. Error t-value Pr(>|t|)  
## ThrtR      -6.5693e-01  2.1138e+00 -0.3108  0.75781  
## IntAt      -1.5240e-02  3.2997e-02 -0.4619  0.64704  
## DomAt      -3.3798e-02  1.4944e-02 -2.2616  0.03004 *
## CivWr      -2.9786e-02  2.0314e-01 -0.1466  0.88427  
## IntWr      -1.4156e-01  1.8817e-01 -0.7523  0.45690  
## Pop         3.5814e-08  1.4484e-08  2.4726  0.01842 *
## log(GDPpC)  2.6664e-01  1.3853e-01  1.9248  0.06241 .
## Dem        -3.9560e-02  3.8692e-01 -0.1022  0.91915  
## PubOp       1.8684e-03  1.7718e-03  1.0545  0.29887  
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Total Sum of Squares:    8.3019
## Residual Sum of Squares: 0.90118
## R-Squared      :  0.89145 
##       Adj. R-Squared :  0.55716 
## F-statistic: 31.9366 on 9 and 35 DF, p-value: 2.6667e-14
=======
##     Pop + log(GDPpC) + Dem + NATO + OpDef, data = reg_df, model = "within", 
##     index = c("Country", "Year"))
## 
## Unbalanced Panel: n=10, T=2-6, N=50
## 
## Residuals :
##     Min.  1st Qu.   Median  3rd Qu.     Max. 
## -0.15800 -0.04000  0.00322  0.03940  0.17100 
## 
## Coefficients :
##               Estimate  Std. Error t-value  Pr(>|t|)    
## ThrtR      -2.3386e+00  3.3844e+00 -0.6910 0.4945615    
## IntAt       2.6435e-02  2.0455e-02  1.2923 0.2054920    
## DomAt      -1.5723e-03  3.7279e-03 -0.4218 0.6760092    
## IntWr      -6.9310e-02  1.1250e-01 -0.6161 0.5421971    
## Pop        -6.3863e-08  1.4817e-08 -4.3101 0.0001455 ***
## log(GDPpC)  4.0116e-01  9.7145e-02  4.1295 0.0002431 ***
## Dem        -7.2601e-02  1.8659e-01 -0.3891 0.6997837    
## OpDef       1.6132e-03  1.1214e-03  1.4386 0.1599634    
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Total Sum of Squares:    0.69623
## Residual Sum of Squares: 0.29128
## R-Squared      :  0.58163 
##       Adj. R-Squared :  0.37225 
## F-statistic: 5.56103 on 8 and 32 DF, p-value: 0.00019103
>>>>>>> 6b369eef5855697e09f5598e18be55c8cb15c9d5
```

```r
screenreg(list(Bresults1, Bresults2))
```

```
## 
<<<<<<< HEAD
## ===============================
##              Model 1    Model 2
## -------------------------------
## (Intercept)  15.70 ***         
##              (1.62)            
## ThrtR        -1.18 **   -0.66  
##              (0.36)     (2.11) 
## IntAt         0.05      -0.02  
##              (0.06)     (0.03) 
## DomAt        -0.01      -0.03 *
##              (0.01)     (0.01) 
## CivWr        -0.40      -0.03  
##              (0.29)     (0.20) 
## IntWr         0.39      -0.14  
##              (0.24)     (0.19) 
## Pop           0.00 ***   0.00 *
##              (0.00)     (0.00) 
## log(GDPpC)    0.78 ***   0.27  
##              (0.12)     (0.14) 
## Dem          -0.14      -0.04  
##              (0.13)     (0.39) 
## PubOp         0.01 ***   0.00  
##              (0.00)     (0.00) 
## -------------------------------
## R^2           0.95       0.89  
## Adj. R^2      0.93       0.56  
## Num. obs.    54         56     
## ===============================
=======
## =================================
##              Model 1    Model 2  
## ---------------------------------
## (Intercept)  18.78 ***           
##              (2.52)              
## ThrtR        -0.93      -2.34    
##              (0.90)     (3.38)   
## IntAt         0.02       0.03    
##              (0.06)     (0.02)   
## DomAt        -0.01      -0.00    
##              (0.01)     (0.00)   
## CivWr        -0.52               
##              (0.43)              
## IntWr         0.03      -0.07    
##              (0.27)     (0.11)   
## Pop           0.00 ***  -0.00 ***
##              (0.00)     (0.00)   
## log(GDPpC)    0.67 ***   0.40 ***
##              (0.17)     (0.10)   
## Dem          -0.38 *    -0.07    
##              (0.15)     (0.19)   
## NATO          0.51 *             
##              (0.25)              
## OpDef         0.01 ***   0.00    
##              (0.00)     (0.00)   
## ---------------------------------
## R^2           0.93       0.58    
## Adj. R^2      0.91       0.37    
## Num. obs.    50         50       
## =================================
>>>>>>> 6b369eef5855697e09f5598e18be55c8cb15c9d5
## *** p < 0.001, ** p < 0.01, * p < 0.05
```

```r
##Time Fixed Effects Model

<<<<<<< HEAD
Bresults3 <- plm(log(Dspend) ~ ThrtR + IntAt + DomAt + CivWr + IntWr + Pop + log(GDPpC) + Dem + NATO + PubOp, data=reg_df, index=c("Country", "Year"), effect="time")
=======
Bresults3 <- plm(log(Dspend) ~ ThrtR + IntAt + DomAt + CivWr + IntWr + Pop + log(GDPpC) + Dem + NATO + OpDef, data=reg_df, index=c("Country", "Year"), effect="time")
>>>>>>> 6b369eef5855697e09f5598e18be55c8cb15c9d5
summary(Bresults3)  
```

```
## Oneway (time) effect Within Model
## 
## Call:
## plm(formula = log(Dspend) ~ ThrtR + IntAt + DomAt + CivWr + IntWr + 
<<<<<<< HEAD
##     Pop + log(GDPpC) + Dem + NATO + PubOp, data = reg_df, effect = "time", 
##     index = c("Country", "Year"))
## 
## Unbalanced Panel: n=10, T=2-11, N=95
## 
## Residuals :
##     Min.  1st Qu.   Median  3rd Qu.     Max. 
## -0.59400 -0.16600  0.00297  0.14100  0.54800 
## 
## Coefficients :
##               Estimate  Std. Error t-value  Pr(>|t|)    
## ThrtR       6.1407e-01  7.2932e-01  0.8420   0.40251    
## IntAt       3.9464e-03  5.4823e-02  0.0720   0.94281    
## DomAt       1.4949e-02  6.7420e-03  2.2173   0.02967 *  
## CivWr      -6.0648e-01  3.4564e-01 -1.7546   0.08346 .  
## IntWr      -3.1676e-01  2.2228e-01 -1.4251   0.15834    
## Pop         3.2746e-08  1.5196e-09 21.5485 < 2.2e-16 ***
## log(GDPpC)  7.2261e-01  1.5579e-01  4.6383 1.482e-05 ***
## Dem        -6.2601e-01  1.2863e-01 -4.8668 6.238e-06 ***
## NATO        2.2135e-01  2.2812e-01  0.9703   0.33505    
## PubOp       9.2845e-03  2.2128e-03  4.1958 7.469e-05 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Total Sum of Squares:    85.466
## Residual Sum of Squares: 5.899
## R-Squared      :  0.93098 
##       Adj. R-Squared :  0.72518 
## F-statistic: 99.8121 on 10 and 74 DF, p-value: < 2.22e-16
=======
##     Pop + log(GDPpC) + Dem + NATO + OpDef, data = reg_df, effect = "time", 
##     index = c("Country", "Year"))
## 
## Unbalanced Panel: n=10, T=2-6, N=50
## 
## Residuals :
##    Min. 1st Qu.  Median 3rd Qu.    Max. 
## -0.5980 -0.0924 -0.0138  0.1420  0.5430 
## 
## Coefficients :
##               Estimate  Std. Error t-value  Pr(>|t|)    
## ThrtR       6.0355e-01  8.4111e-01  0.7176  0.477931    
## IntAt      -1.1598e-03  5.9914e-02 -0.0194  0.984669    
## DomAt      -5.7102e-03  6.3714e-03 -0.8962  0.376431    
## CivWr       8.3226e-02  3.9185e-01  0.2124  0.833067    
## IntWr       1.3431e-01  2.4066e-01  0.5581  0.580440    
## Pop         2.9049e-08  1.8455e-09 15.7409 < 2.2e-16 ***
## log(GDPpC)  1.1268e+00  1.7526e-01  6.4295 2.397e-07 ***
## Dem        -3.6505e-01  1.3520e-01 -2.7000  0.010727 *  
## NATO        7.4592e-01  2.3239e-01  3.2097  0.002898 ** 
## OpDef       1.1512e-02  2.3513e-03  4.8959 2.343e-05 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Total Sum of Squares:    46.509
## Residual Sum of Squares: 2.1734
## R-Squared      :  0.95327 
##       Adj. R-Squared :  0.64822 
## F-statistic: 69.3585 on 10 and 34 DF, p-value: < 2.22e-16
>>>>>>> 6b369eef5855697e09f5598e18be55c8cb15c9d5
```

```r
screenreg(list(Bresults1, Bresults2, Bresults3))
```

```
## 
<<<<<<< HEAD
## ==========================================
##              Model 1    Model 2  Model 3  
## ------------------------------------------
## (Intercept)  15.70 ***                    
##              (1.62)                       
## ThrtR        -1.18 **   -0.66     0.61    
##              (0.36)     (2.11)   (0.73)   
## IntAt         0.05      -0.02     0.00    
##              (0.06)     (0.03)   (0.05)   
## DomAt        -0.01      -0.03 *   0.01 *  
##              (0.01)     (0.01)   (0.01)   
## CivWr        -0.40      -0.03    -0.61    
##              (0.29)     (0.20)   (0.35)   
## IntWr         0.39      -0.14    -0.32    
##              (0.24)     (0.19)   (0.22)   
## Pop           0.00 ***   0.00 *   0.00 ***
##              (0.00)     (0.00)   (0.00)   
## log(GDPpC)    0.78 ***   0.27     0.72 ***
##              (0.12)     (0.14)   (0.16)   
## Dem          -0.14      -0.04    -0.63 ***
##              (0.13)     (0.39)   (0.13)   
## PubOp         0.01 ***   0.00     0.01 ***
##              (0.00)     (0.00)   (0.00)   
## NATO                              0.22    
##                                  (0.23)   
## ------------------------------------------
## R^2           0.95       0.89     0.93    
## Adj. R^2      0.93       0.56     0.73    
## Num. obs.    54         56       95       
## ==========================================
=======
## ============================================
##              Model 1    Model 2    Model 3  
## --------------------------------------------
## (Intercept)  18.78 ***                      
##              (2.52)                         
## ThrtR        -0.93      -2.34       0.60    
##              (0.90)     (3.38)     (0.84)   
## IntAt         0.02       0.03      -0.00    
##              (0.06)     (0.02)     (0.06)   
## DomAt        -0.01      -0.00      -0.01    
##              (0.01)     (0.00)     (0.01)   
## CivWr        -0.52                  0.08    
##              (0.43)                (0.39)   
## IntWr         0.03      -0.07       0.13    
##              (0.27)     (0.11)     (0.24)   
## Pop           0.00 ***  -0.00 ***   0.00 ***
##              (0.00)     (0.00)     (0.00)   
## log(GDPpC)    0.67 ***   0.40 ***   1.13 ***
##              (0.17)     (0.10)     (0.18)   
## Dem          -0.38 *    -0.07      -0.37 *  
##              (0.15)     (0.19)     (0.14)   
## NATO          0.51 *                0.75 ** 
##              (0.25)                (0.23)   
## OpDef         0.01 ***   0.00       0.01 ***
##              (0.00)     (0.00)     (0.00)   
## --------------------------------------------
## R^2           0.93       0.58       0.95    
## Adj. R^2      0.91       0.37       0.65    
## Num. obs.    50         50         50       
## ============================================
>>>>>>> 6b369eef5855697e09f5598e18be55c8cb15c9d5
## *** p < 0.001, ** p < 0.01, * p < 0.05
```

```r
##PROBLEMS fixed and time fixed effects model returns ERROR: "Error in crossprod(t(X), beta) : non-conformable arguments"
##State fixed and time fixed effects Model
<<<<<<< HEAD
# Bresults4 <- plm(log(Dspend) ~ ThrtR + IntAt + DomAt + CivWr + IntWr + Pop + GDPpC + Dem + NATO + PubOp, data=reg_df[complete.cases(reg_df),], index=c("Country", "Year"), effect="twoways", model="within")
# summary(Bresults4)
# screenreg(list(Bresults1, Bresults2, Bresults3))


DefSpnd_IncDec_Data.1lag
```

```
##         Country Year Increase Decrease Same IDK Spread democ autoc IntlCnf
## 1      Bulgaria 2008       30       19   21  31     11     9     0       0
## 2      Bulgaria 2011       26       24   44   6      2     9     0       0
## 3      Bulgaria 2012       12       30   51   7    -18     9     0       0
## 4        France 2002       28       33   47   2     -5     9     0       0
## 5        France 2003       22       32   43   3    -10     9     0       0
## 6        France 2004       19       29   44   8    -10     9     0       0
## 7        France 2008       19       23   54   4     -4     9     0       0
## 8        France 2011       11       33   55   1    -22     9     0       0
## 9        France 2012        8       38   54   0    -30     9     0       0
## 10       France 2013       11       31   57   1    -20     9     0       0
## 11      Germany 2002       14       45   38   2    -31    10     0       0
## 12      Germany 2003       15       43   37   5    -28    10     0       0
## 13      Germany 2004       21       32   39   8    -11    10     0       0
## 14      Germany 2008       16       34   44   6    -18    10     0       0
## 15      Germany 2011       14       36   47   3    -22    10     0       0
## 16      Germany 2012        6       45   47   3    -39    10     0       0
## 17      Germany 2013        5       47   47   1    -42    10     0       0
## 18        Italy 2002       12       52   33   2    -40    10     0       0
## 19        Italy 2003       23       27   37  13     -4    10     0       0
## 20        Italy 2004       13       34   35  18    -21    10     0       0
## 21        Italy 2008       38       22   34   6     16    10     0       0
## 22        Italy 2011       11       45   40   4    -34    10     0       0
## 23        Italy 2012        5       56   34   5    -51    10     0       0
## 24        Italy 2013       13       53   29   5    -40    10     0       0
## 25  Netherlands 2002        6       38   53   2    -32    10     0       0
## 26  Netherlands 2003       12       37   41  10    -25    10     0       0
## 27  Netherlands 2004       17       29   39  15    -12    10     0       0
## 28  Netherlands 2008       18       37   35  10    -19    10     0       0
## 29  Netherlands 2011       14       38   47   1    -24    10     0       0
## 30  Netherlands 2012        7       37   51   5    -30    10     0       0
## 31  Netherlands 2013        9       40   50   1    -31    10     0       0
## 32       Poland 2002       45       14   36   8     31    10     0       0
## 33       Poland 2003       44       14   23  19     30    10     0       1
## 34       Poland 2004       41       19   23  17     22    10     0       0
## 35       Poland 2008       35       18   30  17     17    10     0       0
## 36       Poland 2011       21       19   55   6      2    10     0       0
## 37       Poland 2012       19       21   49  10     -2    10     0       0
## 38       Poland 2013       22       19   52   6      3    10     0       0
## 39     Portugal 2003       32       26   24  18      6    10     0       0
## 40     Portugal 2004       16       45   22  16    -29    10     0       0
## 41     Portugal 2008       38       26   27   9     12    10     0       0
## 42     Portugal 2011       10       49   38   3    -39    10     0       0
## 43     Portugal 2012        8       45   43   3    -37    10     0       0
## 44     Portugal 2013       11       46   41   2    -35    10     0       0
## 45      Romania 2008       32       21   22  25     11     9     0       0
## 46      Romania 2011       17       32   44   7    -15     9     0       0
## 47      Romania 2012       14       34   45   7    -20     9     0       0
## 48      Romania 2013       22       29   46   3     -7     9     0       0
## 49       Russia 2012       34       13   43  10     21     5     1      NA
## 50       Sweden 2011       21       24   52   3     -3    10     0       0
## 51       Sweden 2012       17       25   56   3     -8    10     0       0
## 52       Sweden 2013       29       23   45   3      6    10     0       0
## 53     Slovakia 2004       11       32   32  26    -21     9     0       0
## 54     Slovakia 2008       11       16   55  19     -5    10     0       0
## 55     Slovakia 2011       10       43   42   6    -33    10     0       0
## 56     Slovakia 2012        7       45   42   6    -38    10     0       0
## 57     Slovakia 2013        5       48   45   2    -43    10     0       0
## 58        Spain 2004       16       28   38  19    -12    10     0       0
## 59        Spain 2008       29       20   42  10      9    10     0       0
## 60        Spain 2011       10       50   37   3    -40    10     0       0
## 61        Spain 2012        5       52   42   1    -47    10     0       0
## 62        Spain 2013        6       56   37   1    -50    10     0       0
## 63       Turkey 2004       15       35   32  18    -20     8     1       1
## 64       Turkey 2008       18       24   35  22     -6     8     1       1
## 65       Turkey 2011       23       24   38  15     -1     9     0       0
## 66       Turkey 2012       29       17   44  10     12     9     0       0
## 67       Turkey 2013       50       15   32   4     35     9     0       0
## 68           UK 2002       24       21   53   3      3    10     0       0
## 69           UK 2003       25       26   40   9     -1    10     0       0
## 70           UK 2004       28       28   34  10      0    10     0       0
## 71           UK 2008       50       19   26   5     31    10     0       0
## 72           UK 2011       36       18   45   2     18    10     0       0
## 73           UK 2012       29       16   51   4     13    10     0       0
## 74           UK 2013       28       18   53   2     10    10     0       0
## 75          USA 2002       44       15   38   3     29    10     0      NA
## 76          USA 2003       17       25   53   5     -8    10     0      NA
## 77          USA 2004       21       38   36   6    -17    10     0      NA
## 78          USA 2008       26       36   32   5    -10    10     0      NA
## 79          USA 2011       19       34   45   2    -15    10     0      NA
## 80          USA 2012       20       32   45   3    -12    10     0      NA
## 81          USA 2013       25       26   46   3     -1    10     0      NA
## 82        EU 10 2004       21       30   36  13     -9    NA    NA      NA
## 83        EU 10 2008       27       25   39   9      2    NA    NA      NA
## 84        EU 10 2013       13       39   46   2    -26    NA    NA      NA
## 85        EU 11 2008       29       24   38   9      5    NA    NA      NA
## 86        EU 11 2011       16       35   46   3    -19    NA    NA      NA
## 87        EU 11 2012       11       39   46   4    -28    NA    NA      NA
## 88        EU 11 2013       14       38   46   2    -24    NA    NA      NA
## 89         EU 5 2013       12       41   45   2    -29    NA    NA      NA
## 90         EU 7 2002       22       33   42   3    -11    NA    NA      NA
## 91         EU 7 2003       23       31   37   9     -8    NA    NA      NA
## 92         EU 7 2004       22       30   36  12     -8    NA    NA      NA
## 93         EU 7 2008       29       25   38   7      4    NA    NA      NA
## 94         EU 7 2011       17       33   47   3    -16    NA    NA      NA
## 95         EU 7 2012       12       38   47   4    -26    NA    NA      NA
## 96         EU 7 2013       14       37   47   2    -23    NA    NA      NA
## 97         EU 9 2004       22       29   36  13     -7    NA    NA      NA
## 98         EU 9 2008       29       25   39   7      4    NA    NA      NA
## 99         EU 9 2011       16       35   46   3    -19    NA    NA      NA
## 100        EU 9 2012       11       39   46   4    -28    NA    NA      NA
## 101        EU 9 2013       13       39   46   2    -26    NA    NA      NA
## 102       EU 12 2008       28       24   38  10      4    NA    NA      NA
## 103       EU 12 2011       17       34   46   3    -17    NA    NA      NA
## 104       EU 12 2012       11       39   46   4    -28    NA    NA      NA
##     CivilWar GDPpCap Population NATOally Attacks IntAt DomAt     DefSpnd
## 1          0    7205    7492561        1       0     0     0  1065083213
## 2          0    7589    7348328        1       0     0     0   718876738
## 3          0    7035    7305888        1       1     1     0   752084592
## 4          0   28247   61803229        1       0     0     0 54256071060
## 5          0   33605   62242474        1       4     4     0 61518456930
## 6          0   36943   62702121        1       1     0     1 60165247200
## 7          0   45985   64371099        1       1     0     1 57401764800
## 8          0   43810   65343588        1       3     2     1 50862376580
## 9          0   39982   65676758        1       3     3     0 52343609540
## 10         0   40638   66028467        1       5     2     3          NA
## 11         0   29288   82488495        1       1     0     1 39449554600
## 12         0   34314   82534176        1       1     1     0 42066245660
## 13         0   37209   82516260        1       0     0     0 41865276410
## 14         0   46205   82110097        1       0     0     0 50452640440
## 15         0   45871   81797673        1       6     1     5 47498642650
## 16         0   42937   80425823        1       0     0     0 48805945660
## 17         0   44238   80621788        1       0     0     0          NA
## 18         0   25838   57059007        1       2     0     2 36152500700
## 19         0   31010   57313203        1       6     0     6 39777514880
## 20         0   34012   57685327        1       1     0     1 38336347140
## 21         0   41169   58826731        1       0     0     0 32093933570
## 22         0   38367   59379449        1       2     0     2 26873302630
## 23         0   34336   59539717        1       2     0     2 25217977260
## 24         0   34349   59831093        1       4     0     4          NA
## 25         0   33467   16148929        1       0     0     0  9596116222
## 26         0   39824   16225302        1       2     2     0 10675464760
## 27         0   43271   16281779        1       1     0     1 10618057080
## 28         0   57339   16445593        1       1     0     1 12750392130
## 29         0   53541   16693074        1       1     0     1 10511455050
## 30         0   48015   16754962        1       0     0     0 10331360120
## 31         0   48564   16804224        1       0     0     0          NA
## 32         0    6047   38230364        1       0     0     0  5170372054
## 33         0    6444   38204570        1       0     0     0  5831830218
## 34         0    7241   38182222        1       0     0     0  6752435055
## 35         0   14080   38125759        1       0     0     0  8152831615
## 36         0   13608   38534157        1       0     0     0  8795687805
## 37         0   12585   38535873        1       0     0     0  9101645625
## 38         0   13049   38530725        1       0     0     0          NA
## 39         0   17851   10458821        1       0     0     0  3241525485
## 40         0   19679   10483861        1       0     0     0  3484700453
## 41         0   25127   10558177        1       0     0     0  3839979936
## 42         0   23196   10557560        1       0     0     0  3093979021
## 43         0   20263   10514844        1       0     0     0  3322454887
## 44         0   20779   10459806        1       0     0     0          NA
## 45         1   10074   20537875        1       0     0     0  2673719561
## 46         0    9064   20147528        1       0     0     0  2425637462
## 47         0    8246   20076727        1       0     0     0  2524376089
## 48         0    9082   19963581        1       0     0     0          NA
## 49        NA   13772  143178000       NA      NA    NA    NA          NA
## 50         0   59593    9449213       NA       1     0     1  6305839092
## 51         0   55840    9519374       NA       0     0     0  6522411322
## 52         0   57778    9592552       NA       0     0     0          NA
## 53         0   11637    5372280        1      NA    NA    NA  1160642958
## 54         0   18791    5379233        1      NA    NA    NA  1402096900
## 55         0   18066    5398384        1      NA    NA    NA  1026321479
## 56         0   16763    5407579        1      NA    NA    NA   998994832
## 57         0   17255    5414095        1      NA    NA    NA          NA
## 58         0   27174   42921895        1      26     0    26 14497868370
## 59         0   36025   45954106        1      32     0    32 17135374680
## 60         0   31975   46742697        1       0     0     0 14010626650
## 61         0   28336   46761264        1       1     0     1 12769066920
## 62         0   28553   46647421        1       4     0     4          NA
## 63         1    6398   66845635        1      14     0    14 18393516430
## 64         1   10509   70363511        1      21     0    21 16530834340
## 65         1   10605   73058638        1      33     0    33 14796553700
## 66         1   10419   73997128        1     141     0   141 14361337800
## 67         1   10490   74932641        1      29     2    27          NA
## 68         0   32816   59370479        1       2     0     2 54603101520
## 69         0   36881   59647577        1       0     0     0 60634213880
## 70         0   41776   59987905        1       0     0     0 67710403050
## 71         0   45735   61806995        1       1     1     0 64819079500
## 72         0   40972   63258918        1       0     0     0 58910921610
## 73         0   40124   63695687        1       2     2     0 60428454090
## 74         0   39954   64097085        1       3     0     3          NA
## 75        NA      NA         NA       NA      NA    NA    NA          NA
## 76        NA      NA         NA       NA      NA    NA    NA          NA
## 77        NA      NA         NA       NA      NA    NA    NA          NA
## 78        NA      NA         NA       NA      NA    NA    NA          NA
## 79        NA      NA         NA       NA      NA    NA    NA          NA
## 80        NA      NA         NA       NA      NA    NA    NA          NA
## 81        NA      NA         NA       NA      NA    NA    NA          NA
## 82        NA      NA         NA       NA      NA    NA    NA          NA
## 83        NA      NA         NA       NA      NA    NA    NA          NA
## 84        NA      NA         NA       NA      NA    NA    NA          NA
## 85        NA      NA         NA       NA      NA    NA    NA          NA
## 86        NA      NA         NA       NA      NA    NA    NA          NA
## 87        NA      NA         NA       NA      NA    NA    NA          NA
## 88        NA      NA         NA       NA      NA    NA    NA          NA
## 89        NA      NA         NA       NA      NA    NA    NA          NA
## 90        NA      NA         NA       NA      NA    NA    NA          NA
## 91        NA      NA         NA       NA      NA    NA    NA          NA
## 92        NA      NA         NA       NA      NA    NA    NA          NA
## 93        NA      NA         NA       NA      NA    NA    NA          NA
## 94        NA      NA         NA       NA      NA    NA    NA          NA
## 95        NA      NA         NA       NA      NA    NA    NA          NA
## 96        NA      NA         NA       NA      NA    NA    NA          NA
## 97        NA      NA         NA       NA      NA    NA    NA          NA
## 98        NA      NA         NA       NA      NA    NA    NA          NA
## 99        NA      NA         NA       NA      NA    NA    NA          NA
## 100       NA      NA         NA       NA      NA    NA    NA          NA
## 101       NA      NA         NA       NA      NA    NA    NA          NA
## 102       NA      NA         NA       NA      NA    NA    NA          NA
## 103       NA      NA         NA       NA      NA    NA    NA          NA
## 104       NA      NA         NA       NA      NA    NA    NA          NA
##      ThreatRatio
## 1   0.8880489189
## 2   0.8087053230
## 3   0.8040210728
## 4   0.0572846890
## 5   0.0564886256
## 6   0.0544225806
## 7   0.0513588745
## 8   0.0474726496
## 9   0.0468451064
## 10  0.0449770213
## 11  0.0368503546
## 12  0.0380296429
## 13  0.0381492958
## 14  0.0352728155
## 15  0.0339453968
## 16  0.0333889241
## 17  0.0325879747
## 18  0.0401133333
## 19  0.0409585635
## 20  0.0412271739
## 21  0.0392842105
## 22  0.0400456522
## 23  0.0405346369
## 24  0.0405494318
## 25  0.0863322981
## 26  0.0851021672
## 27  0.0810729483
## 28  0.0722102426
## 29  0.0727181572
## 30  0.0754173554
## 31  0.0757059639
## 32  0.3509962963
## 33  0.3449571429
## 34  0.3296802721
## 35  0.3299555556
## 36  0.3158208955
## 37  0.3410488998
## 38  0.3470192771
## 39  0.0768489583
## 40  0.0777040816
## 41  0.0902135922
## 42  0.0699500000
## 43  0.0761658031
## 44  0.0674842105
## 45  0.0674733871
## 46  0.0618145299
## 47  0.0668461538
## 48  0.0690570248
## 49            NA
## 50  0.0254236111
## 51  0.0245846868
## 52  0.0243524027
## 53  0.3246984184
## 54  0.2692348216
## 55  0.2567726572
## 56  0.2593791229
## 57  0.2582834117
## 58  0.0636955357
## 59  0.0553960317
## 60  0.0574371901
## 61  0.0572226891
## 62  0.0573623932
## 63  0.0597421525
## 64  0.0537352941
## 65  0.0458991870
## 66            NA
## 67            NA
## 68  0.0006500000
## 69  0.0005986900
## 70  0.0005923404
## 71  0.0005744094
## 72  0.0005162698
## 73  0.0004869565
## 74  0.0004728682
## 75            NA
## 76            NA
## 77            NA
## 78            NA
## 79            NA
## 80            NA
## 81            NA
## 82            NA
## 83            NA
## 84            NA
## 85            NA
## 86            NA
## 87            NA
## 88            NA
## 89            NA
## 90            NA
## 91            NA
## 92            NA
## 93            NA
## 94            NA
## 95            NA
## 96            NA
## 97            NA
## 98            NA
## 99            NA
## 100           NA
## 101           NA
## 102           NA
## 103           NA
## 104           NA
=======
# Bresults4 <- plm(log(Dspend) ~ ThrtR + IntAt + DomAt + CivWr + IntWr + Pop + GDPpC + Dem + NATO + OpDef, data=reg_df[complete.cases(reg_df),], index=c("Country", "Year"), effect="twoways", model="within")
# summary(Bresults4)
# screenreg(list(Bresults1, Bresults2, Bresults3))
>>>>>>> 6b369eef5855697e09f5598e18be55c8cb15c9d5
```
