function f = SS_PlotAccuracy_CompareStrategy()
% This function is used to compare Menu Item vs Full Text strategies

sParentFolderA = 'E:\\UIUC\\Run\\201411_ForPaper_TFIDF\\Similarity\\OCR_Web\\Mall_OCR_Mall_Web\\';

sParentFolderB = 'E:\\UIUC\\Run\\201411_ForPaper_TFIDF\\Similarity\\OCR_Web\\Mall_OCR_Mall_Web_FullText\\';

%mFrameCnt = [5 10 15 20 25 30 9999];   % 9999: all
mFrameCnt = [10 20 30 9999];   % 9999: all

% Using place name in matching
mAccuracyWithPlaceName = [];

for i=1:length(mFrameCnt)
    nFrameCnt = mFrameCnt(i);
    
    % Strategy A
    sWithPlaceNameRankFileA = sprintf('%s%s%d.csv', sParentFolderA, 'withPlaceName\\KeywordMatchingCM_withPlaceNameMatching_CorrectPlaceRanking_', nFrameCnt);

    mRankA = SS_CalAccuracy(sWithPlaceNameRankFileA);
    
    nCntA = mRankA(1,1);
    nRankA1 = mRankA(1,2);
    nRankA2 = mRankA(1,3);
    nRankA3 = mRankA(1,4);

    % Strategy B
    sWithPlaceNameRankFileB = sprintf('%s%s%d.csv', sParentFolderB, 'withPlaceName\\KeywordMatchingCM_withPlaceNameMatching_CorrectPlaceRanking_', nFrameCnt);

    mRankB = SS_CalAccuracy(sWithPlaceNameRankFileB);
    
    nCntB = mRankB(1,1);
    nRankB1 = mRankB(1,2);
    nRankB2 = mRankB(1,3);
    nRankB3 = mRankB(1,4);
   
    
    mAccuracyWithPlaceName(i,1) = nRankA1*1.0/nCntA*100;
    mAccuracyWithPlaceName(i,2) = nRankB1*1.0/nCntB*100;

end


% Without using place name in matching

mAccuracyWithoutPlaceName = [];

for i=1:length(mFrameCnt)
    nFrameCnt = mFrameCnt(i);
    
    % Strategy A
    sWithoutPlaceNameRankFileA = sprintf('%s%s%d.csv', sParentFolderA, 'withoutPlaceName\\KeywordMatchingCM_withoutPlaceNameMatching_CorrectPlaceRanking_', nFrameCnt);
    
    mRankA = SS_CalAccuracy(sWithoutPlaceNameRankFileA);
    
    nCntA = mRankA(1,1);
    nRankA1 = mRankA(1,2);
    nRankA2 = mRankA(1,3);
    nRankA3 = mRankA(1,4);
    
    % Strategy B
    sWithoutPlaceNameRankFileB = sprintf('%s%s%d.csv', sParentFolderB, 'withoutPlaceName\\KeywordMatchingCM_withoutPlaceNameMatching_CorrectPlaceRanking_', nFrameCnt);
    
    mRankB = SS_CalAccuracy(sWithoutPlaceNameRankFileB);
    
    nCntB = mRankB(1,1);
    nRankB1 = mRankB(1,2);
    nRankB2 = mRankB(1,3);
    nRankB3 = mRankB(1,4);
    
    mAccuracyWithoutPlaceName(i,1) = nRankA1*1.0/nCntA*100;
    mAccuracyWithoutPlaceName(i,2) = nRankB1*1.0/nCntB*100;
     
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

screenSize = get(0, 'ScreenSize');
figure(1);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%Plotting Accuracy for Without Using Place Name in Matching%%%%%%%%%%%%%%%
%h1=figure('numbertitle', 'off', 'name', 'Comparision of Accuracy of In-store vs. Web Matching (Without Using Place Name in Matching)');
subplot(1,2,1);
bar(mAccuracyWithoutPlaceName, 1,'edgecolor','k', 'linewidth', 2); colormap(gray);

title(gca, 'Place Name Not Involved', 'FontName','Times New Roman', 'FontSize', 50);

XTickTxt = {'10'; '20'; '30'; 'All';};

set(gca, 'FontName','Times New Roman');
set(gca, 'FontSize', 36)
        
set(gca, 'FontSize', 36)
set(gca, 'XTickLabel', XTickTxt);
set(gca,'YTick',0:5:100);
    
legend('Non Full-Text Matching', 'Full-Text Matching');
    
xlabelStr = 'Number of In-store Pictures';

xlabel(xlabelStr, 'FontSize', 50);
ylabel('Accuracy (%)', 'FontSize', 50);
set(gca,'ygrid','on');
ylim([0 100]);

set(0, 'DefaultFigurePosition', screenSize);

%%%%%%%%Plotting Accuracy for Using Place Name in Matching%%%%%%%%%%%%%%%
%h1=figure('numbertitle', 'off', 'name', 'Comparision of Accuracy of In-store vs. Web Matching (Using Place Name in Matching)');
subplot(1,2,2);

bar(mAccuracyWithPlaceName, 1,'edgecolor','k', 'linewidth', 2); colormap(gray);

title(gca, 'Place Name Involved', 'FontName','Times New Roman', 'FontSize', 50);


XTickTxt = {'10'; '20'; '30'; 'All';};

set(gca, 'FontName','Times New Roman');
set(gca, 'FontSize', 36)
        
set(gca, 'FontSize', 36)
set(gca, 'XTickLabel', XTickTxt);
set(gca,'YTick',0:5:100);
    
%legend('Non Full-Text Matching', 'Full-Text Matching');
    
xlabelStr = 'Number of In-store Pictures';

xlabel(xlabelStr, 'FontSize', 50);
ylabel('Accuracy (%)', 'FontSize', 50);
set(gca,'ygrid','on');
ylim([0 100]);

set(0, 'DefaultFigurePosition', screenSize);


return;

