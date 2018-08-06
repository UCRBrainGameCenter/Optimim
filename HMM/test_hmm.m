%Parameters must be A, Pi obtained from training the model, and test_accu,
%test_nbacks, test_nTrials.
function [test_rmse] = test_hmm(theta,Pi,accu,nbacks,nTrials,X)

sz = size(accu);
nSubs = sz(1);
test_M = cell(nSubs,1);
test_R = cell(nSubs,1);
A_list = cell(nSubs,1);
B_list = cell(nSubs,1);
test_residuals = cell(nSubs,1);
Test_Predicted_Values = cell(nSubs,1);
Test_Actual_Values = cell(nSubs,1);
X= linspace(1,12,12);
rho=1.7;
c=0.0;
d=1;
n=3;
%Collecting data across all subjects
for k = 1:nSubs
    acc = accu{k};
    nback = nbacks{k};
    nTrial = nTrials{k};
    R = acc.*nTrial;
    R = round(R);
    Test_Actual_Values{k} = acc;
    if ndims(theta)>2
        sz2 = size(acc)
        T = sz2(1);

        nb_prev = zeros(T,1);
        accu_prev = zeros(T,1);
        Y = discretize(acc,10);
        A= cell(T-1,1);
         for t=2:T
             accu_prev(t) = Y(t-1);
             nb_prev(t) = nback(t-1);
             [A_t] = populateA(theta,nb_prev(t),accu_prev(t));
             A{t-1} = A_t;
         end
        [B] = computeA_B(nTrial,R,nback,rho,c,d,X,n); %Computing the emission prob for each training seq
    else
        [B] = compute_emission_prob(nTrial,R,nback,rho,c,d,X,n); %Computing the emission prob for each training seq
         A = theta;
    end
      
    [Y_hat,err] = forward2(Pi,B,A,R,nTrial,nback,rho,c,d,X); %To compute the filtered prediction
    test_residuals{k} =err;
    Test_Predicted_Values{k}= Y_hat;
     B_list{k} = B;
     A_list{k} = A;
     test_M{k}= nTrial;
     test_R{k} = R;
end
sessions = linspace(1,nSubs,nSubs);
test_residuals = cell2mat(test_residuals);
test_rmse = sqrt(sum(test_residuals.*test_residuals)/length(test_residuals)); %rmse


save('test_rmse.mat','test_rmse');
save('test_residuals.mat','test_residuals');
save('test_B.mat','B_list');
save('test_A.mat','A_list');
save('test_R.mat','test_R');
save('test_M.mat','test_M');
save('test_n_backs_list.mat','nbacks');
save('Test_Actual_Values.mat','Test_Actual_Values');
save('Test_Predicted_Values.mat','Test_Predicted_Values');
end