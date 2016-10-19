function fMatchingDist = SBM_MatchingMotion(mRefDF, mPsgDF, mSelectedFeatures)
% This function is used to match the detailed motion between Reference
% trace and Passenger trace
%
% The matching is based on the selected features
%
format long;

fMatchingDist = 99999999;

mSelectedRefDF = mRefDF(:, mSelectedFeatures);
mSelectedPsgDF = mPsgDF(:, mSelectedFeatures);

[nRefRowCnt nRefColCnt] = size(mSelectedRefDF);
[nPsgRowCnt nPsgColCnt] = size(mSelectedPsgDF);

% Normalize features (Might need to try different ways of normalization)
for i=1:nRefColCnt
    mSelectedRefDF(:,i) = zscore(mSelectedRefDF(:,i));
end

for i=1:nPsgColCnt
    mSelectedPsgDF(:,i) = zscore(mSelectedPsgDF(:,i));
end

% DTW
[fDist,mDist,nPathLen,mPath,mMatchedRef,mMatchedPsg] = md_dtw(mSelectedRefDF,mSelectedPsgDF);

fMatchingDist = fDist/nPathLen;   % Normalized over the warping path

return;
