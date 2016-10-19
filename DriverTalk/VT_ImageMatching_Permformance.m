function f = VT_ImageMatching_Permformance(nSameCar, nThreshold, nSizeLimit)

format long;

mFeatureNum = [20 40 60 80 100 120 140 160 180 200 250 300 500 1000];
%mFeatureNum = [20 40 60 80 100 120 140 160 180 200 250];

[nRow nCol] = size(mFeatureNum);

sPlace = 'F:\\DriverTalk_DiversityResult\\';

mAccuracy = [];

for i=1:nCol
    disp(strcat('Processing..............', num2str(mFeatureNum(1, i)) ));
    if nSameCar == 0
        sMatchedResultFile = sprintf('%s%s_%s.csv', sPlace,  'MatchResult_RequiredKeypoint', num2str(mFeatureNum(1, i)));
    else
        sMatchedResultFile = sprintf('%s%s_%s.csv', sPlace,  'SameCar_MatchResult_RequiredKeypoint', num2str(mFeatureNum(1, i)));        
    end
    mResult = load(sMatchedResultFile);
    
    if nSameCar == 0
       fTmpAccuracy = VT_CalculateMatchingAccuracy_Snapshot(mResult, nThreshold, nSizeLimit);
    else
       fTmpAccuracy = VT_CalculateMatchingAccuracy_SameCar(mResult, nThreshold, nSizeLimit);
    end
    mAccuracy(1, i) = fTmpAccuracy*100;

    disp(strcat('[Accuracy]   ', num2str(mAccuracy(1, i))));
    
    disp('###############################################################');

end

figure('numbertitle', 'off', 'name', 'Accuracy of Image Matching vs. #Maximal Feature Points','units','normalized','outerposition',[0 0 1 1]);

matXVal = 1:1:nCol;
plot(matXVal, mAccuracy, 'b-*','linewidth',2, 'MarkerFaceColor','r','MarkerEdgeColor','r', 'Markersize',15);

xlim([0 nCol]);
set(gca,'XTick',1:1:nCol);

XTickTxt = {'20'; '40'; '60'; '80'; '100'; '120';'140'; '160'; '180'; '200'; '250'; '300'; '500'; '1000'};
%XTickTxt = {'20'; '40'; '60'; '80'; '100'; '120'; '140'; '160'; '180'; '200'; '250'};

if nSameCar == 0
        title(gca, strcat('Performance of Image Matching (Vehicles in Highway Snapshots, Threshold=', num2str(nThreshold), ')'), 'FontName','Times New Roman', 'FontSize', 26);    
else
    if nSizeLimit == 0
        title(gca, strcat('Performance of Image Matching (between Same Car, Threshold=', num2str(nThreshold), ')'), 'FontName','Times New Roman', 'FontSize', 26);
    else
        title(gca, strcat('Performance of Image Matching (between Same Car, Threshold=', num2str(nThreshold), ', Size Limit=10KB)'), 'FontName','Times New Roman', 'FontSize', 26);        
    end
end

set(gca, 'XTickLabel', XTickTxt, 'FontName','Times New Roman', 'FontSize', 24);

xlabelStr = 'Number of Maximal Feature Points';
xlabel(xlabelStr, 'FontName','Times New Roman', 'FontSize', 26);    
ylabel('Accuracy (%)', 'FontName', 'Times New Roman', 'FontSize', 26);
set(gca,'ygrid','on');

ylim([0 100]);
set(gca,'YTick',0:5:100);


f = 0;

return;
