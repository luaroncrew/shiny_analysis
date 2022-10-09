# install all needed packages
install.packages("tm")  # pour le text mining
install.packages("SnowballC") # pour le text stemming
install.packages("wordcloud") # g?n?rateur de word-cloud 
install.packages("RColorBrewer") # Palettes de couleurs
install.packages("shinydashboard")

# import libraries
library("tm")
library("SnowballC")
library("wordcloud")
library("RColorBrewer")
library(shiny)
library(shinydashboard)
library(shinythemes)
library(readr)

# ---- database part ----

# read different entities of the database
transactions = read.csv('transactions.csv')
token_ids = read.csv('token_ids.csv')
symbols = read.csv('symbols.csv')
prices = read.csv('prices.csv')


# join the token_symbol for token_in
analysis_dataframe = merge(
  x = transactions,
  y = symbols,
  by.x = "token_in_address",
  by.y = "token_address",
  all.x = TRUE
)

# rename the column
names(analysis_dataframe)[length(names(analysis_dataframe))]= 'token_in_symbol'

# join the token_symbol for token_out
analysis_dataframe = merge(
  x = analysis_dataframe,
  y = symbols,
  by.x = "token_out_address",
  by.y = "token_address",
  all.x = TRUE
)

# rename the column
names(analysis_dataframe)[length(names(analysis_dataframe))] = 'token_out_symbol'

# rename another column
names(analysis_dataframe)[7] = 'decimals_token_in'
analysis_dataframe[9] = NULL

# making all symbols lowercase for merging
ech = analysis_dataframe$token_in_symbol
lower = tolower(ech)
analysis_dataframe$token_in_symbol = lower
ech = analysis_dataframe$token_out_symbol
lower = tolower(ech)
analysis_dataframe$token_out_symbol = lower


# join the token_id for token_in_symbol
analysis_dataframe = merge(
  x = analysis_dataframe,
  y = token_ids,
  by.x = "token_in_symbol",
  by.y = "token_symbol",
  all.x = TRUE,
  all.y = FALSE
)


# being given the id, get the price at a day
analysis_dataframe = merge(
  x = analysis_dataframe,
  y = token_ids,
  by.x = "token_in_symbol",
  by.y = "token_symbol",
  all.x = TRUE
)

# delete useless column after merge and rename one
analysis_dataframe$token_id.x = NULL
names(analysis_dataframe)[10] = 'token_in_id'

# merge with prices by day
analysis_dataframe = merge(
  x = analysis_dataframe,
  y = prices,
  by.x = c('token_in_id', 'day'),
  by.y = c('token_id_coingecko', 'day'),
  all.x = TRUE
)

# remove all the NULL values
analysis_dataframe = na.omit(analysis_dataframe) 

# remove doubled entries
analysis_dataframe = unique(analysis_dataframe)

# calculate volumes being given all the merged information
analysis_dataframe$volume = (analysis_dataframe$amount_in / (10 ** analysis_dataframe$decimals_token_in)) * analysis_dataframe$price_usd

# ---- connection of the merged data with the app's backend ----

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
