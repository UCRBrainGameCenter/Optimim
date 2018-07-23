function [] = cluster_statistics(cluster_list,avg_obsAccu,avg_pedAccu)
N=177;%Change according to number of sequences
group1 = [];
group2= [];
group3 = [];
group4 = [];
sum1=0;
sum2=0;
sum3=0;
sum4=0;
psum1 =0;
psum2=0;
psum3=0;
psum4=0;
for i=1:35
    if cluster_list(i) == 1
        group1 = [group1,i];
        sum1 = sum1+ avg_obsAccu(i);
        psum1 = psum1+ avg_pedAccu(i);
    end
    if cluster_list(i) == 2
        group2 = [group2,i];
        sum2 = sum2+ avg_obsAccu(i);
        psum2 = psum2+ avg_pedAccu(i);
    end
    if cluster_list(i) == 3
        group3 = [group3,i];
        sum3 = sum3+ avg_obsAccu(i);
        psum3 = psum3+ avg_pedAccu(i);
    end
     if cluster_list(i) == 4
        group4 = [group4,i];
        sum4 = sum4+ avg_obsAccu(i);
        psum4 = psum4+ avg_pedAccu(i);
    end
           
end
sz1 = size(group1);
sum1 = sum1/sz1(2);
psum1 = psum1/sz1(2);
sz2 = size(group2);
sum2 = sum2/sz2(2);
psum2 = psum2/sz2(2);
sz3 = size(group3);
sum3 = sum3/sz3(2);
psum3 = psum3/sz3(2);
sz4 = size(group4);
sum4 = sum4/sz4(2);
psum4 = psum4/sz4(2);
end

