function [] = tuning_parameters_newDS()

[accu1,nbacks1,nTrials1] = set_upnew2017();
[accu2,nbacks2,nTrials2] = set_upnew2016();
accu= [accu1; accu2];
nbacks =[nbacks1;nbacks2];
nTrials =[nTrials1;nTrials2];


sz = size(accu);
nSubs = sz(1);

rhos= linspace(0,2,20);
cs= linspace(0,1,10);
ds= linspace(0,1,10);
ns= linspace(0,30,20);

Models_A = cell(20,10,10,20);
Models_Pi = cell(20,10,10,20);
log_lik = zeros(20,10,10,20);

B_list = cell(nSubs,20,10,10,20);
M_list = cell(nSubs,20,10,10,20);
R_list = cell(nSubs,20,10,10,20);

X= linspace(1,12,12); %Defining the state-space
%c=0.0;
%d=1;
for k = 1:nSubs
    acc = accu{k};
    nback = nbacks{k};
    nTrial = nTrials{k};
    R = acc.*nTrial;
    R = round(R);
    t=1;
    for rho=rhos
        s=1;
        for c=cs
            u=1;
            for d=ds
                w=1;
                for n=ns
                    [B] =  compute_emission_prob(nTrial,R,nback,rho,c,d,X,n);
                    B_list{k,t,s,u,w} = B;
                    M_list{k,t,s,u,w} = nTrial;
                    R_list{k,t,s,u,w} = R;
                    w = w+1;
                end
                u = u+1;
            end
            s=s+1;
        end
        t=t+1;
    end
end


%Collecting data across all subjects
t=1;
%Performing grid search
for rho=rhos %For each rho
    s=1;
    for c=cs
        u=1;
        for d = ds
            w=1;
            for n=ns
                 A_rr = cell(5,1);
                 Pi_rr = cell(5,1);
                 ll_rr = zeros(5,1);
                for rr=1:5
                   [A,Pi,ll] = baum_welch_cont(X,B_list(:,t,s,u,w));%Applying Baum Welch to re-estimate the parameters
                    A_rr{rr} = A;
                    Pi_rr{rr} = Pi;
                    ll_rr(rr) = ll;
                end
                    [loglik idx] = max(ll_rr(:));

                    Models_A{t,s,u,w} = A_rr{idx};
                    Models_Pi{t,s,u,w} = Pi_rr{idx};
                    log_lik(t,s,u,w) =loglik;
                    w = w+1;
            end
                u = u+1;
        end
        s=s+1;
    end
    t=t+1;
end  
save('log_lik.mat','log_lik');
save('Models_A.mat','Models_A');
save('Models_Pi.mat','Models_Pi');
%Find maximum log-likelihood and corresponding rho
[num idx] = max(log_lik(:));
[x y z w] = ind2sub(size(log_lik),idx); %Find the index corresponding to max log-likelihood

A =  Models_A{x,y,z,w};
Pi =  Models_Pi{x,y,z,w};
picked_c = cs(y);
picked_d = ds(z);
picked_rho = rhos(x);
picked_n = ns(w);

save('A.mat','A');
save('Pi.mat','Pi');
save('picked_n.mat','picked_n');
save('picked_d.mat','picked_d');
save('picked_c.mat','picked_c');
save('picked_rho.mat','picked_rho');

end