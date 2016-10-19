function f = SS_PlotAccuracy_FullText_NonFullText()
% This function is used to plot the Rank1/Rank2/Rank3 accuracy for the matching between OCR and Candidate Web

sParentFolderA = 'E:\\UIUC\\Run\\201411_ForPaper_TFIDF\\Similarity\\OCR_Web\\Mall_OCR_Mall_Web_MultipleIndexSet\\';
sParentFolderB = 'E:\\UIUC\\Run\\201411_ForPaper_TFIDF\\Similarity\\OCR_Web\\Mall_OCR_Mall_Web_FullText_MultipleIndexSet\\';

sBaseFolder = 'E:\\UIUC\\Run\\201411_ForPaper_TFIDF\\Accuracy_FullText_NonFullText_MultipleIndexSet\\';

subTitle = 'Non-Full-Text vs. Full-Text';

sFilePostfix = 'Mall_FullText_NonFullText_MultipleIndexSet';

% mFrameCnt = [10 20 30 40 9999];   % 9999: all
% XTickTxt = {'10'; '20'; '30'; '40'; 'All';};

mFrameCnt = [5 10 15 20 25 30 35 40 9999];   % 9999: all
XTickTxt = {'5'; '10'; '15'; '20';'25'; '30';'35'; '40'; 'All';};

% Using place name in matching
mAccuracyWithPlaceNameMean = [];
mAccuracyWithPlaceNameStd = [];

mAccuracyWithoutPlaceNameMean = [];
mAccuracyWithoutPlaceNameStd = [];

sResultAccuracyUsingPlaceFile = [sBaseFolder 'Accuracy_UsingPlaceName_' sFilePostfix '.csv'];
fid_resultUsingPlace = fopen(sResultAccuracyUsingPlaceFile, 'w');

sResultAccuracyNotUsingPlaceFile = [sBaseFolder 'Accuracy_NotUsingPlaceName_' sFilePostfix '.csv'];
fid_resultNotUsingPlace = fopen(sResultAccuracyNotUsingPlaceFile, 'w');

for i=1:length(mFrameCnt)
    nFrameCnt = mFrameCnt(i);
    
    for j=1:2
        if j==1
            sParentFolder = sParentFolderA;
        else
            sParentFolder = sParentFolderB;            
        end
        
        % Using place name in matching
        sWithPlaceNameRankFile = sprintf('%s%s%d.csv', sParentFolder, 'withPlaceName\\KeywordMatchingCM_withPlaceNameMatching_CorrectPlaceRanking_', nFrameCnt);

        mAccuracy = SS_CalAccuracy_MultipleIndexSet(sWithPlaceNameRankFile);

        mAccuracyWithPlaceNameMean(i,j) = mAccuracy(1);
        mAccuracyWithPlaceNameStd(i,j) = mAccuracy(2);

        fprintf(fid_resultUsingPlace, '%d,%f,%f\n', nFrameCnt, mAccuracyWithPlaceNameMean(i,j), mAccuracyWithPlaceNameStd(i,j));
 
        % Without using place name in matching
        sWithoutPlaceNameRankFile = sprintf('%s%s%d.csv', sParentFolder, 'withoutPlaceName\\KeywordMatchingCM_withoutPlaceNameMatching_CorrectPlaceRanking_', nFrameCnt);

        mAccuracy = SS_CalAccuracy_MultipleIndexSet(sWithoutPlaceNameRankFile);

        mAccuracyWithoutPlaceNameMean(i,j) = mAccuracy(1);
        mAccuracyWithoutPlaceNameStd(i,j) = mAccuracy(2);

        fprintf(fid_resultNotUsingPlace, '%d,%f,%f\n', nFrameCnt, mAccuracyWithoutPlaceNameMean(i,j), mAccuracyWithoutPlaceNameStd(i,j));
    end
end
    
fclose(fid_resultUsingPlace);
fclose(fid_resultNotUsingPlace);

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
        for i=1:2
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
        for i=1:2
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


 mAccuracyWithPlaceNameMean

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
screenSize = get(0, 'ScreenSize');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%Plotting Accuracy for Without Using Place Name in Matching%%%%%%%%%%%%%%%
h1=figure('numbertitle', 'off', 'name', 'Accuracy of OCR-Web Matching (Without Using Place Name in Matching)');
subplot(1,2,1);
barHandle = bar(mAccuracyWithoutPlaceNameMean, 1,'edgecolor','k', 'linewidth', 2); 

hold on;

for j = 1:2
    x = get(get(barHandle(j),'children'), 'xdata');

    x = mean(x([1 3],1:length(mFrameCnt)-1));

    errorbar(x, mAccuracyWithoutPlaceNameMean(1:length(mFrameCnt)-1,j),  mAccuracyWithoutPlaceNameDistStdDown(1:length(mFrameCnt)-1,j), mAccuracyWithoutPlaceNameDistStdUp(1:length(mFrameCnt)-1,j), 'k', 'linestyle', 'none', 'linewidth', 3);             
end

set(gca, 'FontName','Times New Roman');
set(gca, 'FontSize', 32);
        
set(gca, 'XTickLabel', XTickTxt);
set(gca,'YTick',0:10:100);

sTotalTitle = [subTitle ' (Place Name Not Involved)'];

title(gca, sTotalTitle, 'FontName','Times New Roman', 'FontSize', 32);

legend('Non-Full-Text', 'Full-Text');

xlabelStr = 'Number of In-store Pictures';

xlabel(xlabelStr, 'FontSize', 32);
ylabel('Accuracy (%)', 'FontSize', 32);
set(gca,'ygrid','on');
ylim([0 100]);

set(0, 'DefaultFigurePosition', screenSize);


%%%%%%%%Plotting Accuracy for Using Place Name in Matching%%%%%%%%%%%%%%%
%h1=figure('numbertitle', 'off', 'name', 'Accuracy of OCR-Web Matching (Using Place Name in Matching)');

subplot(1,2,2);

barHandle = bar(mAccuracyWithPlaceNameMean, 1,'edgecolor','k', 'linewidth', 2); 

hold on;


for j = 1:2
    x = get(get(barHandle(j),'children'), 'xdata');

    x = mean(x([1 3],1:length(mFrameCnt)-1));
        
    errorbar(x, mAccuracyWithPlaceNameMean(1:length(mFrameCnt)-1,j),  mAccuracyWithPlaceNameDistStdDown(1:length(mFrameCnt)-1,j), mAccuracyWithPlaceNameDistStdUp(1:length(mFrameCnt)-1,j), 'k', 'linestyle', 'none', 'linewidth', 3); %  
end


set(gca, 'FontName','Times New Roman');
set(gca, 'FontSize', 32);
        
set(gca, 'XTickLabel', XTickTxt);
set(gca,'YTick',0:10:100);

%sTotalTitle = ['In-store vs. Web Matching (' subTitle ', Place Name Involved)'];
sTotalTitle = [subTitle ' (Place Name Involved)'];

title(gca, sTotalTitle, 'FontName','Times New Roman', 'FontSize', 32);

legend('Non-Full-Text', 'Full-Text');
    
xlabelStr = 'Number of In-store Pictures';

xlabel(xlabelStr, 'FontSize', 32);
ylabel('Accuracy (%)', 'FontSize', 32);
set(gca,'ygrid','on');
ylim([0 100]);

set(0, 'DefaultFigurePosition', screenSize);


return;

