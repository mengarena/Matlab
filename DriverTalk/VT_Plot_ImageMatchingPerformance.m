function f=VT_Plot_ImageMatchingPerformance()

sFile = 'F:\\DriverTalk_DiversityResult\\ChooseThreshold.csv';

mResult = load(sFile);

nSnapshotIndex = 2;

nSamecarIndex = 3;

nDifferentCarIndex = 4;

[nRow nCol] = size(mResult);



figure('numbertitle', 'off', 'name', 'Accuracy of Image Matching vs. #Maximal Feature Points for Snapshot','units','normalized','outerposition',[0 0 1 1]);

matXVal = 1:1:nRow;
plot(matXVal, mResult(:,nSnapshotIndex), 'b-*','linewidth',3, 'MarkerFaceColor','r','MarkerEdgeColor','r', 'Markersize',15);

xlim([0 nRow]);
set(gca,'XTick',1:1:nRow);

XTickTxt = {'5'; '10'; '15'; '20'; '25'; '30'};

title(gca, 'Performance of Image Matching (for Traffic Snapshot on Highway)', 'FontName','Times New Roman', 'FontSize', 26);        

set(gca, 'XTickLabel', XTickTxt, 'FontName','Times New Roman', 'FontSize', 24);

xlabelStr = 'Threshold of Matched Points';
xlabel(xlabelStr, 'FontName','Times New Roman', 'FontSize', 26);    
ylabel('Accuracy (%)', 'FontName', 'Times New Roman', 'FontSize', 26);
set(gca,'ygrid','on');

ylim([0 100]);
set(gca,'YTick',0:5:100);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure('numbertitle', 'off', 'name', 'Accuracy of Image Matching vs. #Maximal Feature Points for Same Car','units','normalized','outerposition',[0 0 1 1]);

matXVal = 1:1:nRow;
plot(matXVal, mResult(:,nSamecarIndex), 'b-*','linewidth',3, 'MarkerFaceColor','r','MarkerEdgeColor','r', 'Markersize',15);

xlim([0 nRow]);
set(gca,'XTick',1:1:nRow);

XTickTxt = {'5'; '10'; '15'; '20'; '25'; '30'};

title(gca, 'Performance of Image Matching (between Images of Same Car)', 'FontName','Times New Roman', 'FontSize', 26);        

set(gca, 'XTickLabel', XTickTxt, 'FontName','Times New Roman', 'FontSize', 24);

xlabelStr = 'Threshold of Matched Points';
xlabel(xlabelStr, 'FontName','Times New Roman', 'FontSize', 26);    
ylabel('Accuracy (%)', 'FontName', 'Times New Roman', 'FontSize', 26);
set(gca,'ygrid','on');

ylim([0 100]);
set(gca,'YTick',0:5:100);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure('numbertitle', 'off', 'name', 'Accuracy of Image Matching vs. #Maximal Feature Points for Different Car','units','normalized','outerposition',[0 0 1 1]);

matXVal = 1:1:nRow;
plot(matXVal, mResult(:,nDifferentCarIndex), 'b-*','linewidth',3, 'MarkerFaceColor','r','MarkerEdgeColor','r', 'Markersize',15);

xlim([0 nRow]);
set(gca,'XTick',1:1:nRow);

XTickTxt = {'5'; '10'; '15'; '20'; '25'; '30'};

title(gca, 'Performance of Image Matching (between Images of Different Car)', 'FontName','Times New Roman', 'FontSize', 26);        

set(gca, 'XTickLabel', XTickTxt, 'FontName','Times New Roman', 'FontSize', 24);

xlabelStr = 'Threshold of Matched Points';
xlabel(xlabelStr, 'FontName','Times New Roman', 'FontSize', 26);    
ylabel('Accuracy (%)', 'FontName', 'Times New Roman', 'FontSize', 26);
set(gca,'ygrid','on');

ylim([0 100]);
set(gca,'YTick',0:5:100);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Together%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure('numbertitle', 'off', 'name', 'Accuracy of Image Matching vs. #Maximal Feature Points (Together)','units','normalized','outerposition',[0 0 1 1]);

matXVal = 1:1:nRow;
plot(matXVal, mResult(:,nSamecarIndex), 'c-+','linewidth',3, 'MarkerFaceColor','b','MarkerEdgeColor','b', 'Markersize',15);
hold on;
plot(matXVal, mResult(:,nDifferentCarIndex), 'm-*','linewidth',3, 'MarkerFaceColor','r','MarkerEdgeColor','r', 'Markersize',15);
%plot(matXVal, mResult(:,nSamecarIndex), 'b-+','linewidth',3, 'MarkerFaceColor','m','MarkerEdgeColor','m', 'Markersize',15);
%hold on;
%plot(matXVal, mResult(:,nDifferentCarIndex), 'r-*','linewidth',3, 'MarkerFaceColor','c','MarkerEdgeColor','c', 'Markersize',15);

xlim([0 nRow]);
set(gca,'XTick',1:1:nRow);

XTickTxt = {'5'; '10'; '15'; '20'; '25'; '30'};

title(gca, 'Performance of Image Matching', 'FontName','Times New Roman', 'FontSize', 26);        

set(gca, 'XTickLabel', XTickTxt, 'FontName','Times New Roman', 'FontSize', 24);

legend('Matching between Images of Same Vehicle', 'Matching between Images of Different Vehicles');

xlabelStr = 'Threshold of Matched Points';
xlabel(xlabelStr, 'FontName','Times New Roman', 'FontSize', 26);    
ylabel('Accuracy (%)', 'FontName', 'Times New Roman', 'FontSize', 26);
set(gca,'ygrid','on');

ylim([0 100]);
set(gca,'YTick',0:5:100);

f = 0;

return;
