function [data_list,n_backs_list,R_list,M_list] = setup_newDS()

[accu1,nbacks1,nTrials1] = set_upnew2017();
[accu2,nbacks2,nTrials2] = set_upnew2016();
taccu= [accu1; accu2];
tnbacks =[nbacks1;nbacks2];
tnTrials =[nTrials1;nTrials2];
%Train- Test split

sz = size(taccu);
totalSubs = sz(1);

sz = round(0.8*totalSubs);
accu = taccu(1:sz,:);
n_backs_list = tnbacks(1:sz,:);
nTrials = tnTrials(1:sz,:);

accu_test = taccu(sz+1:end,:);
nbacks_test = tnbacks(sz+1:end,:);
nTrials_test = tnTrials(sz+1:end,:);

save('accu_test.mat','accu_test');
save('nbacks_test.mat','nbacks_test');
save('nTrials_test.mat','nTrials_test');


nSubs = sz(1);
M_list = cell(nSubs,1);
R_list = cell(nSubs,1);
data_list = cell(nSubs,1); 

for k = 1:nSubs
    acc = accu{k};
    nback = n_backs_list{k};
    nTrial = nTrials{k};
    Rt = acc.*nTrial;
    Rt= round(Rt);
    M_list{k} = nTrial;
    R_list{k} = Rt;
    data_list{k} = (Rt./nTrial);
end


save('data_list.mat','data_list');
save('R_list.mat','R_list');
save('M_list.mat','M_list');
save('n_backs_list.mat','n_backs_list');

end



