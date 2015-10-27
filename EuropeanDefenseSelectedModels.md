# European Defense and Public Opinion: Selected Models
Greg Sanders  
October 19, 2015  





**Load and subset the data we want**





**load and subset the data we want**



#Hypothesis 1: Public Support for Defense Spending

Hypothesis 1 a: Net public support for more defense spending results in an increase of defense spending.
Hypothesis 1 b: Net public support for more defense spending results in an increase of investment spending.


```r
#Model #1 is Defense Spending and Defense Spread
Europe_model<-panelmodels(selected.formula="DefSpendDelt_lead ~ DefSpread_lag1 + GDPpCapDelt",
                              source.data=DefSpread,
                              regression.name="Too Much/Little & Def",
                             include.random=FALSE)
```

```
## series Unit.Currency is constant and has been removed
## series Unit.Currency is constant and has been removed
## series Unit.Currency is constant and has been removed
## series Unit.Currency is constant and has been removed
```

```r
# summary(Europe_model$ols[[1]])
summary(Europe_model$pooling[[1]])
```

```
## Oneway (individual) effect Pooling Model
## 
## Call:
## plm(formula = as.formula(selected.formula), data = source.data, 
##     model = "pooling")
## 
## Unbalanced Panel: n=10, T=4-6, N=53
## 
## Residuals :
##     Min.  1st Qu.   Median  3rd Qu.     Max. 
## -0.15800 -0.02970  0.00201  0.02970  0.15300 
## 
## Coefficients :
##                 Estimate Std. Error t-value Pr(>|t|)   
## (Intercept)    0.0146036  0.0091334  1.5989 0.116138   
## DefSpread_lag1 0.1302971  0.0375748  3.4677 0.001089 **
## GDPpCapDelt    0.1295122  0.0843122  1.5361 0.130818   
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Total Sum of Squares:    0.21334
## Residual Sum of Squares: 0.16665
## R-Squared      :  0.21888 
##       Adj. R-Squared :  0.20649 
## F-statistic: 7.00525 on 2 and 50 DF, p-value: 0.0020795
```

```r
# summary(Europe_model$between[[1]])
# summary(Europe_model$fd[[1]])
# summary(Europe_model$within[[1]])
# summary(Europe_model$random[[1]])
# plot(Europe_model$ols[[1]])
#190, #86, #194,81


#Mode2 #1 is Equipment Spending and Defense Spread
Europe_model<-rbind(
    Europe_model[1,],
    panelmodels(selected.formula="EquSpendDelt ~ DefSpread_lag2 + GDPpCapDelt + left_right_ls_spread",
                              source.data=DefSpread,
                              regression.name="Too Much/Little & Equ")
)
```

```
## series Unit.Currency is constant and has been removed
## series Unit.Currency is constant and has been removed
## series Unit.Currency is constant and has been removed
## series Unit.Currency is constant and has been removed
## series Unit.Currency is constant and has been removed
```

```r
# summary(Europe_model$ols[[2]])
# summary(Europe_model$pooling[[2]])
# summary(Europe_model$between[[2]])
# summary(Europe_model$fd[[2]])
# summary(Europe_model$within[[2]])
summary(Europe_model$random[[2]])
```

```
## Oneway (individual) effect Random Effect Model 
##    (Swamy-Arora's transformation)
## 
## Call:
## plm(formula = as.formula(selected.formula), data = source.data, 
##     model = "random")
## 
## Unbalanced Panel: n=10, T=3-5, N=43
## 
## Effects:
##                   var std.dev share
## idiosyncratic 0.02513 0.15853 0.548
## individual    0.02073 0.14398 0.452
## theta  : 
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
##  0.4635  0.5177  0.5582  0.5347  0.5582  0.5582 
## 
## Residuals :
##     Min.  1st Qu.   Median     Mean  3rd Qu.     Max. 
## -0.38300 -0.09680  0.02050  0.00175  0.08230  0.33400 
## 
## Coefficients :
##                        Estimate Std. Error t-value Pr(>|t|)   
## (Intercept)           0.1633234  0.0719289  2.2706 0.028771 * 
## DefSpread_lag2        0.5264725  0.1626773  3.2363 0.002472 **
## GDPpCapDelt           0.9122738  0.5052552  1.8056 0.078709 . 
## left_right_ls_spread -0.0164080  0.0055691 -2.9463 0.005403 **
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Total Sum of Squares:    1.4122
## Residual Sum of Squares: 0.9403
## R-Squared      :  0.33423 
##       Adj. R-Squared :  0.30314 
## F-statistic: 6.52344 on 3 and 39 DF, p-value: 0.0011053
```

```r
# plot(Europe_model$ols[[2]])
screenreg(list(Europe_model$pooling[[1]],Europe_model$random[[2]]),
          custom.model.name=c(as.character(Europe_model$name[1:2])),
          digits=3,
          stars=c(0.01,0.05,0.1),
          reorder.coef=c(1,2,4,3,5),
          groups = list("Intercept" = 1,"Polling" = 2:3, "MacroEconomics" = 4,"Parliamentary" = 5)
          )
```

```
## 
## ======================================================================
##                           Too Much/Little & Def  Too Much/Little & Equ
## ----------------------------------------------------------------------
## Intercept                                                             
##                                                                       
##     (Intercept)            0.015                  0.163 **            
##                           (0.009)                (0.072)              
## Polling                                                               
##                                                                       
##     DefSpread_lag1         0.130 ***                                  
##                           (0.038)                                     
##     DefSpread_lag2                                0.526 ***           
##                                                  (0.163)              
## MacroEconomics                                                        
##                                                                       
##     GDPpCapDelt            0.130                  0.912 *             
##                           (0.084)                (0.505)              
## Parliamentary                                                         
##                                                                       
##     left_right_ls_spread                         -0.016 ***           
##                                                  (0.006)              
## ----------------------------------------------------------------------
## R^2                        0.219                  0.334               
## Adj. R^2                   0.206                  0.303               
## Num. obs.                 53                     43                   
## ======================================================================
## *** p < 0.01, ** p < 0.05, * p < 0.1
```

#Hypothesis 2: Public Support for Active European Foreign Policy

Hypothesis 2a: Net public support of individual European countries for a greater presence of the EU in international affairs results in an increase of investment defense spending.
Hypothesis 2b: Net public support of individual European countries for a greater presence of the EU in international affairs results in an increase of investment spending.



```r
#Mode2 #3 is Defense Spending and European Leadership
Europe_model<-rbind(
    Europe_model[1:2,],
    panelmodels(selected.formula="DefSpendDelt ~ EUldrSpread + IntlCnf + GDPpCapDelt +
                                 eu_anti_pro_ls_spread",
                source.data=DefSpread,
                regression.name="EU leader. & Def",
                include.random=TRUE)
)
```

```
## series Unit.Currency is constant and has been removed
## series Unit.Currency is constant and has been removed
## series Unit.Currency is constant and has been removed
## series Unit.Currency is constant and has been removed
## series Unit.Currency is constant and has been removed
```

```r
# summary(Europe_model$ols[[3]])
summary(Europe_model$pooling[[3]])
```

```
## Oneway (individual) effect Pooling Model
## 
## Call:
## plm(formula = as.formula(selected.formula), data = source.data, 
##     model = "pooling")
## 
## Balanced Panel: n=9, T=9, N=81
## 
## Residuals :
##    Min. 1st Qu.  Median 3rd Qu.    Max. 
## -0.2430 -0.0367 -0.0015  0.0355  0.1690 
## 
## Coefficients :
##                         Estimate Std. Error t-value  Pr(>|t|)    
## (Intercept)           -0.0704555  0.0200863 -3.5076 0.0007628 ***
## EUldrSpread            0.0761750  0.0302977  2.5142 0.0140442 *  
## IntlCnf                0.0565025  0.0384544  1.4693 0.1458686    
## GDPpCapDelt            0.1497776  0.0899760  1.6646 0.1001024    
## eu_anti_pro_ls_spread  0.0034568  0.0016275  2.1241 0.0369176 *  
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Total Sum of Squares:    0.35139
## Residual Sum of Squares: 0.28674
## R-Squared      :  0.18399 
##       Adj. R-Squared :  0.17263 
## F-statistic: 4.28404 on 4 and 76 DF, p-value: 0.0035242
```

```r
# summary(Europe_model$between[[3]])
# summary(Europe_model$fd[[3]])
# summary(Europe_model$within[[3]])
# summary(Europe_model$random[[3]])
# plot(Europe_model$ols[[3]])
Europe_model<-rbind(
    Europe_model[1:3,],
    panelmodels(selected.formula="EquSpendDelt ~ EUldrSpread_lag1 + CivilWar + Cab_liberty_authority + Cab_eu_anti_pro",
                source.data=DefSpread,
                regression.name="EU leader. & Equ",
                include.random=FALSE)
)
```

```
## series Unit.Currency is constant and has been removed
## series Unit.Currency is constant and has been removed
## series Unit.Currency is constant and has been removed
## series Unit.Currency is constant and has been removed
```

```r
#Mode2 #4 is Equipment Spending and European Leadership    
# summary(Europe_model$ols[[4]])
summary(Europe_model$pooling[[4]])
```

```
## Oneway (individual) effect Pooling Model
## 
## Call:
## plm(formula = as.formula(selected.formula), data = source.data, 
##     model = "pooling")
## 
## Unbalanced Panel: n=9, T=8-9, N=78
## 
## Residuals :
##    Min. 1st Qu.  Median 3rd Qu.    Max. 
## -0.9530 -0.1550 -0.0365  0.0921  2.4800 
## 
## Coefficients :
##                        Estimate Std. Error t-value Pr(>|t|)
## (Intercept)           -0.401322   0.422382 -0.9501   0.3452
## EUldrSpread_lag1      -0.165615   0.329849 -0.5021   0.6171
## CivilWar              -0.395976   0.369485 -1.0717   0.2874
## Cab_liberty_authority  0.054262   0.037569  1.4444   0.1529
## Cab_eu_anti_pro        0.031710   0.038329  0.8273   0.4108
## 
## Total Sum of Squares:    10.827
## Residual Sum of Squares: 10.503
## R-Squared      :  0.029948 
##       Adj. R-Squared :  0.028029 
## F-statistic: 0.563433 on 4 and 73 DF, p-value: 0.68993
```

```r
# summary(Europe_model$between[[4]])
# summary(Europe_model$fd[[4]])
# summary(Europe_model$within[[4]])
# summary(Europe_model$random[[4]])
# plot(Europe_model$ols[[4]])

screenreg(list(Europe_model$pooling[[3]],Europe_model$pooling[[4]]),
          custom.model.name=c(as.character(Europe_model$name[3:4])),
          digits=3,
          stars=c(0.01,0.05,0.1),
          reorder.coef=c(1,2,6,3,7,4,8,9,5),
          groups = list("Intercept" = 1,"Polling" = 2:3, "Security"=4:5, "Macroeconomic" = 6, "Parliamentary"=7:9)
          )
```

```
## 
## =============================================================
##                            EU leader. & Def  EU leader. & Equ
## -------------------------------------------------------------
## Intercept                                                    
##                                                              
##     (Intercept)            -0.070 ***        -0.401          
##                            (0.020)           (0.422)         
## Polling                                                      
##                                                              
##     EUldrSpread             0.076 **                         
##                            (0.030)                           
##     EUldrSpread_lag1                         -0.166          
##                                              (0.330)         
## Security                                                     
##                                                              
##     IntlCnf                 0.057                            
##                            (0.038)                           
##     CivilWar                                 -0.396          
##                                              (0.369)         
## Macroeconomic                                                
##                                                              
##     GDPpCapDelt             0.150                            
##                            (0.090)                           
## Parliamentary                                                
##                                                              
##     Cab_liberty_authority                     0.054          
##                                              (0.038)         
##     Cab_eu_anti_pro                           0.032          
##                                              (0.038)         
##     eu_anti_pro_ls_spread   0.003 **                         
##                            (0.002)                           
## -------------------------------------------------------------
## R^2                         0.184             0.030          
## Adj. R^2                    0.173             0.028          
## Num. obs.                  81                78              
## =============================================================
## *** p < 0.01, ** p < 0.05, * p < 0.1
```

#Hypothesis 3: Public Support for NATO

Hypothesis 3 a: Net public support for believing that NATO is essential to your country's security will increase defense spending. 
Hypothesis 3 b: Net public support for believing that NATO is essential to your country's security will increase defense spending. 
Hypothesis 3 cb: Net public support for believing that NATO is essential to your country's security will increase investment spending.


```r
#Model #5 is Defense Spending and NATO EU convergence
Europe_model<-rbind(
    Europe_model[1:4,],
    panelmodels(selected.formula="DefSpendDelt_lead ~ NATO.EUspread_lag1   + GDPpCapDelt + liberty_authority_ls_spread",
                source.data=DefSpread,
                regression.name="NATO-EU Conv. & Def",
                include.random=FALSE)
)
```

```
## series Unit.Currency is constant and has been removed
## series Unit.Currency is constant and has been removed
## series Unit.Currency is constant and has been removed
## series Unit.Currency is constant and has been removed
```

```r
# summary(Europe_model$ols[[5]])
summary(Europe_model$pooling[[5]])
```

```
## Oneway (individual) effect Pooling Model
## 
## Call:
## plm(formula = as.formula(selected.formula), data = source.data, 
##     model = "pooling")
## 
## Balanced Panel: n=8, T=8, N=64
## 
## Residuals :
##     Min.  1st Qu.   Median  3rd Qu.     Max. 
## -0.19700 -0.03040  0.00422  0.04080  0.16900 
## 
## Coefficients :
##                               Estimate Std. Error t-value Pr(>|t|)  
## (Intercept)                  0.0113942  0.0166765  0.6832  0.49708  
## NATO.EUspread_lag1           0.0783871  0.0450339  1.7406  0.08688 .
## GDPpCapDelt                  0.1159769  0.1024389  1.1322  0.26207  
## liberty_authority_ls_spread -0.0011648  0.0012981 -0.8974  0.37312  
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Total Sum of Squares:    0.24637
## Residual Sum of Squares: 0.231
## R-Squared      :  0.062392 
##       Adj. R-Squared :  0.058493 
## F-statistic: 1.33088 on 3 and 60 DF, p-value: 0.27278
```

```r
# summary(Europe_model$between[[5]])
# summary(Europe_model$fd[[5]])
# summary(Europe_model$within[[5]])
# summary(Europe_model$random[[5]])
# plot(Europe_model$ols[[5]])

#Model #6 is Defense Spending and NATO essential
Europe_model<-rbind(
    Europe_model[1:5,],
    panelmodels(selected.formula="DefSpendDelt_lead ~ NATOessSpread_lag2",
                source.data=DefSpread,
                regression.name="NATO Ess. & Def",
                include.random=TRUE)
)
```

```
## series Unit.Currency is constant and has been removed
## series Unit.Currency is constant and has been removed
## series Unit.Currency is constant and has been removed
## series Unit.Currency is constant and has been removed
## series Unit.Currency is constant and has been removed
```

```r
# summary(Europe_model$ols[[6]])
# summary(Europe_model$pooling[[6]])
# summary(Europe_model$between[[6]])
# summary(Europe_model$fd[[6]])
summary(Europe_model$within[[6]])
```

```
## Oneway (individual) effect Within Model
## 
## Call:
## plm(formula = as.formula(selected.formula), data = source.data, 
##     model = "within")
## 
## Unbalanced Panel: n=9, T=8-9, N=78
## 
## Residuals :
##     Min.  1st Qu.   Median  3rd Qu.     Max. 
## -0.18100 -0.03830  0.00576  0.03820  0.16400 
## 
## Coefficients :
##                    Estimate Std. Error t-value Pr(>|t|)
## NATOessSpread_lag2 0.022703   0.085186  0.2665   0.7906
## 
## Total Sum of Squares:    0.30404
## Residual Sum of Squares: 0.30372
## R-Squared      :  0.0010435 
##       Adj. R-Squared :  0.00090969 
## F-statistic: 0.0710299 on 1 and 68 DF, p-value: 0.79065
```

```r
# summary(Europe_model$random[[6]])

# plot(Europe_model$ols[[6]])


#Model #7 is Equipment Spending and NATO essential
Europe_model<-rbind(
    Europe_model[1:6,],
    panelmodels(selected.formula="EquSpendDelt_lead ~ NATO.EUspread_lag2  + GDPpCapDelt + eu_anti_pro_ls_spread",
                source.data=DefSpread,
                regression.name="NATO-EU Conv. & Equ",
                include.random=FALSE)
)
```

```
## series Unit.Currency is constant and has been removed
## series Unit.Currency is constant and has been removed
## series Unit.Currency is constant and has been removed
## series Unit.Currency is constant and has been removed
```

```r
# summary(Europe_model$ols[[7]])
summary(Europe_model$pooling[[7]])
```

```
## Oneway (individual) effect Pooling Model
## 
## Call:
## plm(formula = as.formula(selected.formula), data = source.data, 
##     model = "pooling")
## 
## Balanced Panel: n=8, T=7, N=56
## 
## Residuals :
##    Min. 1st Qu.  Median 3rd Qu.    Max. 
## -0.8910 -0.2350 -0.0833  0.0834  2.4000 
## 
## Coefficients :
##                        Estimate Std. Error t-value Pr(>|t|)
## (Intercept)            0.193113   0.116976  1.6509   0.1048
## NATO.EUspread_lag2     0.586667   0.390107  1.5039   0.1387
## GDPpCapDelt            0.976197   0.960252  1.0166   0.3140
## eu_anti_pro_ls_spread -0.020585   0.016556 -1.2434   0.2193
## 
## Total Sum of Squares:    15.817
## Residual Sum of Squares: 14.762
## R-Squared      :  0.066737 
##       Adj. R-Squared :  0.06197 
## F-statistic: 1.2395 on 3 and 52 DF, p-value: 0.30483
```

```r
# summary(Europe_model$between[[7]])
# summary(Europe_model$fd[[7]])
# summary(Europe_model$within[[7]])
# summary(Europe_model$random[[3]])
# plot(Europe_model$ols[[7]])



#Model #8 is Equipment Spending and NATO EU convergence
Europe_model<-rbind(
    Europe_model[1:7,],
    panelmodels(selected.formula="EquSpendDelt_lead ~ NATOessSpread_lag1  + CivilWar",
                source.data=DefSpread,
                regression.name="NATO Ess. & Equ",
                include.random=FALSE)
)
```

```
## series Unit.Currency is constant and has been removed
## series Unit.Currency is constant and has been removed
## series Unit.Currency is constant and has been removed
## series Unit.Currency is constant and has been removed
```

```r
# summary(Europe_model$ols[[8]])
summary(Europe_model$pooling[[8]])
```

```
## Oneway (individual) effect Pooling Model
## 
## Call:
## plm(formula = as.formula(selected.formula), data = source.data, 
##     model = "pooling")
## 
## Unbalanced Panel: n=9, T=9-10, N=87
## 
## Residuals :
##    Min. 1st Qu.  Median 3rd Qu.    Max. 
## -0.8130 -0.1710 -0.0671  0.0965  2.5700 
## 
## Coefficients :
##                    Estimate Std. Error t-value Pr(>|t|)  
## (Intercept)         0.18695    0.11193  1.6702  0.09861 .
## NATOessSpread_lag1 -0.47438    0.34767 -1.3644  0.17607  
## CivilWar           -0.20930    0.17789 -1.1766  0.24270  
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Total Sum of Squares:    17.096
## Residual Sum of Squares: 16.655
## R-Squared      :  0.025811 
##       Adj. R-Squared :  0.024921 
## F-statistic: 1.11277 on 2 and 84 DF, p-value: 0.33344
```

```r
# summary(Europe_model$between[[8]])
# summary(Europe_model$fd[[8]])
# summary(Europe_model$within[[8]])
# summary(Europe_model$random[[8]])
plot(Europe_model$ols[[8]])
```

![](EuropeanDefenseSelectedModels_files/figure-html/Hyp3_NATO-1.png) ![](EuropeanDefenseSelectedModels_files/figure-html/Hyp3_NATO-2.png) ![](EuropeanDefenseSelectedModels_files/figure-html/Hyp3_NATO-3.png) ![](EuropeanDefenseSelectedModels_files/figure-html/Hyp3_NATO-4.png) 

```r
screenreg(list(Europe_model$pooling[[5]],Europe_model$within[[6]],Europe_model$pooling[[7]],Europe_model$pooling[[8]]),
          custom.model.name=c(as.character(Europe_model$name[5:8])),
          digits=4,
          stars=c(0.01,0.05,0.1),
          reorder.coef=c(1,2,6,5,8,9,3,4,7),
          groups = list("Intercept" = 1,"Polling" = 2:5, "Security" = 6, "Macroeconomic" = 7, "Parliamentary"=8:9)

          )
```

```
## 
## ===========================================================================================================
##                                  NATO-EU Conv. & Def  NATO Ess. & Def  NATO-EU Conv. & Equ  NATO Ess. & Equ
## -----------------------------------------------------------------------------------------------------------
## Intercept                                                                                                  
##                                                                                                            
##     (Intercept)                   0.0114                                0.1931               0.1869 *      
##                                  (0.0167)                              (0.1170)             (0.1119)       
## Polling                                                                                                    
##                                                                                                            
##     NATO.EUspread_lag1            0.0784 *                                                                 
##                                  (0.0450)                                                                  
##     NATO.EUspread_lag2                                                  0.5867                             
##                                                                        (0.3901)                            
##     NATOessSpread_lag2                                 0.0227                                              
##                                                       (0.0852)                                             
##     NATOessSpread_lag1                                                                      -0.4744        
##                                                                                             (0.3477)       
## Security                                                                                                   
##                                                                                                            
##     CivilWar                                                                                -0.2093        
##                                                                                             (0.1779)       
## Macroeconomic                                                                                              
##                                                                                                            
##     GDPpCapDelt                   0.1160                                0.9762                             
##                                  (0.1024)                              (0.9603)                            
## Parliamentary                                                                                              
##                                                                                                            
##     liberty_authority_ls_spread  -0.0012                                                                   
##                                  (0.0013)                                                                  
##     eu_anti_pro_ls_spread                                              -0.0206                             
##                                                                        (0.0166)                            
## -----------------------------------------------------------------------------------------------------------
## R^2                               0.0624               0.0010           0.0667               0.0258        
## Adj. R^2                          0.0585               0.0009           0.0620               0.0249        
## Num. obs.                        64                   78               56                   87             
## ===========================================================================================================
## *** p < 0.01, ** p < 0.05, * p < 0.1
```

#Dependent Variable cross-analyses

##All Tests Using Top-Line Defense Spending as a Dependent Variable


```r
screenreg(list(Europe_model$pooling[[1]],Europe_model$pooling[[3]],Europe_model$pooling[[5]],Europe_model$within[[6]]),
          custom.model.name=c(as.character(Europe_model$name[c(1,3,5,6)])),
          digits=4,
          stars=c(0.01,0.05,0.1),
          reorder.coef=c(1,7,2,4,9,5,3,8,6),
          groups = list("Intercept" = 1,"Polling" = 2:5, "Security"=6,"Macroeconomic" = 7, "Parliamentary"=8:9)
          )
```

```
## 
## ==============================================================================================================
##                                  Too Much/Little & Def  EU leader. & Def  NATO-EU Conv. & Def  NATO Ess. & Def
## --------------------------------------------------------------------------------------------------------------
## Intercept                                                                                                     
##                                                                                                               
##     (Intercept)                   0.0146                -0.0705 ***        0.0114                             
##                                  (0.0091)               (0.0201)          (0.0167)                            
## Polling                                                                                                       
##                                                                                                               
##     NATO.EUspread_lag1                                                     0.0784 *                           
##                                                                           (0.0450)                            
##     DefSpread_lag1                0.1303 ***                                                                  
##                                  (0.0376)                                                                     
##     EUldrSpread                                          0.0762 **                                            
##                                                         (0.0303)                                              
##     NATOessSpread_lag2                                                                          0.0227        
##                                                                                                (0.0852)       
## Security                                                                                                      
##                                                                                                               
##     IntlCnf                                              0.0565                                               
##                                                         (0.0385)                                              
## Macroeconomic                                                                                                 
##                                                                                                               
##     GDPpCapDelt                   0.1295                 0.1498            0.1160                             
##                                  (0.0843)               (0.0900)          (0.1024)                            
## Parliamentary                                                                                                 
##                                                                                                               
##     liberty_authority_ls_spread                                           -0.0012                             
##                                                                           (0.0013)                            
##     eu_anti_pro_ls_spread                                0.0035 **                                            
##                                                         (0.0016)                                              
## --------------------------------------------------------------------------------------------------------------
## R^2                               0.2189                 0.1840            0.0624               0.0010        
## Adj. R^2                          0.2065                 0.1726            0.0585               0.0009        
## Num. obs.                        53                     81                64                   78             
## ==============================================================================================================
## *** p < 0.01, ** p < 0.05, * p < 0.1
```

##All Tests Using Defense Investment Spending as a Dependent Variable


```r
screenreg(list(Europe_model$random[[2]],Europe_model$pooling[[4]],Europe_model$pooling[[7]],Europe_model$pooling[[8]]),
          custom.model.name=c(as.character(Europe_model$name[c(2,4,7,8)])),
          digits=4,
          stars=c(0.01,0.05,0.1),
          reorder.coef=c(1,2,5,10,11,6,3,4,7,9,8),
          groups = list("Intercept" = 1,"Polling" = 2:5, "Security"=6,"Macroeconomic" = 7, "Parliamentary"=8:11)
          )
```

```
## 
## ========================================================================================================
##                            Too Much/Little & Equ  EU leader. & Equ  NATO-EU Conv. & Equ  NATO Ess. & Equ
## --------------------------------------------------------------------------------------------------------
## Intercept                                                                                               
##                                                                                                         
##     (Intercept)             0.1633 **             -0.4013            0.1931               0.1869 *      
##                            (0.0719)               (0.4224)          (0.1170)             (0.1119)       
## Polling                                                                                                 
##                                                                                                         
##     DefSpread_lag2          0.5265 ***                                                                  
##                            (0.1627)                                                                     
##     EUldrSpread_lag1                              -0.1656                                               
##                                                   (0.3298)                                              
##     eu_anti_pro_ls_spread                                           -0.0206                             
##                                                                     (0.0166)                            
##     NATOessSpread_lag1                                                                   -0.4744        
##                                                                                          (0.3477)       
## Security                                                                                                
##                                                                                                         
##     CivilWar                                      -0.3960                                -0.2093        
##                                                   (0.3695)                               (0.1779)       
## Macroeconomic                                                                                           
##                                                                                                         
##     GDPpCapDelt             0.9123 *                                 0.9762                             
##                            (0.5053)                                 (0.9603)                            
## Parliamentary                                                                                           
##                                                                                                         
##     left_right_ls_spread   -0.0164 ***                                                                  
##                            (0.0056)                                                                     
##     Cab_liberty_authority                          0.0543                                               
##                                                   (0.0376)                                              
##     NATO.EUspread_lag2                                               0.5867                             
##                                                                     (0.3901)                            
##     Cab_eu_anti_pro                                0.0317                                               
##                                                   (0.0383)                                              
## --------------------------------------------------------------------------------------------------------
## R^2                         0.3342                 0.0299            0.0667               0.0258        
## Adj. R^2                    0.3031                 0.0280            0.0620               0.0249        
## Num. obs.                  43                     78                56                   87             
## ========================================================================================================
## *** p < 0.01, ** p < 0.05, * p < 0.1
```
