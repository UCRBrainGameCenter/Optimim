
function [] = explot3_newDS(A,Pi,B_list,n_backs_list,Y_hat_list,Ratio)
%Plotting for every subject:
nSubs = numel(B_list);
filtered_estimates = cell(nSubs,1);
X= linspace(1,12,12);
for k=1:nSubs
    Y1= Y_hat_list{k};
    Y2= Ratio{k};
    B= B_list{k};
    n_backs= n_backs_list{k};
    if (isempty(B) == 1)
       continue;
    end
    [fs] = alpha_beta_pass(A,Pi,B) % gamma= alpha_hat*beta_hat 
    
    N= size(B,1);
    N=150; %N is constant across all subjects: This can be changed 
    sessions = linspace(1,N,N);
    
    
    %Subject= subList{k}.name;
    %Subject =strsplit(Subject,'-');
    %Subject = Subject{1};
    fig(k)= figure;
    
    h= zeros(1,2);
    h(1)=subplot(2, 1, 1);
    fs1 = fs'
    imagesc(fs1(:,1:N));
    
    
    set(gca,'YDir','normal');
    set(gca, 'YTick', 1:12, 'YTickLabel',{'1', '2','3', '4', '5', '6', '7', '8', '9','10','11','12'});
   caxis([0, 1])
    %c=colorbar;
    hold on;
    scatter(sessions+0.2,n_backs(1:N),'wx');
    xlabel('Block Number','FontSize', 20);
    ylabel('N-back','FontSize', 20);
    %title(sprintf('N-level trajectory for Subject RLB153'),'FontSize', 25);
    
    h(2)=subplot(2, 1, 2);
    scatter(sessions,Y1(1:N),'bo');
    hold on;
    scatter(sessions,Y2(1:N),'rx');
    
    b = num2str(n_backs(1:N));
    c = cellstr(b);
    %text(sessions,Y2,c);
    
    
    for i=1:N
        hold on;
        line([i,i],[Y1(i),Y2(i)],'Color', 'k');
    end
    %xlim([0 25]);
    %title(sprintf('Accuracy for Subject RLB153'),'FontSize', 25);
    %lgnd=legend('Predictions','Actual Percentage Correct');
    xlabel('Block Number','FontSize', 20);
    ylabel('Classification Accuracy','FontSize', 20);
    set(gcf,'NextPlot','add');
    axes;
    axis('equal') 
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
      temp=['fig',num2str(k),'.png'];
      saveas(gca,temp);  
end
save('filtered_estimates.mat','filtered_estimates');
end

