#!/bin/bash 

#
# implements the building of databases using makeblastdb
#

echo $1
echo $2
echo $3

sed 's/^/>/' $1 | tr "," "\n" >$2
rm -f $1
makeblastdb -dbtype nucl -in $2 -out $3 -parse_seqids
rm -f $2 
