# demux
## shell scripts and R support files to demultiplex barcodes in illumina data

VERSION: 0.0.2
DATE: 3/23/2022

This folder should include:

  + README (this file)
  + demux (shell script that works the whole thing)
  + setupIDs.R (support script needed to create awk files)
  + import.sql (only needed if you use the blast non-exact match thing)
  + makebdb.sh (also only needed if you use the blast non-exact match thing)
  + barcode_test.csv (example barcode-id map)
  + test.fastq.gz (example reads)

# This set of codes demultiplexes illumina reads with inline barcodes

To run the analysis for exact matches you just need to run this command:

./demux test.fastq.gz barcode_test.csv

You should get a new directory installed in this folder called "fastq" containing the demultiplexed reads.



If you want to also include reads that have slight errors in the barcodes, then you first have to make sure you have installed:

blast+ suite from ncbi
sqlite3
gnu parallel

Then invoke this way:

./demux test.fastq.gz barcode_test.csv 1 1

the third parameter "1" is a flag to conduct the more in depth demultiplexing and the fourth parameter "1" indicates that you want to use a single core.
