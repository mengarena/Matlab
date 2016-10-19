function f = SS_CalMatchingAccuracyDist_CDF_SingleMethod()
% This function calculate the accuracy (for top 1, top 2 and top 3) for Subset OCR vs. Web matching
% It process files under topfolder/1, topfolder/2,...
% In each folder, there are "withPlaceName", "withoutPlaceName",
% Under these folders, this function process KeywordMatchingCM_with/withoutPlaceNameMatching_CorrectPlaceRanking_xx.csv files to calcualte the accuracy
% 
%
% This is only plotting CDF for one subset and one place name method (use or not use)

%sParentFolder = 'E:\UIUC\Run\201411_ForPaper_TFIDF\Similarity\OCR_Web_Subset\10Place';

sParentFolder = 'E:\UIUC\Run\201411_ForPaper_TFIDF\Similarity\OCR_Web_Subset_MultipleIndexSet\20Place';
sTitle = '20-store Region';

xTickStart = 20;

format long;

bLock = 0;

%mFrameCnt = [10 20 30 9999];   % 9999: all
%mFrameCnt = [5 10 15 20 25 30 35 40 45 50 9999];   % 9999: all
%mFrameCnt = [5 25 50 9999];   % 9999: all
mFrameCnt = [5 10 15 20 25 30 35 40 9999];   % 9999: all

%nWithPlaceName = 1;   % With place name or not
%nFrameCnt = 10;       % Number of usable frames

sWithoutPlaceNameSubFolder = 'withoutPlaceName';
sWithPlaceNameSubFolder = 'withPlaceName';

Files = dir(sParentFolder);

% Save the raw accuracy for top 1/2/3
mTotalAccuracyWithPlaceName = [];
mTotalAccuracyWithoutPlaceName = [];

% Save the disctribution (mean, std, max, min) for top 1/2/3
mTotalAccuracyWithPlaceNameDist = [];
mTotalAccuracyWithoutPlaceNameDist = [];

mWithPlaceNameDistMean = [];
mWithPlaceNameDistStd = [];
mWithPlaceNameDistMax = [];
mWithPlaceNameDistMin = [];

mWithoutPlaceNameDistMean = [];
mWithoutPlaceNameDistStd = [];
mWithoutPlaceNameDistMax = [];
mWithoutPlaceNameDistMin = [];

for j=1:length(mFrameCnt)
    nFrameCnt = mFrameCnt(j);
    
    % With Place Name
    mAccuracyWithPlaceName = [];
    nWithPlaceNameCnt = 0;
    
    for i=3:length(Files)  % First two are: "."   "..'
        sFolderName = Files(i).name;
        sFullFolderPath = [sParentFolder '\' Files(i).name];

        if isdir(sFullFolderPath) == 1

            sFullFolderPath = [sFullFolderPath '\' sWithPlaceNameSubFolder];
            sRankFile = sprintf('%s%s%d.csv', sFullFolderPath, '\\KeywordMatchingCM_withPlaceNameMatching_CorrectPlaceRanking_', nFrameCnt);

            mRank = SS_CalAccuracy(sRankFile);

            nCnt = mRank(1,1);
            nRank1 = mRank(1,2);
            nRank2 = mRank(1,3);
            nRank3 = mRank(1,4);

            nWithPlaceNameCnt = nWithPlaceNameCnt + 1;
            mAccuracyWithPlaceName(nWithPlaceNameCnt,1) = nRank1*1.0/nCnt*100;
            mAccuracyWithPlaceName(nWithPlaceNameCnt,2) = nRank2*1.0/nCnt*100;
            mAccuracyWithPlaceName(nWithPlaceNameCnt,3) = nRank3*1.0/nCnt*100;
        end
    end
    
    mTotalAccuracyWithPlaceName{j} = mAccuracyWithPlaceName;
   
    for i=1:3
        mWithPlaceNameDistMean(j,i) = mean(mAccuracyWithPlaceName(:,i));
        mWithPlaceNameDistStd(j,i) = std(mAccuracyWithPlaceName(:,i));
        mWithPlaceNameDistMax(j,i) = max(mAccuracyWithPlaceName(:,i));
        mWithPlaceNameDistMin(j,i) = min(mAccuracyWithPlaceName(:,i));
    end
  
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%% Without Place Name
    mAccuracyWithoutPlaceName = [];
    nWithoutPlaceNameCnt = 0;
    
    for i=3:length(Files)
        sFolderName = Files(i).name;
        sFullFolderPath = [sParentFolder '\' Files(i).name];

        if isdir(sFullFolderPath) == 1

            sFullFolderPath = [sFullFolderPath '\' sWithoutPlaceNameSubFolder];
            sRankFile = sprintf('%s%s%d.csv', sFullFolderPath, '\\KeywordMatchingCM_withoutPlaceNameMatching_CorrectPlaceRanking_', nFrameCnt);

            mRank = SS_CalAccuracy(sRankFile);

            nCnt = mRank(1,1);
            nRank1 = mRank(1,2);
            nRank2 = mRank(1,3);
            nRank3 = mRank(1,4);

            nWithoutPlaceNameCnt = nWithoutPlaceNameCnt + 1;
            mAccuracyWithoutPlaceName(nWithoutPlaceNameCnt,1) = nRank1*1.0/nCnt*100;
            mAccuracyWithoutPlaceName(nWithoutPlaceNameCnt,2) = nRank2*1.0/nCnt*100;
            mAccuracyWithoutPlaceName(nWithoutPlaceNameCnt,3) = nRank3*1.0/nCnt*100;

        end
    end

    mTotalAccuracyWithoutPlaceName{j} = mAccuracyWithoutPlaceName;
    
    for i=1:3
        mWithoutPlaceNameDistMean(j,i) = mean(mAccuracyWithoutPlaceName(:,i));
        mWithoutPlaceNameDistStd(j,i) = std(mAccuracyWithoutPlaceName(:,i));
        mWithoutPlaceNameDistMax(j,i) = max(mAccuracyWithoutPlaceName(:,i));
        mWithoutPlaceNameDistMin(j,i) = min(mAccuracyWithoutPlaceName(:,i));
    end    
    
end

% figure(1);
% plotNormPDF(mWithPlaceNameDistMean(4,1), mWithPlaceNameDistStd(4,1),'r');
% hold on;
% %figure(2);
% plotNormPDF(mWithoutPlaceNameDistMean(4,1), mWithoutPlaceNameDistStd(4,1), 'b');

% figure(3);
% KK = mTotalAccuracyWithoutPlaceName{4};
% x = linspace(mWithoutPlaceNameDistMean(4,1)-4*mWithoutPlaceNameDistStd(4,1), mWithoutPlaceNameDistMean(4,1)+4*mWithoutPlaceNameDistStd(4,1), 10000);
% plot(x, normpdf (x,mWithoutPlaceNameDistMean(4,1), mWithoutPlaceNameDistStd(4,1)));
% figure(4);
%plot(x, normcdf(x,mWithoutPlaceNameDistMean(4,1), mWithoutPlaceNameDistStd(4,1)));

%normcdf(mAccuracyWithoutPlaceName(:,1), mWithoutPlaceNameDistMean(4,1), mWithoutPlaceNameDistStd(4,1));

% Plot all CDF together
sArr_ColorType = [ ...
    'r'; ...
    'g'; ...
    'b'; ...
    'm'; ...    
];

cellColorType = cellstr(sArr_ColorType);

figure(1);

% With Place Name
for j=1:length(mFrameCnt)
    mAccuracy = mTotalAccuracyWithPlaceName{j};
    [h, stats] = cdfplot(mAccuracy(:,1));
    hold on;
    set(h, 'linewidth', 3);

    if j ~= length(mFrameCnt)
       
        nColorIndex = mod(j, length(cellColorType));
        if nColorIndex == 0
            nColorIndex = length(cellColorType);
        end
 
        set(h, 'color', cellColorType{nColorIndex});
        if j > length(cellColorType)
            set(h, 'linestyle', '- -');
        else
            set(h, 'linestyle', '-');
        end
    else
        set(h, 'color', 'k');
        set(h, 'linestyle', '-');
    end
end

xlim([xTickStart 100]);
set(gca,'XTick',xTickStart:10:100);
set(gca,'ygrid','off');
set(gca,'xgrid','off');

sTotalTitle = ['In-store vs. Web Matching (' sTitle ', Place Name Involved)' ];
title(gca, sTotalTitle, 'FontName','Times New Roman', 'FontSize', 48);
set(gca,'FontName','Times New Roman', 'FontSize', 30);
xlabel('Accuracy', 'FontName','Times New Roman', 'FontSize', 44);    
ylabel('CDF','FontName','Times New Roman', 'FontSize', 44);

legend('5 In-store Pictures', '10 In-store Pictures', '15 In-store Pictures', '20 In-store Pictures', '25 In-store Pictures', ...
       '30 In-store Pictures', '35 In-store Pictures', '40 In-store Pictures', 'All In-store Pictures');

figure(2);
% Without Place Name
for j=1:length(mFrameCnt)
    mAccuracy = mTotalAccuracyWithoutPlaceName{j};
    [h, stats] = cdfplot(mAccuracy(:,1));
    hold on;
    set(h, 'linewidth', 3);

    if j ~= length(mFrameCnt)
        nColorIndex = mod(j, length(cellColorType));
        if nColorIndex == 0
            nColorIndex = length(cellColorType);
        end
        set(h, 'color', cellColorType{nColorIndex});
        if j > length(cellColorType)
            set(h, 'linestyle', '- -');
        else
            set(h, 'linestyle', '-');
        end
    else
        set(h, 'color', 'k');
        set(h, 'linestyle', '-');
    end
end

xlim([xTickStart 100]);
set(gca,'XTick',xTickStart:10:100);
set(gca,'ygrid','off');
set(gca,'xgrid','off');

sTotalTitle = ['In-store vs. Web Matching (' sTitle ', Place Name Not Involved)' ];
title(gca, sTotalTitle, 'FontName','Times New Roman', 'FontSize', 48);
set(gca,'FontName','Times New Roman', 'FontSize', 30);
xlabel('Accuracy', 'FontName','Times New Roman', 'FontSize', 44);    
ylabel('CDF','FontName','Times New Roman', 'FontSize', 44);

legend('5 In-store Pictures', '10 In-store Pictures', '15 In-store Pictures', '20 In-store Pictures', '25 In-store Pictures', ...
       '30 In-store Pictures', '35 In-store Pictures', '40 In-store Pictures', 'All In-store Pictures');
   
figure(3);
% Normal Version

nNumSigma = 3;
% With Place Name
for j=1:length(mFrameCnt)    
    x = linspace(mWithPlaceNameDistMean(j,1)-nNumSigma*mWithPlaceNameDistStd(j,1), mWithPlaceNameDistMean(j,1)+nNumSigma*mWithPlaceNameDistStd(j,1), 10000);
  
    if j ~= length(mFrameCnt)
        nColorIndex = mod(j, length(cellColorType));
        if nColorIndex == 0
            nColorIndex = length(cellColorType);
        end
        
        if j > length(cellColorType)
            plot(x, normcdf(x,mWithPlaceNameDistMean(j,1), mWithPlaceNameDistStd(j,1)), cellColorType{nColorIndex}, 'linestyle', '- -',  'linewidth', 3);
        else
            plot(x, normcdf(x,mWithPlaceNameDistMean(j,1), mWithPlaceNameDistStd(j,1)), cellColorType{nColorIndex}, 'linestyle', '-',  'linewidth', 3);
        end
    else
        plot(x, normcdf(x,mWithPlaceNameDistMean(j,1), mWithPlaceNameDistStd(j,1)), 'k', 'linestyle', '-',  'linewidth', 3)
    end
    
    hold on;  
end

xlim([xTickStart 100]);
set(gca,'XTick',xTickStart:10:100);
set(gca,'ygrid','off');
set(gca,'xgrid','off');

sTotalTitle = ['In-store vs. Web Matching (' sTitle ', Place Name Involved)' ];
title(gca, sTotalTitle, 'FontName','Times New Roman', 'FontSize', 48);
set(gca,'FontName','Times New Roman', 'FontSize', 30);
xlabel('Accuracy', 'FontName','Times New Roman', 'FontSize', 44);    
ylabel('CDF','FontName','Times New Roman', 'FontSize', 44);

legend('5 In-store Pictures', '10 In-store Pictures', '15 In-store Pictures', '20 In-store Pictures', '25 In-store Pictures', ...
       '30 In-store Pictures', '35 In-store Pictures', '40 In-store Pictures', 'All In-store Pictures');
 
figure(4);

% Without Place Name
for j=1:length(mFrameCnt)
    x = linspace(mWithoutPlaceNameDistMean(j,1)-nNumSigma*mWithoutPlaceNameDistStd(j,1), mWithoutPlaceNameDistMean(j,1)+nNumSigma*mWithoutPlaceNameDistStd(j,1), 10000);
    
    if j ~= length(mFrameCnt)
        nColorIndex = mod(j, length(cellColorType));
        if nColorIndex == 0
            nColorIndex = length(cellColorType);
        end
        
        if j > length(cellColorType)
            plot(x, normcdf(x,mWithoutPlaceNameDistMean(j,1), mWithoutPlaceNameDistStd(j,1)), cellColorType{nColorIndex}, 'linestyle', '- -',  'linewidth', 3);
        else
            plot(x, normcdf(x,mWithoutPlaceNameDistMean(j,1), mWithoutPlaceNameDistStd(j,1)), cellColorType{nColorIndex}, 'linestyle', '-',  'linewidth', 3);
        end
    else
        plot(x, normcdf(x,mWithoutPlaceNameDistMean(j,1), mWithoutPlaceNameDistStd(j,1)), 'k', 'linestyle', '-',  'linewidth', 3)
    end
    
    hold on;  
       
end   

xlim([xTickStart 100]);
set(gca,'XTick',xTickStart:10:100);
set(gca,'ygrid','off');
set(gca,'xgrid','off');

sTotalTitle = ['In-store vs. Web Matching (' sTitle ', Place Name Not Involved)' ];
title(gca, sTotalTitle, 'FontName','Times New Roman', 'FontSize', 48);
set(gca,'FontName','Times New Roman', 'FontSize', 30);
xlabel('Accuracy', 'FontName','Times New Roman', 'FontSize', 44);    
ylabel('CDF','FontName','Times New Roman', 'FontSize', 44);

legend('5 In-store Pictures', '10 In-store Pictures', '15 In-store Pictures', '20 In-store Pictures', '25 In-store Pictures', ...
       '30 In-store Pictures', '35 In-store Pictures', '40 In-store Pictures', 'All In-store Pictures');

return;

