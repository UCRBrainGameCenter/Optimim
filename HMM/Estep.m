function [A_list,Pi_,theta_,lik] = Estep(A_list,Pi,B_list,nbacks,accu,theta)
K= numel(B_list); %Number of subjects
N=12;
sum_Pi_hat = zeros(N,1);
lik = 0;
P_list = cell(K,1);
        for k=1:K
             B= B_list{k};
            if (isempty(B) == 1)
                continue;
            end
           % A= A_list{k};
            nb =nbacks{k};
            acc = accu{k};
            [theta_,Pi_hat,logP,A] =single_seq2(Pi,B,theta,nb,acc); %Computing expectations per sequence
            theta = theta_;
           
            A_list{k} = A;
            P_list{k} = logP;
            
            sum_Pi_hat = sum_Pi_hat + Pi_hat;
            lik = lik + logP;%Calculate total likelihood of data:/exp(logP)
        end
Pi_ = sum_Pi_hat./sum(sum_Pi_hat);
end



