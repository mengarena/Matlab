function f = SBM_MergePassengerBasicFeature(mBasicFeature, mUniquedTmCrtTrace, nIdxDataType)
% mBasicFeature contains unit motion feature with small length and
% neighboring same features are not mergered.
% This function is used to merge same neighboring features.
%
% @mBasicFeature: Each record is 1-second window motion feature,
% neighboring records overlaps by 0.5 seconds Or a record is a turn
%    Each line:  Type (0--stop, 1--moving, 2-turn), Duration/Direction, Start Line (in
%    Original trace), End Line
%

format long;

[nBFCnt ~] = size(mBasicFeature);

% Merge ramained features
mMergedBF = [];

if nBFCnt == 1
    mMergedBF(1,1) = mBasicFeature(1,1);
    if mBasicFeature(1,1) ~= 2  % Stop/Moving
        mMergedBF(1,2) = mUniquedTmCrtTrace(mBasicFeature(1,4),1) - mUniquedTmCrtTrace(mBasicFeature(1,3),1);   % Duration
    else  % Turn
        mMergedBF(1,2) = mBasicFeature(1,2);
    end
    mMergedBF(1,3) = mBasicFeature(1,3);
    mMergedBF(1,4) = mBasicFeature(1,4);
    mMergedBF(1,5) = mBasicFeature(1,5);
    mMergedBF(1,6) = mBasicFeature(1,6);
    
    f = mMergedBF;
    return;
end


nPreviousType = mBasicFeature(1,1);
nPreviousDurationDirection = mBasicFeature(1,2);  % Duration or Direction
nPreviousStartLine = mBasicFeature(1,3);
nPreviousEndLine = mBasicFeature(1,4);
nMergedBFIdx = 0;

nBFIdx = 2;

while nBFIdx <= nBFCnt
    nCurrentType = mBasicFeature(nBFIdx, 1);  
    
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
        %nPreviousStartLine = mBasicFeature(nBFIdx, 3);
        nPreviousStartLine = nPreviousEndLine + 1;
        nPreviousEndLine = mBasicFeature(nBFIdx, 4);

        if nCurrentType == 2
            nPreviousDurationDirection = mBasicFeature(nBFIdx, 2);  % Duration or Direction
        else
            nPreviousDurationDirection = mUniquedTmCrtTrace(nPreviousEndLine, 1) - mUniquedTmCrtTrace(nPreviousStartLine, 1);
        end
    else
        if nPreviousType ~= 2  % Stop/Moving
            nPreviousEndLine = mBasicFeature(nBFIdx, 4);
        else % Turn
            if mBasicFeature(nBFIdx, 2) ~= nPreviousDurationDirection   % Both are turn, but directions are different, should NOT merge
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
                nPreviousDurationDirection = mBasicFeature(nBFIdx,2);  % Duration or Direction
                % nPreviousStartLine = mBasicFeature(nBFIdx, 3);
                nPreviousStartLine = nPreviousEndLine + 1;   %%

                nPreviousEndLine = mBasicFeature(nBFIdx, 4);
            else
                nPreviousEndLine = mBasicFeature(nBFIdx, 4);  % Merge Turn
            end
        end
    end
    
    nBFIdx = nBFIdx + 1;
end

% Process the remained last one
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
