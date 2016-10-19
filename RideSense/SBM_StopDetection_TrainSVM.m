function f = SBM_StopDetection_TrainSVM(mFeatureVector, mLabels, sDimMeanStdFile, sResultSvmModelFile)

% @mFeatureVector:  Feature vectors for training: (Raw data, have not been normalized)
% @mLabels:  Labels correspond to Feature Vector
% @sDimMeanStdFile:  This file is used to save the Means/Stds of the features, which should be used to normalize the features in test data
% @sResultSvmModelFile: This file is used to save the trained SVM model
% 

fprintf('SVM Training Start Time: %s\n', datestr(clock, 'yyyy-mm-dd HH:MM:SS'));

format long;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Standardize feature vectors to avoid scale problem between feature values
% of different dimensions

disp('Standardizing Feature Vectors......');

[nRow nFeatureCnt] = size(mFeatureVector);

mDimMean = [];
mDimStd = [];

% Get the mean and std for the value of each dimensions
% These values should be saved to standardize the test data
for j=1:nFeatureCnt
    mDimMean(1,j) = mean(mFeatureVector(:,j));
    mDimStd(1,j) = std(mFeatureVector(:,j));
end

% Save DimMean and DimStd in file
fid_DimMeanStd = fopen(sDimMeanStdFile, 'w');
for j=1:nFeatureCnt
    fprintf(fid_DimMeanStd, '%f,%f\n', mDimMean(1,j), mDimStd(1,j));
end
fclose(fid_DimMeanStd);

% Standardize (normalize) the feature vectors
mStandardizedFeatureVector  = [];

for i=1:nRow
    for j=1:nFeatureCnt
        mStandardizedFeatureVector(i, j) = (mFeatureVector(i,j) - mDimMean(1,j))/mDimStd(1,j);
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Train SVM
disp('Training SVM......');

svmModel = svmtrain(mLabels,  mStandardizedFeatureVector);

% Save svmModel into a file, which could be used later
savemodel(sResultSvmModelFile, svmModel);

fprintf('SVM Training End Time: %s\n', datestr(clock, 'yyyy-mm-dd HH:MM:SS'));

return;
