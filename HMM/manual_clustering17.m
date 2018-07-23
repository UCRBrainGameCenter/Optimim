function [] = manual_clustering17()
load('Accuracy_clean.mat');
sz = size(subjectInfo_clean{1,1});
filename ='/home/csgrads/ssand024/Desktop/HMM_on_new_data/Subject inclusion criteria.xlsx'
[numbers, TEXT, everything]= xlsread(filename,6);
cluster_assign = horzcat(TEXT(2:end,1),num2cell(numbers(:,2)));
c1_idx17=[];
c2_idx17=[];
c3_idx17=[];

for i=1:sz[1]
    [x,y]= find(strcmp(cluster_assign,subjectInfo_clean{1,1}{i,1}));
    if isempty(x) == 1
        continue;
    end
    if(cluster_assign{x,2} == 1)
        c1_idx17= [c1_idx17,i];
    elseif(cluster_assign{x,2} == 2) 
        c2_idx17 =[c2_idx17,i];
    else
        c3_idx17 =[c3_idx17,i];
    end
end
save('c3_idx17.mat','c3_idx17');
save('c2_idx17.mat','c2_idx17');
save('c1_idx17.mat','c1_idx17');
end

