## SCI_2020
 
This repository contains the analysis scripts and data from our recent pre-print: <a href="link here when availableXX" target="_blank"> Hamel R, <i>et al</i>. Time-resolved single-cell RNAseq profiling identifies a novel Fabp5-expressing subpopulation of inflammatory myeloid cells in chronic spinal cord injury. <i>bioRxiv</i> XXXX (2020) - BioRxiv link will be here asap</a>

- `Data`:  
    + `Counts`: contains the raw gene-cell matrix for all samples. To replicate the entire analysis, dowload this folder and adjust the directory in the first analysis script, ''  
    + `Normalized_Counts`: contains the normalized gene-cell matrix for all samples.
    + `sce.RDS`: the SingleCellExperiment object comprising all the cells that passed quality control and their respective raw counts, normalized counts, and metadata. To replicate the figures, download this object and adjust the directories accordingly.
    + `Sample_Data`: contains the sample-specific molecule information in an `h5` format, and a `raw_feature_bc_matrix` folder containing the raw, unfiltered cell-gene counts. To replicate the analysis from barcode swapping, download these folders and adjust the `1. Barcode Swapping.Rmd` directories to the `h5` files. To process the data without adjusting for barcode swapping, update the `2. EmptyDrops.Rmd` directories to the `raw_feature_bc_matrix` folders.
    + `Extended_Data_Fig1d`: contains the data from Arneson et al., 2018 (GEO: GSE101901), Hammond et al., 2019 (GEO: GSE121654), Zeisel et al., 2018 (loom file from http://mousebrain.org/loomfiles_level_L6.html), and Van Hove et al., 2019 (from http://www.brainimmuneatlas.org/download.php) that was used to generate Extended Data Figure 1d

- `Scripts`:
    + `Data_Analysis`: contains all `R markdown` scripts used to analyse the scRNAseq data.
    + `Figures_Tables`: contains all `R markdown` scripts used to produce the figures and tables.
    + `Sources`: contains all source R scripts and text files referenced in the `Data_Analysis` and `Figures` scripts. To run the scripts, ensure the source files have been downloaded and the source directories have been updated accordingly.
        + `IEGs List from van Oudenaarden (Nature Methods 2017).txt`: a list of immediate early genes used to generate Extended Data Figure 1d
        + `regev_lab_cell_cycle_genes.txt`: a list of cell cycling genes from Tirosh et al., 2015 (doi: 10.1101/gr.192237.115) used to generate Extended Data Figure 5f
        + `All.R`: this script stores the metadata of each sample in an object for `2. EmptyDrops.Rmd`
        + `SLX Names.R`: this script generates objects containing the IDs of all samples in an SLX, important for `1. Barcode Swapping.Rmd`
        + `Non-M RNA.R`: this script contains lists of non-myeloid cell types marker genes from Wheeler et al., 2020 (doi: 10.1038/s41586-020-1999-0) and Zeisel et al., 2018 (doi: 10.1016/j.cell.2018.06.021) for the generation of Extended Data Figure 1f
        + `Fxn - Prep Genes`: a helpful function that splits strings and remove empty spaces, namely from lists of genes, to make the lists compatible with other functions
         + `Fxn - qcPlots`: a function for quickly generating qplots and data frames containing quality control metrics. Used only in `4. QC.Rmd` 
         + `Fxn - Quick Analysis`: a function to quickly generate a UMAP plot (no-QC) and cluster a sce for the use of comparing pre- and post-SoupX results in `3. SoupX.Rmd`

- `ShinyApp`: contains the scripts we used to build the spinal cord injury myeloid cell atlas that can be used to interactively browse and download the data (<a href="link here when availableXX" target="_blank">link will be here asap</a>)
