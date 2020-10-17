library(shiny)
library(shinythemes)


shinyUI(fluidPage(
  
  theme = shinytheme("flatly"),
  
  navbarPage("SCI Myeloid Cell Atlas",
             tabPanel("About",
                      includeMarkdown("README.Rmd")),
             tabPanel("Gene Expression",
                      sidebarLayout(
                        
                        sidebarPanel(
                          helpText("Select one of the following options to colour the reference plot"),
                          radioButtons("RefInput", label = "Reference Plot",
                                       choices= c("Cell_Type", "Cell_Type_by_Stage","SCI_Stage", "Cluster", "Fate_Map", "Sex"), selected="Cell_Type"),
                          submitButton("Submit", icon("refresh")),
                          br(),
                          helpText("Input the gene of interest to visualize on the plot. To visualize the average expression of a set of genes, separate each gene with a comma (max 50 genes)"),
                          textInput("GeneInput", label = "Gene Plot", value = "Fabp5", placeholder = "Gene Symbol(s)"),
                          submitButton("Submit", icon("refresh"))),
                        
                        mainPanel(
                          tags$head(tags$style(type="text/css", "#loadmessage {
                                               position: fixed;
                                               top: 200px;
                                               left: 490px;
                                               width: 65%;
                                               text-align: center;
                                               font-weight: bold;
                                               font-size: 100%;
                                               color: #FFFF;
                                               background-color: #2C3E50;
                                               z-index: 105;
                                               }
                                               ")),
                          conditionalPanel(condition="$('html').hasClass('shiny-busy')",
                                           tags$div("Loading...",id="loadmessage")),
                          tabsetPanel(
                            tabPanel("UMAP",
                                     splitLayout(
                                       plotOutput("UMAP_R",width="100%",height="400px"), 
                                       plotOutput("UMAP_G",width="100%",height="400px")
                                     ),
                                     fluidRow(column(3, offset=5, downloadButton('downloadPlotG', "Download UMAPs")))
                            ),
                            tabPanel("Boxplot",
                                     plotOutput("boxplot",width="100%",height="200px"),
                                     br(),
                                     br(),
                                     br(),
                                     fluidRow(column(3, offset=5, downloadButton('downloadPlotB', "Download Boxplot")))
                            )),
                          h4(strong("Notes:")),
                          p("Download: Click the download button to save a pdf file of the plot(s)"),
                          p("Gene Expression: Depicted as the log2 transformed, normalized UMI counts per cell"),
                          textOutput("text"),
                          
                          conditionalPanel(
                            HTML('<center>'),
                            condition = "input.RefInput == 'Cluster'",
                            imageOutput("Clust", inline=T),
                            HTML('</center>')
                          ),
                          h4(strong("Acronyms:")),
                          p(strong("HC"), "= healthy control (laminectomy only);  ", strong("MG"), "= microglia;  ", strong("MCd"), "= monocyte derived macrophages;  ", strong("DC"), "= dendritic cells;  ", strong("NP"), " = neutrophils")
                        )
                      )
             ),
             tabPanel("Data Download",
                      p("Click to download the normalized post-quality control counts data"),
                      
                      fluidRow(
                        h4("All Cells"), wellPanel(downloadButton('downloadM', "Gene-Cell Count Matrix"), downloadButton('downloadA', "Cell Annotation Matrix"))
                      ),
                      fluidRow(
                        h4("Microglia"), wellPanel(downloadButton('downloadM_MG', "Gene-Cell Count Matrix"), downloadButton('downloadA_MG', "Cell Annotation Matrix"))
                      ),
                      fluidRow(
                        h4("Monocyte-Derived Macrophages"), wellPanel(downloadButton('downloadM_MCd', "Gene-Cell Count Matrix"), downloadButton('downloadA_MCd', "Cell Annotation Matrix"))
                      ),
                      fluidRow(
                        h4("Dendritic Cells"), wellPanel(downloadButton('downloadM_DC', "Gene-Cell Count Matrix"), downloadButton('downloadA_DC', "Cell Annotation Matrix"))
                      ),
                      fluidRow(
                        h4("Neutrophils"), wellPanel(downloadButton('downloadM_NP', "Gene-Cell Count Matrix"), downloadButton('downloadA_NP', "Cell Annotation Matrix"))
                      )
             )
  )
)
)
