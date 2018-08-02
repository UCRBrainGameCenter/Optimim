function [accu,nback,nTrials] = set_upnew2017()

load('Accuracy_clean.mat');
sz = size(Accuracy_clean);
nDays = sz(2);
nSubs = sz(3);
accu ={};
nback = {};
nTrials = {};
for sub=1:nSubs
    accur = Accuracy_clean(:,:,sub);
    nlevel = Nlevel_clean(:,:,sub);
    ntrials = numTrials_clean(:,:,sub);
    
    nlevel_mat = cell(nDays,1);
    accu_mat =cell(nDays,1);
    ntrials_mat = cell(nDays,1);
    
    for k=1:nDays
        A =accur(:,k);
        idx = find(isnan(A));
        A(idx)=[];
        
        nlevel1 =nlevel(:,k);
        nlevel1(idx)=[];
        ntrials1 =ntrials(:,k);
        ntrials1(idx)=[];
        idx2 =find(ntrials1==0);
        
        A(idx2) =[];
        nlevel1(idx2)=[];
        ntrials1(idx2)=[];
        
        
        %A= [A1;A2]; %Combining both sessions
       % ntrials = [ntrials1;ntrials2];
        accu_mat{k} =A;
        nlevel_mat{k} = nlevel1;
        ntrials_mat{k} = ntrials1;
    end
    accu = [accu;cell2mat(accu_mat)];
    nback = [nback;cell2mat(nlevel_mat)];
    nTrials = [nTrials;cell2mat(ntrials_mat)];
end
save('accu.mat','accu');
save('nback.mat','nback');
save('nTrials.mat','nTrials');

end