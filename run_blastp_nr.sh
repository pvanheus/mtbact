#!/bin/bash

if [ $# != 1 ] ; then
  echo "Usage: run_blastp_nr.sh $INPUT_FASTA" >&2
  exit 1
fi
SAMPLE=$1
PATH=$PATH:/tools/software/singularity-2.5.2/bin
export PATH
BLAST="singularity exec -B /tools /tools/simg/blast-2.7.1.sing blastp"
DB=/tools/databases/ncbi/nr/default/nr
#DB=/tools/databases/ncbi/ref_prok_rep_genomes/default/ref_prok_rep_genomes
BLASTDB=$(dirname $DB)
export BLASTDB
IN_DIR=$HOME/mapula
NUM_THREADS=$(expr $SLURM_JOB_CPUS_PER_NODE - 1)
/usr/bin/time $BLAST -num_threads $NUM_THREADS -db $DB -outfmt "6 std slen qlen qcovs qcovhsp stitle sblastnames staxids sscinames sskingdoms" -out blast_results/${SAMPLE}_nr.tsv -query $IN_DIR/${SAMPLE}.faa -max_target_seqs 10 -evalue 10 -negative_seqidlist $IN_DIR/accession_list.txt
