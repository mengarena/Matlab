function f = SBM_FilterPassengerBasicFeature(mSegBasicFeature, mUniquedTmCrtTrace, nIdxDataType)
% This function is used to filter the basic feature (moving,stop, turn) if
% its duration is too short and merge neighboring features if they have the
% same type
%
% Fields in Basic Feature
%  Type, Duration, Start Line, End Line, GPS Lat, GPS Long
%

format long;

fDurationThreshold = 1.0;  

[nBasicFeatureCnt ~] = size(mSegBasicFeature);

mThresholdedBF = [];

% Filter features which has small duration
for i = 1:nBasicFeatureCnt
    if mSegBasicFeature(i,1) == 2  % For Turn, mSegBasicFeature(i,2) is direction information, so anyway keep it
        mThresholdedBF = [mThresholdedBF; mSegBasicFeature(i,:)];
    else  % For Stop/Moving, mSegBasicFeature(i,2) is duration
        if mSegBasicFeature(i,2) >= fDurationThreshold 
            mThresholdedBF = [mThresholdedBF; mSegBasicFeature(i,:)];
        end 
    end
end

mMergedBF = SBM_MergePassengerBasicFeature(mThresholdedBF, mUniquedTmCrtTrace, nIdxDataType);

f = mMergedBF;

return;
