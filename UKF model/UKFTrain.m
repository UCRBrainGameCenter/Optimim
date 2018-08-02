%Function to read the session file and set up the values for y and n back

function [] = UKFTrain(input)

if strcmp(input,'recollect') == 1
    [data_list,n_backs_list,R_list,M_list] = setup_newDS();
    maxState = 12;
else
    [data_list,n_backs_list,R_list,M_list] = setup_OldDS();
    maxState = 9;
end

log_P = zeros(5,1);
A_rr = cell(5,1);
B_rr = cell(5,1);
Q_rr = cell(5,1);
R_rr = cell(5,1);
x0_rr = cell(5,1);
V0_rr = cell(5,1);
LL = [];
A_L=[];
B_L=[]; 
Q_L=[];
R_L=[];
x0_L=[];
V0_L=[];

dim=2
for i=1:5%Random Restarts to avoid getting stuck in local maxima
    [A, B, Q, R,x0, V0, loglik] = learn_kalman(data_list,n_backs_list,M_list,R_list,maxState,LL,A_L,B_L,Q_L,R_L,x0_L,V0_L,dim);
    A_rr{i} = A;
    B_rr{i} = B;
    Q_rr{i} = Q;
    R_rr{i} = R;
    x0_rr{i} = x0;
    V0_rr{i} = V0;
    log_P(i) = loglik;
end
 
[loglik,idx] =max(log_P);
 
A = A_rr{idx};
B = B_rr{idx};
Q = Q_rr{idx};
R = R_rr{idx};

x0 = x0_rr{idx};
V0 = V0_rr{idx};
 save('log_P.mat','log_P');
 save('loglik.mat','loglik');
 save('A.mat','A');
 save('B.mat','B');
 save('Q.mat','Q');
 save('R.mat','R');
 save('x0.mat','x0');
 save('V0.mat','V0');
 
end