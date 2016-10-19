function f = SBM_StopDetection_TestSVM(sSvmModelFile, sDimMeanStdFile, mTestFeatureVector, mGroundTruthLabel)
% @sSvmModelFile stores SVM model
% @sDimMeanStdFile stores mean and std of the features from Training, these means/stds should be used to normalize the features for test
% In this file, each line contains one mean, std pair for one feature
% @mTestFeatureVector: Feature vector of test data (have not been normalized) 
% @mGroundTruthLabel:  Ground Truth of Test Data (corresponds to mTestFeatureVector)
%

fprintf('SVM Test Start Time: %s\n', datestr(clock, 'yyyy-mm-dd HH:MM:SS'));

format long;

disp('Testing......');

mDimMeanStd = load(sDimMeanStdFile);   % Mean/Std of features from Training data; In mDimMeanStd, first column is mean;  second column is std

mDimMean = mDimMeanStd(:, 1);
mDimStd = mDimMeanStd(:, 2);

% Standardize the feature vectors
mStandardizedTestFeatureVector = [];
[nRow nFeatureCnt] = size(mTestFeatureVector);

if nFeatureCnt ~= length(mDimMean)
       disp('Number of Features in Test data does not match with Number of Features in trained SVM model !');
       return;
end

for i=1:nRow
    for j=1:nFeatureCnt
        mStandardizedTestFeatureVector(i, j) = (mTestFeatureVector(i,j) - mDimMean(j))/mDimStd(j);
    end
end

%%% Load SVM Model
svmModel = loadmodel(sSvmModelFile, nFeatureCnt);

% Test on svmModel
[mPredictedLabel, accuracy, probValues] = svmpredict(mGroundTruthLabel, mStandardizedTestFeatureVector, svmModel); 

f = mPredictedLabel;

fprintf('SVM Test End Time: %s\n', datestr(clock, 'yyyy-mm-dd HH:MM:SS'));

return;
