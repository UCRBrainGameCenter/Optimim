%Function to read the session file and set up the values for y and n back

function [] = train_hmm(input)

if strcmp(input,'recollect') == 1
    [X,B_list] = setup_newDS();
else
    [X,B_list] = setup_OldDS();
end

log_P = zeros(5,1);
A_rr = cell(5,1);
Pi_rr = cell(5,1);
for i=1:5 %Random Restarts to avoid getting stuck in local maxima
    [A,Pi,loglik] = baum_welch_cont(X,B_list);
    A_rr{i} = A;
    Pi_rr{i} = Pi;
    log_P(i) = loglik;
end

[loglik,idx] =max(log_P);

A = A_rr{idx};
Pi = Pi_rr{idx};
save('A.mat','A');
save('Pi.mat','Pi');
save('log_P.mat','log_P');
save('loglik.mat','loglik');


end