function [A1_,Pi1_,A2_,Pi2_,A3_,Pi3_,A4_,Pi4_,loglik,pi_1,pi_2,pi_3,pi_4] = reestimate_A_EM(A1,Pi1,A2,Pi2,A3,Pi3,A4,Pi4,B_list,pi_1,pi_2,pi_3,pi_4)
A1_ = zeros(size(A1));
A2_ = zeros(size(A2));
A3_ = zeros(size(A3));
A4_ = zeros(size(A4));


N = size(A1,1);
K= numel(B_list);

    %Call the function to calculate the values of numer, denom and
    %likelihood for training sequence k
Sum_q4= 0;
Sum_q3=0;
Sum_q2= 0;
Sum_q1=0;
sum_numer1 = zeros(N,N);
sum_denom1 = zeros(N,1);
sum_Pi_hat1 = zeros(N,1);

sum_numer2 = zeros(N,N);
sum_denom2 = zeros(N,1);
sum_Pi_hat2 = zeros(N,1);

sum_numer3 = zeros(N,N);
sum_denom3 = zeros(N,1);
sum_Pi_hat3 = zeros(N,1);

sum_numer4 = zeros(N,N);
sum_denom4 = zeros(N,1);
sum_Pi_hat4 = zeros(N,1);
loglik = 0;
P_list = cell(K,1);
       for k=1:K
             B= B_list{k};
            if (isempty(B) == 1)
                continue;
            end
            [Pi_hat1,numer1,denom1,logP1] =single_seq(A1,Pi1,B);%For each model
            [Pi_hat2,numer2,denom2,logP2] =single_seq(A2,Pi2,B);
            [Pi_hat3,numer3,denom3,logP3] =single_seq(A3,Pi3,B);
            [Pi_hat4,numer4,denom4,logP4] =single_seq(A4,Pi4,B);

            q_1_old = exp(logP1*2^-10)*(pi_1);%To make sure that the values don't fall below 0, multiply with 2*10^-10
            q_2_old = exp(logP2*2^-10)*(pi_2);
            q_3_old = exp(logP3*2^-10)*(pi_3);
             q_4_old = exp(logP4*2^-10)*(pi_4);
            
            
             q_1 = q_1_old/(q_1_old+q_2_old+q_3_old+q_4_old);
             q_2 = q_2_old/(q_1_old+q_2_old+q_3_old+q_4_old);
            q_3 = q_3_old/(q_1_old+q_2_old+q_3_old+q_4_old);
            q_4 = q_4_old/(q_1_old+q_2_old+q_3_old+q_4_old);
           
           
              if q_1< 0.001
                diff = (q_2 + q_3 + q_4)-0.999;
                 q_2= q_2 - (diff/3);
                 q_3= q_3 -(diff/3);
                 q_4= q_4 - (diff/3);
                 q_1=0.001;
            end
             if q_2< 0.001
                 diff = (q_1 + q_3 + q_4)-0.999;
                 q_1= q_1 - (diff/3);
                 q_3= q_3 - (diff/3);
                 q_4= q_4 - (diff/3);
                 q_2=0.001;
             end
             if q_3< 0.001
                diff = (q_1 + q_2 + q_4)-0.999;
                 q_1= q_1 - (diff/3);
                 q_4= q_4 - (diff/3);
                 q_2 = q_2 - (diff/3);
                 q_3=0.001;
            end
             if q_4< 0.001
                diff = (q_1 + q_3 + q_2)-0.999;
                 q_1= q_1 - (diff/3);
                 q_3= q_3 - (diff/3);
                 q_2= q_2 - (diff/3);
                 q_4=0.001;
             end
             if q_1+q_2+q_3+q_4 ~= 1
                warning('Error.they must sum to 1!');
             end
              if q_1_old== 0 && q_2_old== 0 && q_3_old== 0 && q_4_old== 0
                q_1=0;
                q_2=0;
                q_3=0;
                q_4=0;
             end
            sum_numer1 = sum_numer1 + numer1*q_1; %Here
            sum_numer2 = sum_numer2 + numer2*q_2;
            sum_numer3 = sum_numer3 + numer3*q_3;
            sum_numer4 = sum_numer4 + numer4*q_4;
            if abs(sum(sum(numer1)) - (length(B)-1)) > 1e-10
                warning('Incorrect sum');
            end
            if abs(sum(sum(numer2)) - (length(B)-1)) > 1e-10
                warning('Incorrect sum');
            end
            if abs(sum(sum(numer3)) - (length(B)-1)) > 1e-10
                warning('Incorrect sum');
            end
            if abs(sum(sum(numer4)) - (length(B)-1)) > 1e-10
                warning('Incorrect sum');
            end
            sum_Pi_hat1 = sum_Pi_hat1 + Pi_hat1*q_1;%here
            sum_Pi_hat2 = sum_Pi_hat2 + Pi_hat2*q_2;
            sum_Pi_hat3 = sum_Pi_hat3 + Pi_hat3*q_3;
            sum_Pi_hat4 = sum_Pi_hat4 + Pi_hat4*q_4;
            %lik = lik + exp(logP);%Calculate total likelihood of data:/exp(logP)
            Sum_q1=Sum_q1+q_1;
            Sum_q2=Sum_q2+q_2;
            Sum_q3=Sum_q3+q_3;
            Sum_q4=Sum_q4+q_4;
             loglik = loglik + log(pi_1*exp(logP1)+pi_2*exp(logP2)+pi_3*exp(logP3)+pi_4*exp(logP4));
             
       end

 Pi1_ = sum_Pi_hat1./sum(sum_Pi_hat1);
 pi_1= Sum_q1/(Sum_q2+Sum_q1+Sum_q3+Sum_q4);

  x1=0;y1=0;z1=0;
     for i=2:N-1 %Parameter Sharing
       x1= x1 + sum_numer1(i,i-1);
       y1= y1 + sum_numer1(i,i);
       z1= z1 + sum_numer1(i,i+1);
     end
 
     for i=2:N-1
        sum_numer1(i,i-1) = x1;
        sum_numer1(i,i) = y1;
        sum_numer1(i,i+1) = z1;
     end
   % A_s = sum(sum_numer,2);
   % for i=1:N
    %    A_(i,:) = sum_numer(i,:)./sum_denom(i);
    %end
    totalTransitions = sum(sum_numer1,2);

    A1_ = sum_numer1./(repmat(totalTransitions,1,N));
    
     Pi2_ = sum_Pi_hat2./sum(sum_Pi_hat2);
 pi_2= Sum_q2/(Sum_q2+Sum_q1+Sum_q3+Sum_q4);

  x1=0;y1=0;z1=0;
     for i=2:N-1 %Parameter Sharing
       x1= x1 + sum_numer2(i,i-1);
       y1= y1 + sum_numer2(i,i);
       z1= z1 + sum_numer2(i,i+1);
     end
 
     for i=2:N-1
        sum_numer2(i,i-1) = x1;
        sum_numer2(i,i) = y1;
        sum_numer2(i,i+1) = z1;
     end
   % A_s = sum(sum_numer,2);
   % for i=1:N
    %    A_(i,:) = sum_numer(i,:)./sum_denom(i);
    %end
    totalTransitions = sum(sum_numer2,2);

    A2_ = sum_numer2./(repmat(totalTransitions,1,N));
    
     Pi3_ = sum_Pi_hat3./sum(sum_Pi_hat3);
 pi_3= Sum_q3/(Sum_q2+Sum_q1+Sum_q3+Sum_q4);

  x1=0;y1=0;z1=0;
     for i=2:N-1 %Parameter Sharing
       x1= x1 + sum_numer3(i,i-1);
       y1= y1 + sum_numer3(i,i);
       z1= z1 + sum_numer3(i,i+1);
     end
 
     for i=2:N-1
        sum_numer3(i,i-1) = x1;
        sum_numer3(i,i) = y1;
        sum_numer3(i,i+1) = z1;
     end
   % A_s = sum(sum_numer,2);
   % for i=1:N
    %    A_(i,:) = sum_numer(i,:)./sum_denom(i);
    %end
    totalTransitions = sum(sum_numer3,2);

    A3_ = sum_numer3./(repmat(totalTransitions,1,N));
    
Pi4_ = sum_Pi_hat4./sum(sum_Pi_hat4);
 pi_4= Sum_q4/(Sum_q2+Sum_q1+Sum_q3+Sum_q4);

  x1=0;y1=0;z1=0;
     for i=2:N-1 %Parameter Sharing
       x1= x1 + sum_numer4(i,i-1);
       y1= y1 + sum_numer4(i,i);
       z1= z1 + sum_numer4(i,i+1);
     end
 
     for i=2:N-1
        sum_numer4(i,i-1) = x1;
        sum_numer4(i,i) = y1;
        sum_numer4(i,i+1) = z1;
     end
   % A_s = sum(sum_numer,2);
   % for i=1:N
    %    A_(i,:) = sum_numer(i,:)./sum_denom(i);
    %end
    totalTransitions = sum(sum_numer4,2);

    A4_ = sum_numer4./(repmat(totalTransitions,1,N));

end



