%This function carries out EM for training
function [A,Pi,logP] = baum_welch_cont(X,B_list)
N= size(X,2); %Number of states
err = 1e-6; %Error theshold for convergence

%Step 1: Initializing A and Pi
%Initialization of the tri-diagonal transition matrix
A =full(gallery('tridiag',N, rand(1,N-1), rand(1,N), rand(1, N-1)));
A_s = sum(A,2);
for i=1:N
    A(i,:) = A(i,:)./A_s(i); %So that the rows sum up to 1
end

Pi = rand(N,1); % Pi ~ 1/N
Pi= Pi./sum(Pi);%Normalizing

maxIters = 20; %Maximum number of re-estimation iterations
it = 1;

logliks = zeros(maxIters,1);

logPold = -Inf;
%Step 2: Alternate  between E step and M step
%[A,Pi,logP] = reestimate_A(A,Pi,B_list); %Here logP  is the log-likelihood
converged = false;
for it =1: maxIters
        [A_,Pi_,logP] = reestimate_A(A,Pi,B_list); %E step
        
        %Likelihood must monotonically increase, else a warning is
        %generated
        if logP < logPold 
           logP = logPold;
           warning('Error. The log-likelihood must go up!');
           break;
        end
        
     %Convergence for EM
      if (abs(logPold - logP)/(1+abs(logPold))) < err
          if norm(A_ - A,inf)/N < err
             converged = true;
              A = A_; 
              Pi = Pi_;
              break;
          end
      end
      
     %M step
    A = A_;
    Pi = Pi_;
    logPold = logP;
    logliks(it) = logP;
    it = it + 1;
end

logliks(logliks ==0) = [];
loglik = max(logliks); 

save('logliks.mat','logliks'); %Plot logliks to see, if there is a monotonic increase


end

