%Function to read the session file and set up the values for y and n back

function [] = UKF_EM()

DataDir = '/home/csgrads/ssand024/Desktop/n-back/GameplayData/Conditions/2 Tapback (Active Control)/'; % Directory name
%Creating a list of directories for the subjects:
subjects=dir([DataDir]);
subjects(~[subjects.isdir]) = []; %Clean up
nSubs = numel (subjects); %Number of subjects
subList =cell(nSubs,1);
n_backs_list = cell(nSubs,1);
M_list = cell(nSubs,1);
R_list = cell(nSubs,1);
data_list = cell(nSubs,1);   
%Collecting data across all subjects
for k = 1:nSubs
    subject_name = subjects(k).name;
    disp(subject_name);
   if(subject_name ~= '.') %Check to ensure that hidden files are not open
        %Now open all the session files
        files = [dir([DataDir subject_name '/*.session']);dir([DataDir subject_name '/*.csv'])]; 
        [files]=filter_files(files);%Function to get rid of files with lower than 81 entries
        %Arranging the files in order of sessions: By introducing a new
        %field
        for i=1:numel(files) %For each fie name
            C = strsplit(files(i).name,{'session','-'},'CollapseDelimiters',true);
            tmp =str2double(cell2mat(C(2)));
            files(i).Session_Order =deal(tmp);
        end
        [blah, order] = sort([files(:).Session_Order],'ascend');
        files = files(order);
        if(isempty(files) == 0)
            subList{k} =files;
            [M,R,n_backs] = set_up_olddata(subList{k});  %Getting the required values from all sessions
             n_backs_list{k} = n_backs;
             M_list{k} = M;
             R_list{k} = R;
           data_list{k} = (R./M);
        end
    end
    
end
        
save('data_list.mat','data_list');
save('n_backs_list.mat','n_backs_list');
save('R_list.mat','R_list');
save('M_list.mat','M_list');

log_P = zeros(5,1);
A_m1_rr = cell(5,1);
B_m1_rr = cell(5,1);
Q_m1_rr = cell(5,1);
R_m1_rr = cell(5,1);
x0_1_rr = cell(5,1);
V0_1_rr = cell(5,1);

A_m2_rr = cell(5,1);
B_m2_rr = cell(5,1);
Q_m2_rr = cell(5,1);
R_m2_rr = cell(5,1);
x0_2_rr = cell(5,1);
V0_2_rr = cell(5,1);

LL = [];
A_m1_L=[];
B_m1_L=[]; 
Q_m1_L=[];
R_m1_L=[];
x0_1_L=[];
V0_1_L=[];
A_m2_L=[];
B_m2_L=[]; 
Q_m2_L=[];
R_m2_L=[];
x0_2_L=[];
V0_2_L=[];



dim=2
for i=1:10%Random Restarts to avoid getting stuck in local maxima
    [A_m1,A_m2, B_m1,B_m2, Q_m1,Q_m2, R_m1,R_m2,x0_1,x0_2, V0_1,V0_2, loglik] = learn_kalman_EM(data_list,n_backs_list,M_list,R_list,LL,A_m1_L,B_m1_L,Q_m1_L,R_m1_L,x0_1_L,V0_1_L,A_m2_L,B_m2_L,Q_m2_L,R_m2_L,x0_2_L,V0_2_L,dim);
    A_m1_rr{i} = A_m1;
    B_m1_rr{i} = B_m1;
    Q_m1_rr{i} = Q_m1;
    R_m1_rr{i} = R_m1;
    x0_1_rr{i} = x0_1;
    V0_1_rr{i} = V0_1;
    A_m2_rr{i} = A_m2;
    B_m2_rr{i} = B_m2;
    Q_m2_rr{i} = Q_m2;
    R_m2_rr{i} = R_m2;
    x0_2_rr{i} = x0_2;
    V0_2_rr{i} = V0_2;
    log_P(i) = loglik;
end
 
[loglik,idx] =max(log_P);
 
A_m1 = A_m1_rr{idx};
B_m1 = B_m1_rr{idx};
Q_m1 = Q_m1_rr{idx};
R_m1 = R_m1_rr{idx};

x0_2 = x0_2_rr{idx};
V0_2 = V0_2_rr{idx};
A_m2 = A_m2_rr{idx};
B_m2 = B_m2_rr{idx};
Q_m2 = Q_m2_rr{idx};
R_m2 = R_m2_rr{idx};

x0_2 = x0_2_rr{idx};
V0_2 = V0_2_rr{idx};
 save('log_P.mat','log_P');
 save('loglik.mat','loglik');
 save('A_m1.mat','A_m1');
 save('B_m1.mat','B_m1');
 save('Q_m1.mat','Q_m1');
 save('R_m1.mat','R_m1');
 save('x0_1.mat','x0_1');
 save('V0_1.mat','V0_1');
 save('A_m2.mat','A_m2');
 save('B_m2.mat','B_m2');
 save('Q_m2.mat','Q_m2');
 save('R_m2.mat','R_m2');
 save('x0_2.mat','x0_2');
 save('V0_2.mat','V0_2');
 save('subList.mat','subList');
end
