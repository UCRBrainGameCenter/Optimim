%This function carries out EM for training
function [A_list,Pi,theta,logP] = baum_welch_cont2(X,B_list,nbacks,accu)

A_list = cell(numel(B_list),1);

N= size(X,2); %Number of states
err = 1e-6; %Error theshold for convergence
%Step 1: Initializing A and Pi
%Initialization of the tri-diagonal transition matrix
theta = rand(3,24,10);
theta= theta./sum(theta,1);

Pi = rand(N,1); % Pi ~ 1/N
Pi= Pi./sum(Pi);%Normalizing

maxIters = 20; %Maximum number of re-estimation iterations
it = 1;

logliks = zeros(maxIters,1);

logPold = -Inf;
%Step 2: Alternate  between E step and M step
converged = false;
for it =1: maxIters
        [A_list,Pi_,theta_,logP] = Estep(A_list,Pi,B_list,nbacks,accu,theta); %E step
       
        if logP < logPold 
           logP = logPold;
           warning('Error. The log-likelihood must go up!');
           break;
        end
        
     %Convergence for EM
      if (abs(logPold - logP)/(1+abs(logPold))) < err
             converged = true;
              theta = theta_;
              Pi = Pi_;
              break;
      end
      
     %M step
    theta= theta_;
    Pi = Pi_;
    logPold = logP;
    logliks(it) = logP;
    it = it + 1;
end

logliks(logliks ==0) = [];
loglik = max(logliks); 

save('logliks.mat','logliks'); %Plot logliks to see, if there is a monotonic increase


end

