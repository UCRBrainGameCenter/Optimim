function [B] = compute_emission_prob(M,R,n_backs,rho,c,d,X) 
%Control input: z=  n_back
%Latent variable : x 
%Sequence of observations: y=r (Number got right)
%time: t-- per block
n_X = size(X,2);
n_blocks = numel(n_backs); %The number of sessions for a subject
B = zeros(n_blocks,n_X);

for i=1:n_blocks
    %Applying item response theory:
    n_back = n_backs(i); 
    r = R(i);
    m = M(i);
    %IRT model:
    q_plug = rho*(X- n_back);
    q= c + (d - c)./ ( 1.0 + exp(-q_plug)); 
     pos_q = q.^r; 
    neg_q =(1-q).^(m-r);
    B(i,:) =nchoosek(m,r).*pos_q .*neg_q; %Warning Generated:Result may not be exact. Coefficient is greater than 9.007199e+15 and is only accurate to 15 digits    
end 

end
