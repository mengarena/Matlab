function f = SBM_ReduceSearchSpace_CDF(mResultData, nFigNo)
% This function is used to plot how much search space is reduced
%

format long;

[nRowCnt ~] = size(mResultData);

mReducedRatio = [];

for i = 1:nRowCnt
    mReducedRatio(i) = (mResultData(i,12) - mResultData(i,13))*100.0/mResultData(i,12);
end    
    
figure(nFigNo);

[h, stats] = cdfplot(mReducedRatio);
hold on;
set(h, 'color', 'b');
set(h, 'linewidth', 4);

xlim([50 100]);
set(gca,'XTick',50:10:100);
set(gca,'ygrid','off');
set(gca,'xgrid','off');

set(gca,'YTick',0:0.2:1);

title(gca, 'Searching Space Reduction via Macro Feature', 'FontName','Times New Roman', 'FontSize', 50);
set(gca,'FontName','Times New Roman', 'FontSize', 50);
xlabel('Percentage of Reduction', 'FontName','Times New Roman', 'FontSize', 50);    
ylabel('CDF','FontName','Times New Roman', 'FontSize', 50);

return;
