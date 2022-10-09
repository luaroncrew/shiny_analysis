#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/


library(shiny)
library(shinydashboard)
library(shinythemes)
library(readr)


data <- read_csv("faucet.csv")
View(data)

# Define UI for 
ui <- fluidPage(
  theme = shinytheme("flatly"),#appliquer une mise en forme
  navbarPage("Tradestats"),#donner un titre
  
  navlistPanel(
    "Analyses",
    tabPanel("Introduction",#creation d'un bouton
             h3("Problematique"),
             h4("Quelles sont les habitudes des traideurs sur la blockchain ?"),
             tags$img(src="blockchain-image.png", height= 200, width = 600)#import d'une image
    ),
    tabPanel("Les symboles",
             h3("L'utilisation des differentes devises sur la bourse"),
             h4(plotOutput("graph"))
             # graphique circulaire sur le top des symboles les plus utilises
    ),
    tabPanel("Les transactions",
             h3("Le suivi des transactions"),
             h4(plotOutput("graph2"))
             #repartition du nombre de transaction par la somme en dollars
    ),
    tabPanel("Les habitudes",
             h3("Les traideurs et les transactions"),
             h4(plotOutput("volume"))
             # repartition du nombre de transactions par le volume
    )
  )
)

#a voir si on rajoute un volet conclusion ou si on met une zone de texte dans "les habitudes"

# Define server logic required to draw a histogram
server <- function(input, output) {
  #creation des graphiques
  
  output$tri_a_plat <- renderPlot(
    A=table(data$token_in_name),
    pie(x = A, main = "Repartition des symboles parmi les transactions",
    col = "turquoise2", labels = paste(rownames(A),A))
  )
  output$tri_a_plat2 <- renderPlot(
    B=table(data$transaction_signer),
    barplot(height = B, 
    main = "Nombre de transactions par traideur",
    col = "steelblue2", horiz = TRUE)
  )
  output$volume <- renderPlot(
    hist(x = data$swap_volume_usd, main = "Distribution du volume deplace par les traideurs",
    col = "blue" , breaks = 60,labels=T, probability = TRUE, xlim = c(0, 120000))
  )
  
}

# Run the application 
shinyApp(ui = ui, server = server)
