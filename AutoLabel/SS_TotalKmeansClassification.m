function f = SS_TotalKmeansClassification()
% This function is used to classify the test data based on the clusters
% constructed by K-means
%
fprintf('Start Time: %s\n', datestr(clock, 'yyyy-mm-dd HH:MM:SS'));

format long;

mK = [15 20 25 30];

sBaseFolder = 'E:\UIUC\TryAudioModel\';

sPlaceNames = [ ...
    'BarnesNoble              '; ...
    'Cravings                 '; ... 
    'Walsgreen                '; ...
    'CSL                      '; ...
    'Street                   '
];

cellPlaceNames = cellstr(sPlaceNames);

for i=1:length(mK)
    sKmeansCentroidFile = [sBaseFolder 'KMeansResult\' 'KmeansCentroid_' num2str(mK(i)) '.csv'];
    mKmeansCentroid = load(sKmeansCentroidFile);
    
    sStandardizationParamFile = [sBaseFolder  'StandarizationParam\' 'StandarizationParam_' num2str(mK(i)) '.csv'];
    mStandardizationParam = load(sStandardizationParamFile);
    
    for j=1:length(cellPlaceNames)
        sTestFeatureVectorFile = [sBaseFolder 'TestFeatureVector\' cellPlaceNames{j} '_Feature_Test.csv'];
        fprintf('Classifying [K = %d]:  %s \n', mK(i), sTestFeatureVectorFile);
        mTestFeatureVector = load(sTestFeatureVectorFile);
        [nTmpRow nTmpCol] = size(mTestFeatureVector);
        % Standardize the test feature vector based on the mean and std
        % generated during standardizing training data
        mTestFeatureVectorZ = [];
        for t = 1:nTmpRow
            for s = 1:nTmpCol
                mTestFeatureVectorZ(t,s) = (mTestFeatureVector(t,s) - mStandardizationParam(s,1))/mStandardizationParam(s,2);
            end
        end
        
        mClassID = SS_ClassifyBasedOnKmeans(mKmeansCentroid, mTestFeatureVectorZ);
         
        % Save classified Class IDs into file
        
        sClassifiedClassIDFile = [sBaseFolder 'KMeansClassifiedTestFeatureData\' cellPlaceNames{j} '_KmeansIdx_' num2str(mK(i)) '.csv'];
        fid_result = fopen(sClassifiedClassIDFile, 'w');
        
        for m =1:length(mClassID)
            fprintf(fid_result, '%d\n', mClassID(m));  % This will be the observation sequence and they will be the input for HMM classification.
        end
        
        fclose(fid_result);
    end

end

fprintf('Finish Time: %s\n', datestr(clock, 'yyyy-mm-dd HH:MM:SS'));

return;
