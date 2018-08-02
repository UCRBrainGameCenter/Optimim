function [A_,Pi_,lik] = reestimate_A(A,Pi,B_list)
A_ = zeros(size(A));
N = size(A,1);
K= numel(B_list); %Number of subjects

%For computing the expected sufficient statistics
sum_numer = zeros(N,N);
sum_denom = zeros(N,1);
sum_Pi_hat = zeros(N,1);
lik = 0;
P_list = cell(K,1);
       for k=1:K
             B= B_list{k};
            if (isempty(B) == 1)
                continue;
            end
            [Pi_hat,numer,denom,logP] =single_seq(A,Pi,B); %Computing expectations per sequence
            P_list{k} = logP;
            sum_numer = sum_numer + numer; 
            %Check: To make sure that the computation is correct
            if abs(sum(sum(numer)) - (length(B)-1)) > 1e-10
                warning('Incorrect sum');
            end
            sum_Pi_hat = sum_Pi_hat + Pi_hat;
            lik = lik + logP;%Calculate total likelihood of data:/exp(logP)
        end

Pi_ = sum_Pi_hat./sum(sum_Pi_hat);

%Parameter Sharing 
%Note: The parameters are tied across each diagonal, in-order to reduce the
%capacity of the model. This step can be avoided too.
  x1=0;y1=0;z1=0;
     for i=2:N-1 
       x1= x1 + sum_numer(i,i-1);
       y1= y1 + sum_numer(i,i);
       z1= z1 + sum_numer(i,i+1);
     end
 
     for i=2:N-1
        sum_numer(i,i-1) = x1;
        sum_numer(i,i) = y1;
        sum_numer(i,i+1) = z1;
     end
   % A_s = sum(sum_numer,2);
   % for i=1:N
    %    A_(i,:) = sum_numer(i,:)./sum_denom(i);
    %end
    totalTransitions = sum(sum_numer,2);

    A_ = sum_numer./(repmat(totalTransitions,1,N));


end



