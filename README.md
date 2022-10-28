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
1. Tsinghua benchmark dataset (Dataset I)
2. BETA dataset (Dataset II)  

The details about Dataset I and II can be found:  
**Dataset I**: Wang, Y., et al. (2016). A benchmark dataset for SSVEP-based brain–computer interfaces. IEEE Transactions on Neural Systems and Rehabilitation Engineering, 25(10), 1746-1752.  

**Dataset II**: Liu, B., et al. (2020). BETA: A large benchmark database toward SSVEP-BCI application. Frontiers in neuroscience, 14, 627.  

These two datasets can be downloaded from http://bci.med.tsinghua.edu.cn/


## Matlab code

**fun_stcca(f_idx,num_of_trials,TW,dataset_no)**  
f_idx: the index of the selected frequencies  
num_of_trials: number of trials for each selected frequency  
TW: data length (unit: sec)  
dataset_no: 1-> tsinghua benchmark dataset, 2-> BETA dataset  

**fun_calculate_ssvep_template(dataset_no)**  
dataset_no: 1-> tsinghua benchmark dataset, 2-> BETA dataset  

**itr_bci(p,Nf,T)**  
p: accuracy
Nf: number of stimuli
T: data length (same dimensions as p), including the stimulation length and the rest length  

## Simulation study  
In this simulation study, we test the accuracy of the stCCA with only 9 calibration trials. The 9 calibration trials are corresponding to 9 different stimulus frequencies (e.g., 8.2, 9.2, 10.0, 11.0, 11.8, 12.6, 13.6, 14.4, 15.4 Hz, according to the selection strategy A2 as mentioned in [1]) on two different SSVEP datasets.  

### Dataset I

> k=9;  
> f_idx=round((40/k*[1:k]+40/k*[0:k-1])/2);  
> [sub_acc]=fun_stcca(f_idx,1,0.7,1);  
> all_sub_itr=itr_bci(sub_acc/100,40,(0.7+0.5)\*ones(35,1));  
> mean(all_sub_itr);    
  
We can achieve the performance of, which is exactly the one as indicated in Table xx in [1].  
It is comparable to the calibration-based algorithms with minimally required calibration data (i.e., the ms-eCCA with 40 calibration trials and the eTRCA with 80 calibration trials)

### Dataset II

> k=9;  
> f_idx=round((40/k*[1:k]+40/k*[0:k-1])/2);  
> [sub_acc]=fun_stcca(f_idx,1,0.7,2);  
> all_sub_itr=itr_bci(sub_acc/100,40,(0.7+0.5)\*ones(70,1));  
> mean(all_sub_itr);  

It is comparable to the calibration-based algorithms with minimally required calibration data (i.e., the ms-eCCA with 40 calibration trials and the eTRCA with 80 calibration trials)

## Version 
v1.0: (28 Oct 2022)  
Test stCCA in two SSVEP datasets  

## Feedback
If you find any mistakes, please let me know via chiman465@gmail.com.
