
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

distritos <<- read.csv("distritos.csv",fileEncoding="UTF-16", header = T)
# determine province ID
distritos$pCode <- substr(x = distritos$coddist, start = 1,stop = 1)
distritos$cCode <- substr(x = distritos$coddist, start = 1,stop = 3)
cat("Created look up table...")


shinyServer(function(input, output,session) {

  # keep track of changes in UI
  observe({
        s_options <- levels(factor(distritos[distritos$pCode==input$provinciaId,"canton"]))
       
        updateSelectInput(session,"cantonId",choices=s_options)
        provId <- distritos[distritos$provincia==input$provinciaId, "pCode"][1]
        output$stylesForMap <-  renderText(paste0('<style>path[data-prov="',
                                       provId,
                                       '"] {fill:#cc4c02}</style>'))
        # remove dups, filter all cantons
        listToShow <- reactive({
                               l <- data.frame(unique(distritos[distritos$pCode==provId,c("canton")]))
                               colnames(l) <- c("Cantons")
                               l
        })
        
        output$cantonList <-  renderTable({listToShow()},label="Cantons")
  })

})
