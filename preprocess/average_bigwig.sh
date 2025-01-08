####
# combine_peaks.sh search_string minrep

module load bioinfo-tools
module load deepTools


for base in $(ls $1*R?.bw | sed -E "s/_R.\..+//" | uniq)
do
  echo "--"$base
  bigwigAverage -b $(ls "$base"_R?.bw) --bin-size 5 -p 1 -o $base"_combined.bw"
  exit
done

for base in $(ls $1*R?.unique.bw | sed -E "s/_R.\..+//" | uniq)
do
  echo "--"$base
  ls "$base"_R?.unique.bw
done
