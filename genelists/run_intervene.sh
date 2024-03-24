intervene venn -i ../peaks/G4_combined_min3rep.bed ../genelists/mRNA*.collapsed.bed -o all_peaks_vs_DKO_mRNA
intervene venn -i ../peaks/G4_CnT_combined_peaks_DESeq_DKO_sig_lfc_base_cutoff.bed ../genelists/mRNA*.collapsed.bed -o DKO_peaks_vs_all_mRNA
intervene venn -i ../peaks/G4_CnT_combined_peaks_DESeq_DKO_sig_lfc_base_cutoff.bed ../genelists/mRNA*.collapsed.bed -o DKO_peaks_vs_all_mRNA
intervene venn -i ../peaks/G4_CnT_promoters_DESeq_DKO_sig.bed ../genelists/mRNA*.collapsed.bed -o DKO_Pro_vs_all_mRNA
