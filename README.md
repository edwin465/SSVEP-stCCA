# SSVEP-stCCA
Steady-state visual evoked potential (SSVEP)-based brain-computer interfaces (BCIs) can deliver high information transfer rate (ITR), but **requiring a large amount of subject’s calibration data to learn the class- and subject-specific model parameters (e.g. the spatial filters and SSVEP templates)**. Among the current calibration-based algorithms, the amount of the calibration data is proportional to the number of classes (or visual stimuli). In addition, **the size of calibration data cannot be less than the number of stimuli**.  

We propose a subject transfer based canonical correlation analysis (stCCA) algorithm that utilizes the intra- and inter-subject knowledge to highly reduce the subject's calibration data. Our experimental results demonstrate that `the stCCA method performs well with extremely little calibration data`, providing an ITR at **198.18±59.12 bpm with 9 calibration trials in the Tsinghua benchmark dataset** and **127.86±60.43 bpm with 9 calibration trials in the BETA dataset**.  


## What is subject transfer CCA (stCCA)?  
In the stCCA, it uses the intra-subject spatial filter and inter-subject SSVEP template to compute the correlation coefficient.

### Intra-subject spatial filter  
According to [1], we find that `SSVEPs share a common spatial pattern (or a common spatial filter) across different stimulus frequencies` (precisely speaking, from 8Hz to 15.8Hz) and `the spatial pattern has very large individual difference`. This may imply that **each subject has his/her own spatial filter and different subjects cannot share a common spatial filter**. This subject-specific spatial filter can be termed **the intra-subject spatial filter**. 

![result1](https://github.com/edwin465/SSVEP-stCCA/blob/main/35subjects_40frequencies_common_spatial_pattern_topoplot.png)


Based on the multi-stimulus CCA, it is possible to learn the intra-subject spatial filter from a subject's SSVEP templates $\bar{\mathbf{X}}\_j$ corresponding to only several frequencies (e.g., $K$ frequencies, $1 \le K \le N\_f$ and $N\_f$ is the number of stimuli):  
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
Here we assume that `different subjects' spatially filtered SSVEP template share common knowledge`. Specifically, **a new subject's (or target subject's) spatially filtered SSVEP template is the weighted summation of the existing subjects' (or source subjects') spatially filtered SSVEP templates**. In addition, the weight vector is invariant with different stimulus frequencies.  

```math
\tilde{\mathbf{X}}_k=\frac{1}{N_{sub}}\sum_{n=1}^{M}{w_{n}\cdot {_{n}\bar{\mathbf{X}}_{k}}\cdot{_{n}{\mathbf{u}}}},
```  
where $w\_n$ is the weight for the $n$-th source subject, $\_{n}\overline{\mathbf{X}}\_{k}$ and $\_{n}\mathbf{u}$ are the SSVEP template and the spatial filter from the $n$-th source subject. $n=1,2,\cdots, M$.

![result2](https://github.com/edwin465/SSVEP-stCCA/blob/main/block_diagram_2020_English.png)  

```math  
\mathbf{w}=\min_{\mathbf{w}}{\frac{1}{2} ||{\mathbf{b}-\mathbf{A}\mathbf{w}}}||,
``` 
where $\mathbf{w}=[w\_{1},w\_{2},\cdots,w\_{M}]^\top$.
  
## Two SSVEP datasets
1. Tsinghua benchmark dataset (Dataset I) [2]  
2. BETA dataset (Dataset II) [3]  

These two datasets can be downloaded from http://bci.med.tsinghua.edu.cn/  

> In [1], we used the Tsinghua benchmark dataset and UCSD dataset [4]. 

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
  
The average ITR is `198.18 bpm`, which is exactly the same one in Table IV [1] (this code can be used to reproduce the results as reported in [1], such as the Figure 7 and Figure 9). As mentioned in [1], this ITR is comparable to some of current calibration-based algorithms with minimally required calibration data (i.e., the ms-eCCA with 40 calibration trials and the eTRCA with 80 calibration trials). 



### Dataset II

> k=9;  
> f_idx=round((40/k*[1:k]+40/k*[0:k-1])/2);  
> [sub_acc]=fun_stcca(f_idx,1,0.7,2);  
> all_sub_itr=itr_bci(sub_acc/100,40,(0.7+0.5)\*ones(70,1));  
> mean(all_sub_itr);  

The average ITR is `127.86 bpm`. I believe that this performance is comparable to some of current calibration-based algorithms with minimally required calibration data (i.e., the eCCA with 40 calibration trials and the eTRCA with 80 calibration trials). 

## Version 
v1.0: (28 Oct 2022)  
Test stCCA in two SSVEP datasets  

## Feedback
If you find any mistakes, please let me know via chiman465@gmail.com.

## Reference
[1] Wong, C. M., et al. (2020). Inter-and intra-subject transfer reduces calibration effort for high-speed SSVEP-based BCIs. IEEE Transactions on Neural Systems and Rehabilitation Engineering, 28(10), 2123-2135.  
[2] Wang, Y., et al. (2016). A benchmark dataset for SSVEP-based brain–computer interfaces. IEEE Transactions on Neural Systems and Rehabilitation Engineering, 25(10), 1746-1752.   
[3] Liu, B., et al. (2020). BETA: A large benchmark database toward SSVEP-BCI application. Frontiers in neuroscience, 14, 627.  
[4] Nakanishi, M., et al. (2015). A comparison study of canonical correlation analysis based methods for detecting steady-state visual evoked potentials. PloS one, 10(10), e0140703.  

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

