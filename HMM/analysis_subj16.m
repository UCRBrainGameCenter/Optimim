%Analysis of cluster 

function [maxnb] = analysis_subj16(Nlevel_s1_clean,Nlevel_s2_clean,subjectInfo_clean,cluster_list,nbacks,nTrials)

sz = size(Nlevel_s1_clean);

group1 = [];

group2= [];

group3 = [];

group4 =[];

%To get the max n-back reached by a subject per session

maxnb_S1 = zeros(sz(2),sz(3));

maxnb_S2 = zeros(sz(2),sz(3));

maxnb = zeros(sz(2),sz(3));



maxnb_gp1 =[];

maxnb_gp2 =[];

maxnb_gp3 =[];

maxnb_gp4 =[];



algo_gp1 ={};

algo_gp2 ={};

algo_gp3 ={};

algo_gp4 ={};



sub_gp1={};

sub_gp2={};

sub_gp3={};

sub_gp4={};



maxnbReached_gp1=[];

maxnbReached_gp2=[];

maxnbReached_gp3=[];

maxnbReached_gp4=[];



tnb1 ={};

tnb2 ={};

tnb3 ={};

tnb4 ={};



tnt1 ={};

tnt2 ={};

tnt3 ={};

tnt4 ={};





for i=1:sz(3)



    for j = 1:11

        maxnb_S1(j,i) = max(Nlevel_s1_clean(:,j,i));

        maxnb_S2(j,i) = max(Nlevel_s2_clean(:,j,i));

        if maxnb_S2(j,i) > maxnb_S1(j,i)

            maxnb(j,i) = maxnb_S2(j,i);

        else

            maxnb(j,i) = maxnb_S1(j,i);

        end

    end



    if cluster_list(i) == 1

        group1 = [group1,i];

        tnb1=[tnb1;nbacks(i)];

        tnt1=[tnt1;nTrials(i)];

        sub_gp1 =[sub_gp1;cell2mat(subjectInfo_clean(i,1))];

        maxnb_gp1 = [maxnb_gp1,maxnb(:,i)];

        algo_gp1 =[algo_gp1;cell2mat(subjectInfo_clean(i,2))];

        maxnbReached_gp1 = [maxnbReached_gp1;max(maxnb(:,i))];

        %tnb1 = [tnb1;nb];

    end

    if cluster_list(i) == 2

        group2 = [group2,i];

        tnb2=[tnb2;nbacks(i)];

        tnt2=[tnt2;nTrials(i)];

        sub_gp2 =[sub_gp2;cell2mat(subjectInfo_clean(i,1))];

        	maxnb_gp2 = [maxnb_gp2,maxnb(:,i)];

        algo_gp2 =[algo_gp2;cell2mat(subjectInfo_clean(i,2))];

        maxnbReached_gp2 = [maxnbReached_gp2;max(maxnb(:,i))];

        %tnb2 = [tnb2;nb];

    end

    if cluster_list(i) == 3

        group3 = [group3,i];

        tnb3=[tnb3;nbacks(i)];

        tnt3=[tnt3;nTrials(i)];

        sub_gp3 =[sub_gp3;cell2mat(subjectInfo_clean(i,1))];

        algo_gp3 =[algo_gp3;cell2mat(subjectInfo_clean(i,2))];

        maxnb_gp3 = [maxnb_gp3,maxnb(:,i)];

        maxnbReached_gp3 = [maxnbReached_gp3;max(maxnb(:,i))];

        %tnb3 = [tnb3;nb];

    end

    if cluster_list(i) == 4

        group4 = [group4,i];

        tnb4=[tnb4;nbacks(i)];

        tnt4=[tnt4;nTrials(i)];

        sub_gp4 =[sub_gp4;cell2mat(subjectInfo_clean(i,1))];

        algo_gp4 =[algo_gp4;cell2mat(subjectInfo_clean(i,2))];

        maxnb_gp4 = [maxnb_gp4,maxnb(:,i)];

        maxnbReached_gp4 = [maxnbReached_gp4;max(maxnb(:,i))];

       %tnb4 = [tnb4;nb];

    end

end

mode_maxnb1=zeros(12,1);

mode_maxnb2=zeros(12,1);

for i=1:12

    mode_maxnb1(i)=sum(maxnbReached_gp1 == i);

    mode_maxnb2(i)=sum(maxnbReached_gp2 == i);

end

figure;

hist(maxnb_gp1');

title('Cluster 1: maximum n-back reached per-day','FontSize', 25);

lgnd=legend({'day 1','day 2','day 3','day 4','day 5','day 6','day 7','day 8','day 9','day 10','day 11'});

lgnd.FontSize = 18;

xlabel('max n-back played','FontSize', 20);

ylabel('Number of subjects','FontSize', 20);



    figure;

    hist(maxnb_gp2');

    title('Cluster 2: maximum n-back reached per-day','FontSize', 25);

    lgnd =legend({'day 1','day 2','day 3','day 4','day 5','day 6','day 7','day 8','day 9','day 10','day 11'});

    lgnd.FontSize = 18;

    xlabel('max n-back played','FontSize', 20);

    ylabel('Number of subjects','FontSize', 20);



sz1 = size(group1);

sz2 = size(group2);

sz3 = size(group3);

sz4 = size(group4);

nalgo_gp1 =[];

nalgo_gp2 =[];

nalgo_gp3 =[];

nalgo_gp4 =[];



for i=1:sz1(2)

    if strcmp(algo_gp1(i),'StaircaseDifficult') == 1

        nalgo_gp1 = [nalgo_gp1;1];

    elseif strcmp(algo_gp1(i),'MiniBlockModerate') == 1

        nalgo_gp1 = [nalgo_gp1;2];

    elseif strcmp(algo_gp1(i),'MiniBlockDifficult') == 1

        nalgo_gp1 = [nalgo_gp1;3];

    elseif strcmp(algo_gp1(i),'MiniBlockReset') == 1

        nalgo_gp1 = [nalgo_gp1;4];

    elseif strcmp(algo_gp1(i),'MiniBlockDifficult') == 1

        nalgo_gp1 = [nalgo_gp1;5];

    elseif strcmp(algo_gp1(i),'StaircaseModerate') == 1

        nalgo_gp1 = [nalgo_gp1;6];

    elseif strcmp(algo_gp1(i),'Accuracy') == 1

        nalgo_gp1 = [nalgo_gp1;7];

    end
end


