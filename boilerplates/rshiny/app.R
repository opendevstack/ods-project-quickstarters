options(java.parameters = c("-Xss2560k", "-Xmx4g"))

library(DBI)
library(rJava)
library(RJDBC)
library(shiny)
library(shinythemes)
library(d3heatmap)
library(ggplot2)
library(reshape2)

HIVE_URL <- Sys.getenv('HIVE_URL')
HIVE_USER <- Sys.getenv('HIVE_USER')
HIVE_PASSWORD <- Sys.getenv('HIVE_PASSWORD')

HIVE_CLIENT_LIB <- '/usr/lib/hive/lib/'
.jinit(classpath=sapply(list.files(HIVE_CLIENT_LIB),
    function (jar) {
        paste0(HIVE_CLIENT_LIB, jar)
    }
))

getConnection <- function() {
    driver <- JDBC('org.apache.hive.jdbc.HiveDriver', paste0(HIVE_CLIENT_LIB, 'hive-jdbc.jar'))
    dbConnect(driver, HIVE_URL, HIVE_USER, HIVE_PASSWORD)
}

# ================================================= UI PART =======================================================
ui <- fluidPage(theme=shinytheme("cosmo"),
                navbarPage("Data Analysis",

                           # First card
                           tabPanel("Table",
                                    fluidRow(
                                      column(width = 10, align = "center", offset = 1,
                                             dataTableOutput("table")))
                           ),
                           # Second card
                           tabPanel("Plots",
                                    br(),
                                    fluidRow(
                                      # left column (help text and small plot)
                                      column(width = 2, align = "left",
                                             helpText("Here we can write something interesting, or not.
                                                      Description of data or help test"),
                                             plotOutput("smallplot", height ="300px")
                                      ),

                                      column(width = 9, align = "right",
                                             plotOutput("boxplot", height ="600px")
                                      )),
                                    br(),
                                    hr(),
                                    br(),
                                    fluidRow(
                                      # interactive heatmap
                                      column(width = 10, align = "center", offset = 1,
                                             d3heatmapOutput("heatmap", height ="800px")
                                      )),
                                    br()

                           )
                )
)

# ====================================== SERVER PART =======================================================
server <- function(input, output) {
  # load data
  users <- dbGetQuery(getConnection(), 'SELECT * FROM users')
  colnames(users) <- gsub("users.", "", colnames(users))

  # -------------------------------- render table -----------------------------------------
  output$table <- renderDataTable(users)

  # -------------------------------- boxplots -----------------------------
  # Create big boxplot
  boxdata <- users
  output$boxplot <- renderPlot({
    ggplot(data = users) + #dose~gender, data=boxdata
      geom_boxplot(mapping= aes(y = dose, x = drug, fill = drug), show.legend = F) +
      facet_wrap(~ gender, ncol=1) +
      theme(axis.text.x  = element_text(angle = 90, hjust = 1),
            plot.title   = element_text(hjust = 0.5, size = 17),
            axis.title   = element_text(size = 14),
            axis.text    = element_text(size = 14),
            legend.text  = element_text(size = 16),
            legend.title = element_text(size = 17)) +
      labs(list(title = "Title of this plot",
                y = "Dose",
                x = "Drug"))
  })

  output$smallplot <- renderPlot({
    ggplot(data = users) +
      geom_boxplot(mapping= aes(y = dose, x = gender, fill = gender), show.legend = F) +
      theme_bw()+
      theme(axis.text.x  = element_text(angle = 0, hjust = 0.5),
            plot.title   = element_text(hjust = 0.5, size = 15),
            axis.title   = element_text(size = 13),
            axis.text    = element_text(size = 13),
            legend.text  = element_text(size = 13),
            legend.title = element_text(size = 15)) +
      labs(list(title = "Title of this plot",
                y = "Dose",
                x = "Gender")) +
      scale_fill_manual(values=c("#E69F00", "#56B4E9"))
  })

  # -------------------------- heatmaps -----------------------------------------
  # create named matrix - structure required by d3heatmap
  heat_data <- reshape2::dcast(users, drug~gender, value.var = "dose")
  rownames(heat_data) <- heat_data[,1]
  heat_data <- as.matrix(heat_data[,2:3])

  output$heatmap <- renderD3heatmap({
    d3heatmap(heat_data, scale = "column",
              dendrogram = "row",
              cexCol = 1.2)
  })

}

shinyApp(ui, server)
