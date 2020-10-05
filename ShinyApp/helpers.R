#install.packages("shiny")
#install.packages("shinythemes")

sce <- readRDS("sce.RDS")

# function to generate the boxplots
library(RColorBrewer)
boxPlot <- function(sce=sce, gene="Serpine2", subset_name="SCI_Stage") {
  
  # set the x axis level
  subset <- colData(sce)[subset_name][,1]
  
  # if the input is more than one gene:
  if (grepl(",", gene)) {
    
    # prepare the gene list
    genes <- unlist(strsplit(gene, split=","))
    genes <- trimws(genes, which = "b", whitespace = "[ \t\r\n]")
    genes <- unique(genes)
    genes <- toTitleCase(tolower(genes))
 
    # make sure they are valid gene names and fewer than 50 (to keep it running quickly)
    validate(
      need(all(genes %in% rownames(sce)), paste0(genes[!(genes %in% rownames(sce))], " is not valid. Please input a valid MGI gene name"))
    )
    validate(
      need((length(genes) <= 50), "Please input 50 genes or less")
    )
    
    ylabel <- "Mean Log2 UMI Counts"
    
    # calculate the mean and subset the sce
    logs <- colMeans(logcounts(sce[genes]))
  } else {
    #covert to title case
    gene <- toTitleCase(tolower(gene))
    # make sure they are valid gene names and fewer than 50 (to keep it running quickly)
    validate(
      need(gene %in% rownames(sce), paste0(gene[!(gene %in% rownames(sce))], " is not valid. Please input a valid MGI gene name"))
    )
    # extract the log10-transformed counts for the single gene of interes
    logs <- as.numeric(logcounts(sce[gene]))
    
    # set the y label
    ylabel <- "Log2 UMI Counts"
    
  }
  
  df <- data.frame(Logs=logs, x=subset)
  
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

# plot the UMAPs
library(scater)
library(ggplot2)
library(tools)
UMAPs <- function(sce=sce, colour_by, title) {
  
  # set the coloour scheme
  if (colour_by == "Cluster") {
    colours <- scale_fill_manual(values=c("lightblue", brewer.pal(11,"RdYlGn"),"#003319","black", "grey50", "grey50"))
  } else if (colour_by == "SCI_Stage") {
    colours <- scale_fill_manual(values=c("#D53E4F", "#FF8D59","#E6F598","#1A9850","#3288BD", "#542788"))
  } else { colours <- NULL}
  
  # if multiple genes input, calculate the average
  if (grepl(",", colour_by)) {
    
    # prepare the gene list
    genes <- unlist(strsplit(colour_by, split=","))
    genes <- trimws(genes, which = "b", whitespace = "[ \t\r\n]")
    genes <- unique(genes)
    genes <- toTitleCase(tolower(genes))
    
    # make sure they are valid gene names and fewer than 50 (to keep it running quickly)
    validate(
      need(all(genes %in% rownames(sce)), paste0(genes[!(genes %in% rownames(sce))], " is not valid. Please input a valid MGI gene name"))
    )
    validate(
      need((length(genes) <= 50), "Please input 50 genes or less")
    )
    
    
    # calculate the mean and subset the sce
    sce$log2Mean <- colMeans(logcounts(sce[genes]))
    colour_by <- "log2Mean"
  }
  #covert to title case if it's a gene
  else if (!colour_by %in% names(colData(sce))) {
    colour_by <- toTitleCase(tolower(colour_by))
    
    validate(
      need(colour_by %in% rownames(sce), paste0(colour_by[!(colour_by %in% rownames(sce))], " is not valid. Please input a valid MGI gene name"))
    )
  }
  
  # plot
  plotUMAP(sce, colour_by=colour_by) + 
    colours +
    ggtitle(title)
}
