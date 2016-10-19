function f = SS_CalMatchingAccuracyDist_CDF_DifferetStoreSubset_SinglePicNum()
% This function calculate the accuracy (for top 1, top 2 and top 3) for Subset OCR vs. Web matching
% It process files under topfolder/1, topfolder/2,...
% In each folder, there are "withPlaceName", "withoutPlaceName",
% Under these folders, this function process KeywordMatchingCM_with/withoutPlaceNameMatching_CorrectPlaceRanking_xx.csv files to calcualte the accuracy
% 
%

format long;

% sParentFolderA = 'E:\UIUC\Run\201411_ForPaper_TFIDF\Similarity\OCR_Web_Subset\10Place';
% sParentFolderB = 'E:\UIUC\Run\201411_ForPaper_TFIDF\Similarity\OCR_Web_Subset\20Place';

%E:\UIUC\Run\201411_ForPaper_TFIDF\Similarity\OCR_Web_Subset_MultipleIndexSet
%E:\UIUC\Run\201411_ForPaper_TFIDF\Similarity\OCR_Web_Subset_MultipleIndexSet_withCA6

sParentFolderA = 'E:\UIUC\Run\201411_ForPaper_TFIDF\Similarity\OCR_Web_Subset_MultipleIndexSet_withCA6\5Place';
sParentFolderB = 'E:\UIUC\Run\201411_ForPaper_TFIDF\Similarity\OCR_Web_Subset_MultipleIndexSet_withCA6\10Place';
sParentFolderC = 'E:\UIUC\Run\201411_ForPaper_TFIDF\Similarity\OCR_Web_Subset_MultipleIndexSet_withCA6\15Place';
sParentFolderD = 'E:\UIUC\Run\201411_ForPaper_TFIDF\Similarity\OCR_Web_Subset_MultipleIndexSet_withCA6\20Place';

sTitle = 'Store vs. Web Text Matching (Varying Area Size)';

mFrameCnt = [9999];   % 9999: all

nTitleLabelFontSize = 50;
nTickFontSize = 40;


%nWithPlaceName = 1;   % With place name or not
%nFrameCnt = 10;       % Number of usable frames
xTickStart = 40;
nLineWidth = 6;

sWithoutPlaceNameSubFolder = 'withoutPlaceName';
sWithPlaceNameSubFolder = 'withPlaceName';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Save the raw accuracy for top 1/2/3
mTotalAccuracyWithPlaceNameA = [];
mTotalAccuracyWithoutPlaceNameA = [];

mWithPlaceNameDistMeanA = [];
mWithPlaceNameDistStdA = [];
mWithPlaceNameDistMaxA = [];
mWithPlaceNameDistMinA = [];

mWithoutPlaceNameDistMeanA = [];
mWithoutPlaceNameDistStdA = [];
mWithoutPlaceNameDistMaxA = [];
mWithoutPlaceNameDistMinA = [];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
mTotalAccuracyWithPlaceNameB = [];
mTotalAccuracyWithoutPlaceNameB = [];

mWithPlaceNameDistMeanB = [];
mWithPlaceNameDistStdB = [];
mWithPlaceNameDistMaxB = [];
mWithPlaceNameDistMinB = [];

mWithoutPlaceNameDistMeanB = [];
mWithoutPlaceNameDistStdB = [];
mWithoutPlaceNameDistMaxB = [];
mWithoutPlaceNameDistMinB = [];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
mTotalAccuracyWithPlaceNameC = [];
mTotalAccuracyWithoutPlaceNameC = [];

mWithPlaceNameDistMeanC = [];
mWithPlaceNameDistStdC = [];
mWithPlaceNameDistMaxC = [];
mWithPlaceNameDistMinC = [];

mWithoutPlaceNameDistMeanC = [];
mWithoutPlaceNameDistStdC = [];
mWithoutPlaceNameDistMaxC = [];
mWithoutPlaceNameDistMinC = [];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
mTotalAccuracyWithPlaceNameD = [];
mTotalAccuracyWithoutPlaceNameD = [];

mWithPlaceNameDistMeanD = [];
mWithPlaceNameDistStdD = [];
mWithPlaceNameDistMaxD = [];
mWithPlaceNameDistMinD = [];

mWithoutPlaceNameDistMeanD = [];
mWithoutPlaceNameDistStdD = [];
mWithoutPlaceNameDistMaxD = [];
mWithoutPlaceNameDistMinD = [];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for k=1:4
    if k==1
        sParentFolder = sParentFolderA;
    elseif k==2
        sParentFolder = sParentFolderB;
    elseif k==3
        sParentFolder = sParentFolderC;
    else
        sParentFolder = sParentFolderD;
    end
    
    Files = dir(sParentFolder);
   
    for j=1:length(mFrameCnt)
        nFrameCnt = mFrameCnt(j);

        % With Place Name
        mAccuracyWithPlaceName = [];
        nWithPlaceNameCnt = 0;

        for i=3:length(Files)  % First two are: "."   "..'
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

        if k == 1
            mTotalAccuracyWithPlaceNameA{j} = mAccuracyWithPlaceName;
            for t=1:3
                mWithPlaceNameDistMeanA(j,t) = mean(mAccuracyWithPlaceName(:,t));
                mWithPlaceNameDistStdA(j,t) = std(mAccuracyWithPlaceName(:,t));
                mWithPlaceNameDistMaxA(j,t) = max(mAccuracyWithPlaceName(:,t));
                mWithPlaceNameDistMinA(j,t) = min(mAccuracyWithPlaceName(:,t));
            end
        elseif k == 2
            mTotalAccuracyWithPlaceNameB{j} = mAccuracyWithPlaceName;
            for t=1:3
                mWithPlaceNameDistMeanB(j,t) = mean(mAccuracyWithPlaceName(:,t));
                mWithPlaceNameDistStdB(j,t) = std(mAccuracyWithPlaceName(:,t));
                mWithPlaceNameDistMaxB(j,t) = max(mAccuracyWithPlaceName(:,t));
                mWithPlaceNameDistMinB(j,t) = min(mAccuracyWithPlaceName(:,t));
            end
            
        elseif k == 3
            mTotalAccuracyWithPlaceNameC{j} = mAccuracyWithPlaceName;
            for t=1:3
                mWithPlaceNameDistMeanC(j,t) = mean(mAccuracyWithPlaceName(:,t));
                mWithPlaceNameDistStdC(j,t) = std(mAccuracyWithPlaceName(:,t));
                mWithPlaceNameDistMaxC(j,t) = max(mAccuracyWithPlaceName(:,t));
                mWithPlaceNameDistMinC(j,t) = min(mAccuracyWithPlaceName(:,t));
            end
            
        else
            mTotalAccuracyWithPlaceNameD{j} = mAccuracyWithPlaceName;
            for t=1:3
                mWithPlaceNameDistMeanD(j,t) = mean(mAccuracyWithPlaceName(:,t));
                mWithPlaceNameDistStdD(j,t) = std(mAccuracyWithPlaceName(:,t));
                mWithPlaceNameDistMaxD(j,t) = max(mAccuracyWithPlaceName(:,t));
                mWithPlaceNameDistMinD(j,t) = min(mAccuracyWithPlaceName(:,t));
            end
            
        end

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%% Without Place Name
        mAccuracyWithoutPlaceName = [];
        nWithoutPlaceNameCnt = 0;

        for i=3:length(Files)
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

        if k == 1
            mTotalAccuracyWithoutPlaceNameA{j} = mAccuracyWithoutPlaceName;

            for t=1:3
                mWithoutPlaceNameDistMeanA(j,t) = mean(mAccuracyWithoutPlaceName(:,t));
                mWithoutPlaceNameDistStdA(j,t) = std(mAccuracyWithoutPlaceName(:,t));
                mWithoutPlaceNameDistMaxA(j,t) = max(mAccuracyWithoutPlaceName(:,t));
                mWithoutPlaceNameDistMinA(j,t) = min(mAccuracyWithoutPlaceName(:,t));
            end    
        elseif k == 2
            mTotalAccuracyWithoutPlaceNameB{j} = mAccuracyWithoutPlaceName;

            for t=1:3
                mWithoutPlaceNameDistMeanB(j,t) = mean(mAccuracyWithoutPlaceName(:,t));
                mWithoutPlaceNameDistStdB(j,t) = std(mAccuracyWithoutPlaceName(:,t));
                mWithoutPlaceNameDistMaxB(j,t) = max(mAccuracyWithoutPlaceName(:,t));
                mWithoutPlaceNameDistMinB(j,t) = min(mAccuracyWithoutPlaceName(:,t));
            end    
        elseif k == 3
            mTotalAccuracyWithoutPlaceNameC{j} = mAccuracyWithoutPlaceName;

            for t=1:3
                mWithoutPlaceNameDistMeanC(j,t) = mean(mAccuracyWithoutPlaceName(:,t));
                mWithoutPlaceNameDistStdC(j,t) = std(mAccuracyWithoutPlaceName(:,t));
                mWithoutPlaceNameDistMaxC(j,t) = max(mAccuracyWithoutPlaceName(:,t));
                mWithoutPlaceNameDistMinC(j,t) = min(mAccuracyWithoutPlaceName(:,t));
            end    
        else
            mTotalAccuracyWithoutPlaceNameD{j} = mAccuracyWithoutPlaceName;

            for t=1:3
                mWithoutPlaceNameDistMeanD(j,t) = mean(mAccuracyWithoutPlaceName(:,t));
                mWithoutPlaceNameDistStdD(j,t) = std(mAccuracyWithoutPlaceName(:,t));
                mWithoutPlaceNameDistMaxD(j,t) = max(mAccuracyWithoutPlaceName(:,t));
                mWithoutPlaceNameDistMinD(j,t) = min(mAccuracyWithoutPlaceName(:,t));
            end    
        end
    end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plot all CDF together
sArr_ColorType = [ ...
    'r'; ...
    'g'; ...
    'b'; ...
    'k'; ...
];

cellColorType = cellstr(sArr_ColorType);

sArr_LineType = [ ...
    '--'; ...
    ': '; ...
    '-.'; ...
    '- '; ...
];
 
cellLineType = cellstr(sArr_LineType);

figure(1);

 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Without Place Name
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%figure(3);
%subplot(1,2,1);
for k=1:4
    % Without Place Name
    for j=1:length(mFrameCnt)
        if k == 1
            mAccuracy = mTotalAccuracyWithoutPlaceNameA{j};
        elseif k == 2
            mAccuracy = mTotalAccuracyWithoutPlaceNameB{j};
        elseif k == 3
            mAccuracy = mTotalAccuracyWithoutPlaceNameC{j};
        elseif k == 4
            mAccuracy = mTotalAccuracyWithoutPlaceNameD{j};
        end
        
        [h, stats] = cdfplot(mAccuracy(:,1));
        hold on;
        set(h, 'color', cellColorType{k});
        set(h, 'linestyle', cellLineType{k});
        set(h, 'linewidth', nLineWidth);
        
%        set(h, 'linewidth', (5-k)*2);
    end
end

xlim([xTickStart 100]);
set(gca,'XTick',xTickStart:10:100);
set(gca,'ygrid','off');
set(gca,'xgrid','off');

title(gca, 'Store vs. Web Text Matching (Varying Area Size, Place Name Not Involved)', 'FontName','Times New Roman', 'FontSize', nTitleLabelFontSize);
%title(gca, 'Store vs. Web Text Matching (Place Name Not Involved)', 'FontName','Times New Roman', 'FontSize', nTitleLabelFontSize);

set(gca,'FontName','Times New Roman', 'FontSize', nTickFontSize);
xlabel('Accuracy', 'FontName','Times New Roman', 'FontSize', nTitleLabelFontSize);    
ylabel('CDF','FontName','Times New Roman', 'FontSize', nTitleLabelFontSize);

legend('5-store Area', '10-store Area', '15-store Area', '20-store Area');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% With Place Name
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% With Place Name
figure(2);
%subplot(1,2,2);
for k=1:4
    
    for j=1:length(mFrameCnt)
        if k == 1
            mAccuracy = mTotalAccuracyWithPlaceNameA{j};
        elseif k == 2
            mAccuracy = mTotalAccuracyWithPlaceNameB{j};
        elseif k == 3
            mAccuracy = mTotalAccuracyWithPlaceNameC{j};
        else
            mAccuracy = mTotalAccuracyWithPlaceNameD{j};
        end
        
        [h, stats] = cdfplot(mAccuracy(:,1));
        hold on;
        set(h, 'color', cellColorType{k});
        set(h, 'linestyle', cellLineType{k});
        set(h, 'linewidth', nLineWidth);
%        set(h, 'linewidth', (5-k)*2);
        
    end
end


xlim([xTickStart 100]);
set(gca,'XTick',xTickStart:10:100);
set(gca,'ygrid','off');
set(gca,'xgrid','off');

title(gca, 'Store vs. Web Text Matching (Varying Area Size, Place Name Involved)', 'FontName','Times New Roman', 'FontSize', nTitleLabelFontSize);
%title(gca, 'Store vs. Web Text Matching (Place Name Involved)', 'FontName','Times New Roman', 'FontSize', nTitleLabelFontSize);

set(gca,'FontName','Times New Roman', 'FontSize', nTickFontSize);
xlabel('Accuracy', 'FontName','Times New Roman', 'FontSize', nTitleLabelFontSize);    
ylabel('CDF','FontName','Times New Roman', 'FontSize', nTitleLabelFontSize);

legend('5-store Area', '10-store Area', '15-store Area', '20-store Area');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(3);

%figure(4);
%subplot(1,2,1);
% Normal Version

nNumSigma = 3;
for k = 1:4
    % Without Place Name
    for j=1:length(mFrameCnt)
        if k == 1
            x = linspace(mWithoutPlaceNameDistMeanA(j,1)-nNumSigma*mWithoutPlaceNameDistStdA(j,1), mWithoutPlaceNameDistMeanA(j,1)+nNumSigma*mWithoutPlaceNameDistStdA(j,1), 10000);
            plot(x, normcdf(x,mWithoutPlaceNameDistMeanA(j,1), mWithoutPlaceNameDistStdA(j,1)),cellColorType{k},  'linestyle', cellLineType{k},  'linewidth', nLineWidth);
        elseif k == 2
            x = linspace(mWithoutPlaceNameDistMeanB(j,1)-nNumSigma*mWithoutPlaceNameDistStdB(j,1), mWithoutPlaceNameDistMeanB(j,1)+nNumSigma*mWithoutPlaceNameDistStdB(j,1), 10000);
            plot(x, normcdf(x,mWithoutPlaceNameDistMeanB(j,1), mWithoutPlaceNameDistStdB(j,1)), cellColorType{k},  'linestyle', cellLineType{k},'linewidth', nLineWidth);
        elseif k == 3
            x = linspace(mWithoutPlaceNameDistMeanC(j,1)-nNumSigma*mWithoutPlaceNameDistStdC(j,1), mWithoutPlaceNameDistMeanC(j,1)+nNumSigma*mWithoutPlaceNameDistStdC(j,1), 10000);
            plot(x, normcdf(x,mWithoutPlaceNameDistMeanC(j,1), mWithoutPlaceNameDistStdC(j,1)),   cellColorType{k},  'linestyle', cellLineType{k}, 'linewidth', nLineWidth);
        else
            x = linspace(mWithoutPlaceNameDistMeanD(j,1)-nNumSigma*mWithoutPlaceNameDistStdD(j,1), mWithoutPlaceNameDistMeanD(j,1)+nNumSigma*mWithoutPlaceNameDistStdD(j,1), 10000);
            plot(x, normcdf(x,mWithoutPlaceNameDistMeanD(j,1), mWithoutPlaceNameDistStdD(j,1)),   cellColorType{k},  'linestyle', cellLineType{k}, 'linewidth', nLineWidth);
        end
         
        hold on;
    end
end


xlim([xTickStart 100]);
set(gca,'XTick',xTickStart:10:100);
set(gca,'ygrid','off');
set(gca,'xgrid','off');

title(gca, 'Store vs. Web Text Matching (Varying Area Size, Place Name Not Involved)', 'FontName','Times New Roman', 'FontSize', nTitleLabelFontSize);
%title(gca, 'Store vs. Web Text Matching (Place Name Not Involved)', 'FontName','Times New Roman', 'FontSize', nTitleLabelFontSize);

set(gca,'FontName','Times New Roman', 'FontSize', nTickFontSize);
xlabel('Accuracy', 'FontName','Times New Roman', 'FontSize', nTitleLabelFontSize);    
ylabel('CDF','FontName','Times New Roman', 'FontSize', nTitleLabelFontSize);

legend('5-store Area', '10-store Area', '15-store Area', '20-store Area');

%%%%%%%%%%%%%%%%%%%%%%
figure(4);
%subplot(1,2,2);
% Normal Version

nNumSigma = 3;

for k = 1:4
    % With Place Name
    for j=1:length(mFrameCnt) 
        if k == 1
            x = linspace(mWithPlaceNameDistMeanA(j,1)-nNumSigma*mWithPlaceNameDistStdA(j,1), mWithPlaceNameDistMeanA(j,1)+nNumSigma*mWithPlaceNameDistStdA(j,1), 10000);
            plot(x, normcdf(x,mWithPlaceNameDistMeanA(j,1), mWithPlaceNameDistStdA(j,1)),  cellColorType{k}, 'linestyle', cellLineType{k}, 'linewidth', nLineWidth);
        elseif k == 2
            x = linspace(mWithPlaceNameDistMeanB(j,1)-nNumSigma*mWithPlaceNameDistStdB(j,1), mWithPlaceNameDistMeanB(j,1)+nNumSigma*mWithPlaceNameDistStdB(j,1), 10000);
            plot(x, normcdf(x,mWithPlaceNameDistMeanB(j,1), mWithPlaceNameDistStdB(j,1)), cellColorType{k},   'linestyle', cellLineType{k}, 'linewidth', nLineWidth); 
        elseif k == 3
            x = linspace(mWithPlaceNameDistMeanC(j,1)-nNumSigma*mWithPlaceNameDistStdC(j,1), mWithPlaceNameDistMeanC(j,1)+nNumSigma*mWithPlaceNameDistStdC(j,1), 10000);
            plot(x, normcdf(x,mWithPlaceNameDistMeanC(j,1), mWithPlaceNameDistStdC(j,1)),  cellColorType{k},  'linestyle', cellLineType{k}, 'linewidth', nLineWidth);
        else
            x = linspace(mWithPlaceNameDistMeanD(j,1)-nNumSigma*mWithPlaceNameDistStdD(j,1), mWithPlaceNameDistMeanD(j,1)+nNumSigma*mWithPlaceNameDistStdD(j,1), 10000);
            plot(x, normcdf(x,mWithPlaceNameDistMeanD(j,1), mWithPlaceNameDistStdD(j,1)),  cellColorType{k},  'linestyle', cellLineType{k}, 'linewidth', nLineWidth);
        end
     
        hold on;
    end
end

xlim([xTickStart 100]);
set(gca,'XTick',xTickStart:10:100);
set(gca,'ygrid','off');
set(gca,'xgrid','off');

title(gca, 'Store vs. Web Text Matching (Varying Area Size, Place Name Involved)', 'FontName','Times New Roman', 'FontSize', nTitleLabelFontSize);
%title(gca, 'Store vs. Web Text Matching (Place Name Involved)', 'FontName','Times New Roman', 'FontSize', nTitleLabelFontSize);

set(gca,'FontName','Times New Roman', 'FontSize', nTickFontSize);
xlabel('Accuracy', 'FontName','Times New Roman', 'FontSize', nTitleLabelFontSize);    
ylabel('CDF','FontName','Times New Roman', 'FontSize', nTitleLabelFontSize);

legend('5-store Area', '10-store Area', '15-store Area', '20-store Area');



return;

