rm(list = ls())
require(shiny)
require(sets)
setwd("~/Documents/investigacion ii/posible/pruebas/fuzzyLogic_ranking")
test <- read.csv("~/Documents/investigacion ii/posible/pruebas/fuzzyLogic_ranking/pre_transformed.csv")
#test <- read.csv2(file.choose())

filtros <- c("hotel", "lineaNegocio", "origen", "destino", "temporada", "ninnoGratis", 
             "nocheGratis", "descuentos", "parejas", "addValues", "checkBox")

#datos <- test[, !names(test) %in% filtros] #variables for checkBoxes

datos <- test
datos$ranking <- 0
test$ranking <- 0
colnames <- names(datos)


##set universe
sets_options("universe", seq(from = 0, to = 10, by = 0.1))

##set up fuzzy variables
variables <- set(
  tecnologia = fuzzy_partition(
    varnames = c(
      poco = 0,
      medio = 5,
      bueno = 10
    ),
    sd = 2
  ),
  
  necesidad = fuzzy_partition(
    varnames = c(
      baja = 0,
      normal = 5,
      mucha = 10
    ),
    sd = 2
  ),
  
  mercado = fuzzy_partition(
    varnames = c(
      poco = 0,
      medio = 5,
      alto = 10
    ),
    sd = 2
  ),
  ranking = fuzzy_partition(
    varnames = c(
      bajo = 0,
      regular = 5,
      alto = 10
    ),
    FUN = fuzzy_cone,
    radius = 5
  )
)

###set up rules
rules <- set(
  fuzzy_rule(tecnologia %is% bueno && necesidad %is% mucha && mercado %is% alto, ranking %is% alto),
  fuzzy_rule(tecnologia %is% medio && necesidad %is% mucha && mercado %is% medio, ranking %is% regular),
  fuzzy_rule(tecnologia %is% poco && necesidad %is% baja && mercado %is% poco, ranking %is% bajo),
  fuzzy_rule(tecnologia %is% bueno && necesidad %is% mucha && mercado %is% medio, ranking %is% alto),
  fuzzy_rule(tecnologia %is% medio && necesidad %is% normal && mercado %is% medio, ranking %is% regular),
  fuzzy_rule(tecnologia %is% medio && necesidad %is% baja && mercado %is% poco, ranking %is% alto),
  fuzzy_rule(tecnologia %is% poco && necesidad %is% baja && mercado %is% alto, ranking %is% alto),
  fuzzy_rule(tecnologia %is% poco && necesidad %is% mucha && mercado %is% alto, ranking %is% regular)
  
)

###combine to a system
system <- fuzzy_system(variables, rules)

system <- fuzzy_system(variables, rules)
#####
ui <- fluidPage(
  titlePanel(
    h1("Sistema de Ranking", align = "center")),
  fluidRow(column = 4, align = "center",
           tags$img(height=80, width=120, 
                    src = "https://goo.gl/3xpBkR"),
           column = 4, 
           tags$img(height=60, width=100, 
                    src = "http://aspirantes.itam.mx/sites/all/themes/evolve/logo.png")
  ),

  
  dateRangeInput("datesPeriod",
                 "Periodo",
                 start = Sys.Date(),
                 end = Sys.Date() + 7,
                 format = "dd-mm-yyyy",
                 separator= " a "),
 
  #####
  
  h4(tags$b("Simulaciones")),
  fluidRow(column(3, sliderInput("sTecnologia", label = h5("Tecnologia"),         min = 0, max = 10, value = 5)),
           column(3, sliderInput("sNecesidad", label = h5("Necesidad"), min = 0, max = 10, value = 5)),
           column(3, sliderInput("sMercado", label = h5("Mercado"),     min = 0, max = 10, value = 5))
  ),
  
  ###
  fluidRow(
    actionButton("crearRanking",
                 "Rankea hoteles (CSV)"),
    actionButton("daysPeriod",
                 "Dias en periodo")
  ),
  
  textOutput("period"),
  textOutput("inference"),
  
  sidebarLayout(
    sidebarPanel(
      fluidRow(checkboxGroupInput("columns", "Choose variables",
                                  choices = colnames,
                                  selected = colnames)
      )
    ),
    
    #uiOutput("tablaDatos"),
    
    mainPanel(
      tabsetPanel(
        tabPanel("PlotInference", plotOutput("fuzzyInference")),
        tabPanel("PlotGraphs", plotOutput("fuzzyGraphs")),
        tabPanel("Rules", verbatimTextOutput("resume")),
        tabPanel("Tabla", tableOutput("tabla"))
      )
    )
  )
)

server <- function(input, output) {
  dias1 <- reactive({input$datesPeriod[1]})
  dias2 <- reactive({input$datesPeriod[2]})
  diasPeriodo <- reactive(difftime(dias1, dias2, unit="days")) #Selecting season of the year
  
  
  datos2 <- function(){
    temp <- datos[1:10, ]
    return (temp)
  }
  
  rRanking <- function() {
    return(fuzzy_inference(system, 
                           list(tecnologia = as.numeric(input$sTecnologia), 
                                 necesidad = as.numeric(input$sNecesidad), 
                                   mercado = as.numeric(input$sMercado)))
    )
  }
  
  fRanking <- reactive(gset_defuzzify(rRanking(), "centroid"))
  
  output$inference <- renderText({ 
    toString(fRanking())
  })
  
  output$fuzzyInference <- renderPlot({
    plot(rRanking(), main = paste("El ranking es: ", fRanking()))
  })
  
  output$fuzzyGraphs <- renderPlot({
    plot(system)
  })
  
  output$resume <- renderPrint({
    print(system)
  })
  
  output$tabla <-renderTable({
    temp <- datos2()
    #aux <- order(temp$ranking, decreasing = T)
    temp
  })
  
}

shinyApp(ui=ui, server=server)
