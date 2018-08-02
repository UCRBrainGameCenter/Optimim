function [accu,nback,nTrials] = set_upnew2016()
load('Accuracy_s1_clean.mat');
load('Accuracy_s2_clean.mat');

sz = size(Accuracy_s1_clean);
nDays = sz(2);
nSubs = sz(3);
accu ={};
nback = {};
nTrials = {};
for sub=1:nSubs
    accu_s1 = Accuracy_s1_clean(:,:,sub);
    accu_s2 = Accuracy_s2_clean(:,:,sub);
    
    nlevel_s1 = Nlevel_s1_clean(:,:,sub);
    nlevel_s2 = Nlevel_s2_clean(:,:,sub);
    
    ntrials_s1 = numTrials_s1_clean(:,:,sub);
    ntrials_s2 = numTrials_s2_clean(:,:,sub);
    
    nlevel_mat = cell(nDays,1);
    accu_mat =cell(nDays,1);
    ntrials_mat = cell(nDays,1);
    
    for k=1:nDays
        A1 =accu_s1(:,k);
        idx = find(isnan(A1));
        
        A1(idx)=[];
        nlevel1 =nlevel_s1(:,k);
        nlevel1(idx)=[];
        ntrials1 =ntrials_s1(:,k);
        ntrials1(idx)=[];
        idx2 =find(ntrials1==0);
        
        A1(idx2) =[];
        nlevel1(idx2)=[];
        ntrials1(idx2)=[];
        
        
        
        
        A2 =accu_s2(:,k);
        idx = find(isnan(A2));
        A2(idx)=[];
        nlevel2 =nlevel_s2(:,k);
        nlevel2(idx)=[]; 
        ntrials2 =ntrials_s2(:,k);
        ntrials2(idx)=[];
        idx2 =find(ntrials2==0);
        
        A2(idx2) =[];
        nlevel2(idx2)=[];
        ntrials2(idx2)=[];
        
        A= [A1;A2]; %Combining both sessions
        nlevel = [nlevel1;nlevel2];
        ntrials = [ntrials1;ntrials2];
       
        
        
        accu_mat{k} =A;
        nlevel_mat{k} = nlevel;
        ntrials_mat{k} = ntrials;
    end
    accu = [accu;cell2mat(accu_mat)];
    nback = [nback;cell2mat(nlevel_mat)];
    nTrials = [nTrials;cell2mat(ntrials_mat)];
end
save('accu.mat','accu');
save('nback.mat','nback');
save('nTrials.mat','nTrials');

end