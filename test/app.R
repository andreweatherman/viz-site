library(shiny)
lgNP_OBP <-.32
lgNP_SLG <-.4
OPS_plus <- function(obp, slg){100 * (obp/lgNP_OBP + slg/lgNP_SLG - 1)}
hitting <- function(ops, pa) {(ops-100)*.1123*pa/100}
replacement = 17.5/600
positions<-c("C","1B","2B","3B","SS", "LF","CF","RF","DH","P")
posadj<-c(12.5,-12.5,2.5,2.5,7.5,-7.5,2.5,-7.5,-17.5,65)
position<-data.frame(positions,posadj)
bsr<-function(spd,pa){(3*(spd-50)/10)*pa/675}#rate spd 20-80
uzr<-function(glove,pa){(6*(glove-50)/10)*pa/625}#rate glove 20-80
runsPerWin <- 9.25
posWAR <-function(obp,slg, pa, pos, glove, spd){
  (hitting(OPS_plus(obp,slg),pa) +
     if(pos=="DH") 0 else uzr(glove,pa) +
     bsr(spd,pa) +
     position[position$positions==pos,2]*pa/675 +
     pa * replacement)/runsPerWin}
NLReplaceStarter <- 4.79
ALReplaceStarter <- 5.21
NLReplaceRelief <- 3.98
ALReplaceRelief <-4.15
pitchWAR <- function(lg, role, ip, era){
  ifelse(role=="Starter",
         ifelse(lg=="NL", (NLReplaceStarter - era)*(ip/9), (ALReplaceStarter - era)*(ip/9)),
         ifelse(lg=="NL", (NLReplaceRelief - era)*(ip/9), (ALReplaceRelief - era)*(ip/9))
  ) *
    switch(role, "Starter"=1, "Closer"=1.8, "Setup"=1.5, "Relief"=1.2, "Mopup"=0.7) /runsPerWin
}


# Define server logic for slider examples
server <- shinyServer(function(input, output) {
  result <- reactive({
    round(posWAR(input$OBP,input$SLG,input$PA,input$Pos,input$UZR, input$BSR)
          + pitchWAR(input$LG,input$Role,input$IP, input$ERA)
          ,1)
  })
  #WAR(.363,.5,540,"SS",30,50))

  # Show the value
  output$answer <- renderText({
    result()
  })
})

ui <- fluidPage(
  textInput("name", "What's your name?"),
  passwordInput("password", "What's your password?"),
  textAreaInput("story", "Tell me about yourself", rows = 3)
)

# Run the application
shinyApp(ui = ui, server = server)
