function [A,Pi] = pre_train(X,B_list)
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
end

