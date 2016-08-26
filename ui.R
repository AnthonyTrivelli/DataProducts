#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for random distribution application 
shinyUI(
  navbarPage("Insurance Premium Analysis",
             tabPanel("Exploratory Histograms", uiOutput("histtab")),
             tabPanel( "Regression Plot", uiOutput("regrtab"))
  )
)
             
              
 






