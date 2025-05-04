#!/bin/bash

#Make working directory
mkdir brean-brca-gemdiff
cd brean-brca-gemdiff

#Prepare GEMDiff Anaconda Environment
git clone https://github.com/xai990/GEMDiff.git
cd GEMDiff
conda env create -f environment.yml -n GEMDiffEnv
cd ..

#May need to install this package independently as GEMDiff requirement
#conda install mpi4py

#Make datasets directory
mkdir datasets
cd datasets

#Manually download and upload raw GEMs from Wang et al paper
#https://figshare.com/articles/dataset/Data_record_3/5330593
#gunzip *.txt.gz

#Manually upload tab-delimited gene list for GEMDiff
#cat mechanotransduction-genes.txt

#Manually upload YAML config file for GEMDiff
#Set feature_size value equal to number of genes in gene list
#cat brean-brca-config.yml

#Clone GEMBuild to preprocess GEMs for GEMDiff training/testing
git clone https://github.com/feltus/gembuild.git

#Merge GEMs
python gembuild/gem_merge.py breastrsemfpkmgtex.txt brcarsemfpkmtcgat.txt BREAN_BRCAT.txt

#Transpose GEMs
bash gembuild/transpose_gem.sh BREAN_BRCAT.txt > BREAN_BRCAT_transpose.txt

#Split into test and train sets
bash gembuild/split_gem.sh BREAN_BRCAT_transpose.txt BREAN_BRCAT_train.txt BREAN_BRCAT_test.txt

#Convert GEMs to tab-delimited format
cat BREAN_BRCAT_train.txt | awk '{$1=$1}1' OFS='\t'  > BREAN_BRCAT.train; cat BREAN_BRCAT_test.txt | awk '{$1=$1}1' OFS='\t'  > BREAN_BRCAT.test

#Make group label files
bash gembuild/make_labels.sh BREAN_BRCAT.train; bash gembuild/make_labels.sh BREAN_BRCAT.test

#Create histogram from GEMs using gene list in PWD
python gembuild/gem_histogram.py -e BREAN_BRCAT.train -g mechanotransduction-genes-v2.txt -o output-histo-train.png
python gembuild/gem_histogram.py -e BREAN_BRCAT.test -g mechanotransduction-genes-v2.txt -o output-histo-test.png
