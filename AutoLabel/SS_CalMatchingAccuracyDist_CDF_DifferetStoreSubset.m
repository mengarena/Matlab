function f = SS_CalMatchingAccuracyDist_CDF_DifferetStoreSubset()
% This function calculate the accuracy (for top 1, top 2 and top 3) for Subset OCR vs. Web matching
% It process files under topfolder/1, topfolder/2,...
% In each folder, there are "withPlaceName", "withoutPlaceName",
% Under these folders, this function process KeywordMatchingCM_with/withoutPlaceNameMatching_CorrectPlaceRanking_xx.csv files to calcualte the accuracy
% 
%

format long;

sParentFolderA = 'E:\UIUC\Run\201411_ForPaper_TFIDF\Similarity\OCR_Web_Subset\10Place';
sParentFolderB = 'E:\UIUC\Run\201411_ForPaper_TFIDF\Similarity\OCR_Web_Subset\20Place';

sTitle = 'In-store vs. Web Matching (Varying Region Size)';

mFrameCnt = [10 20 30 9999];   % 9999: all

%nWithPlaceName = 1;   % With place name or not
%nFrameCnt = 10;       % Number of usable frames

sWithoutPlaceNameSubFolder = 'withoutPlaceName';
sWithPlaceNameSubFolder = 'withPlaceName';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%% A %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Files = dir(sParentFolderA);

% Save the raw accuracy for top 1/2/3
mTotalAccuracyWithPlaceNameA = [];
mTotalAccuracyWithoutPlaceNameA = [];

% Save the disctribution (mean, std, max, min) for top 1/2/3
mTotalAccuracyWithPlaceNameDistA = [];
mTotalAccuracyWithoutPlaceNameDistA = [];

mWithPlaceNameDistMeanA = [];
mWithPlaceNameDistStdA = [];
mWithPlaceNameDistMaxA = [];
mWithPlaceNameDistMinA = [];

mWithoutPlaceNameDistMeanA = [];
mWithoutPlaceNameDistStdA = [];
mWithoutPlaceNameDistMaxA = [];
mWithoutPlaceNameDistMinA = [];

for j=1:length(mFrameCnt)
    nFrameCnt = mFrameCnt(j);
    
    % With Place Name
    mAccuracyWithPlaceName = [];
    nWithPlaceNameCnt = 0;
    
    for i=3:length(Files)  % First two are: "."   "..'
        sFolderName = Files(i).name;
        sFullFolderPath = [sParentFolderA '\' Files(i).name];

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
    
    mTotalAccuracyWithPlaceNameA{j} = mAccuracyWithPlaceName;
   
     for i=1:3
        mWithPlaceNameDistMeanA(j,i) = mean(mAccuracyWithPlaceName(:,i));
        mWithPlaceNameDistStdA(j,i) = std(mAccuracyWithPlaceName(:,i));
        mWithPlaceNameDistMaxA(j,i) = max(mAccuracyWithPlaceName(:,i));
        mWithPlaceNameDistMinA(j,i) = min(mAccuracyWithPlaceName(:,i));
    end
  
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%% Without Place Name
    mAccuracyWithoutPlaceName = [];
    nWithoutPlaceNameCnt = 0;
    
    for i=3:length(Files)
        sFolderName = Files(i).name;
        sFullFolderPath = [sParentFolderA '\' Files(i).name];

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

    mTotalAccuracyWithoutPlaceNameA{j} = mAccuracyWithoutPlaceName;
    
    for i=1:3
        mWithoutPlaceNameDistMeanA(j,i) = mean(mAccuracyWithoutPlaceName(:,i));
        mWithoutPlaceNameDistStdA(j,i) = std(mAccuracyWithoutPlaceName(:,i));
        mWithoutPlaceNameDistMaxA(j,i) = max(mAccuracyWithoutPlaceName(:,i));
        mWithoutPlaceNameDistMinA(j,i) = min(mAccuracyWithoutPlaceName(:,i));
    end    
   
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%% B %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Files = dir(sParentFolderB);

% Save the raw accuracy for top 1/2/3
mTotalAccuracyWithPlaceNameB = [];
mTotalAccuracyWithoutPlaceNameB = [];

% Save the disctribution (mean, std, max, min) for top 1/2/3
mTotalAccuracyWithPlaceNameDistB = [];
mTotalAccuracyWithoutPlaceNameDistB = [];

mWithPlaceNameDistMeanB = [];
mWithPlaceNameDistStdB = [];
mWithPlaceNameDistMaxB = [];
mWithPlaceNameDistMinB = [];

mWithoutPlaceNameDistMeanB = [];
mWithoutPlaceNameDistStdB = [];
mWithoutPlaceNameDistMaxB = [];
mWithoutPlaceNameDistMinB = [];

for j=1:length(mFrameCnt)
    nFrameCnt = mFrameCnt(j);
    
    % With Place Name
    mAccuracyWithPlaceName = [];
    nWithPlaceNameCnt = 0;
    
    for i=3:length(Files)  % First two are: "."   "..'
        sFolderName = Files(i).name;
        sFullFolderPath = [sParentFolderB '\' Files(i).name];

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
    
    mTotalAccuracyWithPlaceNameB{j} = mAccuracyWithPlaceName;
   
    for i=1:3
        mWithPlaceNameDistMeanB(j,i) = mean(mAccuracyWithPlaceName(:,i));
        mWithPlaceNameDistStdB(j,i) = std(mAccuracyWithPlaceName(:,i));
        mWithPlaceNameDistMaxB(j,i) = max(mAccuracyWithPlaceName(:,i));
        mWithPlaceNameDistMinB(j,i) = min(mAccuracyWithPlaceName(:,i));
    end
  
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%% Without Place Name
    mAccuracyWithoutPlaceName = [];
    nWithoutPlaceNameCnt = 0;
    
    for i=3:length(Files)
        sFolderName = Files(i).name;
        sFullFolderPath = [sParentFolderB '\' Files(i).name];

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

    mTotalAccuracyWithoutPlaceNameB{j} = mAccuracyWithoutPlaceName;
    
    for i=1:3
        mWithoutPlaceNameDistMeanB(j,i) = mean(mAccuracyWithoutPlaceName(:,i));
        mWithoutPlaceNameDistStdB(j,i) = std(mAccuracyWithoutPlaceName(:,i));
        mWithoutPlaceNameDistMaxB(j,i) = max(mAccuracyWithoutPlaceName(:,i));
        mWithoutPlaceNameDistMinB(j,i) = min(mAccuracyWithoutPlaceName(:,i));
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% With Place Name
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(1);
% With Place Name  A
for j=1:length(mFrameCnt)
    mAccuracy = mTotalAccuracyWithPlaceNameA{j};
    [h, stats] = cdfplot(mAccuracy(:,1));
    hold on;
    set(h, 'color', cellColorType{j});
    set(h, 'linewidth', 3);
end

% With Place Name  B
for j=1:length(mFrameCnt)
    mAccuracy = mTotalAccuracyWithPlaceNameB{j};
    [h, stats] = cdfplot(mAccuracy(:,1));
    hold on;
    set(h, 'color', cellColorType{j});
    set(h, 'linewidth', 3);
    set(h, 'linestyle', '- -');
end

xlim([30 100]);
set(gca,'XTick',30:10:100);
set(gca,'ygrid','off');
set(gca,'xgrid','off');

title(gca, 'In-store vs. Web Matching (10-store vs. 20-store Subset, Place Name Involved)', 'FontName','Times New Roman', 'FontSize', 42);
set(gca,'FontName','Times New Roman', 'FontSize', 30);
xlabel('Accuracy', 'FontName','Times New Roman', 'FontSize', 40);    
ylabel('CDF','FontName','Times New Roman', 'FontSize', 40);

legend('10 In-store Pictures (10-store Subset)', '20 In-store Pictures (10-store Subset)', '30 In-store Pictures (10-store Subset)', 'All In-store Pictures (10-store Subset)', ...
       '10 In-store Pictures (20-store Subset)', '20 In-store Pictures (20-store Subset)', '30 In-store Pictures (20-store Subset)', 'All In-store Pictures (20-store Subset)');

figure(2);
% Normal Version

nNumSigma = 3;
% With Place Name
for j=1:length(mFrameCnt)    
    x = linspace(mWithPlaceNameDistMeanA(j,1)-nNumSigma*mWithPlaceNameDistStdA(j,1), mWithPlaceNameDistMeanA(j,1)+nNumSigma*mWithPlaceNameDistStdA(j,1), 10000);
    plot(x, normcdf(x,mWithPlaceNameDistMeanA(j,1), mWithPlaceNameDistStdA(j,1)), cellColorType{j},  'linewidth', 3);
    
    hold on;
end

% With Place Name
for j=1:length(mFrameCnt)
    x = linspace(mWithPlaceNameDistMeanB(j,1)-nNumSigma*mWithPlaceNameDistStdB(j,1), mWithPlaceNameDistMeanB(j,1)+nNumSigma*mWithPlaceNameDistStdB(j,1), 10000);
    plot(x, normcdf(x,mWithPlaceNameDistMeanB(j,1), mWithPlaceNameDistStdB(j,1)), cellColorType{j}, 'linestyle', '- -', 'linewidth', 3);
    hold on;
end


xlim([30 100]);
set(gca,'XTick',30:10:100);
set(gca,'ygrid','off');
set(gca,'xgrid','off');

title(gca, 'In-store vs. Web Matching (10-store vs. 20-store Subset, Place Name Involved)', 'FontName','Times New Roman', 'FontSize', 42);
set(gca,'FontName','Times New Roman', 'FontSize', 30);
xlabel('Accuracy', 'FontName','Times New Roman', 'FontSize', 40);    
ylabel('CDF','FontName','Times New Roman', 'FontSize', 40);

legend('10 In-store Pictures (10-store Subset)', '20 In-store Pictures (10-store Subset)', '30 In-store Pictures (10-store Subset)', 'All In-store Pictures (10-store Subset)', ...
       '10 In-store Pictures (20-store Subset)', '20 In-store Pictures (20-store Subset)', '30 In-store Pictures (20-store Subset)', 'All In-store Pictures (20-store Subset)');

   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Without Place Name
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(3);
% Without Place Name  A
for j=1:length(mFrameCnt)
    mAccuracy = mTotalAccuracyWithoutPlaceNameA{j};
    [h, stats] = cdfplot(mAccuracy(:,1));
    hold on;
    set(h, 'color', cellColorType{j});
    set(h, 'linewidth', 3);
end

% Without Place Name  B
for j=1:length(mFrameCnt)
    mAccuracy = mTotalAccuracyWithoutPlaceNameB{j};
    [h, stats] = cdfplot(mAccuracy(:,1));
    hold on;
    set(h, 'color', cellColorType{j});
    set(h, 'linewidth', 3);
    set(h, 'linestyle', '- -');
end

xlim([30 100]);
set(gca,'XTick',30:10:100);
set(gca,'ygrid','off');
set(gca,'xgrid','off');

title(gca, 'In-store vs. Web Matching (10-store vs. 20-store Subset, Place Name Not Involved)', 'FontName','Times New Roman', 'FontSize', 42);
set(gca,'FontName','Times New Roman', 'FontSize', 30);
xlabel('Accuracy', 'FontName','Times New Roman', 'FontSize', 40);    
ylabel('CDF','FontName','Times New Roman', 'FontSize', 40);

legend('10 In-store Pictures (10-store Subset)', '20 In-store Pictures (10-store Subset)', '30 In-store Pictures (10-store Subset)', 'All In-store Pictures (10-store Subset)', ...
       '10 In-store Pictures (20-store Subset)', '20 In-store Pictures (20-store Subset)', '30 In-store Pictures (20-store Subset)', 'All In-store Pictures (20-store Subset)');

figure(4);
% Normal Version

nNumSigma = 3;
% Without Place Name
for j=1:length(mFrameCnt)    
    x = linspace(mWithoutPlaceNameDistMeanA(j,1)-nNumSigma*mWithoutPlaceNameDistStdA(j,1), mWithoutPlaceNameDistMeanA(j,1)+nNumSigma*mWithoutPlaceNameDistStdA(j,1), 10000);
    plot(x, normcdf(x,mWithoutPlaceNameDistMeanA(j,1), mWithoutPlaceNameDistStdA(j,1)), cellColorType{j},  'linewidth', 3);
    
    hold on;
end

% Without Place Name
for j=1:length(mFrameCnt)
    x = linspace(mWithoutPlaceNameDistMeanB(j,1)-nNumSigma*mWithoutPlaceNameDistStdB(j,1), mWithoutPlaceNameDistMeanB(j,1)+nNumSigma*mWithoutPlaceNameDistStdB(j,1), 10000);
    plot(x, normcdf(x,mWithoutPlaceNameDistMeanB(j,1), mWithoutPlaceNameDistStdB(j,1)), cellColorType{j}, 'linestyle', '- -', 'linewidth', 3);
    hold on;
end

xlim([30 100]);
set(gca,'XTick',30:10:100);
set(gca,'ygrid','off');
set(gca,'xgrid','off');

title(gca, 'In-store vs. Web Matching (10-store vs. 20-store Subset, Place Name Not Involved)', 'FontName','Times New Roman', 'FontSize', 42);
set(gca,'FontName','Times New Roman', 'FontSize', 30);
xlabel('Accuracy', 'FontName','Times New Roman', 'FontSize', 40);    
ylabel('CDF','FontName','Times New Roman', 'FontSize', 40);

legend('10 In-store Pictures (10-store Subset)', '20 In-store Pictures (10-store Subset)', '30 In-store Pictures (10-store Subset)', 'All In-store Pictures (10-store Subset)', ...
       '10 In-store Pictures (20-store Subset)', '20 In-store Pictures (20-store Subset)', '30 In-store Pictures (20-store Subset)', 'All In-store Pictures (20-store Subset)');   
   
return;

