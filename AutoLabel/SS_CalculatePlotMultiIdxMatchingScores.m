function SS_CalculatePlotMultiIdxMatchingScores(nWithPlaceName, sParentFolder, nImgCnt, nIndexCnt)
% Calculate the matching score between Crowdsoruced data and Web for each Image Number, use nIndexCnt sets, 
% i.e. study the case when randomly select nImgCnt images (over nIndexCnt sets), to get statistic meaning of matching when only randomly, 5, 10,.... images are available
%
% 

format long;

sPreFix = 'KeywordMatchingCM';

if nWithPlaceName == 1
        sWithWithoutPlaceName = 'withPlaceNameMatching';
else
        sWithWithoutPlaceName = 'withoutPlaceNameMatching';
end

mFiles = [];
nFileCnt = 0;
Files = dir(sParentFolder);

for i=3:length(Files)  % First two are: "."   "..'
    sFileName = Files(i).name;
    sFullPathFileName = [sParentFolder '\' sFileName];
    
    mNameFileds = SS_SplitString(sFileName, '_');
    
    if length(mNameFileds) > 3 && strcmp(mNameFileds{1}, sPreFix) == 1 && strcmp(mNameFileds{2}, sWithWithoutPlaceName) == 1 && strcmp(mNameFileds{4}, num2str(nImgCnt)) == 1
            nFileCnt = nFileCnt + 1;
            mFiles{nFileCnt} = sFullPathFileName;
    end
end

mFiles

%%%% Calculate mathing scores

fidRead = fopen(mFiles{1});

mCM = [];

nGroundTruthLine = 0; 
nCandidateLine = 0;

matRecogResult = [];

while 1
    sLine = fgetl(fidRead);
    if ~ischar(sLine)
        break;
    end
           
    if nGroundTruthLine == 0
        % Save Ground Truth names here
        GroundTruthPlaceNames = SS_SplitString(sLine, ',');
        nGroundTruthLine = 1;
        continue;
    end  
    
    if nCandidateLine == 0
        % Save Candidate place names here
        CandidatePlaceNames = SS_SplitString(sLine, ',');
        nCandidateLine = 1;
        continue;
    end
    
    % Process matching score lines and save in matRecogResult
    mRow = SS_SplitStringNum(sLine, ',');
    
    matRecogResult = [matRecogResult, mRow'];
   
end

fclose(fidRead);

mCM{1} = matRecogResult;

for i = 2:length(mFiles)
        fidRead = fopen(mFiles{i});

        nGroundTruthLine = 0; 
        nCandidateLine = 0;

        matRecogResult = [];

        while 1
            sLine = fgetl(fidRead);
            if ~ischar(sLine)
                break;
            end

            if nGroundTruthLine == 0
                nGroundTruthLine = 1;
                continue;
            end  

            if nCandidateLine == 0
                nCandidateLine = 1;
                continue;
            end

            % Process matching score lines and save in matRecogResult
            mRow = SS_SplitStringNum(sLine, ',');

            matRecogResult = [matRecogResult, mRow'];

        end

        fclose(fidRead);

        mCM{i} = matRecogResult;
        
end


%%%% Statistics
mMean = [];
mStd = [];

[nRow nCol] = size(mCM{1});

for i = 1:nRow
    for j = 1:nCol
            mValues = [];
            for k = 1:nFileCnt
                 mValues(k) =  mCM{k}(i, j);
            end
            
            mMean(i, j) = mean(mValues);
            mStd(i, j) = std(mValues);
            
    end
end


%%% Plot
mMeanNorm = [];

for i=1:nCol
    fMax = max(mMean(:,i));
    mCol = [];
    
    if fMax == 0
        mCol = zeros(nRow, 1);
    else
        for j=1:nRow
            mCol(j) = mMean(j,i)/fMax;
        end
    end
    
    mMeanNorm = [mMeanNorm mCol'];
end

[a b] = size(mMeanNorm)

xTicks = GroundTruthPlaceNames;
yTicks = CandidatePlaceNames;

xLabels = 'Ground Truth Place';
yLabels = 'Predicted Place';

nFontSizeTitleAxis = 40;
nFontSizeContent = 36;

%subplot(1,2,1);
SS_PlotConfusion(mMean, xLabels, xTicks, yLabels, yTicks, 'Place Recognition Confusion Matrix', 1, nFontSizeTitleAxis, nFontSizeContent);
hold on;

%subplot(1,2,2);
SS_PlotConfusion(mMeanNorm, xLabels, xTicks, yLabels, yTicks, 'Place Recognition Confusion Matrix (Normalized)', 2, nFontSizeTitleAxis, nFontSizeContent);


return;


    


