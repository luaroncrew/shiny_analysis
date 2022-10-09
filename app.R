# Define UI for 

ui <- fluidPage(
  setSliderColor('#ee2e31', 1:20),
  theme = shinytheme("flatly"),#appliquer une mise en forme
  navbarPage("Tradestats"),#donner un titre
  tags$style(HTML("
      .row {
        margin: 30px;
        background-color: white;
      }
      h3 {
        padding-left: 4%;
      }
      h4 {
        padding-left: 4%;
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
    tabPanel("Introduction",
             h3("Problematique"),
             h4("Quelles sont les habitudes des traideurs sur la blockchain ?"),
             tags$img(src="blockchain-image.png", height= 200, width = 600)#import d'une image
    ),
    tabPanel("Les symboles",
             h3("L'utilisation des differentes devises sur la bourse"),
             h4(plotOutput("graph"))
             # graphique circulaire sur le top des symboles les plus utilises
    ),
    tabPanel("Top traders",
             h3("The top traders by the number of transactions"),
             h4(plotOutput("top_signers_plot")),
             sliderInput(
               inputId = "top",
               label = "Top of:",
               min = 5,
               max = 20,
               value = 10
             )
    ),
    tabPanel("Trading volumes",
             h3("How are transactions distributed by the volume of a transaction"),
             h4(plotOutput("volume_plot")),
             selectInput(
               inputId='tokenchoice',
               label='filter by token',
               choices = c('usn', 'dai', 'aurora', 'usdt')
             )
    )
  )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  data <- read_csv("data/final/swap_operations.csv")
  
  signers = data$transaction_signer
  signers = data.frame(table(signers))
  signers = signers[order(signers$Freq),]
  
  #creation des graphiques
  output$tri_a_plat <- renderPlot(
    A=table(data$token_in_name),
    pie(x = A, main = "Repartition des symboles parmi les transactions",
    col = "turquoise2", labels = paste(rownames(A),A))
  )
  output$top_signers_plot <- renderPlot(
    barplot(
      height=tail(signers, input$top)$Freq,
      names = tail(signers, input$top)$x,
      xlab = "number of transactions",
      main = "top 10 traders by number of trades",
      col = "#1d7874",
      horiz = TRUE
      )
  )
  output$volume_plot <- renderPlot({
    x <- data[data$token_in_symbol == input$tokenchoice,]$volume
    hist(
      x,
      breaks=5000,
      xlim=c(0,1000),
      main="Volumes of swap operations on REF finance",
      xlab="Volume, $USD",
      c = '#1d7874'
    )
  })
}

# Run the application 
shinyApp(ui = ui, server = server)
