function fun_calculate_ssvep_template(dataset_no)

if dataset_no==1
    str_dir='..\Tsinghua dataset 2016\';
    ch_used=[48 54 55 56 57 58 61 62 63]; % Pz, PO5, PO3, POz, PO4, PO6, O1, Oz, O2
    sti_f=[8.0:1:15.0, 8.2:1:15.2,8.4:1:15.4,8.6:1:15.6,8.8:1:15.8];
    n_sti=length(sti_f);                     % number of stimulus frequencies
    [~,target_order]=sort(sti_f);
    sti_f=sti_f(target_order);
    num_of_subj=35;
    latencyDelay = 0.14;                     % latency
elseif dataset_no==2
    str_dir='..\BETA SSVEP dataset\';
    ch_used=[48 54 55 56 57 58 61 62 63]; % Pz, PO5, PO3, POz, PO4, PO6, O1, Oz, O2
    sti_f=[8.6:0.2:15.8,8.0 8.2 8.4];
    n_sti=length(sti_f);                     % number of stimulus frequencies
    [~,target_order]=sort(sti_f);
    sti_f=sti_f(target_order);
    num_of_subj=70;
    latencyDelay = 0.13;                    % latency
else
end

Fs=250;                                 % sampling frequency
% butterworth filter
bandpass=[7 100];
[b1,a1]=butter(4,[bandpass(1)/(Fs/2) bandpass(2)/(Fs/2)]);

tic
for sn=1:num_of_subj
    if dataset_no==1
        load(strcat(str_dir,'S',num2str(sn),'.mat'));
        eeg = data(ch_used,floor(0.5*Fs+latencyDelay*Fs):floor(0.5*Fs+latencyDelay*Fs)+4*Fs-1,:,:);
    elseif dataset_no==2
        load([str_dir 'S' num2str(sn) '.mat']);
        eegdata = data.EEG;
        data = permute(eegdata,[1 2 4 3]);
        eeg = data(ch_used,floor(0.5*Fs+latencyDelay*Fs)+1:floor(0.5*Fs+latencyDelay*Fs)+2*Fs,:,:);
    else
       
    end
    
    [d1_,d2_,d3_,d4_]=size(eeg);
    d1=d3_;d2=d4_;d3=d1_;d4=d2_;    
    % d1: num of stimuli
    % d2: num of trials
    % d3: num of channels % Pz, PO5, PO3, POz, PO4, PO6, O1, Oz, O2
    % d4: num of sampling points
    
    for i=1:1:d1
        for j=1:1:d2
            y0=reshape(eeg(:,:,i,j),d3,d4);
            for ch_no=1:d3
                % CAR
                y0(ch_no,:)=y0(ch_no,:)-mean(y0([1:ch_no-1,ch_no+1:end],:));
                y(ch_no,:)=filtfilt(b1,a1,y0(ch_no,:));
            end            
            SSVEPdata(:,:,j)=reshape(y,d3,d4,1);
        end
        mu_ssvep=mean(SSVEPdata,3);
        subj(sn).ssvep_template(:,:,i)=mu_ssvep;
    end
    subj(sn).ssvep_template=subj(sn).ssvep_template(:,:,target_order);
   
    clear eeg SSVEPdata
    toc
end
filename=mfilename('fullpath');
if dataset_no==1
    save('th_ssvep_template_for_stcca.mat','subj','filename');
elseif dataset_no==2
    save('beta_ssvep_template_for_stcca.mat','subj','filename');
else
end
    
    
