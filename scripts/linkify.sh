#!/bin/bash
#paf_to_links

while getopts ":a:l:" opt;do
    case $opt in
	a) align="$OPTARG";;
	l) link="$OPTARG";;
    esac
done

while read line
do
    seq1=$(echo $line | cut -d " " -f 1)
    seq1start=$(echo $line | cut -d " " -f 3)
    seq1end=$(echo $line | cut -d " " -f 4)
    seq2=$(echo $line | cut -d " " -f 6)
    seq2start=$(echo $line | cut -d " " -f 8)
    seq2end=$(echo $line | cut -d " " -f 9)
    echo $seq1" "$seq1start" "$seq1end" "$seq2" "$seq2start" "$seq2end" color=black" >> $link
done < $align

exit 0