#!/bin/bash
# Made by Thomas Arn Hansen

###################################
## Read in arguments
###############################
if [ $# -ne 4 ]; 
then
echo -e "Wrong number of input arguments\nUsage: sh /home/arn/install/scripts/collapse_paired_end_for_barcodes.sh pair1.fq pair2.fq primerfile.txt output_dir"
exit
fi


if [ ! -f $1  -o ! -f $2 ] || [ $1 = $2 ]; then 
echo -e "File not found or pair1 is identical to pair2!\nUsage: sh /home/arn/install/scripts/collapse_paired_end_for_barcodes.sh pair1.fq pair2.fq primerfile.txt output_dir"
exit
fi

#echo `paste -d: $1 $2` 

paste -d\| $1 $2 | perl /path/to/script/remove_tagprimer_for_misew.pl $3 $4

