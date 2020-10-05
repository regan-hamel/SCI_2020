library(shiny)


shinyServer(
  
  function(input, output) {
    
    output$UMAP_R <- renderPlot({
      UMAP_r <- UMAPs(sce, colour_by=input$RefInput, title="Reference Plot") 
      UMAP_r
    })
    
    output$UMAP_G <- renderPlot({
      UMAP_g <- UMAPs(sce, colour_by=input$GeneInput, title="Gene Plot") 
      UMAP_g
    })
    
    output$boxplot <- renderPlot({
      boxp <- boxPlot(sce, gene=input$GeneInput, subset_name=input$RefInput) 
      boxp
    })
    
    output$Clust <-  renderImage({
        return(list(
          src = "Cell Maps.png",
          contentType = "image/png",
          height =  598.5,
          width = 656.25
        ))
    }) 
    
    output$text <- renderText({
      if(input$RefInput == "Cluster") {"Clusters: We generated clusters via the unsupervised Leiden 
        community detection method by calling cluster_cells {Monocle3} on the batch corrected cells with the parameters: 
        reduction_method = UMAP and the number of nearest neighbours (k)=16. We used differentially expressed genes and gene ontology
        (GO) enrichment analysis to hypothesize the cell states of each cluster. Then we combined trajectory analysis 
        {Monocle3} with our staged collection timepoints to infer the temporal relationship between cell clusters, depicted in the diagram below."}
      
      else if(input$RefInput == "Cell_Type") {"Cell Types: We assigned a cell type identity to each cluster using its top DEGs, 
        GO terms, and the expression of canonical marker genes. We then refined these annotations, for example in the case of MG(A2), 
        which contained both MG and MCds, using the resident vs. infiltrating labels from our fate-mapping Cremato mouse."}
      
      else if(input$RefInput == "Cell_Type_by_Stage") {"Cell Types by SCI Stage: Browse by the data by cell types separated by the collection stage (in days) post-SCI. 
        See 'Cell_Type', or the manuscript, for how we assigned the cell type identities."}
      
      else if(input$RefInput == "SCI_Stage") {"SCI Stage: Browse by the data by the collection stage (in days) post-SCI."}
      
      else if(input$RefInput == "Sex") {"Sex of the Mouse Model: Browse the data by the sex of the mouse model. 
        XXNote: there is currently no female samples collected from day 1 post-SCI"}
      
      else if(input$RefInput == "Fate_Map") {"Fate Map Label of the Cells: Browse by the data by its fate-map label. CreRFP = Cremato mouse strain, 
        double positive for RFP and YFP, long-lived, resident myeloid cells; CreYFP = Cremato mouse strain, single positive for YFP, negative for RFP, 
        short lived, infiltrating, myeloid cells; Cx3 = Cx3cr1 mouse strain, all myeloid cells are YFP+"}
    })
    
    output$downloadPlotG <- downloadHandler(
      filename = function() {
        paste0(input$RefInput, "-", input$GeneInput, "-UMAP.pdf")
      },
      content = function(file) {
        p <- UMAPs(sce, colour_by=input$RefInput, title=NULL)
        p2 <- UMAPs(sce, colour_by=input$GeneInput, title=NULL)
        
        pdf(file)
        print(p)
        print(p2)
        dev.off()
      }
    )
    
    output$downloadPlotB <- downloadHandler(
      filename = function() {
        paste0(input$RefInput, "-", input$GeneInput, "-Boxplot.pdf")
      },
      content = function(file) {
        b <- boxPlot(sce, gene=input$GeneInput, subset_name=input$RefInput) 
        pdf(file)
        print(b)
        dev.off()
      }
    )
    
    output$downloadM <- downloadHandler(
      filename <- function() {
        paste("Hamel et al., 202X_Count Matrix", "zip", sep=".")
      },
      content <- function(file) {
        file.copy("Data/Count Matrix.zip", file)
      },
      contentType = "application/zip"
    )
    
    output$downloadA <- downloadHandler(
      filename <- function() {
        paste("Annotation", "csv", sep=".")
      },
      content <- function(file) {
        file.copy("Data/Annotation.csv", file)
      }
    )
    
    output$downloadM_MG <- downloadHandler(
      filename <- function() {
        paste("Count Matrix_MG", "zip", sep=".")
      },
      content <- function(file) {
        file.copy("Data/Count Matrix MG.zip", file)
      },
      contentType = "application/zip"
    )
    
    output$downloadA_MG <- downloadHandler(
      filename <- function() {
        paste("Annotation_MG", "csv", sep=".")
      },
      content <- function(file) {
        file.copy("Data/Annotation MG.csv", file)
      }
    )
    
    output$downloadM_MCd <- downloadHandler(
      filename <- function() {
        paste("Count Matrix_MCd", "zip", sep=".")
      },
      content <- function(file) {
        file.copy("Data/Count Matrix MCd.zip", file)
      },
      contentType = "application/zip"
    )
    
    output$downloadA_MCd <- downloadHandler(
      filename <- function() {
        paste("Annotation_MCd", "csv", sep=".")
      },
      content <- function(file) {
        file.copy("Data/Annotation MCd.csv", file)
      }
    )
    output$downloadM_DC <- downloadHandler(
      filename <- function() {
        paste("Count Matrix_DC", "zip", sep=".")
      },
      content <- function(file) {
        file.copy("Data/Count Matrix DC.zip", file)
      },
      contentType = "application/zip"
    )
    
    output$downloadA_DC <- downloadHandler(
      filename <- function() {
        paste("Annotation_DC", "csv", sep=".")
      },
      content <- function(file) {
        file.copy("Data/Annotation DC.csv", file)
      }
    )
    output$downloadM_NP <- downloadHandler(
      filename <- function() {
        paste("Count Matrix_NP", "zip", sep=".")
      },
      content <- function(file) {
        file.copy("Data/Count Matrix NP.zip", file)
      },
      contentType = "application/zip"
    )
    
    output$downloadA_NP <- downloadHandler(
      filename <- function() {
        paste("Annotation_NP", "csv", sep=".")
      },
      content <- function(file) {
        file.copy("Data/Annotation NP.csv", file)
      }
    )
  }
)