function [A1,Pi1,A2,Pi2,A3,Pi3,A4,Pi4,logP,pi1,pi2,pi3,pi4,it_value] = baum_welch_cont_EM(X,B_list)
%Step 1: Initializing the matrices
N= size(X,2);
err = 1e-6;

maxIters = 20; %Maximum number of re-estimation iterationslogP
it = 1;
%{
A1 =full(gallery('tridiag',N, rand(1,N-1), rand(1,N), rand(1, N-1)));
A1_s = sum(A1,2);

for i=1:N
    A1(i,:) = A1(i,:)./A1_s(i); %So that the rows sum up to 1
end

Pi1 = rand(N,1); % Pi ~ 1/N
Pi1= Pi1./sum(Pi1);

A2 =full(gallery('tridiag',N, rand(1,N-1), rand(1,N), rand(1, N-1)));
A2_s = sum(A2,2);

for i=1:N
    A2(i,:) = A2(i,:)./A2_s(i); %So that the rows sum up to 1
end

Pi2 = rand(N,1); % Pi ~ 1/N
Pi2= Pi2./sum(Pi2);


A3 =full(gallery('tridiag',N, rand(1,N-1), rand(1,N), rand(1, N-1)));
A3_s = sum(A3,2);

for i=1:N
    A3(i,:) = A3(i,:)./A3_s(i); %So that the rows sum up to 1
end

Pi3 = rand(N,1); % Pi ~ 1/N
Pi3= Pi3./sum(Pi3);

A4 =full(gallery('tridiag',N, rand(1,N-1), rand(1,N), rand(1, N-1)));
A4_s = sum(A4,2);

for i=1:N
    A4(i,:) = A4(i,:)./A4_s(i); %So that the rows sum up to 1
end

Pi4 = rand(N,1); % Pi ~ 1/N
Pi4= Pi4./sum(Pi4);
%}

%Initializing A and Pi -- Making sure that elements are non uniform
%A1 = 1/N*rand(N,N); % A ~ 1/N

[A1,Pi1]=pre_train(X,B_list(5));
[A2,Pi2]=pre_train(X,B_list(11));
[A3,Pi3]=pre_train(X,B_list(21));
[A4,Pi4]=pre_train(X,B_list(26));


%[A1,Pi1,A2,Pi2,A3,Pi3,A4,Pi4] = set_parameters();

logliks = zeros(maxIters,1);
pi1=1/4;
pi2=1/4;
pi3=1/4;
pi4=1/4;
logPold = -Inf;
%Estmate:
%[A,Pi,logP] = reestimate_A(A,Pi,B_list); %Here logP  is the log-likelihood
converged = 0;
for it =1: maxIters
        [A1_,Pi1_,A2_,Pi2_,A3_,Pi3_,A4_,Pi4_,logP,pi_1,pi_2,pi_3,pi_4] = reestimate_A_EM(A1,Pi1,A2,Pi2,A3,Pi3,A4,Pi4,B_list,pi1,pi2,pi3,pi4); %Re-estimate the model
        
        if logP < logPold 
           logP = logPold;
           warning('Error. The log-likelihood must go up!');
           break;
        end
        
     
      if (abs(logPold - logP)/(1+abs(logPold))) < err
         % if norm(A_ - A,inf)/N < err
             converged = 1;
              A1 = A1_;
              Pi1 = Pi1_;
              A2 = A2_;
              Pi2 = Pi2_;
              A3 = A3_;
              Pi3 = Pi3_;
              A4 = A4_;
              Pi4 = Pi4_;
              pi1=pi_1;
              pi2=pi_2;
              pi3=pi_3;
              pi4=pi_4;
              plot(linspace(1,it,it),logliks(1:it,1));
              xlabel('Number of Iterations');
              ylabel('log-likelihood');
              it_value =it;
              break;
         % end
     end
       A1 = A1_;
       Pi1 = Pi1_;
       A2 = A2_;
       Pi2 = Pi2_;
       A3 = A3_;
       Pi3 = Pi3_;
       A4 = A4_;
       Pi4 = Pi4_;
        pi1=pi_1;
        pi2=pi_2;
        pi3=pi_3;
        pi4=pi_4;
      logPold = logP;
    logliks(it) = logP;
    it = it + 1;
end
if converged == 0
    plot(linspace(1,maxIters,maxIters),logliks);
    it_value =maxIters;
    xlabel('Number of Iterations');
    ylabel('log-likelihood');
end
logliks(logliks ==0) = [];
loglik = max(logliks);

save('logliks.mat','logliks');
save('loglik.mat','loglik');

end

