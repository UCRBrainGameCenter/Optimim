function [B,A_list] = computeA_B(M,R,n_backs,rho,c,d,X,n) 
n_X = size(X,2);
n_blocks = numel(n_backs); %The number of sessions for a subject
B = zeros(n_blocks,n_X);
A_list = cell(n_blocks,1);
for i=1:n_blocks
    A =full(gallery('tridiag',n_X, rand(1,n_X-1), rand(1,n_X), rand(1, n_X-1)));
    A_s = sum(A,2);
    for j=1:n_X
        A(j,:) = A(j,:)./A_s(j); %So that the rows sum up to 1
    end
    A_list{i} = A;
    
    n_back = n_backs(i); 
    r = R(i);
    m = M(i);
    %IRT model:
    q_plug = rho*(X- n_back);
    q= c + (d - c)./ ( 1.0 + exp(-q_plug)); 
    res = zeros(n_X,1);
    for j=1:n_X
        res(j) = control_fn(r,m,q(j),n);
    end
    B(i,:) =res;
end 

end
