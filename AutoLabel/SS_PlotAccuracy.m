function f = SS_PlotAccuracy()
% This function is used to plot the Rank1/Rank2/Rank3 accuracy for the matching between OCR and Candidate Web

%sParentFolder = 'E:\\UIUC\\Run\\201411_ForPaper_TF_Only\\Similarity\\OCR_Web\\All_OCR_All_Web\\';

%sParentFolder = 'E:\\UIUC\\Run\\201411_ForPaper_TF_Only\\Similarity\\OCR_Web\\Mall_OCR_Mall_Web\\';

%sParentFolder = 'E:\\UIUC\\Run\\201411_ForPaper\\Similarity\\OCR_Web\\Mall_Sub1_OCR_Mall_Sub1_Web\\';

%sParentFolder = 'E:\\UIUC\\Run\\201411_ForPaper\\Similarity\\OCR_Web\\Mall_Sub2_OCR_Mall_Sub2_Web\\';

%sParentFolder = 'E:\\UIUC\\Run\\201411_ForPaper_TF_Only\\Similarity\\OCR_Web\\Street_OCR_Street_Web\\';

%sBaseFolder = 'E:\\UIUC\\Run\\201411_ForPaper_TF_Only\\Accuracy\\';

sParentFolder = 'E:\\UIUC\\Run\\201411_ForPaper_TFIDF\\Similarity\\OCR_Web\\Mall_OCR_Mall_Web_FullText\\';

sBaseFolder = 'E:\\UIUC\\Run\\201411_ForPaper_TFIDF\\Accuracy_FullText\\';

AA = SS_SplitString(sParentFolder, '\');

sResultAccuracyUsingPlaceFile = [sBaseFolder  AA{length(AA)-1} '_Accuracy_UsingPlaceName.csv'];
fid_resultUsingPlace = fopen(sResultAccuracyUsingPlaceFile, 'w');


%mFrameCnt = [5 10 15 20 25 30 9999];   % 9999: all
mFrameCnt = [10 20 30 9999];   % 9999: all

% Using place name in matching
mAccuracyWithPlaceName = [];

for i=1:length(mFrameCnt)
    nFrameCnt = mFrameCnt(i);
    
    sWithPlaceNameRankFile = sprintf('%s%s%d.csv', sParentFolder, 'withPlaceName\\KeywordMatchingCM_withPlaceNameMatching_CorrectPlaceRanking_', nFrameCnt);

    mRank = SS_CalAccuracy(sWithPlaceNameRankFile);
    
    nCnt = mRank(1,1);
    nRank1 = mRank(1,2);
    nRank2 = mRank(1,3);
    nRank3 = mRank(1,4);
    
    mAccuracyWithPlaceName(i,1) = nRank1*1.0/nCnt*100;
    mAccuracyWithPlaceName(i,2) = nRank2*1.0/nCnt*100;
    mAccuracyWithPlaceName(i,3) = nRank3*1.0/nCnt*100;

% % %     mAccuracy(i,1) = 16*1.0/20*100;
% % %     mAccuracy(i,2) = 18*1.0/20*100;
% % %     mAccuracy(i,3) = 19*1.0/20*100

    fprintf(fid_resultUsingPlace, '%d, %f,%f,%f\n', mFrameCnt(i), mAccuracyWithPlaceName(i,1), mAccuracyWithPlaceName(i,2), mAccuracyWithPlaceName(i,3));
end

fclose(fid_resultUsingPlace);

% Without using place name in matching
sResultAccuracyNotUsingPlaceFile = [sBaseFolder  AA{length(AA)-1} '_Accuracy_NotUsingPlaceName.csv'];
fid_resultNotUsingPlace = fopen(sResultAccuracyNotUsingPlaceFile, 'w');

mAccuracyWithoutPlaceName = [];

for i=1:length(mFrameCnt)
    nFrameCnt = mFrameCnt(i);
    
    sWithoutPlaceNameRankFile = sprintf('%s%s%d.csv', sParentFolder, 'withoutPlaceName\\KeywordMatchingCM_withoutPlaceNameMatching_CorrectPlaceRanking_', nFrameCnt);
    
    mRank = SS_CalAccuracy(sWithoutPlaceNameRankFile);
    
    nCnt = mRank(1,1);
    nRank1 = mRank(1,2);
    nRank2 = mRank(1,3);
    nRank3 = mRank(1,4);
    
    mAccuracyWithoutPlaceName(i,1) = nRank1*1.0/nCnt*100;
    mAccuracyWithoutPlaceName(i,2) = nRank2*1.0/nCnt*100;
    mAccuracyWithoutPlaceName(i,3) = nRank3*1.0/nCnt*100;
 
    fprintf(fid_resultNotUsingPlace, '%d, %f,%f,%f\n', mFrameCnt(i), mAccuracyWithoutPlaceName(i,1), mAccuracyWithoutPlaceName(i,2), mAccuracyWithoutPlaceName(i,3));
    
end

fclose(fid_resultNotUsingPlace);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

screenSize = get(0, 'ScreenSize');

%%%%%%%%Plotting Accuracy for Using Place Name in Matching%%%%%%%%%%%%%%%
h1=figure('numbertitle', 'off', 'name', 'Accuracy of OCR-Web Matching (Using Place Name in Matching)');

bar(mAccuracyWithPlaceName, 1,'edgecolor','k', 'linewidth', 2); colormap(gray);

XTickTxt = {'10'; '20'; '30'; 'All';};

set(gca, 'FontName','Times New Roman');
set(gca, 'FontSize', 36);
        
set(gca, 'XTickLabel', XTickTxt);
set(gca,'YTick',0:5:100);
    
legend('Correct Place is Top 1 Matched Place', 'Correct Place in Top 2 Matched Places', 'Correct Place in Top 3 Matched Places');
    
xlabelStr = 'Number of In-store Pictures';

xlabel(xlabelStr, 'FontSize', 50);
ylabel('Accuracy (%)', 'FontSize', 50);
set(gca,'ygrid','on');
ylim([0 100]);

set(0, 'DefaultFigurePosition', screenSize);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%Plotting Accuracy for Without Using Place Name in Matching%%%%%%%%%%%%%%%
h1=figure('numbertitle', 'off', 'name', 'Accuracy of OCR-Web Matching (Without Using Place Name in Matching)');

bar(mAccuracyWithoutPlaceName, 1,'edgecolor','k', 'linewidth', 2); colormap(gray);

XTickTxt = {'10'; '20'; '30'; 'All';};

set(gca, 'FontName','Times New Roman');
set(gca, 'FontSize', 36);
        
set(gca, 'XTickLabel', XTickTxt);
set(gca,'YTick',0:5:100);
    
legend('Correct Place is Top 1 Matched Place', 'Correct Place in Top 2 Matched Places', 'Correct Place in Top 3 Matched Places');
    
xlabelStr = 'Number of In-store Pictures';

xlabel(xlabelStr, 'FontSize', 50);
ylabel('Accuracy (%)', 'FontSize', 50);
set(gca,'ygrid','on');
ylim([0 100]);

set(0, 'DefaultFigurePosition', screenSize);



return;

