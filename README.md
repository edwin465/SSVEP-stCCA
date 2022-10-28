# SSVEP-stCCA
High performance but long calibration time 
Calibration-based algorithm

The size of calibration data cannot be less than the number of stimuli

We propose a new CCA algorithm that utilizes the intra- and inter-subject knowledge 
The size of calibration data can be less than the number of stimuli




## What is subject transfer CCA (stCCA)?  


### Intra-subject spatial filter  
According to [1], we find that `SSVEPs share a common spatial pattern (or a common spatial filter) across different stimulus frequencies` (precisely speaking, from 8Hz to 15.8Hz) and `the spatial pattern has very large individual difference`. This may imply that each subject can be assigned only one spatial filter. This spatial filter can be termed **the intra-subject spatial filter**. In other words, each subject has his/her own spatial filter.

Based on the multi-stimulus CCA, it is possible to learn the intra-subject spatial filter from only several trials of a subject's calibration data:  
[ms-CCA formula]

### Inter-subject SSVEP template  
Target subject's SSVEP template = weighted summation of source subjects' SSVEP templates  

Weight vector is shared across different stimulus frequencies  

## Two SSVEP datasets
Tsinghua benchmark dataset  
BETA dataset  

## Matlab code

**fun_stcca(f_idx,num_of_trials,TW,dataset_no)**  
f_idx: the index of the selected frequencies  
num_of_trials: number of trials for each selected frequency  
TW: data length (unit: sec)  
dataset_no: 1-> tsinghua benchmark dataset, 2-> BETA dataset  

**fun_calculate_ssvep_template(dataset_no)**  
dataset_no: 1-> tsinghua benchmark dataset, 2-> BETA dataset  

**itr_bci()**  


**ck_signal_nh(sti_f,Fs,pha_val,sig_len,num_of_harmonics)**  
sti_f: stimulus frequency  
Fs: sample frequency  
pha_val: stimulus phase (unit: rad)
sig_len: signal length
num_of_harmonics: number of harmonics for sine-cosine reference signal

## Simulation study  

With only 9 calibration trials, the stCCA can achieve an excellent recognition performance.  
It is comparable to the calibration-based algorithms with minimally required calibration data (i.e., the ms-eCCA with 40 calibration trials and the eTRCA with 80 calibration trials)

### Dataset I

> k=9;  
> f_idx=round((40/k*[1:k]+40/k*[0:k-1])/2);  
> [sub_acc]=fun_stcca(f_idx,1,0.7,1);
  
We can achieve the performance of, which is exactly the one as indicated in Table xx in [1]

### Dataset II

> k=9;  
> f_idx=round((40/k*[1:k]+40/k*[0:k-1])/2);  
> [sub_acc]=fun_stcca(f_idx,1,0.7,2);


