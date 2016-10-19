function f = SS_CalcPlot_ClusterAccuracy_CDF()

%sParentFolder = 'E:\UIUC\Run\ClusteringResultSmart\Mall_Sub';
%sParentFolder = 'E:\UIUC\Run\ClusteringResultSmart_FilterWithWiFi\Mall_Sub2';
sParentFolder = 'E:\UIUC\Run\PictureClusteringResult\ClusteringResultSmart_FilterWithWiFi201508\Street';

sTitle = 'Performance of Store Picture Clustering';

format long;

sSubFolderWithout = 'withoutPlaceName';
sSubFolderWith = 'withPlaceName';

sFileStartWithout = 'ClusteringResult_withoutPlaceName';

sFileStartWith = 'ClusteringResult_withPlaceName';

sFileEnd = 'Simple';


%%% Process without place name
if 0
        mTotalAccuracyWithout = [];
        sParentSubFolderWithout = [sParentFolder '\' sSubFolderWithout];
        Files = dir(sParentSubFolderWithout);

        nWithoutFileCnt = 0;

        for i=3:length(Files)  % First two are: "."   "..'
            sFileName = Files(i).name;
            sFullFilePathName = [sParentFolder '\' sSubFolderWithout '\' sFileName];

            mFindStart = strfind(sFileName, sFileStartWithout);
            mFindEnd = strfind(sFileName, sFileEnd);

            if length(mFindStart) > 0 && length(mFindEnd) > 0
                mAccuracy = SS_GetClusterAccuracy(sFullFilePathName);
                mTotalAccuracyWithout = [mTotalAccuracyWithout mAccuracy];
                nWithoutFileCnt = nWithoutFileCnt + 1;
            end

        end

        fprintf('Without #File: %d\n', nWithoutFileCnt);


        meanAccuracyWithout = mean(mTotalAccuracyWithout);
        stdAccuracyWithout = std(mTotalAccuracyWithout);
        maxAccuracyWithout = max(mTotalAccuracyWithout);
        minAccuracyWithout = min(mTotalAccuracyWithout);
end



%%% Process with place name
mTotalAccuracyWith = [];
sParentSubFolderWith = [sParentFolder '\' sSubFolderWith];
Files = dir(sParentSubFolderWith);
nWithFileCnt = 0;

for i=3:length(Files)  % First two are: "."   "..'
    sFileName = Files(i).name;
    sFullFilePathName = [sParentFolder '\' sSubFolderWith '\' sFileName];

    mFindStart = strfind(sFileName, sFileStartWith);
    mFindEnd = strfind(sFileName, sFileEnd);
    
    if length(mFindStart) > 0 && length(mFindEnd) > 0
        mAccuracy = SS_GetClusterAccuracy(sFullFilePathName);
        mTotalAccuracyWith = [mTotalAccuracyWith mAccuracy];
        nWithFileCnt = nWithFileCnt + 1;
    end
   
end

fprintf('With #File: %d\n', nWithFileCnt);


meanAccuracyWith = mean(mTotalAccuracyWith)
stdAccuracyWith = std(mTotalAccuracyWith)
maxAccuracyWith = max(mTotalAccuracyWith);
minAccuracyWith = min(mTotalAccuracyWith);



% Plot all CDF together
sArr_ColorType = [ ...
    'r'; ...
    'g'; ...
    'b'; ...
    'k'; ...
];

cellColorType = cellstr(sArr_ColorType);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Together: One one figure

if 0
figure(1);

[h, stats] = cdfplot(mTotalAccuracyWithout(1,:));
hold on;
set(h, 'color', 'r');
set(h, 'linewidth', 3);

[h, stats] = cdfplot(mTotalAccuracyWith(1,:));
hold on;
set(h, 'color', 'b');
set(h, 'linewidth', 3);

xlim([0 100]);
set(gca,'XTick',0:10:100);
set(gca,'ygrid','off');
set(gca,'xgrid','off');

title(gca, sTitle, 'FontName','Times New Roman', 'FontSize', 48);
set(gca,'FontName','Times New Roman', 'FontSize', 36);
xlabel('Accuracy', 'FontName','Times New Roman', 'FontSize', 44);    
ylabel('CDF','FontName','Times New Roman', 'FontSize', 44);

legend('Place Name Not Involved', 'Place Name Involved');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%% Separate: One file, subplot
if 0
figure(2);
subplot(1,2,1);
[h, stats] = cdfplot(mTotalAccuracyWithout);
hold on;
set(h, 'color', 'b');
set(h, 'linewidth', 3);

xlim([0 100]);
set(gca,'XTick',0:10:100);
set(gca,'ygrid','off');
set(gca,'xgrid','off');

title(gca, 'Accuracy of Store Picture Clustering (Place Name Not Involved)', 'FontName','Times New Roman', 'FontSize', 48);
set(gca,'FontName','Times New Roman', 'FontSize', 36);
xlabel('Accuracy', 'FontName','Times New Roman', 'FontSize', 44);    
ylabel('CDF','FontName','Times New Roman', 'FontSize', 44);

subplot(1,2,2);
[h, stats] = cdfplot(mTotalAccuracyWith);
hold on;
set(h, 'color', 'b');
set(h, 'linewidth', 3);

xlim([0 100]);
set(gca,'XTick',0:10:100);
set(gca,'ygrid','off');
set(gca,'xgrid','off');

title(gca, 'Accuracy of Store Picture Clustering (Place Name Involved)', 'FontName','Times New Roman', 'FontSize', 48);
set(gca,'FontName','Times New Roman', 'FontSize', 36);
xlabel('Accuracy', 'FontName','Times New Roman', 'FontSize', 44);    
ylabel('CDF','FontName','Times New Roman', 'FontSize', 44);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%% Separate: separate files
if 0
figure(3);

[h, stats] = cdfplot(mTotalAccuracyWithout(1,:));
hold on;
set(h, 'color', 'b');
set(h, 'linewidth', 3);

xlim([0 100]);
set(gca,'XTick',0:10:100);
set(gca,'ygrid','off');
set(gca,'xgrid','off');

title(gca, 'Accuracy of Store Picture Clustering (Place Name Not Involved)', 'FontName','Times New Roman', 'FontSize', 48);
set(gca,'FontName','Times New Roman', 'FontSize', 36);
xlabel('Accuracy', 'FontName','Times New Roman', 'FontSize', 44);    
ylabel('CDF','FontName','Times New Roman', 'FontSize', 44);
end

figure(4);

[h, stats] = cdfplot(mTotalAccuracyWith(1,:));
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

