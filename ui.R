
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

fileName <- 'cr.svg'
mapa <- readChar(fileName, file.info(fileName)$size)
chosenProvince <<- 'path[data-prov="1"] {
          fill: red;
  }'
listaProvincias <- levels(distritos$provincia)
listaCantones <- levels(factor(distritos[distritos$pCode==2,"canton"]))


shinyUI(fluidPage(theme = "bootstrap.css",

  # Application title
  headerPanel("Costa Rica Map Explorer"),
  h4("Learn about the provinces and cantons"),
  
  tags$span("Author: "),
  icon("twitter",lib = "font-awesome"),
  tags$a(href="https://twitter.com/esmitperez","@esmitperez"),
  icon("github",lib = "font-awesome"),
  tags$a(href="https://github.com/esmitperez/Ujko-ng","esmitperez"),
  icon("linkedin",lib = "font-awesome"),
  tags$a(href="http://esmitperez.github.io/Ujko-ng/index.html","esmitperez"),
  tags$div("Date Created: March 4th 2015"),
  helpText("Change the province using the provided dropdown, it is then highlighted in the map and its cantons will be loaded from a data.frame created from a .csv file. This is a Shiny based proof of concept of my Ujko-ng project (see my GitHub repo). This application was created for the Developing Data Products course project on Coursera."),
  includeCSS("www/css/crmaps.css"),
  
  # get current styling data
  htmlOutput("stylesForMap"),
  
  # Sidebar with a slider input for number of bins
  sidebarLayout(
          sidebarPanel(
                  selectInput(choices = listaProvincias, 
                              inputId = "provinciaId", 
                              label = "Province", 
                              selectize = T, multiple=F),
                  tableOutput("cantonList")
                  ),
          
          mainPanel( HTML(text = '<svg width="550px" height="550px" xmlns="http://www.w3.org/2000/svg">'),
                     HTML(text=mapa),
                     HTML(text="</svg>"))
          
          )
))
