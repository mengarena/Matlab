function f = SS_CalMatchingAccuracyDist_BAR()
% This function calculate the accuracy (for top 1, top 2 and top 3) for Subset OCR vs. Web matching
% It process files under topfolder/1, topfolder/2,...
% In each folder, there are "withPlaceName", "withoutPlaceName",
% Under these folders, this function process KeywordMatchingCM_with/withoutPlaceNameMatching_CorrectPlaceRanking_xx.csv files to calcualte the accuracy
% 
%
% This is for BAR + (ERROR BAR) chart !
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%sParentFolder = 'E:\UIUC\Run\201411_ForPaper_TFIDF\Similarity\OCR_Web_Subset\20Place';

sParentFolder = 'E:\UIUC\Run\201411_ForPaper_TFIDF\Similarity\OCR_Web_Subset_MultipleIndexSet\20Place';
sTitle = '20-store Subset';

format long;

mFrameCnt = [10 20 30 9999];   % 9999: all
%mFrameCnt = [5 10 15 20 25 30 35 40 9999];   % 9999: all

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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
mWithPlaceNameDistStdUp = [];
mWithPlaceNameDistStdDown = [];

mWithoutPlaceNameDistStdUp = [];
mWithoutPlaceNameDistStdDown = [];

for j=1:length(mFrameCnt)
    % With Place Name
    for i=1:3
        if mWithPlaceNameDistMean(j,i) - mWithPlaceNameDistStd(j,i) >= 0
            mWithPlaceNameDistStdDown(j,i) = mWithPlaceNameDistStd(j,i);
        else
            mWithPlaceNameDistStdDown(j,i) = mWithPlaceNameDistMean(j,i);
        end
    
        if mWithPlaceNameDistMean(j,i) + mWithPlaceNameDistStd(j,i) <= 100
            mWithPlaceNameDistStdUp(j,i) = mWithPlaceNameDistStd(j,i);
        else
            mWithPlaceNameDistStdUp(j,i) = 100 - mWithPlaceNameDistMean(j,i);
        end
    end
    
    % Without Place Name
    for i=1:3
        if mWithoutPlaceNameDistMean(j,i) - mWithoutPlaceNameDistStd(j,i) >= 0
            mWithoutPlaceNameDistStdDown(j,i) = mWithoutPlaceNameDistStd(j,i);
        else
            mWithoutPlaceNameDistStdDown(j,i) = mWithoutPlaceNameDistMean(j,i);
        end
    
        if mWithoutPlaceNameDistMean(j,i) + mWithoutPlaceNameDistStd(j,i) <= 100
            mWithoutPlaceNameDistStdUp(j,i) = mWithoutPlaceNameDistStd(j,i);
        else
            mWithoutPlaceNameDistStdUp(j,i) = 100 - mWithoutPlaceNameDistMean(j,i);
        end
    end    
    
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Here below could plot time bar for Img Reception with standard deviation
figure('numbertitle', 'off', 'name', 'Accuracy of OCR-Web Matching');


XTickTxt = {'10'; '20'; '30'; 'All'};
%XTickTxt = {'5'; '10'; '15'; '20'; '25'; '30'; '35'; '40'; 'All'};

width=1;

% With Place Name
subplot(1,2,2);
%figure(1);

barHandle = bar(mWithPlaceNameDistMean, width,'edgecolor','k', 'linewidth', 2); 

hold on;

tmp = [];
for ii=1:length(mFrameCnt)
    for j = 1:3
        tmp(ii,j) = 0;
    end
end

for j = 1:3
    x = get(get(barHandle(j),'children'), 'xdata');

    x = mean(x([1 3],:));
    errorbar(x, mWithPlaceNameDistMean(:,j),  mWithPlaceNameDistStdDown(:,j), mWithPlaceNameDistStdUp(:,j), 'k', 'linestyle', 'none', 'linewidth', 3); %

end


sTotalTitle = ['In-store vs. Web Matching (' sTitle ', Place Name Involved)'];

title(gca, sTotalTitle, 'FontName','Times New Roman', 'FontSize', 24);  %44

set(gca, 'XTickLabel', XTickTxt, 'FontName','Times New Roman', 'FontSize', 24);  %30

%legend('Correct Place is Top 1 Matched Place', 'Correct Place in Top 2 Matched Places', 'Correct Place in Top 3 Matched Places');

xlabelStr = 'Number of In-store Pictures';
xlabel(xlabelStr, 'FontName','Times New Roman', 'FontSize', 24);    
ylabel('Accuracy (%)','FontName','Times New Roman', 'FontSize', 24);
set(gca,'ygrid','on');
ylim([0 100]);
set(gca,'YTick',0:10:100);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Without Place Name
subplot(1,2,1);
%figure(2);

barHandle = bar(mWithoutPlaceNameDistMean, width,'edgecolor','k', 'linewidth', 2); 

hold on;

tmp = [];
for ii=1:length(mFrameCnt)
    for j = 1:3
        tmp(ii,j) = 0;
    end
end

for j = 1:3
    x = get(get(barHandle(j),'children'), 'xdata');

    x = mean(x([1 3],:));
    errorbar(x, mWithoutPlaceNameDistMean(:,j), mWithoutPlaceNameDistStdDown(:,j), mWithoutPlaceNameDistStdUp(:,j), 'k', 'linestyle', 'none', 'linewidth', 3); %

end

sTotalTitle = ['In-store vs. Web Matching (' sTitle ', Place Name Not Involved)'];

title(gca, sTotalTitle, 'FontName','Times New Roman', 'FontSize', 24);

set(gca, 'XTickLabel', XTickTxt, 'FontName','Times New Roman', 'FontSize', 24);
legend('Correct Place is Top 1 Matched Place', 'Correct Place in Top 2 Matched Places', 'Correct Place in Top 3 Matched Places');

xlabelStr = 'Number of In-store Pictures';
xlabel(xlabelStr, 'FontName','Times New Roman', 'FontSize', 24);    
ylabel('Accuracy (%)','FontName','Times New Roman', 'FontSize', 24);
set(gca,'ygrid','on');
ylim([0 100]);
set(gca,'YTick',0:10:100);

f=0;

return;

