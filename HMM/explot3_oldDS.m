function [] = explot3_oldDS(A,Pi,B_list,subList,n_backs_list,Y_hat_list,Ratio)
%Plotting for every subject:
nSubs = numel(B_list);
filtered_estimates = cell(nSubs,1);
X= linspace(1,9,18);
for k=1:nSubs
    Y1= Y_hat_list{k};
    Y2= Ratio{k};
    B= B_list{k};
    n_backs= n_backs_list{k};
    if (isempty(B) == 1)
       continue;
    end
    [fs] = alpha_beta_pass(A,Pi,B) % gamma= alpha_hat*beta_hat lpha_hat*beta_hat 
    
   % gamma=alpha.*beta.*(1./scale)';
    N= size(B,1);
    sessions = linspace(1,N,N);
    
    
    Subject= subList{k}.name;
    Subject =strsplit(Subject,'-');
    Subject = Subject{1};
    fig(k)= figure;
    
    h= zeros(1,2);
    h(1)=subplot(2, 1, 1);
    imagesc(fs');
    
    caxis([0, 1])
    %colorbar;
    set(gca,'YDir','normal');
    %yticklabels = -90:20:90;
    set(gca, 'YTick', 1:36, 'YTickLabel',{'','','','1', '', '','','2', '', '','','3', '', '','' ,'4', '', '','' ,'5', '', '','' ,'6', '', '','' ,'7', '', '','' ,'8', '', '','' ,'9'});
    %set(gca,'YTick',[1,1.5,2,2.5,3,3.5,4,4.5,5,5.5,6,6.5,7,7.5,8,8.5,9]);
    hold on;
    scatter(sessions+0.2,n_backs*4,'wx');
    %ylim([1 9]);
    lgnd=legend('\color{white} n-back');
    set(lgnd,'color','none');
    title(sprintf('n-level estimates for Subject %s',Subject));
    xlabel('Block Number');
    ylabel('n-back');
    
    h(2)=subplot(2, 1, 2);
    scatter(sessions,Y1,'bo');
    hold on;
    scatter(sessions,Y2,'rx');
    
      b = num2str(n_backs);
    c = cellstr(b);
    text(sessions,Y2,c);
    
    
    for i=1:N
        hold on;
        line([i,i],[Y1(i),Y2(i)],'Color', 'k');
    end
    %xlim([0 25]);
    title(sprintf('Accuracy Predictions for Subject %s',Subject));
    legend('Predictions','Feedback');
    xlabel('Block Number');
    ylabel('Classification Accuracy');
     set(gcf,'NextPlot','add');
    axes;
    %ht = title(sprintf('Subject= %s',Subject));
    set(gca,'Visible','off');
    %set(ht,'Visible','on');
    
    
    c= get(h(1));
    position =c.XLim;
    x1 = position(2);
     c= get(h(2));
    position =c.XLim;
    x2 = position(2);
    set(h(2), 'XLim',[0.5 x1]);
     filtered_estimates{k} = fs;
    if k==1
        print(fig(k), '-dpsc2', 'User-Skill-Trace.ps');
    else
       print(fig(k), '-append', '-dpsc2', 'User-Skill-Trace.ps'); 
    end
    
end
save('filtered_estimates.mat','filtered_estimates');
end

