## SCI_2020
 
This repository contains the analysis scripts from our recent pre-print: <a href="https://www.biorxiv.org/content/10.1101/2020.10.21.346635v2" target="_blank"> Hamel R, <i>et al</i>. Time-resolved single-cell RNAseq profiling identifies a novel Fabp5-expressing subpopulation of inflammatory myeloid cells in chronic spinal cord injury. <i>bioRxiv</i> 2020.2010.2021.346635 (2020)</a>.

GSE159638

To replicate or explore our findings, download the data (fastq [requires Cell Ranger, then script 1], raw counts [insert to script 3] , or normalised counts [insert to script 4+]) from the GEO (TBD) and process them with the scripts in this repository.

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

- `ShinyApp`: contains the scripts we used to build the spinal cord injury myeloid cell <a href="https://marionilab.cruk.cam.ac.uk/SCI_Myeloid_Cell_Atlas/" target="_blank">atlas</a> that can be used to interactively browse and download the data 
