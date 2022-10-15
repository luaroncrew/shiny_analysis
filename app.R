library("tm")
library("SnowballC")
library("wordcloud")
library("RColorBrewer")
library(shiny)
library(shinydashboard)
library(shinythemes)
library(readr)
library(shinyWidgets)

data <- read_csv("data/final/swap_operations.csv")
transaction_choices = data[0,"...1"]

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
             tags$img(src="blockchain-image.png", height= 200, width = 600)
    ),
    tabPanel("General information",
             h3("General information about trading volume"),
             
    ),
    tabPanel("Les symboles",
             h3("Top assets"),
             h4(plotOutput("most_traded_tokens"))
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
               label='Filter by token',
               choices = c('usn', 'dai', 'aurora', 'usdt')
             )
    ),
    tabPanel("Transaction observer",
        h3("Here you can see the essential information about the transaction of your choice"),
        h4(
        fluidRow(
          column(12,
                 tableOutput('transaction')
          )
        ),
        selectInput(
          inputId='transactionchoice',
          label='Filter by transaction',
          choices = c(
            25487, 26690, 17148, 36046, 11545, 24934, 10194, 17958)
        )
        )
    )
  )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  
  signers = data$transaction_signer
  signers = data.frame(table(signers))
  signers = signers[order(signers$Freq),]
  
  tokens = data$token_in_id
  tokens = data.frame(table(tokens))
  tokens = tokens[order(tokens$Freq),]
  
  pie_labels = levels(tail(tokens, 4)$tokens)[tail(tokens, 4)$tokens]
  pie_labels = append(pie_labels, 'others')
  pie_values = tail(tokens, 4)$Freq
  pie_values = append(pie_values, sum(tokens$Freq) - sum(tail(tokens, 4)$Freq))
  piepercent<- round(100*pie_values/sum(pie_values), 1)
  pie_colors = c(
    "#264563",
    "#2a9d8f",
    "#e9c46a",
    "#f4a261",
    "#e76f51"
  )
  
  #creation des graphiques
  output$most_traded_tokens <- renderPlot(
    pie(
      pie_values,
      pie_labels,
      col=pie_colors
      )
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
  output$transaction <- renderTable(
    data[data$...1 == input$transactionchoice,c(
      "token_in_symbol",
      "token_out_symbol",
      "day",
      "volume",
      "transaction_signer")],
    bordered=TRUE)
}

# Run the application 
shinyApp(ui = ui, server = server)
