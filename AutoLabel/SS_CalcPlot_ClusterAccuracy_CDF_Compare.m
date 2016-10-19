function f = SS_CalcPlot_ClusterAccuracy_CDF_Compare()

sParentFolderA = 'E:\UIUC\Run\PictureClusteringResult\ClusteringResultSmart\Mall_Sub';
sParentFolderB = 'E:\UIUC\Run\ClusteringResultSmart_FilterWithWiFi\Mall_Sub';
%sParentFolderB = 'E:\UIUC\Run\ClusteringResultSmart_FilterWithWiFi\Mall_Sub2';

sTitle = 'Performance of Store Picture Clustering';

format long;

sSubFolderWithout = 'withoutPlaceName';
sSubFolderWith = 'withPlaceName';

sFileStartWithout = 'ClusteringResult_withoutPlaceName';

sFileStartWith = 'ClusteringResult_withPlaceName';

sFileEnd = 'Simple';

%%% Process with place name for A set
mTotalAccuracyWithA = [];
sParentSubFolderWith = [sParentFolderA '\' sSubFolderWith];
Files = dir(sParentSubFolderWith);
nWithFileCntA = 0;

for i=3:length(Files)  % First two are: "."   "..'
    sFileName = Files(i).name;
    sFullFilePathName = [sParentFolderA '\' sSubFolderWith '\' sFileName];

    mFindStart = strfind(sFileName, sFileStartWith);
    mFindEnd = strfind(sFileName, sFileEnd);
    
    if length(mFindStart) > 0 && length(mFindEnd) > 0
        mAccuracy = SS_GetClusterAccuracy(sFullFilePathName);
        mTotalAccuracyWithA = [mTotalAccuracyWithA mAccuracy];
        nWithFileCntA = nWithFileCntA + 1;
    end
   
end

fprintf('With #File: %d, Record: %d\n', nWithFileCntA, length(mTotalAccuracyWithA));

meanAccuracyWithA = mean(mTotalAccuracyWithA)
stdAccuracyWithA = std(mTotalAccuracyWithA)
maxAccuracyWithA = max(mTotalAccuracyWithA);
minAccuracyWithA = min(mTotalAccuracyWithA);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Process with place name for B set
mTotalAccuracyWithB = [];
sParentSubFolderWith = [sParentFolderB '\' sSubFolderWith];
Files = dir(sParentSubFolderWith);
nWithFileCntB = 0;

for i=3:length(Files)  % First two are: "."   "..'
    sFileName = Files(i).name;
    sFullFilePathName = [sParentFolderB '\' sSubFolderWith '\' sFileName];

    mFindStart = strfind(sFileName, sFileStartWith);
    mFindEnd = strfind(sFileName, sFileEnd);
    
    if length(mFindStart) > 0 && length(mFindEnd) > 0
        mAccuracy = SS_GetClusterAccuracy(sFullFilePathName);
        mTotalAccuracyWithB = [mTotalAccuracyWithB mAccuracy];
        nWithFileCntB = nWithFileCntB + 1;
    end
   
end

fprintf('With #File: %d, Record: %d\n', nWithFileCntB, length(mTotalAccuracyWithB));

meanAccuracyWithB = mean(mTotalAccuracyWithB)
stdAccuracyWithB = std(mTotalAccuracyWithB)
maxAccuracyWithB = max(mTotalAccuracyWithB);
minAccuracyWithB = min(mTotalAccuracyWithB);





% Plot all CDF together
sArr_ColorType = [ ...
    'r'; ...
    'g'; ...
    'b'; ...
    'k'; ...
];

cellColorType = cellstr(sArr_ColorType);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Together: One one figure



%%%%%%%%%%%%%%%%%%%%%%%%%%%% Separate: One file, subplot


figure(1);

[h, stats] = cdfplot(mTotalAccuracyWithA(1,:));
hold on;
set(h, 'color', 'r');
set(h, 'linewidth', 3);

[h, stats] = cdfplot(mTotalAccuracyWithB(1,:));
hold on;
set(h, 'color', 'b');
set(h, 'linewidth', 3);

xlim([0 100]);
set(gca,'XTick',0:10:100);
set(gca,'ygrid','off');
set(gca,'xgrid','off');

title(gca, 'Accuracy of Store Picture Clustering', 'FontName','Times New Roman', 'FontSize', 48);
set(gca,'FontName','Times New Roman', 'FontSize', 36);
xlabel('Accuracy', 'FontName','Times New Roman', 'FontSize', 44);    
ylabel('CDF','FontName','Times New Roman', 'FontSize', 44);

legend('Text-based Clustering', 'AP Vector-based Filtering + Text-based Clustering');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%% Normal Version: Together
% figure(5);
% 
% nNumSigma = 3;
% % Without Place Name
% x = linspace(meanAccuracyWithout - nNumSigma * stdAccuracyWithout, meanAccuracyWithout + nNumSigma * stdAccuracyWithout, 10000);
% plot(x, normcdf(x,meanAccuracyWithout, stdAccuracyWithout), 'r',  'linewidth', 3);
% hold on;
% 
% % Without Place Name
% x = linspace(meanAccuracyWith - nNumSigma * stdAccuracyWith, meanAccuracyWith + nNumSigma * stdAccuracyWith, 10000);
% plot(x, normcdf(x,meanAccuracyWith, stdAccuracyWith), 'b',  'linewidth', 3);
% hold on;
% 
% xlim([0 100]);
% set(gca,'XTick',0:10:100);
% set(gca,'ygrid','off');
% set(gca,'xgrid','off');
% 
% title(gca, sTitle, 'FontName','Times New Roman', 'FontSize', 48);
% set(gca,'FontName','Times New Roman', 'FontSize', 36);
% xlabel('Accuracy of Clustering', 'FontName','Times New Roman', 'FontSize', 44);    
% ylabel('CDF','FontName','Times New Roman', 'FontSize', 44);
% 
% legend('Place Name Not Involved', 'Place Name Involved');



return;

