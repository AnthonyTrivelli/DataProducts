---
title       : Auto Insurance Rate Analysis
subtitle    : What Is Driving Different Auto Insurance Premiums Across States
author      : A. Trivelli
job         : 
framework   : io2012        # {io2012, html5slides, shower, dzslides, ...}
highlighter : highlight.js  # {highlight.js, prettify, highlight}
hitheme     : tomorrow      # 
widgets     : []            # {mathjax, quiz, bootstrap}
mode        : selfcontained # {standalone, draft}
knit        : slidify::knit2slides
classoption: landscape
geometry: margin=0in

---



## Introduction

People often complain that automobile insurance is wildly expensive in their state...

Part of this is perception but a portion is rooted in actual premium rates differences.  We are all aware that the rates do vary based upon a person's demographics, driving record and even the type of car they are driving.  Putting these aside though, we are going to explore:

* Are there fundamental baseline differences in the rate structures across the states?
* What is driving these rate differences?

---

## Varying Auto Insurance Premiums Across States

#### Some Basic Statistics


![plot of chunk unnamed-chunk-1](assets/fig/unnamed-chunk-1-1.png)

* The type of policy whether NoFault, Choice or Tort(Not NoFault) has some effect in the spread of Premiums.



* But, the distribution of auto premiums are more than likely being driven by other factors given the individual spreads within Policy type.

> We really need to explore the data further...


---

## Are There Relevant Factors That are Driving the Varying Premiums or are Insurers Price Gouging Across Different States ?

#### Many factors can be driving auto premium differences such as:

* Driver Demographics/Type of Car
* Points on License
* Historical Accidents
* Theft/Larceny Associated with the geographical area
* Miles driven
* Urban/Suburban/Rural attributing factors and others...

#### To analyze these factors is a larger effort than afforded here, but can we find a factor(s) that proves or disproves the price gouging hypothesis and if so against what outcome ?


---

##  Use the Insurance Premium Analysis App to Explore and Correlate between Rate and Underlying Factors

<img src="./assets/img/InsuranceShinyApp.png" title="plot of chunk unnamed-chunk-2" alt="plot of chunk unnamed-chunk-2" width="600" />

##### Hint: Are the amount of claims generated on a state by state basis a significant factor to Premium pricing/rates ?

[To visit the Insurance Premium Analysis App, follow this URL link]( https://trivea.shinyapps.io/InsuranceShiny/ "Data Products")

#### Thank you
