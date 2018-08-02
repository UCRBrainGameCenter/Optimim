function [alpha,beta,scale,scale_beta] = alpha_beta_pass(A,Pi,B)
%Compute alpha and the scale
N= size(B,2);
T= size(B,1);

alpha = zeros(T,N);
beta = ones(T,N);


scale = zeros(1,T); %Scaling
scale_beta = zeros(1,T);

alpha(1,:) = Pi(1,:).*B(1,:);  %alpha at t=1
scale(1) = 1 ./ sum(alpha(1, :));
alpha(1,:) = alpha(1, :) * scale(1);

for t = 2:T
    alpha(t,:) = (alpha(t-1,:) * A) .* B(t, :);
    if sum(alpha(t,:)) == 0
        scale(t) = 0;
        alpha(t, :) = 0;
    else
        scale(t) = 1 ./ sum(alpha(t, :));
        alpha(t, :) = alpha(t, :) * scale(t);
    end
end

scale_beta(T) = 1 ./ sum(beta(T,:));
beta(T,:) = beta(T, :) * scale_beta(T);

B= B';
for t = (T-1):-1:1
    beta(t,:) = A * (B(:,t+1) .* beta(t+1,:)');
    scale_beta(t) = 1 ./ sum(beta(t, :));
    beta(t, :) = beta(t, :) * scale_beta(t);
end

end
