%Function to read the session file and set up the values for y and n back

function [] = get_cluster_centers(input)
if strcmp(input,'recollect') == 1
    [X,B_list] = setup_newDS();
else
    [X,B_list] = setup_OldDS();
end

log_P = zeros(5,1);
A1_rr = cell(5,1);
Pi1_rr = cell(5,1);
A2_rr = cell(5,1);
Pi2_rr = cell(5,1);
A3_rr = cell(5,1);
Pi3_rr = cell(5,1);
A4_rr = cell(5,1);
Pi4_rr = cell(5,1);

pi1_rr = cell(5,1);
pi2_rr = cell(5,1);
pi3_rr = cell(5,1);
pi4_rr = cell(5,1);
for i=1:5 %Random Restarts to avoid getting stuck in local maxima
    [A1,Pi1,A2,Pi2,A3,Pi3,A4,Pi4,loglik,pi1,pi2,pi3,pi4] = baum_welch_cont_EM(X,B_list);
    A1_rr{i} = A1;
    Pi1_rr{i} = Pi1;
    A2_rr{i} = A2;
    Pi2_rr{i} = Pi2;
    A3_rr{i} = A3;
    Pi3_rr{i} = Pi3;
    A4_rr{i} = A4;
    Pi4_rr{i} = Pi4;
    log_P(i) = loglik;
    pi1_rr{i} =pi1;
    pi2_rr{i} =pi2;
    pi3_rr{i} =pi3;
    pi4_rr{i} =pi4;
end

[loglik,idx] =max(log_P);

A1 = A1_rr{idx};
Pi1 = Pi1_rr{idx};
A2 = A2_rr{idx};
Pi2 = Pi2_rr{idx};
A3 = A3_rr{idx};
Pi3 = Pi3_rr{idx};
A4 = A4_rr{idx};
Pi4 = Pi4_rr{idx};
pi1 = pi1_rr{idx};
pi2 = pi2_rr{idx};
pi3 = pi3_rr{idx};
pi4 = pi4_rr{idx};
     save('A1.mat','A1');
    save('Pi_1.mat','Pi1');
    save('A2.mat','A2');
    save('Pi_2.mat','Pi2');
    save('A3.mat','A3');
    save('Pi_3.mat','Pi3');
    save('A4.mat','A4');
    save('Pi_4.mat','Pi4');
   save('log_P.mat','log_P');
     save('loglik.mat','loglik');
    save('pi1.mat','pi1');
    save('pi2.mat','pi2');
    save('pi3.mat','pi3');
    save('pi4.mat','pi4');
%Get the cluster assignment for each sequence
nSubs = numel(B_list);
for k = 1:nSubs
    [A,Pi,pi,cluster]=assignCluster(A1,A2,A3,A4,Pi1,Pi2,Pi3,Pi4,pi1,pi2,pi3,pi4,B_list{k});
    cluster_list(k)=cluster;
end
save('cluster_list.mat','cluster_list');
end