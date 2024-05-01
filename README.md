# Endnote_BibTeX_citekey_generator
An executable R script to generate "AuthorYear" style cite keys with an EndNote BibTeX output file.

## Rationale
EndNote provides numerous output styles when exporting a bibliography, however, it is lacking in the realm of BibTeX outputs. This is because it pre-populates the citekey, a unique reference ID for each bibliography entry, as the EndNote record number, rendering it useless for the purpose of recognizability (i.e. `RN254` vs `Potter2024`). Previously, others have worked to correct this issue by generating alternative output styles including a [BibTeX output](https://endnote.com/downloads/styles/bibtex-export-using-en-label-field/) using the `Label` field in place of the record number. Unfortunately, this still left the unwieldy task of populating that field with the proper information. [Guides for this](https://library.unimelb.edu.au/recite/reference-management-software/bibtex-and-latex/managing-citations2/endnote) process have been able to automate part, but not all, of this process.

## Function
This R script picks picks up where the [BibTeX Export using EN Label field](https://endnote.com/downloads/styles/bibtex-export-using-en-label-field/) style leaves off. After generating a `.bib` file using this output style, assuming all your `Label` fields are blank, the file should have a list of BibTeX style entries formated something like this:

```
@article{
   author = {Love, M. I. and Huber, W. and Anders, S.},
   title = {Moderated estimation of fold change and dispersion for RNA-seq data with DESeq2},
   journal = {Genome Biol},
   volume = {15},
   number = {12},
   pages = {550},
   abstract = {In comparative high-throughput sequencing assays, a fundamental task is the analysis of count data, such as read counts per gene in RNA-seq, for evidence of systematic changes across experimental conditions. Small replicate numbers, discreteness, large dynamic range and the presence of outliers require a suitable statistical approach. We present DESeq2, a method for differential analysis of count data, using shrinkage estimation for dispersions and fold changes to improve stability and interpretability of estimates. This enables a more quantitative analysis focused on the strength rather than the mere presence of differential expression. The DESeq2 package is available at http://www.bioconductor.org/packages/release/bioc/html/DESeq2.html webcite.},
   keywords = {Algorithms
Computational Biology/*methods
High-Throughput Nucleotide Sequencing
Models, Genetic
RNA/*analysis
Sequence Analysis, RNA
*Software},
   ISSN = {1474-760X (Electronic)
1474-7596 (Linking)},
   DOI = {10.1186/s13059-014-0550-8},
   url = {https://www.ncbi.nlm.nih.gov/pubmed/25516281},
   year = {2014},
   type = {Journal Article}
}
```

As you can see, there is no citekey or record number shown at the beginning of the entry (i.e. `@article{Love2014` or `@article{RN146`). Instead, it is currently blank.

Using the R function `BibTeX_citekey_generator.R`, you can append an AuthorYear style citekey to the beginning of each record, so long as neither field is missing data. Additionally, any duplicate citekeys generated in this way are renamed to prevent conflicts (Two instances of `Love2014` would be replaced by `Love2014` and `Love2014a`).

## Usage
To use this script, all you need is an installation of R and the input / output file names. You can then call the script in terminal like so:
```shell
Rscript BibTeX_citekey_generator.R endNoteLib.bib endNoteLib_withCitekeys.bib
```
And there you have it, all entries in your `.bib` file should now be properly formatted:
```
@article{Love2014,
   author = {Love, M. I. and Huber, W. and Anders, S.},
   title = {Moderated estimation of fold change and dispersion for RNA-seq data with DESeq2},
   journal = {Genome Biol},
   volume = {15},
   number = {12},
   pages = {550},
   abstract = {In comparative high-throughput sequencing assays, a fundamental task is the analysis of count data, such as read counts per gene in RNA-seq, for evidence of systematic changes across experimental conditions. Small replicate numbers, discreteness, large dynamic range and the presence of outliers require a suitable statistical approach. We present DESeq2, a method for differential analysis of count data, using shrinkage estimation for dispersions and fold changes to improve stability and interpretability of estimates. This enables a more quantitative analysis focused on the strength rather than the mere presence of differential expression. The DESeq2 package is available at http://www.bioconductor.org/packages/release/bioc/html/DESeq2.html webcite.},
   keywords = {Algorithms
Computational Biology/*methods
High-Throughput Nucleotide Sequencing
Models, Genetic
RNA/*analysis
Sequence Analysis, RNA
*Software},
   ISSN = {1474-760X (Electronic)
1474-7596 (Linking)},
   DOI = {10.1186/s13059-014-0550-8},
   url = {https://www.ncbi.nlm.nih.gov/pubmed/25516281},
   year = {2014},
   type = {Journal Article}
}
```

Whether you use [LaTeX](https://www.latex-project.org), [Obsidian Notes](https://obsidian.md) with the [Citations](https://github.com/hans/obsidian-citation-plugin) plugin, or some other software that needs this format, I hope this will be as beneficial to you as it has been for me. 
