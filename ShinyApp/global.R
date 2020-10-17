#install.packages("shiny")
#install.packages("shinythemes")

load("Data/sce.RData")

# function to generate the boxplots
library(RColorBrewer)
boxPlot <- function(gene="Fabp5", subset_name="SCI_Stage") {
  
  # set the x axis level
  subset <- cd[,subset_name]
  
  # if the input is more than one gene:
  if (grepl(",", gene)) {
    
    # prepare the gene list
    genes <- unlist(strsplit(gene, split=","))
    genes <- trimws(genes, which = "b")
    genes <- unique(genes)
    genes <- toTitleCase(tolower(genes))
    
    # make sure they are valid gene names and fewer than 50 (to keep it running quickly)
    validate(
      need(all(genes %in% rownames(sce_logs)), paste0(genes[!(genes %in% rownames(sce_logs))], " is not valid. Please input a valid MGI gene name"))
    )
    validate(
      need((length(genes) <= 50), "Please input 50 genes or less")
    )
    ylabel <- "Mean Log2 UMI Counts"
    Logs <-Matrix::colMeans(sce_logs[genes,, drop = FALSE]) # calculate the mean 
    
  } else if (grepl(" ", gene)) {
    
    # prepare the gene list
    genes <- unlist(strsplit(gene, split=" "))
    genes <- trimws(genes, which = "b")
    genes <- unique(genes)
    genes <- toTitleCase(tolower(genes))
    
    # make sure they are valid gene names and fewer than 50 (to keep it running quickly)
    validate(
      need(all(genes %in% rownames(sce_logs)), paste0(genes[!(genes %in% rownames(sce_logs))], " is not valid. Please input a valid MGI gene name"))
    )
    validate(
      need((length(genes) <= 50), "Please input 50 genes or less")
    )
    
    ylabel <- "Mean Log2 UMI Counts"
    
    # calculate the mean 
    Logs <-Matrix::colMeans(sce_logs[genes,, drop = FALSE])
  } else {
    
    #covert to title case
    gene <- toTitleCase(tolower(gene))
    # make sure they are valid gene names and fewer than 50 (to keep it running quickly)
    validate(
      need(gene %in% rownames(sce_logs), paste0(gene[!(gene %in% rownames(sce_logs))], " is not valid. Please input a valid MGI gene name"))
    )
    Logs <-  sce_logs[gene,] # extract the log10-transformed counts for the single gene of interes
    ylabel <- "Log2 UMI Counts" # set the y label
  }
  
  df <- data.frame(Logs=Logs, x=subset)
  
  # set the coloour scheme
  if (subset_name == "Cluster") {
    colours <- scale_fill_manual(values=c("lightblue", brewer.pal(11,"RdYlGn"),"#003319","black", "grey50", "grey50"))
  } else if (subset_name == "SCI_Stage") {
    colours <- scale_fill_manual(values=c("#D53E4F", "#FF8D59","#E6F598","#1A9850","#3288BD", "#542788"))
  } else { colours <- NULL}
  
  # plot
  ggplot(data=df, aes(y=Logs, x=subset, fill=subset)) + 
    geom_boxplot() + 
    ggtitle(gene) + 
    theme(plot.title=element_text(hjust=0.5), axis.text.x=element_text(angle=45, hjust=1), legend.position="none") + 
    ylab(ylabel) + 
    xlab(subset_name) + 
    colours  
}

# plot the UMAPs for column data (ie reference UMAP)
library(ggplot2)
library(tools)
library(RColorBrewer)

ref_UMAP <- function(colour_by, title) { 
  
  # set the colour scheme
  if (colour_by == "Cluster") {
    colours <- c("lightblue", brewer.pal(11,"RdYlGn"),"#003319","black", "grey50", "grey50")
  } else if (colour_by == "SCI_Stage") {
    colours <- c("#D53E4F", "#FF8D59","#E6F598","#1A9850","#3288BD", "#542788")
  } else { 
    qual_col_pals = brewer.pal.info[brewer.pal.info$category == 'qual',]
    colours <- unlist(mapply(brewer.pal, qual_col_pals$maxcolors, rownames(qual_col_pals)))
    colours <- gsub("#FFFF99", "#FFEF00", colours)
  }
  
  # plot the reference umap 
  ggplot(data.frame(UMAP1 = umap[,1],
                    UMAP2 = umap[,2],
                    cData = cd[,colour_by]
  )) +    geom_point(aes(UMAP1, UMAP2, colour = cData), size = 0.7) + theme_classic()  +
    scale_color_manual(values = colours, name = NULL) + 
    guides(alpha=FALSE) + ylab("UMAP 2") + xlab("UMAP 1") + ggtitle(colour_by)
}

# plot the UMAPs for gene data 
library(ggplot2)
library(viridis)
library(tools)

gene_UMAP <- function(gene, title) {
  
  # if multiple genes input, calculate the average
  if (grepl(",", gene)) {
    
    # prepare the gene list
    genes <- unlist(strsplit(gene, split=","))
    genes <- trimws(genes, which = "b")
    genes <- unique(genes)
    genes <- toTitleCase(tolower(genes))
    
    # make sure they are valid gene names and fewer than 50 (to keep it running quickly)
    validate(
      need(all(genes %in% rownames(sce_logs)), paste0(genes[!(genes %in% rownames(sce_logs))], " is not valid. Please input a valid MGI gene name"))
    )
    validate(
      need((length(genes) <= 50), "Please input 50 genes or less")
    )
    Gene <-Matrix::colMeans(sce_logs[genes,, drop = FALSE]) # calculate the mean 
    title <- paste("Mean log2 counts of:", gene) # adjust the legend name
    
  } else if (grepl(" ", gene)) {
    
    # prepare the gene list
    genes <- unlist(strsplit(gene, split=" "))
    genes <- trimws(genes, which = "b")
    genes <- unique(genes)
    genes <- toTitleCase(tolower(genes))
    
    # make sure they are valid gene names and fewer than 50 (to keep it running quickly)
    validate(
      need(all(genes %in% rownames(sce_logs)), paste0(genes[!(genes %in% rownames(sce_logs))], " is not valid. Please input a valid MGI gene name"))
    )
    validate(
      need((length(genes) <= 50), "Please input 50 genes or less")
    )
    Gene <- Matrix::colMeans(sce_logs[genes,, drop = FALSE]) # calculate the mean 
    title <- paste("Mean log2 counts of:", gene)  # adjust the legend name
    
    
  } else {
    
    gene <- toTitleCase(tolower(gene))
    gene <- trimws(gene, which = "b")
    validate(
      need(gene %in% rownames(sce_logs), paste0(gene[!(gene %in% rownames(sce_logs))], " is not valid. Please input a valid MGI gene name"))
    )
    Gene <- sce_logs[gene,]
    title <- paste("log2 ", gene, " counts", sep = "") #for the legend name
  }
  
  # plot the gene umap 
  ggplot(data.frame(UMAP1 = umap[,1],
                    UMAP2 = umap[,2],
                    Gene = Gene)) +    geom_point(aes(UMAP1, UMAP2, colour = Gene), size = 0.7) + theme_classic()  +
    scale_color_viridis(name = NULL) + 
    guides(alpha=FALSE) + ylab("UMAP 2") + xlab("UMAP 1") + ggtitle(title)
}
