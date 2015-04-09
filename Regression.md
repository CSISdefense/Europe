

```r
# install.packages("Hmisc")
# We are assuming your working directory is the source file directory https://groups.google.com/forum/?fromgroups=#!topic/knitr/knM0VWoexT0
# setwd("C:/Users/Greg Sanders/Documents/Development/Europe") #Your working directory here!
# setwd("C:/Users/scohen/My Documents/Europe1/") #Your working directory here!
source("SSIRegression.R")
require("Hmisc")
```

```
## Loading required package: Hmisc
## Loading required package: grid
## Loading required package: lattice
## Loading required package: survival
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
require("texreg")
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
# debug(CompilePubOpData)


require(MASS)
```

```
## Loading required package: MASS
```

```r
########REGRESSIONS
##load texreg
require(texreg)
```



```r
polls1lag <- CompilePubOpDataOmnibus(lag = 1)
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
```


```r
rcorr(as.matrix(subset(reg_df,select=-c(Country,Year))))
```

```
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

screenreg(list(s1, s2, s3, s4, s5, s6, s7, s8, s9, s10))
```

```
## 
## =========================================================================================================================
##              Model 1    Model 2    Model 3    Model 4    Model 5    Model 6    Model 7    Model 8    Model 9    Model 10 
## -------------------------------------------------------------------------------------------------------------------------
## (Intercept)  23.71 ***  24.14 ***  24.01 ***  24.07 ***  24.07 ***  24.07 ***   4.18 ***  -2.61       2.84       2.76    
##              (0.10)     (0.11)     (0.12)     (0.13)     (0.13)     (0.13)     (0.88)     (1.43)     (1.77)     (1.80)   
## OpUSl        -0.00      -0.00      -0.00      -0.00      -0.00      -0.00       0.00       0.00       0.00 **    0.00 ** 
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
```

```
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
##   21.85   23.04   23.63   23.71   24.64   25.10      67
```

```r
summary(log(reg_df$Pop))
```

```
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
##   16.06   17.46   17.88   17.51   17.98   18.23      57
```

```r
summary(log(reg_df$GDPpC))
```

```
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
##   8.707   9.927  10.440  10.220  10.650  11.000      57
```

```r
###### MODELS: US global leadership  
####Linear Model



Aresults1 <- lm(log(Dspend) ~ ThrtR + IntAt + DomAt + CivWr + IntWr + Pop + log(GDPpC) + Dem + NATO + OpUSl, data = reg_df)
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
## OpUSl         0.00 *  
##              (0.00)   
## ----------------------
## R^2           0.90    
## Adj. R^2      0.89    
## Num. obs.    95       
## ======================
## *** p < 0.001, ** p < 0.01, * p < 0.05
```

```r
CAresults1 <- lm(log(Dspend) ~ ThrtR + IntAt + DomAt + CivWr + IntWr + Pop + log(GDPpC) + Dem + NATO + OpUSl, data = reg_df[complete.cases(reg_df),])
USstep <- stepAIC(CAresults1, direction = "backward")
```

```
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
```

```r
###State Fixed Effects Model

Aresults2 <- plm(log(Dspend) ~ ThrtR + IntAt + DomAt + CivWr + IntWr + Pop + log(GDPpC) + Dem + NATO + OpUSl, data=reg_df, index=c("Country", "Year"), model="within")
summary(Aresults2)
```

```
## Oneway (individual) effect Within Model
## 
## Call:
## plm(formula = log(Dspend) ~ ThrtR + IntAt + DomAt + CivWr + IntWr + 
##     Pop + log(GDPpC) + Dem + NATO + OpUSl, data = reg_df, model = "within", 
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
## OpUSl      -1.7567e-03  5.2701e-04 -3.3334  0.001321 ** 
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
## OpUSl         0.00 *    -0.00 ** 
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

Aresults3 <- plm(log(Dspend) ~ ThrtR + IntAt + DomAt + CivWr + IntWr + Pop + log(GDPpC) + Dem + NATO + OpUSl, data=reg_df, index=c("Country", "Year"), effect="time")
summary(Aresults3)  
```

```
## Oneway (time) effect Within Model
## 
## Call:
## plm(formula = log(Dspend) ~ ThrtR + IntAt + DomAt + CivWr + IntWr + 
##     Pop + log(GDPpC) + Dem + NATO + OpUSl, data = reg_df, effect = "time", 
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
## OpUSl       9.2845e-03  2.2128e-03  4.1958 7.469e-05 ***
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
## OpUSl         0.00 *    -0.00 **    0.01 ***
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
# Aresults4 <- plm(log(Dspend) ~ ThrtR + IntAt + DomAt + CivWr + IntWr + Pop + GDPpC + Dem + NATO + OpUSl, data=reg_df[complete.cases(reg_df),], index=c("Country", "Year"), effect="twoways", model="within")
# summary(Aresults4)
# screenreg(list(Aresults1, Aresults2, Aresults3))
```




```r
############
##### MODELS: country is spending too much or too little 


####Linear Model

Bresults1 <- lm(log(Dspend) ~ ThrtR + IntAt + DomAt + CivWr + IntWr + Pop + log(GDPpC) + Dem + NATO + OpDef, reg_df)
screenreg(list(Bresults1))
```

```
## 
## ======================
##              Model 1  
## ----------------------
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
## ======================
## *** p < 0.001, ** p < 0.01, * p < 0.05
```

```r
###State Fixed Effects Model

Bresults2 <- plm(log(Dspend) ~ ThrtR + IntAt + DomAt + CivWr + IntWr + Pop + log(GDPpC) + Dem + NATO + OpDef, data=reg_df, index=c("Country", "Year"), model="within")
summary(Bresults2)
```

```
## Oneway (individual) effect Within Model
## 
## Call:
## plm(formula = log(Dspend) ~ ThrtR + IntAt + DomAt + CivWr + IntWr + 
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
```

```r
screenreg(list(Bresults1, Bresults2))
```

```
## 
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
## *** p < 0.001, ** p < 0.01, * p < 0.05
```

```r
##Time Fixed Effects Model

Bresults3 <- plm(log(Dspend) ~ ThrtR + IntAt + DomAt + CivWr + IntWr + Pop + log(GDPpC) + Dem + NATO + OpDef, data=reg_df, index=c("Country", "Year"), effect="time")
summary(Bresults3)  
```

```
## Oneway (time) effect Within Model
## 
## Call:
## plm(formula = log(Dspend) ~ ThrtR + IntAt + DomAt + CivWr + IntWr + 
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
```

```r
screenreg(list(Bresults1, Bresults2, Bresults3))
```

```
## 
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
## *** p < 0.001, ** p < 0.01, * p < 0.05
```

```r
##PROBLEMS fixed and time fixed effects model returns ERROR: "Error in crossprod(t(X), beta) : non-conformable arguments"
##State fixed and time fixed effects Model
# Bresults4 <- plm(log(Dspend) ~ ThrtR + IntAt + DomAt + CivWr + IntWr + Pop + GDPpC + Dem + NATO + OpDef, data=reg_df[complete.cases(reg_df),], index=c("Country", "Year"), effect="twoways", model="within")
# summary(Bresults4)
# screenreg(list(Bresults1, Bresults2, Bresults3))
```
