function [X,B_list] = setup_OldDS()

DataDir = '/Users/sanjana/Documents/Datasets/2 Tapback (Active Control)/'; % Directory name
%Creating a list of directories for the subjects:
subjects=dir([DataDir]);
subjects(~[subjects.isdir]) = []; %Clean up
nSubs = numel (subjects); %Number of subjects
subList =cell(nSubs,1);
n_backs_list = cell(nSubs,1);
M_list = cell(nSubs,1);
R_list = cell(nSubs,1);
B_list = cell(nSubs,1);
X= linspace(1,9,36);
%Collecting data across all subjects
for k = 1:nSubs
    subject_name = subjects(k).name;
    disp(subject_name);
    if(subject_name ~= '.') %Check to ensure that hidden files are not open
        %Now open all the session files
        files = [dir([DataDir subject_name '/*.session']);dir([DataDir subject_name '/*.csv'])]; 
        [files]=filter_files(files);%Function to get rid of files with lower than 81 entries
        for i=1:numel(files) %For each fie name
            C = strsplit(files(i).name,{'session','-'},'CollapseDelimiters',true);
            tmp =str2double(cell2mat(C(2)));
            files(i).Session_Order =deal(tmp);
        end
        
        %Arranging the files in order of sessions:
        [blah, order] = sort([files(:).Session_Order],'ascend');
        files = files(order);
        if(isempty(files) == 0)
            subList{k} =files;
            [M,R,n_backs] = set_up2(subList{k});  %Getting the required values from all sessions
             n_backs_list{k} = n_backs;
             M_list{k} = M;
             R_list{k} = R;
             rho=1.6;
             c=0.0;
             d=1;
             [B] =  compute_emission_prob(M,R,n_backs,rho,c,d,X); 
             B_list{k} = B;
        end
    end
    
end
save('B_list.mat','B_list');
 save('subList.mat','subList');
    save('n_backs.mat','n_backs_list');
    save('M.mat','M_list');
    save('R.mat','R_list');
    save('X.mat','X');
end

