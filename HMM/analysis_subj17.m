%Analysis of cluster - 2017

function [maxnb] = analysis_subj17(Nlevel_clean,cluster_list,nbacks,nTrials)

sz = size(Nlevel_clean);

group1 = [];

group2= [];

group3 = [];

group4 =[];



maxnb = zeros(sz(2),sz(3));



maxnb_gp1 =[];

maxnb_gp2 =[];

maxnb_gp3 =[];

maxnb_gp4 =[];





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

        maxnb(j,i) = max(Nlevel_clean(:,j,i));

    end



    if cluster_list(i) == 1

        group1 = [group1,i];

        tnb1=[tnb1;nbacks(i)];

        tnt1=[tnt1;nTrials(i)];

        maxnb_gp1 = [maxnb_gp1,maxnb(:,i)];

        maxnbReached_gp1 = [maxnbReached_gp1;max(maxnb(:,i))];

        %tnb1 = [tnb1;nb];

    end

    if cluster_list(i) == 2

        group2 = [group2,i];

        tnb2=[tnb2;nbacks(i)];

        tnt2=[tnt2;nTrials(i)];

        maxnb_gp2 = [maxnb_gp2,maxnb(:,i)];

        maxnbReached_gp2 = [maxnbReached_gp2;max(maxnb(:,i))];

        %tnb2 = [tnb2;nb];

    end

    if cluster_list(i) == 3

        group3 = [group3,i];

        tnb3=[tnb3;nbacks(i)];

        tnt3=[tnt3;nTrials(i)];

        maxnb_gp3 = [maxnb_gp3,maxnb(:,i)];

        maxnbReached_gp3 = [maxnbReached_gp3;max(maxnb(:,i))];

        %tnb3 = [tnb3;nb];

    end

    if cluster_list(i) == 4

        group4 = [group4,i];

        tnb4=[tnb4;nbacks(i)];

        tnt4=[tnt4;nTrials(i)];

        maxnb_gp4 = [maxnb_gp4,maxnb(:,i)];

        maxnbReached_gp4 = [maxnbReached_gp4;max(maxnb(:,i))];

       %tnb4 = [tnb4;nb];

    end

end

mode_maxnb2=zeros(12,1);

mode_maxnb4=zeros(12,1);

for i=1:12

    mode_maxnb2(i)=sum(maxnbReached_gp2 == i);

    mode_maxnb4(i)=sum(maxnbReached_gp4 == i);

end

figure;

hist(maxnb_gp2');

title('Cluster 1: maximum n-back reached per-day','FontSize', 25);

lgnd=legend({'day 1','day 2','day 3','day 4','day 5','day 6','day 7','day 8','day 9','day 10','day 11'});

lgnd.FontSize = 18;

xlabel('max n-back played','FontSize', 20);

ylabel('Number of subjects','FontSize', 20);



    figure;

    hist(maxnb_gp4');

    title('Cluster 2: maximum n-back reached per-day','FontSize', 25);

    lgnd =legend({'day 1','day 2','day 3','day 4','day 5','day 6','day 7','day 8','day 9','day 10','day 11'});

    lgnd.FontSize = 18;

    xlabel('max n-back played','FontSize', 20);

    ylabel('Number of subjects','FontSize', 20);



sz1 = size(group1);

sz2 = size(group2);

sz3 = size(group3);

sz4 = size(group4);





nbRate1 = zeros(12,sz1(2));

nbRate2 = zeros(12,sz2(2));

nbRate3 = zeros(12,sz3(2));

nbRate4 = zeros(12,sz4(2));

for i=1:sz1(2)

    trialSub=cell2mat(tnt1(i));

    nbackSub = cell2mat(tnb1(i));

    szk = size(nbackSub);

    for j=2:szk(1)

        if nbackSub(j) - nbackSub(j-1) == 1

          nbRate1(nbackSub(j-1),i)  = trialSub(nbackSub(j));

        end

    end

end



for i=1:sz2(2)

    trialSub=cell2mat(tnt2(i));

    nbackSub = cell2mat(tnb2(i));

    szk = size(nbackSub);

    for j=2:szk(1)

        if nbackSub(j) - nbackSub(j-1) == 1

          nbRate2(nbackSub(j-1),i)  = trialSub(nbackSub(j));

        end

    end

end



for i=1:sz3(2)

    trialSub=cell2mat(tnt3(i));

    nbackSub = cell2mat(tnb3(i));

    szk = size(nbackSub);

    for j=2:szk(1)

        if nbackSub(j) - nbackSub(j-1) == 1

          nbRate3(nbackSub(j-1),i)  = trialSub(nbackSub(j));

        end

    end

end



for i=1:sz4(2)

    trialSub=cell2mat(tnt4(i));

    nbackSub = cell2mat(tnb4(i));

    szk = size(nbackSub);

    for j=2:szk(1)

        if nbackSub(j) - nbackSub(j-1) == 1

          nbRate4(nbackSub(j-1),i)  = trialSub(nbackSub(j));

        end

    end

end





mean_rate1 = mean(nbRate1,2);

mean_rate2 = mean(nbRate2,2);

mean_rate3 = mean(nbRate3,2);

mean_rate4 = mean(nbRate4,2);



figure;

bar(mean_rate2);

ylim([0 18]);

title('Cluster 1: rate of change of n-back in terms of number of trials','FontSize', 25);

xlabel('n-back change','FontSize', 20);

xticklabels({'1-2','2-3','3-4','4-5','5-6','6-7','7-8','8-9','9-10','10-11','11-12'})

ylabel('number of trials (length of block)','FontSize', 20)



    figure;

    bar(mean_rate4);

    ylim([0 18]);

title('Cluster 2: rate of change of n-back in terms of number of trials','FontSize', 25);

xlabel('n-back change','FontSize', 20);

xticklabels({'1-2','2-3','3-4','4-5','5-6','6-7','7-8','8-9','9-10','10-11','11-12'})

ylabel('number of trials (length of block)','FontSize', 20)

end


