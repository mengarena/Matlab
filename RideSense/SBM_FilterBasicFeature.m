function f = SBM_FilterBasicFeature(mSegBasicFeature, mUniquedTmCrtTrace, nIdxDataType)
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

[nThresholdBFCnt ~] = size(mThresholdedBF);


% Merge ramained features
mMergedBF = [];

if nThresholdBFCnt == 1
    mMergedBF(1,1) = mThresholdedBF(1,1);
    if mThresholdedBF(1,1) ~= 2  % Stop/Moving
        mMergedBF(1,2) = mUniquedTmCrtTrace(mSegBasicFeature(nBasicFeatureCnt,4),1) - mUniquedTmCrtTrace(mSegBasicFeature(1,3),1);   % Duration
    else  % Turn
        mMergedBF(1,2) = mThresholdedBF(1,2);
    end
    mMergedBF(1,3) = mSegBasicFeature(1,3);
    mMergedBF(1,4) = mSegBasicFeature(nBasicFeatureCnt,4);
    mMergedBF(1,5) = mean(mSegBasicFeature(:,5));
    mMergedBF(1,6) = mean(mSegBasicFeature(:,6));
    
    f = mMergedBF;
    return;
end


nPreviousType = mThresholdedBF(1,1);
nPreviousDurationDirection = mThresholdedBF(1,2);  % Duration or Direction
nPreviousStartLine = mThresholdedBF(1,3);
nPreviousEndLine = mThresholdedBF(1,4);
nMergedBFIdx = 0;

nBFIdx = 2;

while nBFIdx <= nThresholdBFCnt
    nCurrentType = mThresholdedBF(nBFIdx, 1);  
    
    if nCurrentType ~= nPreviousType
        % Save previous unit
        nMergedBFIdx = nMergedBFIdx + 1;
        mMergedBF(nMergedBFIdx, 1) = nPreviousType;
        if nPreviousType ~= 2   % Stop/Moving
            mMergedBF(nMergedBFIdx, 2) = mUniquedTmCrtTrace(nPreviousEndLine, 1) - mUniquedTmCrtTrace(nPreviousStartLine, 1);
        else  % Turn
            mMergedBF(nMergedBFIdx, 2) = nPreviousDurationDirection;
        end
        mMergedBF(nMergedBFIdx, 3) = nPreviousStartLine;
        mMergedBF(nMergedBFIdx, 4) = nPreviousEndLine;
        [fMeanGpsLat, fMeanGpsLng, fMeanGpsAlt] = SBM_GetMeanGps(mUniquedTmCrtTrace, nIdxDataType, nPreviousStartLine, nPreviousEndLine);
        mMergedBF(nMergedBFIdx, 5) = fMeanGpsLat;
        mMergedBF(nMergedBFIdx, 6) = fMeanGpsLng;
        
        nPreviousType = nCurrentType;
        nPreviousDurationDirection = mThresholdedBF(nBFIdx,2);  % Duration or Direction
        nPreviousStartLine = mThresholdedBF(nBFIdx, 3);
        nPreviousEndLine = mThresholdedBF(nBFIdx, 4);
    else
        if nPreviousType ~= 2  % Stop/Moving
            nPreviousEndLine = mThresholdedBF(nBFIdx, 4);
        else
            if mThresholdedBF(nBFIdx, 2) ~= nPreviousDurationDirection   % Both are turn, but directions are different, should NOT merge
                % Save previous turn
                nMergedBFIdx = nMergedBFIdx + 1;
                mMergedBF(nMergedBFIdx, 1) = nPreviousType;
                mMergedBF(nMergedBFIdx, 2) = nPreviousDurationDirection;
                mMergedBF(nMergedBFIdx, 3) = nPreviousStartLine;
                mMergedBF(nMergedBFIdx, 4) = nPreviousEndLine;
                [fMeanGpsLat, fMeanGpsLng, fMeanGpsAlt] = SBM_GetMeanGps(mUniquedTmCrtTrace, nIdxDataType, nPreviousStartLine, nPreviousEndLine);
                mMergedBF(nMergedBFIdx, 5) = fMeanGpsLat;
                mMergedBF(nMergedBFIdx, 6) = fMeanGpsLng;

                nPreviousType = nCurrentType;
                nPreviousDurationDirection = mThresholdedBF(nBFIdx,2);  % Duration or Direction
                nPreviousStartLine = mThresholdedBF(nBFIdx, 3);
                nPreviousEndLine = mThresholdedBF(nBFIdx, 4);
            else
                nPreviousEndLine = mThresholdedBF(nBFIdx, 4);
            end
        end
    end
    
    nBFIdx = nBFIdx + 1;
end

nMergedBFIdx = nMergedBFIdx + 1;
mMergedBF(nMergedBFIdx, 1) = nPreviousType;
if nPreviousType ~= 2  % Stop/Moving
    mMergedBF(nMergedBFIdx, 2) = mUniquedTmCrtTrace(nPreviousEndLine, 1) - mUniquedTmCrtTrace(nPreviousStartLine, 1);
else  % Turn
    mMergedBF(nMergedBFIdx, 2) = nPreviousDurationDirection;
end
mMergedBF(nMergedBFIdx, 3) = nPreviousStartLine;
mMergedBF(nMergedBFIdx, 4) = nPreviousEndLine;
[fMeanGpsLat, fMeanGpsLng, fMeanGpsAlt] = SBM_GetMeanGps(mUniquedTmCrtTrace, nIdxDataType, nPreviousStartLine, nPreviousEndLine);
mMergedBF(nMergedBFIdx, 5) = fMeanGpsLat;
mMergedBF(nMergedBFIdx, 6) = fMeanGpsLng;


f = mMergedBF;

return;
