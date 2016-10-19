function f = SS_Kmeans(nMeans)
% This function performs K-Means clustering
% After clustering, the Class ID for the original feature vectores are also
% saved in files.
%
% Parameter
%   @ nMeans:  How many clusters should be formed (i.e. K)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fprintf('Start Time: %s\n', datestr(clock, 'yyyy-mm-dd HH:MM:SS'));

format long;

mFeature = [];

sBaseFolder = 'E:\UIUC\TryAudioModel\';

sCommonPostFix = '_Feature_Train.csv';

sPlaceNames = [ ...
    'BarnesNoble              '; ...
    'Cravings                 '; ... 
    'Walsgreen                '; ...
    'CSL                      '; ...
    'Street                   '
];

cellPlaceNames = cellstr(sPlaceNames);

mFeature = [];

mRows = [];

for i=1:length(cellPlaceNames)
    sFeatureFile = [sBaseFolder 'TrainFeatureVector\' cellPlaceNames{i} sCommonPostFix];
    mTmp = load(sFeatureFile);
    
    [nRow nCol] = size(mTmp);
    mRows(i) = nRow;
    
    mFeature = [mFeature; mTmp];
end

[nRow nCol] = size(mFeature);

%%//////////////////////
%% This part is NOT good, use standardization instead
% fMax = max(max(mFeature));
% fMin = min(min(mFeature));
% 
% % Normalize feature values
% for i=1:nRow
%     for j=1:nCol
%         fTmpValue = (mFeature(i,j) - fMin) / (fMax - fMin);
%       %  mFeature(i,j) = log10(fTmpValue);
%         mFeature(i,j) = fTmpValue;
%     end
% end
%%//////////////////////
[mStandardizedFeature, mMean, mStd] = zscore(mFeature);

% Save the standarization parameter, which will be used to standarize the
% test data
% In this file, each line is: mean, std (which corresponds to the mean/std
% of each column in the feature vector file
sStandardizationParameterFile = [sBaseFolder  'StandarizationParam\' 'StandarizationParam_' num2str(nMeans) '.csv'];
fid_resultStandardize = fopen(sStandardizationParameterFile, 'w');
for i = 1:length(mMean)
    fprintf(fid_resultStandardize, '%f,%f\n', mMean(i), mStd(i));
end
fclose(fid_resultStandardize);

% Do K-Means
[IDX Centroid] = kmeans(mStandardizedFeature, nMeans);

%%%%%%%%%%%% Save KMeans Centroid
[nCentroidRow nCentroidCol] = size(Centroid);

sKmeansCentroidFile = [sBaseFolder  'KMeansResult\' 'KmeansCentroid_' num2str(nMeans) '.csv'];

fid_resultCentroid = fopen(sKmeansCentroidFile, 'w');

for ii=1:nCentroidRow
    for jj=1:nCentroidCol
        fprintf(fid_resultCentroid, '%f,', Centroid(ii,jj));
    end
    fprintf(fid_resultCentroid,'\n');
end    

fclose(fid_resultCentroid);
%%%%%%%%%%%%%%%%%%

%%% Save Kmeans index 

nStartRow = 1;
nEndRow = 0;

for i=1:length(cellPlaceNames)
    sKmeansIdxFile = [sBaseFolder 'KMeansResult\' cellPlaceNames{i} '_KmeansIdx_' num2str(nMeans) '.csv']
    fid_resultIdx = fopen(sKmeansIdxFile, 'w');

    nEndRow = nEndRow + mRows(i);
    
    for j=nStartRow:nEndRow
        fprintf(fid_resultIdx, '%d\n', IDX(j,1));
    end

    fclose(fid_resultIdx); 
    
    nStartRow = nStartRow + mRows(i);
end

fprintf('Finish Time: %s\n', datestr(clock, 'yyyy-mm-dd HH:MM:SS'));

return;
