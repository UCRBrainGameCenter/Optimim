function [A,Pi,pi,cluster]=assignCluster(A1,A2,A3,A4,Pi1,Pi2,Pi3,Pi4,pi1,pi2,pi3,pi4,B)
%Compute likelihood for each cluster
log_P = zeros(4,1);
res= zeros(4,1);
frac=zeros(4,1);

Pi_ = cell(4,1);
A_ = cell(4,1);
pi_ = zeros(4,1);

A_{1}=A1;
A_{2}=A2;
A_{3}=A3;
A_{4}=A4;

Pi_{1} = Pi1;
Pi_{2} = Pi2;
Pi_{3} = Pi3;
Pi_{4} = Pi4;
pi_(1) = pi1;
pi_(2) = pi2;
pi_(3) = pi3;
pi_(4) = pi4;
sum=0;
for i=1:4
    [Pi_hat,numer,denom,log_P(i)] = single_seq(A_{i},Pi_{i},B);
    res(i) = log_P(i)+ log(pi_(i));
    sum = sum + res(i);
end
for i=1:4
    frac(i) = res(i)/sum;
end
%Get the model with dim=2;max likelihood
[r,idx] =max(frac);
A = A_{idx};
Pi = Pi_{idx};
pi = pi_(idx);
cluster = idx;
end

