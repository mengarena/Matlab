function f = SS_BuildHmmWithGroupFile()
% This function is used to build a HMM based on a group of Wav files
% 
% Pre-condition:
%   A. Standardization on feature vectors has been done on a large-scale
%   feature vectors (from various categories), the Mean/Std used are
%   available.
%   B. The Centroid of the K-means on a large-scale feature vectors (from
%   vairous categories) is available.
%
% The steps are as follows:
%   1) Extract frame-based features ---> Feature Vectors
%   2) Standardize Feature Vectors by using the mean/std generated during a
%   General(large scale) pre-processing (zscore) for K-Means --->
%   Standardized Feature Vectors
%   3) Classify the Standardize Feature Vectors based on the Centroid produced from 
%   the General (large scale) K-Means ---> Observation Sequence
%   4) Assume initial transition and emission matrix, based on #state,
%   #observation, train HMM ---> Transition Matrix, Emission Matrix
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf('Start Time: %s\n', datestr(clock, 'yyyy-mm-dd HH:MM:SS'));

format long;

sBaseFolder = 'E:\UIUC\';

sModelName = 'Bookstore';

sBookStoreGroupFiles = [ ...
    'E:\UIUC\Multimedia_Data\BookStore\BarnesNoble\Gear_01\20140621151730.wav                           '; ...
    'E:\UIUC\Multimedia_Data\BookStore\FriendShopBookStore_publiclibrary\Gear_01\20140621133223.wav     '; ...
    'E:\UIUC\Multimedia_Data\BookStore\IlliniUnionBookstore\Gear_01\20140627144203.wav                  '; ...
    'E:\UIUC\Multimedia_Data\BookStore\JaneAddamsBookShop\Gear_01\20140621140234.wav                    '; ...
    'E:\UIUC\Multimedia_Data\BookStore\PricelessBooks\Gear_01\20140621143226.wav                        '; ...
    'E:\UIUC\Multimedia_Data\BookStore\TisCollege_Bookstore\Gear_02\20140627145811.wav                  '
];

cellGroupFiles = cellstr(sBookStoreGroupFiles);

nUsageType = 1;
fDataRatio = 0.8;

% How many hidden states and Observation to use
nState = 12;
nObservation = 20;

% Parameter for frame
nFrameLen = 40;  % ms
nFrameStep = 20; % ms
nPreCut = 15;    % s
fPostCut = 0.1;  % 10%

sKmeansCentroidFile = [sBaseFolder 'LargeScale_StandKmeans\' 'KmeansCentroid_' num2str(nObservation) '.csv'];
mKmeansCentroid = load(sKmeansCentroidFile);

sStandardizationParamFile = [sBaseFolder  'LargeScale_StandKmeans\' 'StandarizationParam_' num2str(nObservation) '.csv'];
mStandardizationParam = load(sStandardizationParamFile);

mFeatureVector = [];   % Store frame-based Feature Vector

nCnt = 0;

% Step 1:  Extract frame based feature
for i=1:length(cellGroupFiles)
    [matEng, matZcr, matMfcc] = SS_ExtractFeature_Audio(cellGroupFiles{i}, nFrameLen, nFrameStep, nPreCut, fPostCut, nUsageType, fDataRatio);
    [nRow nCol] = size(matMfcc);
    
    for j = 1:nRow
        nCnt = nCnt + 1;
        mFeatureVector(nCnt, 1) = matEng(j,1);
        mFeatureVector(nCnt, 2) = matZcr(j,1);
        
        for jj = 1:nCol
            mFeatureVector(nCnt, 2+jj) = matMfcc(j,jj);
        end
    end

    nFeatureLen = length(matEng);

end

% Step 2: Standardize the Feature Vector
mFeatureVectorZ = [];
[nRow nCol] = size(mFeatureVector);

for t = 1:nRow
    for s = 1:nCol
        mFeatureVectorZ(t,s) = (mFeatureVector(t,s) - mStandardizationParam(s,1))/mStandardizationParam(s,2);
    end
end

% Step 3: Classify standardized feature vectors based on the K-mean
% centroid
mClassID = SS_ClassifyBasedOnKmeans(mKmeansCentroid, mFeatureVectorZ);

% Step 4:  
mTrainRet = SS_TrainHMM(nState, nObservation, mClassID);

mTRANS_EST = mTrainRet(1:nState, 1:nState);
mEMIS_EST = mTrainRet(1:nState, nState+1:nState+nObservation);

% Save HMM parameter (i.e. Transition Matrix and Emission Matrix) into file
sTransFile = [sBaseFolder 'LargeScale_StandKmeans\HMM\' sModelName '_HMM_TRANS_' num2str(nState) '_' num2str(nObservation) '.csv'];
sEmisFile = [sBaseFolder 'LargeScale_StandKmeans\HMM\' sModelName '_HMM_EMIS_' num2str(nState) '_' num2str(nObservation) '.csv'];

fid_resultTrans = fopen(sTransFile, 'w');

[nTransRow nTransCol] = size(mTRANS_EST);
for i=1:nTransRow
    for j=1:nTransCol
        fprintf(fid_resultTrans, '%f,', mTRANS_EST(i,j));
    end
    fprintf(fid_resultTrans, '\n');
end

fclose(fid_resultTrans);

fid_resultEmis = fopen(sEmisFile, 'w');

[nEmisRow nEmisCol] = size(mEMIS_EST);
for i=1:nEmisRow
    for j=1:nEmisCol
        fprintf(fid_resultEmis, '%f,', mEMIS_EST(i,j));
    end
    fprintf(fid_resultEmis, '\n');
end

fclose(fid_resultEmis);

fprintf('Finish Time: %s\n', datestr(clock, 'yyyy-mm-dd HH:MM:SS'));

return;
