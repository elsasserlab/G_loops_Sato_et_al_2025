def summarize_bed(file_path,out_file):
    # Dictionary to store gene intervals
    gene_intervals = {}

    # Read the BED file
    with open(file_path, 'r') as file:
        for line in file:
            parts = line.strip().split('\t')
            gene_name = parts[3]
            direction = parts[5]
            chr = parts[0]
            start = int(parts[1])
            end = int(parts[2])
            score= parts[4]

            # Check if gene_name already exists in the dictionary
            if gene_name not in gene_intervals:
                gene_intervals[gene_name] = {'chr':chr, 'start': start, 'end': end, 'name':gene_name, 'score':score, 'direction': direction}
            else:
                # Update start and end coordinates if needed
                if start < gene_intervals[gene_name]['start']:
                    gene_intervals[gene_name]['start'] = start
                if end > gene_intervals[gene_name]['end']:
                    gene_intervals[gene_name]['end'] = end

                # Update direction to the first interval's direction
                gene_intervals[gene_name]['direction'] = direction

    # Generate the summarized BED file
    with open(out_file, 'w') as output_file:
        for gene_name, interval_data in gene_intervals.items():
            # Write the summarized interval to the output file
            output_file.write(f"{interval_data['chr']}\t{interval_data['start']}\t{interval_data['end']}\t{gene_name}\t{interval_data['score']}\t{interval_data['direction']}\n")

# Replace 'your_bed_file.bed' with the path to your BED file
summarize_bed('mRNA_ns.bed','mRNA_ns.collapsed.bed')
summarize_bed('mRNA_WTup.bed','mRNA_WTup.collapsed.bed')
summarize_bed('mRNA_DKOup.bed','mRNA_DKOup.collapsed.bed')
