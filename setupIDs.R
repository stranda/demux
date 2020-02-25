#
#
# read in a barcode key file and write out a sed script to replace the barcode with a fasta header with the idnumber
#
# name of the barcode keyfile is the first argument.  

args = commandArgs(T)

if (is.na(args[1]))
    keyfile="barcodeDec2019.csv" else keyfile = args[1]

bc = read.csv(keyfile)[,-1]
names(bc) <- tolower(names(bc))
bc$barcode=toupper(bc$barcode)
names(bc)[2]='id'
bc$id=toupper(bc$id)
#bc$barcode=gsub("CAATTC","",bc$barcode)
#bc$barcode
#bc$id=paste0("ID_",bc$id)
print("creating the demux.awk file for these barcodes and ids")
cat (file="demux.awk","#automatically generated awk script\n") 
cat (file="demux.awk",append=T,'BEGIN { RS = "\\n"; FS = "\\f" }\n{}\n\n{')
cat (file="demux.awk",append=T,'sample=""\n')


apply(bc,1,function(x){
#    cat (file="demux.awk",append=T,paste0('barcode="',x[1],'"\n'))
    cat (file="demux.awk",append=T,paste0('if (index($2,"',x[1],'")>0)\n'))
    cat (file="demux.awk",append=T,paste0('{\n'))
    cat (file="demux.awk",append=T,paste0('   sample="',x[2],'"\n'))
    cat (file="demux.awk",append=T,paste0('regex="^.*',x[1],'"\n'))
    cat (file="demux.awk",append=T,paste0('sequence=gensub(regex,"",1,$2)\n'))
    cat (file="demux.awk",append=T,paste0('} else \n'))
})

cat (file="demux.awk",append=T,'   { sample = "nomatch"  \n')
cat (file="demux.awk",append=T,'   sequence = $2 }  \n')

cat (file="demux.awk",append=T,'strt = length($4) - length(sequence)\n')
cat (file="demux.awk",append=T,'qual = substr($4,strt+1)\n')

cat (file="demux.awk",append=T,'print "@" $1  >> "fastq/" sample ".fastq" \n')
cat (file="demux.awk",append=T,'print sequence >> "fastq/" sample ".fastq" \n')
cat (file="demux.awk",append=T,'print $3  >> "fastq/" sample ".fastq" \n')
cat (file="demux.awk",append=T,'print qual >> "fastq/" sample ".fastq" \n')
cat (file="demux.awk",append=T,'}\n')

print ("Creating the fasta file to be used with blast to get those barcodes with some error")

for (i in 1:dim(bc)[1])
{
    if (i==1) a=F else a=T
    cat(file="barcode.fasta",append=a,
        paste0("> ",bc$id[i],"\n",bc$barcode[i],"\n"))
}
