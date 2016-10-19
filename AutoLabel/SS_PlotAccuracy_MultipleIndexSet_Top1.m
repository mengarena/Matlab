function f = SS_PlotAccuracy_MultipleIndexSet_Top1()
% This function is used to plot the Rank1/Rank2/Rank3 accuracy for the matching between OCR and Candidate Web

%sParentFolder = 'E:\\UIUC\\Run\\201411_ForPaper_TFIDF\\Similarity\\OCR_Web\\All_OCR_All_Web_MultipleIndexSet\\';

%sParentFolder = 'E:\\UIUC\\Run\\201411_ForPaper_TFIDF\\Similarity\\OCR_Web\\Mall_OCR_Mall_Web_MultipleIndexSet\\';

%sParentFolder = 'E:\\UIUC\\Run\\201411_ForPaper_TFIDF\\Similarity\\OCR_Web\\Street_OCR_Street_Web_MultipleIndexSet\\';

%sBaseFolder = 'E:\\UIUC\\Run\\201411_ForPaper_TFIDF\\Accuracy_MultipleIndexSet\\';

% sParentFolder = 'E:\\UIUC\\Run\\201411_ForPaper_TFIDF\\Similarity\\OCR_Web\\Mall_OCR_Mall_Web_FullText_MultipleIndexSet\\';
% 
% sBaseFolder = 'E:\\UIUC\\Run\\201411_ForPaper_TFIDF\\Accuracy_FullText_MultipleIndexSet\\';

%sParentFolder = 'E:\\UIUC\\Run\\201411_ForPaper_TFIDF\\Similarity\\OCR_Web\\Mall_OCR_Mall_Web_MultipleIndexSet\\';

sParentFolder = 'E:\\UIUC\\Run\\201411_ForPaper_TFIDF\\Similarity\\OCR_Web\\Street_OCR_Street_Web_MultipleIndexSet\\';

sBaseFolder = 'E:\\UIUC\\Run\\201411_ForPaper_TFIDF\\Accuracy_MultipleIndexSet\\';

% subTitle = 'All Places';
subTitle = 'Mall';
%subTitle = 'Mall, Full-Text';
% subTitle = 'Street'

% sFilePostfix = 'All';
% sFilePostfix = 'Mall';
% sFilePostfix = 'Mall_FullText';
sFilePostfix = 'Street';

AA = SS_SplitString(sParentFolder, '\');

sResultAccuracyUsingPlaceFile = [sBaseFolder  AA{length(AA)-1} '_Accuracy_UsingPlaceName_' sFilePostfix '_Top1.csv'];
fid_resultUsingPlace = fopen(sResultAccuracyUsingPlaceFile, 'w');



% mFrameCnt = [10 20 30 9999];   % 9999: all
% XTickTxt = {'10'; '20'; '30'; 'All';};

mFrameCnt = [5 10 15 20 25 30 35 40 9999];   % 9999: all
XTickTxt = {'5'; '10'; '15'; '20';'25'; '30';'35'; '40'; 'All';};


% Using place name in matching
mAccuracyWithPlaceNameMean = [];
mAccuracyWithPlaceNameStd = [];

for i=1:length(mFrameCnt)
    nFrameCnt = mFrameCnt(i);
    
    sWithPlaceNameRankFile = sprintf('%s%s%d.csv', sParentFolder, 'withPlaceName\\KeywordMatchingCM_withPlaceNameMatching_CorrectPlaceRanking_', nFrameCnt);

    mAccuracy = SS_CalAccuracy_MultipleIndexSet(sWithPlaceNameRankFile);
    
    for j=1:1
        mAccuracyWithPlaceNameMean(i,j) = mAccuracy((j-1)*2+1);
        mAccuracyWithPlaceNameStd(i,j) = mAccuracy(j*2);
    end

    fprintf(fid_resultUsingPlace, '%d,%f,%f\n', mFrameCnt(i), mAccuracyWithPlaceNameMean(i,1), mAccuracyWithPlaceNameStd(i,1));
end

fclose(fid_resultUsingPlace);

% Without using place name in matching
sResultAccuracyNotUsingPlaceFile = [sBaseFolder  AA{length(AA)-1} '_Accuracy_NotUsingPlaceName_' sFilePostfix '_Top1.csv'];
fid_resultNotUsingPlace = fopen(sResultAccuracyNotUsingPlaceFile, 'w');

mAccuracyWithoutPlaceNameMean = [];
mAccuracyWithoutPlaceNameStd = [];

for i=1:length(mFrameCnt)
    nFrameCnt = mFrameCnt(i);
    
    sWithoutPlaceNameRankFile = sprintf('%s%s%d.csv', sParentFolder, 'withoutPlaceName\\KeywordMatchingCM_withoutPlaceNameMatching_CorrectPlaceRanking_', nFrameCnt);
    
    mAccuracy = SS_CalAccuracy_MultipleIndexSet(sWithoutPlaceNameRankFile);
    
     for j=1:1
        mAccuracyWithoutPlaceNameMean(i,j) = mAccuracy((j-1)*2+1);
        mAccuracyWithoutPlaceNameStd(i,j) = mAccuracy(j*2);
    end

    fprintf(fid_resultUsingPlace, '%d,%f,%f\n', mFrameCnt(i), mAccuracyWithoutPlaceNameMean(i,1), mAccuracyWithoutPlaceNameStd(i,1));
    
end

fclose(fid_resultNotUsingPlace);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
mAccuracyWithPlaceNameDistStdUp = [];
mAccuracyWithPlaceNameDistStdDown = [];

mAccuracyWithoutPlaceNameDistStdUp = [];
mAccuracyWithoutPlaceNameDistStdDown = [];

for j=1:length(mFrameCnt)
     % With Place Name
    if j == length(mFrameCnt)
        mAccuracyWithPlaceNameDistStdDown(j,i) = 0;
        mAccuracyWithPlaceNameDistStdUp(j,i) = 0;
    else
        for i=1:1
            if mAccuracyWithPlaceNameMean(j,i) - mAccuracyWithPlaceNameStd(j,i) >= 0
                mAccuracyWithPlaceNameDistStdDown(j,i) = mAccuracyWithPlaceNameStd(j,i);
            else
                mAccuracyWithPlaceNameDistStdDown(j,i) = mAccuracyWithPlaceNameMean(j,i);
            end

            if mAccuracyWithPlaceNameMean(j,i) + mAccuracyWithPlaceNameStd(j,i) <= 100
                mAccuracyWithPlaceNameDistStdUp(j,i) = mAccuracyWithPlaceNameStd(j,i);
            else
                mAccuracyWithPlaceNameDistStdUp(j,i) = 100 - mAccuracyWithPlaceNameMean(j,i);
            end
        end
    end
    
    % Without Place Name
    if j == length(mFrameCnt)
        mAccuracyWithoutPlaceNameDistStdDown(j,i) = 0;
        mAccuracyWithoutPlaceNameDistStdUp(j,i) = 0;
    else
        for i=1:1
            if mAccuracyWithoutPlaceNameMean(j,i) - mAccuracyWithoutPlaceNameStd(j,i) >= 0
                mAccuracyWithoutPlaceNameDistStdDown(j,i) = mAccuracyWithoutPlaceNameStd(j,i);
            else
                mAccuracyWithoutPlaceNameDistStdDown(j,i) = mAccuracyWithoutPlaceNameMean(j,i);
            end

            if mAccuracyWithoutPlaceNameMean(j,i) + mAccuracyWithoutPlaceNameStd(j,i) <= 100
                mAccuracyWithoutPlaceNameDistStdUp(j,i) = mAccuracyWithoutPlaceNameStd(j,i);
            else
                mAccuracyWithoutPlaceNameDistStdUp(j,i) = 100 - mAccuracyWithoutPlaceNameMean(j,i);
            end
        end
    end
    
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
screenSize = get(0, 'ScreenSize');

%%%%%%%%Plotting Accuracy for Using Place Name in Matching%%%%%%%%%%%%%%%
h1=figure('numbertitle', 'off', 'name', 'Accuracy of OCR-Web Matching (Using Place Name in Matching)');

barHandle = bar(mAccuracyWithPlaceNameMean, 0.5,'edgecolor','k', 'linewidth', 1); 

hold on;


for j = 1:1
    x = get(get(barHandle(j),'children'), 'xdata');

    x = mean(x([2 3],1:length(mFrameCnt)-1));
        
    errorbar(x, mAccuracyWithPlaceNameMean(1:length(mFrameCnt)-1,j),  mAccuracyWithPlaceNameDistStdDown(1:length(mFrameCnt)-1,j), mAccuracyWithPlaceNameDistStdUp(1:length(mFrameCnt)-1,j), 'k', 'linestyle', 'none', 'linewidth', 3); %  
end


set(gca, 'FontName','Times New Roman');
set(gca, 'FontSize', 36);
        
set(gca, 'XTickLabel', XTickTxt);
set(gca,'YTick',0:10:100);
    
%legend('Correct Place is Top 1 Matched Place', 'Correct Place in Top 2 Matched Places', 'Correct Place in Top 3 Matched Places');

sTotalTitle = ['In-store vs. Web Matching (' subTitle ', Place Name Involved)'];

title(gca, sTotalTitle, 'FontName','Times New Roman', 'FontSize', 50);

xlabelStr = 'Number of In-store Pictures';

xlabel(xlabelStr, 'FontSize', 50);
ylabel('Accuracy (%)', 'FontSize', 50);
set(gca,'ygrid','on');
ylim([0 100]);

set(0, 'DefaultFigurePosition', screenSize);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%Plotting Accuracy for Without Using Place Name in Matching%%%%%%%%%%%%%%%
h1=figure('numbertitle', 'off', 'name', 'Accuracy of OCR-Web Matching (Without Using Place Name in Matching)');

barHandle = bar(mAccuracyWithoutPlaceNameMean, 0.5,'edgecolor','k', 'linewidth', 1); 

hold on;

for j = 1:1
    x = get(get(barHandle(j),'children'), 'xdata');

    x = mean(x([2 3],1:length(mFrameCnt)-1));

    errorbar(x, mAccuracyWithoutPlaceNameMean(1:length(mFrameCnt)-1,j),  mAccuracyWithoutPlaceNameDistStdDown(1:length(mFrameCnt)-1,j), mAccuracyWithoutPlaceNameDistStdUp(1:length(mFrameCnt)-1,j), 'k', 'linestyle', 'none', 'linewidth', 3);             
end




set(gca, 'FontName','Times New Roman');
set(gca, 'FontSize', 36);
        
set(gca, 'XTickLabel', XTickTxt);
set(gca,'YTick',0:10:100);
    
sTotalTitle = ['In-store vs. Web Matching (' subTitle ', Place Name Not Involved)'];

title(gca, sTotalTitle, 'FontName','Times New Roman', 'FontSize', 50);

xlabelStr = 'Number of In-store Pictures';

xlabel(xlabelStr, 'FontSize', 50);
ylabel('Accuracy (%)', 'FontSize', 50);
set(gca,'ygrid','on');
ylim([0 100]);

set(0, 'DefaultFigurePosition', screenSize);

return;

