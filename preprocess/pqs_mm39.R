### Wrapper to run pqsfinder on whole mm39 genome
# 2025 Simon Elsässer

# Load required libraries
if (!requireNamespace("BiocManager", quietly = TRUE))
    install.packages("BiocManager")

if (!requireNamespace("pqsfinder", quietly = TRUE))
    BiocManager::install("pqsfinder")

if (!requireNamespace("rtracklayer", quietly = TRUE))
    BiocManager::install("rtracklayer")

if (!requireNamespace("BSgenome", quietly = TRUE))
    BiocManager::install("BSgenome")

library(pqsfinder)
library(rtracklayer)
library(GenomicRanges)
library(BSgenome)

# Load the mm39 genome file
mm39_fasta <- "../../../bowtie2-index/mm39.fa"  # Path to the mm39 fasta file
if (!file.exists(mm39_fasta)) {
    stop("FASTA file for mm39 genome not found.")
}

# Import the genome sequences
mm39_genome <- Biostrings::readDNAStringSet(mm39_fasta, format = "fasta")

# Initialize an empty GRanges object to store results
combined_granges <- GRanges()

# Create a named vector of sequence lengths from the FASTA file
seq_lengths <- width(mm39_genome)
names(seq_lengths) <- names(mm39_genome)

# Process each chromosome
for (chrom in names(mm39_genome)) {
  cat("Processing", chrom, "...\n")

  # Extract DNA sequence for the current chromosome
  chrom_seq <- mm39_genome[[chrom]]

  # Run pqsfinder on the chromosome sequence
  pqs_results <- pqsfinder(chrom_seq, min_score = 20)

  # Convert pqsfinder results to a GRanges object
  gr <- GRanges(seqnames = chrom,
                ranges = IRanges(start = start(pqs_results),
                                 end = end(pqs_results)),
                score = score(pqs_results))

  # Append to the combined GRanges object
  combined_granges <- c(combined_granges, gr)
}

seqlengths(combined_granges) <- seq_lengths[seqlevels(combined_granges)]
# Write the non-reduced GRanges to a BED file
bed_file <- "PQS_scores.bed"
cat("Writing to BED file:", bed_file, "\n")
export(combined_granges, bed_file, format = "BED")

# Reduce GRanges to ensure no overlapping ranges for BigWig
reduced_granges <- reduce(combined_granges, with.revmap = TRUE, min.gapwidth = 0)

# Assign sequence lengths to the reduced GRanges object
seqlengths(reduced_granges) <- seq_lengths[seqlevels(reduced_granges)]

# Export as a BigWig track
bigwig_file <- "PQS_scores.bw"
cat("Writing to BigWig file:", bigwig_file, "\n")
export(reduced_granges, bigwig_file, format = "BigWig")
