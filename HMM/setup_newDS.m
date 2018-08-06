function [X,B_list] = setup_newDS()
[accu1,nbacks1,nTrials1] = set_upnew2017(); %Reading the 2017 dataset (classic staircase training algo)
[accu2,nbacks2,nTrials2] = set_upnew2016(); %Reading the 2016 dataset(has two sessions per day and multiple training algos)
taccu= [accu1;accu2];
tnbacks =[nbacks1;nbacks2];
tnTrials =[nTrials1;nTrials2];
save('tnbacks.mat','tnbacks');
save('tnTrials.mat','tnTrials');
save('taccu.mat','taccu');
%Train- Test split--
%Shuffling the dataset and taking 80% for training and 20% for testing
sz = size(taccu);
totalSubs = sz(1);
indices = randperm(totalSubs);
sz = round(0.8*totalSubs);
train_idx = indices(1:sz);
accu = taccu(train_idx,:);
nbacks = tnbacks(train_idx,:);
nTrials = tnTrials(train_idx,:);

test_idx = indices(sz+1:end);
accu_test = taccu(test_idx,:);
nbacks_test = tnbacks(test_idx,:);
nTrials_test = tnTrials(test_idx,:);

save('accu_test.mat','accu_test');
save('nbacks_test.mat','nbacks_test');
save('nTrials_test.mat','nTrials_test');

nSubs = sz(1);
%Recording B,M and R for each subject. 
%B: Emission Matrix,
%M: number of trials played per block
%R: number of scored trials per block
B_list = cell(nSubs,1); 
M_list = cell(nSubs,1);
R_list = cell(nSubs,1);
%Setting the global parameters -- via grid search performed in
%tuning_parameters
%NOTE: whenever data changes are made, update the parameters
rho=1.7;
c=0.0;
d=1;
n = 3;
X= linspace(1,12,12);
%Collecting data across all subjects
for k = 1:nSubs
    acc = accu{k};
    nback = nbacks{k};
    nTrial = nTrials{k};
    R = acc.*nTrial;
    R = round(R);
    
    [B] =  compute_emission_prob(nTrial,R,nback,rho,c,d,X,n); %Computing B for subject k
    B_list{k} = B;
    M_list{k} = nTrial;
    R_list{k} = R;
end
save('B_list.mat','B_list');
save('M.mat','M_list');
save('R.mat','R_list');
save('nbacks.mat','nbacks');
save('X.mat','X');

end

