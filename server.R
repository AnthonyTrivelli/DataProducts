#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
## Run once
##setwd("~/Documents/DataScience/Insurance")

histTitle <- c("Blank")

demo <- read.csv("./Data/PD Incurred Losses and Incurred Claims.csv", header= TRUE)
demo <- na.omit(demo)

tort <- read.csv("./Data/Tort-No Fault.csv", header= TRUE)
novehicles <- read.csv("./Data/No vehicles and thefts.csv")
combined <- merge( demo, tort )

prem <- read.csv("./Data/Combined Avg Premium.csv", header= TRUE)
premcombined <- merge( prem, tort )

EP <- read.csv("./Data/PD EP and EE v2.csv", header= TRUE)

allmerged <- merge( premcombined , demo, by.x = "STATE", by.y= "STATE")
allmerged2 <- merge(allmerged, novehicles, by.x = "STATE", by.y= "STATE" )

allmerged3 <- merge (allmerged2, EP, by.x = "STATE", by.y= "STATE")
allmerged3$IncurredperVehicle <- allmerged3$X2012.Incurred.Losses/allmerged3$X2012.No.of.RegVehicles




# Define server logic Insurance Shiny App
shinyServer(function(input, output, session) {
  
  output$histtab <- renderUI( {
    sidebarLayout(
      sidebarPanel(
        radioButtons("measure", "Financial Measure Type:",
                     c("Insurance Premium" = "GPW",
                       "Earned Premium" = "EP",
                       "Incurred Loss" = "Incurred",
                       "No. of Claims" = "NoClaims")),
        br(),
        
        sliderInput("nobuck", 
                    "Number of Histogram Buckets", 
                    value = 8,
                    min = 1, 
                    max = 15),
        h4("Documentation", align= "center"),
        hr(),
        h5("The histogram on this page shows the frequency/number of states that for that particular financial or event count( claim )"),
        h5("To use, select from one of the measures or event type and the histogram will automatically update"),
        h5("- In addition, there is the option to modify the bucket size on the histogram via the slide"),
        h6( "- Based upon data from the NAIC Auto Insurance Database report 20112/2013")
       
      ),
      mainPanel( plotOutput("hist") )
    )
  })
  
  output$regrtab <- renderUI ( {
    sidebarLayout(
      sidebarPanel(
        
        checkboxGroupInput("regroptions", label = h3("Plotting Options"), 
                           choices = list("No Fault Regression" = 1, 
                                          "Tort Regression" = 2, "Tort Confidence Interval" = 3),
                                      selected = NULL),
       
        hr(),
        br(),
        actionButton("update", "Update"),
        hr(),
        br(),
        verbatimTextOutput("pvalue"),
        h4("Documentation", align= "center"),
        hr(),
        h5("This tab depicts an x-y plot of Auto Insurance Rate vs the $Incurred Loss per vehicle to determine if there is a definitive coorelation between the two that are driving the varied auto insurance premiums per state "),
        h5("With no options selected, a basic x-y plot is displayed"),
        h5("- To see linear regressions between the the two terms, select either No Fault or Tort Regression and press update"),
        h5( "- In addition, a 95% confidence interval of the Tort regression can be displayed in conjunction with the other options if so desired"),
        h4("Term definitions:"),
        h5("    - Rate: Exposure Premium/ Earned Exposure which is the normalized premium divided by the normalized amount of risk that the insurer can account for during a period"),
        h5("    - Incurred Losses per Vehicle:  The amount of actual losses and anticipated losses due to auto claims per vehicle in that particular state")
        
        
        
        
      ) ,
    mainPanel( plotOutput("regression"),
               h3("Additional Information", align= "center"),
               hr(),
               h4("As observed in the data, premium varies greatly on a state by state basis, but a high degree of that variation is driven by the observed Claim Incurred Losses per vehicle as demonstrated in the above regression lines and associated P-values. Also note the differences in Rates as related to Incurred Losses per Vehicle for states with NoFault versus Tort based Auto Policies"),
               h4("No Fault refers to those States that have a No Fault Auto Insurance structure vs. Tort states that facilitate lawsuits as part of the Insurance structure"),
               
               br(),
               h5("The confidence interval, along with the regression lines are calculated objects that are implemented with shiny reactive"),
               br(),
               h6("- Rate defined as: Exposure Premium/ Earned Exposure"),
               h6( "- Based upon data from the NAIC Auto Insurance Database report 20112/2013"),
               h6(" - A regression line is not available for Choice based insurance due to the limited number of data points")
               )
    )
  })
  
  
  # Reactive expression to generate the requested distribution.
  # This is called whenever the inputs change. The output
  # functions defined below then all use the value computed from
  # this expression
  
  tdata <- reactive({

    histData <- switch(input$measure,
                      GPW = data.frame( allmerged3$STATE, allmerged3$X2012),
                      EP = data.frame( allmerged3$STATE, allmerged3$X2012.Earned.Premium),
                      Incurred = data.frame( allmerged3$STATE, allmerged3$X2012.Incurred.Losses),
                      NoClaims= data.frame( allmerged3$STATE, allmerged3$X2012.Incurred.Claims),
                      data.frame( allmerged3$STATE, allmerged3$X2012) )
    colnames(histData) <- c("State", "measure" )
  
      
    histData
    })
  
  
  # Generate a hist plot of the data and uses the inputs to build label. 
  
  output$hist <- renderPlot({
    
    histTitle <- switch(input$measure,
                        GPW = c("Distribution of Average Auto Insurance Premiums Across the States", 
                                "Premium (in Dollars)"),
                        EP = c("Distribution Earned Premiums Across the States",
                               "Earned Premium (in Dollars)" ),
                        Incurred = c( "Distribution of Incurred Losses Across the States",
                                      "Incurred Losses (in Dollars)" ),
                        NoClaims= c("Distribution of the Number of Claims Across the States",
                                    "Number of Claims"),
                        "Distribution of the Average Auto Insurance Premiums Across the States")
    options(scipen=5)
    
    hist(tdata()$measure, main= histTitle[1],
         breaks= input$nobuck,
         xlab= histTitle[2],
         ylab= "Number of States",
         xlim=c(min(tdata()$measure), max(tdata()$measure)))

  })
  
  # Generate a x-y plot and linear regression lines on the data
  
  output$regression <- renderPlot({
    
    input$update
    
    ## handle reactive options for regression lines and 
    ## confidence intervals to allow user to pick various options first and then submit for update
    
    
    regr_options <- isolate( {  
    
    plot( allmerged3$IncurredperVehicle ,allmerged3$rate, 
          main = "Automobile Insurance Rate vs Incurred per Vehicle by Insurance Type",
          xlab= "Incurred Claims Amount per Vehicle",
          ylab= "Rate" )
    
    # place a legend
    legend(100,100, 
           c("NoFault","Tort", "Choice" ),
           pch= c(1,1,1),
           col= c("blue","red","green"),
           text.width= 20)
    
    with ( subset(allmerged3, NoFault== "Yes"), 
           points( IncurredperVehicle  ,rate, col= "blue"))
    with ( subset(allmerged3, NoFault== "No"), 
           points( IncurredperVehicle ,rate, col= "red"))
    with ( subset(allmerged3, NoFault== "Choice"), 
           points( IncurredperVehicle ,rate, col= "green"))
    
    input$regroptions 
    
    } ) 
    
    if( length( regr_options) > 0) {
    
      if( "1" %in% regr_options) { 
          modelNoFault<- lm( rate ~ IncurredperVehicle , 
                             allmerged3[ allmerged3$NoFault== "Yes", ])
          abline( modelNoFault, lwd= 2, col= "blue" )
      }
      if( "2" %in% regr_options ) { 
      
          
        modelTort <- lm( rate ~ IncurredperVehicle ,
                        allmerged3[ allmerged3$NoFault== "No", ])
        
        abline( modelTort, lwd= 2, col= "red" )
        p <-summary(modelTort)$coefficients
        output$pvalue <- renderText ({sprintf( "The P-value for the Tort Regression for the Incurred per Vehicle coefficient is %e", p[2,4] )
          })
      }
      else {
        
        output$pvalue <- renderText({"Tort Linear regression P-value not available"})
      }
    ##modelChoice <- lm( rate ~ IncurredperVehicle, 
              ##         allmerged3[ allmerged3$NoFault== "Choice", ])
      # abline( modelChoice, lwd= 2, col= "green" )
    
      if( "3" %in% regr_options) { 
        ## Calculate and print the 95% confidence intervals
        confData <- seq(min(allmerged3$IncurredperVehicle), max(allmerged3$IncurredperVehicle), 1)
        modelTort <- lm( rate ~ IncurredperVehicle ,
                         allmerged3[ allmerged3$NoFault== "No", ])
        
        a <- predict(modelTort, newdata=data.frame(IncurredperVehicle=confData), interval="confidence")
        lines(confData,a[,2], lty=3)
        lines(confData,a[,3], lty=3) 
      }
    
    }
  })
  
 
  
})
