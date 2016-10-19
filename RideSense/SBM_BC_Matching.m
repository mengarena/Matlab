function f = SBM_BC_Matching(nFeatureCombType)

format long;

if nFeatureCombType == 1   % Motion sensor Features
    mSelectedFeatures = [2,9,62];
    sResultFile = 'E:\SensorMatching\Data\Bus_Car\Result\MatchingRet_Motion.csv';
else
    mSelectedFeatures = [41:50];
    sResultFile = 'E:\SensorMatching\Data\Bus_Car\Result\MatchingRet_Baro.csv';
end

fidRet = fopen(sResultFile, 'w');


sFeatureFolder = 'E:\SensorMatching\Data\Bus_Car\FeaturePCA';

nSegCnt = 7;

sRefFeatureFilePrefix = 'Ref_Uniqued_TmCrt_SegDF';

sArrQueryFeatureFilePrefix = [ ...
     'Pocket_Bus_Uniqued_TmCrt_SegDF  '; ...    % 1
     'Pocket_Car_Uniqued_TmCrt_SegDF  '; ...    % 2
     'Seat_Car_Uniqued_TmCrt_SegDF    '; ...    % 3
];

cellQueryFeatureFilePrefix = cellstr(sArrQueryFeatureFilePrefix);


for i = 1:3   % Query
    for j = 1:nSegCnt
        sRefFeatureFile = [sFeatureFolder '\' sRefFeatureFilePrefix '_' num2str(j) '.csv'];
        sQueryFeatureFile = [sFeatureFolder '\' cellQueryFeatureFilePrefix{i} '_' num2str(j) '.csv'];
        
        mRefDF = load(sRefFeatureFile);
        mQueryDF = load(sQueryFeatureFile);
        
        fMatchingDist = SBM_MatchingMotion(mRefDF, mQueryDF, mSelectedFeatures);   %Returned distance is normalized over warping path length

        fprintf(fidRet, '%d, %d, %5.8f\n', i, j, fMatchingDist);
    end
end

fclose(fidRet);

return;
