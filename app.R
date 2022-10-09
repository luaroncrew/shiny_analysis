#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/

# Installer
install.packages("tm")  # pour le text mining
install.packages("SnowballC") # pour le text stemming
install.packages("wordcloud") # g?n?rateur de word-cloud 
install.packages("RColorBrewer") # Palettes de couleurs
install.packages("shinydashboard")
# Charger
library("tm")
library("SnowballC")
library("wordcloud")
library("RColorBrewer")



library(shiny)
library(shinydashboard)
library(shinythemes)
library(readr)

data <- read_csv("faucet.csv")
View(data)

# Define UI for 
ui <- fluidPage(
  theme = shinytheme("flatly"),
  navbarPage("Tradestats"),
  
  navlistPanel(
    "Analyses",
    tabPanel("Introduction",
             h3("Problematique")
             # rajouter un nuage de mot avec le champs lexical de la bourse
    ),
    tabPanel("Les symboles",
             h3("L'utilisation des differentes devises sur la bourse")
             # graphique circulaire sur le top des symboles les plus utilisés
    ),
    tabPanel("Les transactions",
             h3("Le nombre de transactions")
             #répartition du nombre de transaction par la somme en dollars
    ),
    tabPanel("Les habitudes",
             h3("Les traideurs et les transactions")
             # répartition du nombre de transactions par le volume
    )
  )
)

#a voir si on rajoute un volet conclusion ou si on met une zone de texte dans "les habitudes"

# Define server logic required to draw a histogram
server <- function(input, output) {
  
}

# Run the application 
shinyApp(ui = ui, server = server)
