####
# combine_peaks.sh search_string minrep


module load bioinfo-tools
module load BEDTools

lead=$1 #search string for narrowPeak files
min=$2 #minimal replicates that support peak

for base in $(ls $lead*.narrowPeak | sed -E "s/_batch2.+//" | uniq)
do
  echo "--"$base
  cat $(ls $base*.narrowPeak) | sort -k1,1 -k2,2n | bedtools merge -i - -c 4 -o count | awk '$4 >= '$min' {print $1 "\t" $2 "\t" $3 "\t" "'$base'" "\t" $4}' > $base"_combined.bed"
  wc -l $base"_combined.bed"
done

cat $(ls $lead*_combined.bed ) | sort -k1,1 -k2,2n | bedtools merge -i - -c 4 -o collapse > $lead"_combined_min"$min"rep.bed"

head $lead"_combined_min"$min"rep.bed"
wc -l $lead"_combined_min"$min"rep.bed"
