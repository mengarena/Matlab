function f = SS_CalMatchingAccuracyDist_BAR_VaryingPlaceNum()
% This function calculate the accuracy (for top 1, top 2 and top 3) for Subset OCR vs. Web matching
% It process files under topfolder/1, topfolder/2,...
% In each folder, there are "withPlaceName", "withoutPlaceName",
% Under these folders, this function process KeywordMatchingCM_with/withoutPlaceNameMatching_CorrectPlaceRanking_xx.csv files to calcualte the accuracy
% 
%
% This is for BAR + (ERROR BAR) chart !
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%sParentFolder = 'E:\UIUC\Run\201411_ForPaper_TFIDF\Similarity\OCR_Web_Subset\20Place';

sParentFolderA = 'E:\UIUC\Run\201411_ForPaper_TFIDF\Similarity\OCR_Web_Subset_MultipleIndexSet_withCA6\5Place';
sParentFolderB = 'E:\UIUC\Run\201411_ForPaper_TFIDF\Similarity\OCR_Web_Subset_MultipleIndexSet_withCA6\10Place';
sParentFolderC = 'E:\UIUC\Run\201411_ForPaper_TFIDF\Similarity\OCR_Web_Subset_MultipleIndexSet_withCA6\15Place';
sParentFolderD = 'E:\UIUC\Run\201411_ForPaper_TFIDF\Similarity\OCR_Web_Subset_MultipleIndexSet_withCA6\20Place';

sTitle = 'Area';

format long;

mFrameCnt = [10 20 30 40 9999];   % 9999: all
%mFrameCnt = [5 10 15 20 25 30 35 40 9999];   % 9999: all

sWithoutPlaceNameSubFolder = 'withoutPlaceName';
sWithPlaceNameSubFolder = 'withPlaceName';

%Files = dir(sParentFolder);

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

for i=1:4    % 4 types of place numbers
   if i==1
       Files = dir(sParentFolderA);
       sParentFolder = sParentFolderA;
   elseif i==2
       Files = dir(sParentFolderB);
       sParentFolder = sParentFolderB;
   elseif i==3
       Files = dir(sParentFolderC);
       sParentFolder = sParentFolderC;
   else
       Files = dir(sParentFolderD);
       sParentFolder = sParentFolderD;
   end
    
   for j=1:length(mFrameCnt)
       nFrameCnt = mFrameCnt(j);
       
       % With Place Name
       nWithPlaceNameCnt = 0;
       mAccuracyWithPlaceNameTmp = [];
       
       for k=3:length(Files)
           sFullFolderPath = [sParentFolder '\' Files(k).name];

           if isdir(sFullFolderPath) == 1

               sFullFolderPath = [sFullFolderPath '\' sWithPlaceNameSubFolder];
               sRankFile = sprintf('%s%s%d.csv', sFullFolderPath, '\\KeywordMatchingCM_withPlaceNameMatching_CorrectPlaceRanking_', nFrameCnt);

               mRank = SS_CalAccuracy(sRankFile);

               nCnt = mRank(1,1);
               nRank1 = mRank(1,2);

               nWithPlaceNameCnt = nWithPlaceNameCnt + 1;
               mAccuracyWithPlaceNameTmp(nWithPlaceNameCnt,1) = nRank1*1.0/nCnt*100;
           end  
       end
       
       % Only Top Hit
       mWithPlaceNameDistMean(i,j) = mean(mAccuracyWithPlaceNameTmp(:,1))
       mWithPlaceNameDistStd(i,j) = std(mAccuracyWithPlaceNameTmp(:,1));
       mWithPlaceNameDistMax(i,j) = max(mAccuracyWithPlaceNameTmp(:,1));
       mWithPlaceNameDistMin(i,j) = min(mAccuracyWithPlaceNameTmp(:,1));

       % Without Place Name
       nWithoutPlaceNameCnt = 0;
       mAccuracyWithoutPlaceNameTmp = [];
       
       for k=3:length(Files)
           sFullFolderPath = [sParentFolder '\' Files(k).name];

           if isdir(sFullFolderPath) == 1

               sFullFolderPath = [sFullFolderPath '\' sWithoutPlaceNameSubFolder];
               sRankFile = sprintf('%s%s%d.csv', sFullFolderPath, '\\KeywordMatchingCM_withoutPlaceNameMatching_CorrectPlaceRanking_', nFrameCnt);

               mRank = SS_CalAccuracy(sRankFile);

               nCnt = mRank(1,1);
               nRank1 = mRank(1,2);

               nWithoutPlaceNameCnt = nWithoutPlaceNameCnt + 1;
               mAccuracyWithoutPlaceNameTmp(nWithoutPlaceNameCnt,1) = nRank1*1.0/nCnt*100;
           end  
       end
       
       % Only Top Hit
       mWithoutPlaceNameDistMean(i,j) = mean(mAccuracyWithoutPlaceNameTmp(:,1));
       mWithoutPlaceNameDistStd(i,j) = std(mAccuracyWithoutPlaceNameTmp(:,1));
       mWithoutPlaceNameDistMax(i,j) = max(mAccuracyWithoutPlaceNameTmp(:,1));
       mWithoutPlaceNameDistMin(i,j) = min(mAccuracyWithoutPlaceNameTmp(:,1));
       
   end
     
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
mWithPlaceNameDistStdUp = [];
mWithPlaceNameDistStdDown = [];

mWithoutPlaceNameDistStdUp = [];
mWithoutPlaceNameDistStdDown = [];

for i=1:4
    % With Place Name
    for j=1:length(mFrameCnt)
        if mWithPlaceNameDistMean(i,j) - mWithPlaceNameDistStd(i,j) >= 0
            mWithPlaceNameDistStdDown(i,j) = mWithPlaceNameDistStd(i,j);
        else
            mWithPlaceNameDistStdDown(i,j) = mWithPlaceNameDistMean(i,j);
        end
    
        if mWithPlaceNameDistMean(i,j) + mWithPlaceNameDistStd(i,j) <= 100
            mWithPlaceNameDistStdUp(i,j) = mWithPlaceNameDistStd(i,j);
        else
            mWithPlaceNameDistStdUp(i,j) = 100 - mWithPlaceNameDistMean(i,j);
        end
    end
    
    % Without Place Name
    for j=1:length(mFrameCnt)
        if mWithoutPlaceNameDistMean(i,j) - mWithoutPlaceNameDistStd(i,j) >= 0
            mWithoutPlaceNameDistStdDown(i,j) = mWithoutPlaceNameDistStd(i,j);
        else
            mWithoutPlaceNameDistStdDown(i,j) = mWithoutPlaceNameDistMean(i,j);
        end
    
        if mWithoutPlaceNameDistMean(i,j) + mWithoutPlaceNameDistStd(i,j) <= 100
            mWithoutPlaceNameDistStdUp(i,j) = mWithoutPlaceNameDistStd(i,j);
        else
            mWithoutPlaceNameDistStdUp(i,j) = 100 - mWithoutPlaceNameDistMean(i,j);
        end
    end    
    
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Here below could plot time bar for Img Reception with standard deviation
%figure('numbertitle', 'off', 'name', 'Accuracy of OCR-Web Matching');


XTickTxt = {'5'; '10'; '15'; '20'};

width=1;

% With Place Name
%subplot(1,2,2);
figure(1);

barHandle = bar(mWithPlaceNameDistMean, width,'edgecolor','k', 'linewidth', 2); 

hold on;

tmp = [];
for ii=1:4
    for j = 1:length(mFrameCnt)
        tmp(ii,j) = 0;
    end
end

for j = 1:length(mFrameCnt)
    x = get(get(barHandle(j),'children'), 'xdata');

    x = mean(x([1 3],:));
    errorbar(x, mWithPlaceNameDistMean(:,j),  mWithPlaceNameDistStdDown(:,j), mWithPlaceNameDistStdUp(:,j), 'k', 'linestyle', 'none', 'linewidth', 3); %

end


sTotalTitle = ['Store vs. Web Text Matching (' sTitle ', Place Name Involved)'];

title(gca, sTotalTitle, 'FontName','Times New Roman', 'FontSize', 50);  %44

set(gca, 'XTickLabel', XTickTxt, 'FontName','Times New Roman', 'FontSize', 40);  %30

legend('10 Store Pictures', '20 Store Pictures', '30 Store Pictures', '40 Store Pictures', 'All Store Pictures');

xlabelStr = 'Number of Stores in Area';
xlabel(xlabelStr, 'FontName','Times New Roman', 'FontSize', 50);    
ylabel('Accuracy (%)','FontName','Times New Roman', 'FontSize', 50);
set(gca,'ygrid','on');
ylim([0 100]);
set(gca,'YTick',0:10:100);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Without Place Name
%subplot(1,2,1);
figure(2);

barHandle = bar(mWithoutPlaceNameDistMean, width,'edgecolor','k', 'linewidth', 2); 

hold on;

tmp = [];
for ii=1:4
    for j = 1:length(mFrameCnt)
        tmp(ii,j) = 0;
    end
end

for j = 1:length(mFrameCnt)
    x = get(get(barHandle(j),'children'), 'xdata');

    x = mean(x([1 3],:));
    errorbar(x, mWithoutPlaceNameDistMean(:,j), mWithoutPlaceNameDistStdDown(:,j), mWithoutPlaceNameDistStdUp(:,j), 'k', 'linestyle', 'none', 'linewidth', 3); %

end

sTotalTitle = ['Store vs. Web Text Matching (' sTitle ', Place Name Not Involved)'];

title(gca, sTotalTitle, 'FontName','Times New Roman', 'FontSize', 50);

set(gca, 'XTickLabel', XTickTxt, 'FontName','Times New Roman', 'FontSize', 40);
legend('10 Store Pictures', '20 Store Pictures', '30 Store Pictures', '40 Store Pictures', 'All Store Pictures');

xlabel(xlabelStr, 'FontName','Times New Roman', 'FontSize', 50);    
ylabel('Accuracy (%)','FontName','Times New Roman', 'FontSize', 50);
set(gca,'ygrid','on');
ylim([0 100]);
set(gca,'YTick',0:10:100);

f=0;

return;

