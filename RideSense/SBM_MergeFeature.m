function f = SBM_MergeFeature(mSegBasicFeature, mUniquedTmCrtTrace, nIdxDataType)
% This function is used to merge the basic features in mSegBasicFeature
% The basic feature here is in small window (Moving, Stop)
% The neighboring windows might have same type,
% Need to merge these same-type neighboring features into one feature which
% is different from before and after neighboring features
%
% e.g Feature s1s2M1M2s5s6s7===>sM1M2s  (s1,s2 should be merge, M1 and M2
% should be merged, a5a6a7 should be mered into one
%
% In mSegBasicFeature, each row:
%  Type, Duration, Start Line, End Line (Start/End is in the original
%  trace)
%
% After merging, needs to add two columns (GPS Lat, GPS Long) 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

format long;

mMergedBF = [];

[nRawBFCnt ~] = size(mSegBasicFeature);

nPreviousType = mSegBasicFeature(1,1);
nPreviousStartLine = mSegBasicFeature(1,3);
nPreviousEndLine = mSegBasicFeature(1,4);

nMergedBFIdx = 0;
nBFIdx = 2;

while nBFIdx <= nRawBFCnt
    nCurrentType = mThresholdedBF(nBFIdx, 1);  
    
    if nCurrentType ~= nPreviousType
        nMergedBFIdx = nMergedBFIdx + 1;
        mMergedBF(nMergedBFIdx, 1) = nPreviousType;
        mMergedBF(nMergedBFIdx, 2) = mUniquedTmCrtTrace(nPreviousEndLine, 1) - mUniquedTmCrtTrace(nPreviousStartLine, 1);
        mMergedBF(nMergedBFIdx, 3) = nPreviousStartLine;
        mMergedBF(nMergedBFIdx, 4) = nPreviousEndLine;
        
        [fMeanGpsLat, fMeanGpsLng, fMeanGpsAlt] = SBM_GetMeanGps(mUniquedTmCrtTrace, nIdxDataType, nPreviousStartLine, nPreviousEndLine);
        mMergedBF(nMergedBFIdx, 5) = fMeanGpsLat;
        mMergedBF(nMergedBFIdx, 6) = fMeanGpsLng;
                
        nPreviousType = nCurrentType;
        %nPreviousStartLine = mSegBasicFeature(nBFIdx, 3);
        nPreviousStartLine = nPreviousEndLine+1;  % Avoid overlap
        nPreviousEndLine = mSegBasicFeature(nBFIdx, 4);
    else
        nPreviousEndLine = mSegBasicFeature(nBFIdx, 4);
    end
    
    nBFIdx = nBFIdx + 1;
end

nMergedBFIdx = nMergedBFIdx + 1;
mMergedBF(nMergedBFIdx, 1) = nPreviousType;
mMergedBF(nMergedBFIdx, 2) = mUniquedTmCrtTrace(nPreviousEndLine, 1) - mUniquedTmCrtTrace(nPreviousStartLine, 1);
mMergedBF(nMergedBFIdx, 3) = nPreviousStartLine;
mMergedBF(nMergedBFIdx, 4) = nPreviousEndLine;
[fMeanGpsLat, fMeanGpsLng, fMeanGpsAlt] = SBM_GetMeanGps(mUniquedTmCrtTrace, nIdxDataType, nPreviousStartLine, nPreviousEndLine);
mMergedBF(nMergedBFIdx, 5) = fMeanGpsLat;
mMergedBF(nMergedBFIdx, 6) = fMeanGpsLng;

f = mMergedBF;

return;
