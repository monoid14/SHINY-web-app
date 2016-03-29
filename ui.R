
# This small SHINY web app demonstrates and compares the linear and quadratic
# models for predicting the consumption of a car based on its weight.
# CLIENT part

library(shiny)

data("mtcars")
min.wt <- min(mtcars$wt)
max.wt <- max(mtcars$wt)
avg.wt <- mean(mtcars$wt)

shinyUI(pageWithSidebar(
    headerPanel("Fuel consumption vs weight of cars", 
                windowTitle = "Fuel consumption vs weight of cars"), 
    
    sidebarPanel(
        h3("Documentation"),
        p("This small SHINY app demonstrates the linear and 
          quadratic models for predicting the fuel consumption of a car, given 
          its weight."),
        p("The user inputs the car weight, selects a model (default is linear), 
          and the predicted consumption is given together with a plotted visual 
          representation. The user may press the button 'Make report' 
          to generate a report that summarizes the prediction results."),
        p("Note that when changing the weight and model parameters, the plot and 
          the predicted value are automatically updated. However, the summary report 
          is only updated after the button 'Make report' is pressed."),
        a("Link to source code", href = "http://link.to.this.file"),  ###update this!
        
        h3("Input parameters"), 
        p("Set parameters to see the expected fuel consumption."),
        
        numericInput("in.wt", label = h4("Car weight in lb/1000"),  #weight user input
                     avg.wt, min = min.wt, max = max.wt, step = 0.1),
        
        radioButtons("in.model", label = h4("Prediction model"),          #model input
                     choices = list("Linear (y~x)" = 1, "Quadratic (y~x+x^2)" = 2), 
                     selected = 1), 
        
        actionButton("repButton", "Make report")        #generate prediction report
    ),
    
    mainPanel(
        h3("Comparing linear and quadratic models"), 
        
        p("The plot below depicts the relationship between car weight and car fuel 
          consumption, based on the 'mtcars' dataset. The blue line shows the linear 
          fit, while the green line shows the quadratic fit."),
        p("The gray vertical line indicates the selected weight, and the red 
          horizontal line indicates the predicted fuel consumption for the current 
          model."),
        plotOutput("carplot"),           #the plot
        
        p("The predicted fuel consumption in miles per gallon is: "),
        verbatimTextOutput("pred.val"),  #the predicted consumption value
        
        h3("Report"),
        textOutput("report")             #the report
    )
))
