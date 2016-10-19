function f = SBM_PlotRouteTraceSegLenAccuracy(mData, XTickTxt)

% mData is an array, which contain accuracy for: Overall, Pantpocket, Hand
% Values in mData should be scaled to max 100

% Plotting...:
screenSize = get(0, 'ScreenSize');

h1=figure('numbertitle', 'off', 'name', 'Accuracy of Trace Matching');

bar(mData, 1,'edgecolor','k', 'linewidth', 2); colormap(gray);

if length(XTickTxt) == 0
    XTickTxt = {'Overall'; 'Pants Pocket'; 'Hand'};
end

set(gca, 'FontName','Times New Roman');
set(gca, 'FontSize', 36)
        
set(gca, 'FontSize', 36)
set(gca, 'XTickLabel', XTickTxt);
set(gca,'YTick',0:10:100);
        
xlabelStr = 'Position of Passenger Phone';

xlabel(xlabelStr, 'FontSize', 50);
ylabel('Accuracy (%)', 'FontSize', 50);
set(gca,'ygrid','on');
ylim([0 100]);

set(0, 'DefaultFigurePosition', screenSize);

return;
