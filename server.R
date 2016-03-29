
# This small SHINY web app demonstrates and compares the linear and quadratic
# models for predicting the consumption of a car based on its weight.
# SERVER part

library(shiny)

data("mtcars")

#fitting two models on mpg ~ wt
fit1.wt <- lm(mpg ~ wt, data = mtcars)            #linear model: mpg ~ wt
fit2.wt <- lm(mpg ~ poly(wt, 2), data = mtcars)   #quadratic model: mpg ~ wt + wt^2

#array of random weights for plotting the quadratic line
xplot <- seq(min(mtcars$wt), max(mtcars$wt), length = 100)

#prediction depends on selected model
car.predict <- function(weight, model) {
    if (model == 1) predict(fit1.wt, data.frame(wt = weight))  #linear
    else predict(fit2.wt, data.frame(wt = weight))             #quadratic
}

#server-side function
shinyServer(
    function(input, output) {
        #plot fitted lines and selected / predicted values
        output$carplot <- renderPlot({
            #plot fitted lines
            plot(mtcars$wt, mtcars$mpg, 
                 xlab = "Car weight (lb/1000)", ylab = "Fuel consumption (Miles Per Gallon)", 
                 main = "Fuel consumption: linear and quadratic models")
            abline(fit1.wt, col = "blue", lwd = 2)
            lines(xplot, predict(fit2.wt, newdata = data.frame(wt = xplot)), 
                  col="green", lwd = 2)
            
            #plot wt user value and mpg prediction (of selected model)
            abline(v = input$in.wt, col = "gray", lty = 2)
            abline(h = car.predict(input$in.wt, input$in.model), col = "red", lty = 2)
        })
        
        #display predicted mpg value for user input (wt value)
        output$pred.val = renderText({car.predict(input$in.wt, input$in.model)})
        
        #compile a report summarizing the prediction results
        output$report <- renderText({
            input$repButton  #when button is pressed, compile report
            isolate(paste("Yoy have selected the ", ifelse(input$in.model == 1, 
                                                           "linear", "quadratic"),
                          " model. This model predicts that a car weighting ", 
                          input$in.wt * 1000, " lbs covers ", 
                          car.predict(input$in.wt, input$in.model), " miles per gallon.", 
                          " The difference between the predictions given by the two models
                          (linear - quandratic) is: ", 
                          car.predict(input$in.wt, 1) - car.predict(input$in.wt, 2)
            ))
        })
    }
)
