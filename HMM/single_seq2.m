function [theta,Pi_hat,logP,A_list] = single_seq2(Pi,B,theta,nback,accu)

T= size(B,1); %Length of the sequence
N= size(B,2);  %Number of states


nb_prev = zeros(T,1);
accu_prev = zeros(T,1);
Y = discretize(accu,10);
A_list = cell(T-1,1);
 for t=2:T
     accu_prev(t) = Y(t-1);
     nb_prev(t) = nback(t-1);
     A = populateA(theta,nb_prev(t),accu_prev(t));
     A_list{t-1} = A; 
 end

%Carry out the forward-backward procedure
[alpha,beta,scale,scale_beta] = alpha_beta_pass(A_list,Pi,B);

logf = log(alpha);
logb = log(beta);
logGE = log(B);
idx1=0;
idx2=0;
idx3=0;
Pi_hat =zeros(N,1); %Re-estimated Pi
for t=1:T-1
    A_t = A_list{t};
    nb_t = nb_prev(t);
   
    logGTR = log(A_t);
   for i=1:N
      for j=1:N
          if (i-j)>1 || (i-j)<-1 
              continue;
          end
           if i==j
              idx1 = 2;
           elseif j==i-1
              idx1 =1;
           elseif j==i+1
              idx1 =3;
           end
           idx2 = j-nb_t+12;
           idx3 = Y(t);
           
            addition = exp( logf(t,i) + logGTR(i,j) + logGE(t+1,j) + logb(t+1,j));
            theta(idx1,idx2,idx3) = theta(idx1,idx2,idx3)+addition;
      end
    end 
    theta= theta./sum(theta,1);
    theta(isnan(theta))=0;
    A_list{t} = populateA(theta,nb_t,Y(t)); 
end
%For Pi:
Pi_hat(:,1)=  exp( logf(1,:) + logb(1,:)); %Check??%P = sum(alpha(:,t).*beta(:,t))*scale*scale_beta;
Pi_hat = Pi_hat/sum(Pi_hat);

logP = - sum(log(scale));%log likelihood of the sequence

end



