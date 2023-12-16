function [] = plotGLM(cond,run)
%% Plots beta weights of GLMs that have been ran

% output:   behavioural GLMs displayed in main text of Trudel 2020
%           * note, that beta weights are averaged across both conditions


%% 1.) GLM1 across all trials; Figure 3A

if run(1) == 1
    ic1=1;ic2=2;irun=1;
    subbetas = cond{ic1}.allval{irun}.betas;
    avgbetas = mean(subbetas);
    SEbetas  = getSE(subbetas);
    
    regnames = cond{ic1}.allval{irun}.regnames;
   
    figure
    title(['GLM' num2str(irun) ': across all trials']);hold all;
    for ivar = 2:length(avgbetas)
        bar(ivar-1, avgbetas(ivar),'FaceColor','w','EdgeColor','k','LineWidth',1);hold all
        errorbar(ivar-1, avgbetas(ivar),SEbetas(ivar) );hold all
        
        for isub = 1:length(cond{1}.ID)
            plot(ivar-1+rand/7, subbetas(isub,ivar),'ko')
        end
    end
    set_default_fig_properties(gca,gcf);hold all;
    set(gca,'XTick',1: length(regnames));hold all;
    set(gca,'XTickLabel',{ regnames{:}},'FontSize',18);
    ylabel('Choice beta a.u.', 'FontSize', 20, 'FontWeight','bold');
    set(gca,'box','off');
    
end

%% 2.) GLM2 block halves; Figure 3B-i


if run(2) == 1
    irun=2;
    cols     = {'r';'b'};
    regnames = cond{1}.allval{2}.regnames;
   
    ic1=1;ic2=2; subbetas={};avgbeta={};SEbetas={};
    for ib = 1:length(cond{ic1}.allval{irun}.betas)
        subbetas{ib}= (cond{ic1}.allval{irun}.betas{ib}+cond{ic2}.allval{irun}.betas{ib})/2;
        avgbeta{ib} = mean(subbetas{ib});
        SEbetas{ib}  = getSE(subbetas{ib});
    end
    
    figure
    title(['GLM' num2str(irun) ': block halves']);hold all;
    icount=-0.05;
    for ivar = 2:3
        plt{ivar-1}=plot([1:2], [avgbeta{1}(ivar) avgbeta{2}(ivar)],cols{ivar-1},'LineWidth',2); hold all;
        errorbar([1:2], [avgbeta{1}(ivar) avgbeta{2}(ivar)], [SEbetas{1}(ivar) SEbetas{2}(ivar)],cols{ivar-1});
        
        for isub = 1:length(cond{1}.ID)
            plot([1:2]+icount , [subbetas{1}(isub,ivar) subbetas{2}(isub,ivar)],'o','Color',cols{ivar-1})
        end
        icount=0.05;
    end
    line([0.8 2.1] ,[0 0], 'Color', [0 0 0]);hold all;
    set_default_fig_properties(gca,gcf);hold all;
    set(gca,'XTick',1: length(regnames));hold all;
    set(gca,'XTickLabel',{'Half1';'Half2'},'FontSize',18);
    ylabel('Choice beta a.u.', 'FontSize', 20, 'FontWeight','bold');
    set(gca,'box','off');
    legend([plt{:}],regnames)

    
    
end




if run(3) == 1
    irun = 3;
    cols     = {'r';'b'};
    regnames = cond{1}.allval{irun}.regnames;
   
   ic1=1;ic2=2; subbetas={};avgbeta={};SEbetas={};
    for ib = 1:length(cond{ic1}.allval{irun}.betas)
        subbetas{ib}= (cond{ic1}.allval{irun}.betas{ib}+cond{ic2}.allval{irun}.betas{ib})/2;
        avgbeta{ib} = mean(subbetas{ib});
        SEbetas{ib}  = getSE(subbetas{ib});
    end
    
    figure
    title(['GLM' num2str(irun) ': time horizon']);hold all;
    icount=-0.05;
    for ivar = 2:3
        plt{ivar-1}=plot([1:length(avgbeta)], [avgbeta{1}(ivar) avgbeta{2}(ivar) avgbeta{3}(ivar)],cols{ivar-1},'LineWidth',2); hold all;
        errorbar([1:length(avgbeta)], [avgbeta{1}(ivar) avgbeta{2}(ivar) avgbeta{3}(ivar)], [SEbetas{1}(ivar) SEbetas{2}(ivar) SEbetas{3}(ivar)],cols{ivar-1});
        
        for isub = 1:length(cond{1}.ID)
            plot([1:length(avgbeta)]+icount , [subbetas{1}(isub,ivar) subbetas{2}(isub,ivar) subbetas{3}(isub,ivar)],'o','Color',cols{ivar-1})
        end
        icount=0.05;
    end
    line([0.8 3.1] ,[0 0], 'Color', [0 0 0]);hold all;
    set_default_fig_properties(gca,gcf);hold all;
    set(gca,'XTick',1: length(avgbeta));hold all;
    set(gca,'XTickLabel',{'45';'30';'15'},'FontSize',18);
    xlabel('Time Horizon ', 'FontSize', 20, 'FontWeight','bold')
    ylabel('Choice beta a.u.', 'FontSize', 20, 'FontWeight','bold');
    set(gca,'box','off');
    legend([plt{:}],regnames)

end



%% 4.) GLM4 time horizon; Figure 3C

if run(4) == 1
   ic1=1;ic2=2;irun=4;
    subbetas = (cond{ic1}.allval{irun}.betas+cond{ic2}.allval{irun}.betas)/2*-1; % multiply with -1 such that the confidence can be interpret intuitive: higher number, higher confidence
    avgbetas = mean(subbetas);
    SEbetas  = getSE(subbetas);
    regnames = cond{ic1}.allval{irun}.regnames;
   
    figure
    title(['GLM' num2str(irun) ': confidence judgment']);hold all;
    for ivar = 2:length(avgbetas)
        bar(ivar-1, avgbetas(ivar),'FaceColor','w','EdgeColor','k','LineWidth',1);hold all
        errorbar(ivar-1, avgbetas(ivar),SEbetas(ivar) );hold all
        
        for isub = 1:length(cond{1}.ID)
            plot(ivar-1+rand/7, subbetas(isub,ivar),'ko')
        end
    end
    set_default_fig_properties(gca,gcf);hold all;
    set(gca,'XTick',1: length(regnames));hold all;
    set(gca,'XTickLabel',{ regnames{:}},'FontSize',18);
    ylabel('Confidence Interval (inverse measure) beta a.u.', 'FontSize', 20, 'FontWeight','bold');
    set(gca,'box','off');

end

end