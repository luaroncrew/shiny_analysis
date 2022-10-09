# Define UI for 
ui <- fluidPage(
  theme = shinytheme("flatly"),#appliquer une mise en forme
  navbarPage("Tradestats"),#donner un titre
  tags$style(HTML("
      h2 {
        font-family: 'Yusei Magic', sans-serif;
      }
      .row {
        margin: 30px;
        background-color: white;
      }
      .navbar {
        margin: 30px;
      }
      .shiny-input-container {
        color: #474747;
      }
      .wrapper{
      position: fixed;
      top: 50%;
      left: 50%;
      transform: translate(-50%, -50%);
      }
      
      a{
        display: block;
        width: 100%;
        height: 50px;
        line-height: 40px;
        font-size: 18px;
        font-family: sans-serif;
        text-decoration: none;
        color: #333;
        border: 2px solid #333;
        position: relative;
        transition: all .35s;
      }
      
      a span{
        position: relative;
        z-index: 2;
      }
      
      a:after{
        position: absolute;
        top: 0;
        left: 0;
        width: 0;
        height: 100%;
        background: #ff003b;
        transition: all .35s;
      }
      
      a:hover{
        transform: scale(1.05);
      }
      
      a:hover:after{
        width: 100%;
      }")),
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
  data <- read_csv("data/final/swap_operations.csv")
  
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
  output$volume <- renderPlot({
    x    <- data$volume
    hist(
      x,
      breaks=5000,
      xlim=c(0,1000),
      main="Volumes of swap operations on REF finance",
      xlab="Volume, $USD"
    )
    
  })
}

# Run the application 
shinyApp(ui = ui, server = server)
