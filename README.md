# SSVEP-stCCA
High performance but long calibration time 
Calibration-based algorithm

The size of calibration data cannot be less than the number of stimuli

We propose a new CCA algorithm that utilizes the intra- and inter-subject knowledge 
The size of calibration data can be less than the number of stimuli


## What is subject transfer CCA (stCCA)?  
In the stCCA, it uses the intra-subject spatial filter and inter-subject SSVEP template to compute the correlation coefficient.

### Intra-subject spatial filter  
According to [1], we find that `SSVEPs share a common spatial pattern (or a common spatial filter) across different stimulus frequencies` (precisely speaking, from 8Hz to 15.8Hz) and `the spatial pattern has very large individual difference`. This may imply that each subject can be assigned only one spatial filter. This spatial filter can be termed **the intra-subject spatial filter**. In other words, each subject has his/her own spatial filter.

Based on the multi-stimulus CCA, it is possible to learn the intra-subject spatial filter from a subject's SSVEP templates $\bar{\mathbf{X}}_j$ corresponding to only several frequencies (e.g., $K$ frequencies, $1 \le K \le N\_f$ and $N\_f$ is the number of stimuli):  
```math
r_{k}=\max_{\mathbf{u},\mathbf{v}}{\frac{\mathbf{u}^\top\mathcal{X}^\top\mathcal{Y}\mathbf{v}}{\sqrt{\mathbf{u}^\top \mathcal{X}^\top\mathcal{X}\mathbf{u}\cdot\mathbf{v}^\top\mathcal{Y}^\top\mathcal{Y}\mathbf{v}}}}=\mathrm{CCA}(\mathcal{X},\mathcal{Y}), 
```  

where  
```math
\mathcal{X} = \left[\bar{\mathbf{X}}_{a_1}^\top,\bar{\mathbf{X}}_{a_2}^\top,\cdots,\bar{\mathbf{X}}_{a_K}^\top \right]^\top,  \mathcal{Y} = \left[{\mathbf{Y}}_{a_1}^\top,{\mathbf{Y}}_{a_2}^\top,\cdots,{\mathbf{Y}}_{a_K}^\top \right]^\top,  
```  
```math
\mathbf{Y} = \left[\begin{array}{c}
    \sin (2\pi f_{k} t + \phi_k)\\
    \cos (2\pi f_{k} t + \phi_k)\\
    \sin (2\pi 2f_{k} t + 2\phi_k)\\
    \cos (2\pi 2f_{k} t + 2\phi_k)\\
    \vdots\\
    \sin (2\pi N_h f_{k} t + N_h \phi_k)\\
    \cos (2\pi N_h f_{k} t + N_h \phi_k)\\    
	\end{array}\right]^\top 
```  
and $a\_1$, $a\_1$, ..., $a\_K$ are the indices of $K$ stimuli (let's say: $1 \le a_1 < a_2 \cdots < a_K \le N\_f$).  

### Inter-subject SSVEP template  
Target subject's SSVEP template = weighted summation of source subjects' SSVEP templates  

Weight vector is shared across different stimulus frequencies  

## Two SSVEP datasets
1. Tsinghua benchmark dataset (Dataset I) [2]  
2. BETA dataset (Dataset II) [3]  

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

## Reference
[1] Wong, C. M., et al. (2020). Inter-and intra-subject transfer reduces calibration effort for high-speed SSVEP-based BCIs. IEEE Transactions on Neural Systems and Rehabilitation Engineering, 28(10), 2123-2135.  
[2] Wang, Y., et al. (2016). A benchmark dataset for SSVEP-based brain–computer interfaces. IEEE Transactions on Neural Systems and Rehabilitation Engineering, 25(10), 1746-1752.   
[3] Liu, B., et al. (2020). BETA: A large benchmark database toward SSVEP-BCI application. Frontiers in neuroscience, 14, 627.  

# Citation  
If you use this code for a publication, please cite the following papers

@article{wong2020learning,  
title={Learning across multi-stimulus enhances target recognition methods in SSVEP-based BCIs},  
author={Wong, Chi Man and Wan, Feng and Wang, Boyu and Wang, Ze and Nan, Wenya and Lao, Ka Fai and Mak, Peng Un and Vai, Mang I and Rosa, Agostinho},  
journal={Journal of Neural Engineering},  
volume={17},  
number={1},  
pages={016026},  
year={2020},  
publisher={IOP Publishing}  
}  

@article{wong2020spatial,  
title={Spatial filtering in SSVEP-based BCIs: unified framework and new improvements},  
author={Wong, Chi Man and Wang, Boyu and Wang, Ze and Lao, Ka Fai and Rosa, Agostinho and Wan, Feng},  
journal={IEEE Transactions on Biomedical Engineering},  
volume={67},  
number={11},  
pages={3057--3072},  
year={2020},  
publisher={IEEE}  
}  

@article{wong2020inter,  
  title={Inter-and intra-subject transfer reduces calibration effort for high-speed SSVEP-based BCIs},  
  author={Wong, Chi Man and Wang, Ze and Wang, Boyu and Lao, Ka Fai and Rosa, Agostinho and Xu, Peng and Jung, Tzyy-Ping and Chen, CL Philip and Wan, Feng},  
  journal={IEEE Transactions on Neural Systems and Rehabilitation Engineering},  
  volume={28},  
  number={10},  
  pages={2123--2135},  
  year={2020},  
  publisher={IEEE}  
}  
