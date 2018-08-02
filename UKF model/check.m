function [x0,V0] = check(A,B,Q,R)

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
x0_rr = cell(5,1);
V0_rr = cell(5,1);

for i=1:5 %Random Restarts to avoid getting stuck in local maxima
    [x0, V0] = check2(A,B,Q,R,data_list,n_backs_list,M_list,R_list);
    x0_rr{i} = x0;
    V0_rr{i} = V0;
    log_P(i) = loglik;
end
 
[loglik,idx] =max(log_P);
 
x0 = x0_rr{idx};
V0 = V0_rr{idx};
 save('x0.mat','x0');
 save('V0.mat','V0');

end

