
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(RColorBrewer)
library(plyr)

distritos <<- read.csv("distritos.csv",fileEncoding="UTF-16", header = T)
# determine province ID
distritos$pCode <- substr(x = distritos$coddist, start = 1,stop = 1)
distritos$cCode <- as.numeric(substr(x = distritos$coddist, start = 2,stop = 3))
cat("Created look up table...")

# See http://colorbrewer2.org/ for more info
cloropethpalette<-brewer.pal(9,"Purples")

shinyServer(function(input, output,session) {

  # keep track of changes in UI
  observe({
        s_options <- levels(factor(distritos[distritos$pCode==input$provinciaId,"canton"]))
       
        updateSelectInput(session,"cantonId",choices=s_options)
        provId <- distritos[distritos$provincia==input$provinciaId, "pCode"][1]
       
        # remove dups, filter all cantons
        colorTable <- reactive({
                l <- ddply(distritos[distritos$pCode==provId,],~canton+pCode+cCode,summarise,
                           n=sum(!is.na(canton))
                           #,paste0('<style>path[data-canton="',cCode,'"][data-prov="',pCode,'"] {fill:#cc4c02}</style>')
                           )
                l <- cbind(l,colorCode=rep(cloropethpalette,length.out=nrow(l)))
                #maybe use sapply+ function??
                l$css <- paste0('<style>path[data-canton="',l$cCode,'"][data-prov="',l$pCode,'"] {fill:',l$color,'}</style>')
                l
        })
        
        listToShow <- reactive({
                l <- ddply(distritos[distritos$pCode==provId,],~canton,summarise,sum(!is.na(canton)))
                colnames(l) <- c("Cantons","District Count")
                l
        })
        
        output$stylesForMap <- renderText(colorTable()$css)
        output$cantonList <-  renderTable({listToShow()},label="Cantons")
  })

})
