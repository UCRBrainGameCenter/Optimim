%The EM algorithm applied to the kalman model for dual estimation
function [A_m1,A_m2, B_m1,B_m2, Q_m1,Q_m2, R_m1,R_m2,x0_1,x0_2, V0_1,V0_2, loglik] = learn_kalman_EM(data,n_backs,M_list,R_list,LL,A_m1_L,B_m1_L,Q_m1_L,R_m1_L,x0_1_L,V0_1_L,A_m2_L,B_m2_L,Q_m2_L,R_m2_L,x0_2_L,V0_2_L,dim)

N = length(data);


%Initializing A, C, Q,R,x0 and V0
A_m1 =rand(2,2);
B_m1= rand(2,3);
R_m1=[rand];
Q_m1= [rand,0;0,rand];%All covariance matrices are symmetric positive definite
pi_1=0.5

A_m2 =rand(2,2);
B_m2= rand(2,3);
R_m2=[rand];
Q_m2= [rand,0;0,rand];%All covariance matrices are symmetric positive definite
pi_2=0.5;

x0_1=[(9-1)*rand;(2-0)*rand];
V0_1 = [rand,0;0,rand];

x0_2=[(9-1)*rand;(2-0)*rand];
V0_2 = [rand,0;0,rand];

Tsum = 0;
for s = 1:N
  y = data{s};
  if isempty(y) ~= 0
      continue;
  end
  T =size(y,1);
  Tsum = Tsum + T;
end

loglik=0;
previous_loglik= -inf;
converged = 0;
iter = 1;

threshold = 1e-3;
max_iter =20;
while and(~converged,(iter <= max_iter)) 

  %%% E step
    Sum_xx_1 = zeros(dim, dim);
    Sum_xb_1 = zeros(dim, dim);
    Sum_bb_1 = zeros(dim, dim);
    Sum_yy_1 =  zeros(1, 1);
    Sum_yx_1 = zeros(dim,1);
    Sum_yu_1 =  zeros(1,3);
    Sum_xu1_1=  zeros(dim, 3);
    Sum_bu_1= zeros(dim, 3);
    Sum_uu1_1= zeros(3,3);
    Sum_uu2_1=zeros(3,3);
    Sum_xu2_1=zeros(dim,3);
    Sum_bx_1= zeros(dim, dim);
    Sum_xy_1 =zeros(1, dim);
    Sum_uy_1= zeros(3, 1);
    Sum_ux1_1= zeros(3, dim);
     Sum_ux2_1 = zeros(3, dim);
     Sum_yg_1 =zeros(1,1);
     Sum_yg2_1 = zeros(1,1);
    Sum_ub_1 = zeros(3, dim);


    Sum_xx_2 = zeros(dim, dim);
    Sum_xb_2 = zeros(dim, dim);
    Sum_bb_2 = zeros(dim, dim);
    Sum_yy_2 =  zeros(1, 1);
    Sum_yx_2 = zeros(dim,1);
    Sum_yu_2 =  zeros(1,3);
    Sum_xu1_2=  zeros(dim, 3);
    Sum_bu_2= zeros(dim, 3);
    Sum_uu1_2= zeros(3,3);
    Sum_uu2_2=zeros(3,3);
    Sum_xu2_2=zeros(dim,3);
    Sum_bx_2= zeros(dim, dim);
    Sum_xy_2 =zeros(1, dim);
    Sum_uy_2= zeros(3, 1);
    Sum_ux1_2= zeros(3, dim);
     Sum_ux2_2 = zeros(3, dim);
     Sum_yg_2 =zeros(1,1);
     Sum_yg2_2 = zeros(1,1);
    Sum_ub_2 = zeros(3, dim);
    Sum_q1= 0;
    Sum_q2=0;


      P1sum_1 = zeros(dim, dim);
      x1sum_1 = zeros(dim, 1);

    P1sum_2 = zeros(dim, dim);
    x1sum_2 = zeros(dim, 1);

      count=0;
      for s = 1:N %For each training sequence
        y = data{s};
        if isempty(y) ~= 0
          continue;
        end
        n_back = n_backs{s};
        n_back_prev= ones(size(n_back,1),1); %Since there is no 0 n-back, let us take n-back=1 
        n_back_fut = ones(size(n_back,1),1);
        y_prev= ones(size(y,1),1);%Default accuracy =1
        for i=1:size(n_back,1)
            if i==1
              n_back_fut(i) = n_back(i+1);
              continue;
            end
            n_back_prev(i) = n_back(i-1);
            y_prev(i) = y(i-1); %Previous y(t-1) + a constant =1
            if i == size(n_back,1)
               continue;
            end
            n_back_fut(i) = n_back(i+1);
        end

        u = [n_back,y_prev,repmat(1,size(n_back,1),1)];
        u=u';
        M= M_list{s};
        Rt=R_list{s};

        [S_xx,S_xb,S_bb,S_yy,S_yx,S_yu,S_xu1,S_bu,S_uu1,S_uu2,S_xu2,S_bx,S_xy,S_uy,S_ux1,S_ux2,S_ub,S_yg,S_yg2,x1_t,V1_t,lik_1] = Estep(A_m1,B_m1,u,Q_m1,R_m1,y,x0_1,V0_1,M,Rt,dim);
        [S_xx2,S_xb2,S_bb2,S_yy2,S_yx2,S_yu2,S_xu12,S_bu2,S_uu12,S_uu22,S_xu22,S_bx2,S_xy2,S_uy2,S_ux12,S_ux22,S_ub2,S_yg_2,S_yg22,x1_t2,V1_t2,lik_2] = Estep(A_m2,B_m2,u,Q_m2,R_m2,y,x0_2,V0_2,M,Rt,dim);
        %Calculate q_1: weight of model A: P(c=A/Y) = likelihood*prior
        q_1 = lik_1*pi_1;
         %Calculate q_2: weight of model B: P(c=B/Y)
        q_2 = lik_2*pi_2;
        
        q_1 = q_1/(q_1+q_2);
        q_2 = q_2/(q_1+q_2);
        


        Sum_xx_1 = Sum_xx_1 + q_1*S_xx;
        Sum_xb_1 = Sum_xb_1 + q_1*S_xb;
        Sum_bb_1 = Sum_bb_1 +  q_1*S_bb;
        Sum_yy_1 = Sum_yy_1 +  q_1*S_yy;
        Sum_yx_1 = Sum_yx_1 +  q_1*S_yx;
        Sum_yu_1 = Sum_yu_1 +  q_1*S_yu;
        Sum_xu1_1 = Sum_xu1_1 +  q_1*S_xu1;
        Sum_bu_1 = Sum_bu_1 +  q_1*S_bu;
        Sum_uu1_1 = Sum_uu1_1 +  q_1*S_uu1;
        Sum_uu2_1 = Sum_uu2_1 +  q_1*S_uu2;
        Sum_xu2_1 = Sum_xu2_1 +  q_1*S_xu2;
        Sum_bx_1 = Sum_bx_1 +  q_1*S_bx;
        Sum_xy_1 = Sum_xy_1 +  q_1*S_xy;
        Sum_uy_1 = Sum_uy_1 +  q_1*S_uy;
        Sum_ux1_1 = Sum_ux1_1 +  q_1*S_ux1;
        Sum_ux2_1 = Sum_ux2_1 +  q_1*S_ux2;
        Sum_ub_1 = Sum_ub_1 +  q_1*S_ub;
        Sum_yg_1 = Sum_yg_1 +  q_1*S_yg;
        Sum_yg2_1 = Sum_yg2_1 +  q_1*S_yg2;
        P1sum_1 = P1sum_1 +  q_1*(V1_t + x1_t*x1_t');
        x1sum_1 = x1sum_1 +  q_1*x1_t;
       
        

        Sum_xx_2 = Sum_xx_2 +  q_2*S_xx2;
        Sum_xb_2 = Sum_xb_2 + q_2*S_xb2;
        Sum_bb_2 = Sum_bb_2 + q_2*S_bb2;
        Sum_yy_2 = Sum_yy_2 + q_2*S_yy2;
        Sum_yx_2 = Sum_yx_2 + q_2*S_yx2;
        Sum_yu_2 = Sum_yu_2 + q_2*S_yu2;
        Sum_xu1_2 = Sum_xu1_2 + q_2*S_xu12;
        Sum_bu_2 = Sum_bu_2 + q_2*S_bu2;
        Sum_uu1_2 = Sum_uu1_2 + q_2*S_uu12;
        Sum_uu2_2 = Sum_uu2_2 + q_2*S_uu22;
        Sum_xu2_2 = Sum_xu2_2 + q_2*S_xu22;
        Sum_bx_2 = Sum_bx_2 + q_2*S_bx2;
        Sum_xy_2 = Sum_xy_2 + q_2*S_xy2;
        Sum_uy_2 = Sum_uy_2 + q_2*S_uy2;
        Sum_ux1_2 = Sum_ux1_2 + q_2*S_ux12;
        Sum_ux2_2 = Sum_ux2_2 + q_2*S_ux22;
        Sum_ub_2 = Sum_ub_2 + q_2*S_ub2;
        Sum_yg_2 = Sum_yg_2 + q_2*S_yg_2;
        Sum_yg2_2 = Sum_yg2_2 + q_2*S_yg22;
        P1sum_2 = P1sum_2 + q_2*(V1_t2 + x1_t2*x1_t2');
        x1sum_2 = x1sum_2 + q_2*x1_t2;
        
        Sum_q1=Sum_q1+q_1;
        Sum_q2=Sum_q2+q_2;
        loglik = loglik + log(pi_1*lik_1+pi_2*lik_2);
        count=count+1;

      end
     %%% M step

      Tsum1 = Tsum - count;

          M = [Sum_xb_1 Sum_xu1_1] /([Sum_bb_1,Sum_bu_1;Sum_ub_1,Sum_uu1_1]);
          A_m1 = M(:,1:2);
          B_m1= M(:,3:5);
          Q_m1= (Sum_xx_1 - Sum_xb_1*A_m1' - A_m1*Sum_bx_1 - Sum_xu1_1*B_m1' - B_m1*Sum_ux1_1 + A_m1*Sum_bu_1*B_m1' + B_m1*Sum_ub_1*A_m1' + A_m1*Sum_bb_1*A_m1' + B_m1*Sum_uu1_1*B_m1') / Tsum1;
          R_m1 = (Sum_yy_1 - Sum_yg_1 - (Sum_yg_1)' + Sum_yg2_1)/ Tsum;
          x0_1 = x1sum_1 / count;
          V0_1 = P1sum_1/count - x0_1*x0_1';
          pi_1= Sum_q1/count;

           M = [Sum_xb_2 Sum_xu1_2] /([Sum_bb_2,Sum_bu_2;Sum_ub_2,Sum_uu1_2]);
          A_m2 = M(:,1:2);
          B_m2= M(:,3:5);
          Q_m2= (Sum_xx_2 - Sum_xb_2*A_m2' - A_m2*Sum_bx_2 - Sum_xu1_2*B_m2' - B_m2*Sum_ux1_2 + A_m2*Sum_bu_2*B_m2' + B_m2*Sum_ub_2*A_m2' + A_m2*Sum_bb_2*A_m2' + B_m2*Sum_uu1_2*B_m2') / Tsum1;
          R_m2 = (Sum_yy_2 - Sum_yg_2 - (Sum_yg_2)' + Sum_yg2_2)/ Tsum;
          x0_2 = x1sum_2 / count;
          V0_2 = P1sum_2/count - x0_2*x0_2';
          pi_2= Sum_q2/count;



      save('LL.mat','LL');
      iter = iter + 1;
        LL = [LL loglik];
      A_m1_L = [A_m1_L A_m1];
      B_m1_L = [B_m1_L B_m1];
      Q_m1_L = [Q_m1_L Q_m1];
      R_m1_L = [R_m1_L R_m1];
      x0_1_L =[x0_1_L x0_1];
      V0_1_L =[V0_1_L V0_1];
      A_m2_L = [A_m2_L A_m2];
      B_m2_L = [B_m2_L B_m2];
      Q_m2_L = [Q_m2_L Q_m2];
      R_m2_L = [R_m2_L R_m2];
      x0_2_L =[x0_2_L x0_2];
      V0_2_L =[V0_2_L V0_2];
     
     % We have converged if the slope of the log-likelihood function falls below 'threshold'
    %log likelihood should increase
    if loglik - previous_loglik == 0
        previous_loglik = loglik;
        continue;
    end
    if loglik - previous_loglik < -1e-3 % allow for a little imprecision
     fprintf(1, '******likelihood decreased from %6.4f to %6.4f!\n', previous_loglik,loglik);
    end
    delta_loglik = abs(loglik - previous_loglik);
    avg_loglik = (abs(loglik) + abs(previous_loglik) + eps)/2;
    if (delta_loglik / avg_loglik) < threshold
     converged = 1;
     plot(LL);
    else 
    converged = 0; 
    plot(LL);
    end 
      previous_loglik = loglik;
end

end

