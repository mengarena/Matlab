function f = SBM_ExtractPassengerBasicFeature(mUniquedTmCrtTrace, mRawBasicFeature, nIdxDataType)
% This function is used to merge neighboring motion unit
% and also insert the Turn unit
% to form basic features about one segment
%
% @mRawBasicFeature: Each record is 1-second window motion feature,
% neighboring records overlaps by 0.5 seconds
%    Each line:  Type (0--stop, 1--moving), Duration, Start Line (in
%    Original trace), End Line
%
% @mTurns: Each record is a turn:  Begin Line, End Line, Direction (1--Left, -1--Right, 0--No Turn), Turn Degree,
%

format long;

mMergedBasicFeature = SBM_MergePassengerBasicFeature(mRawBasicFeature, mUniquedTmCrtTrace, nIdxDataType);

mFilteredBasicFeature = SBM_FilterPassengerBasicFeature(mMergedBasicFeature, mUniquedTmCrtTrace, nIdxDataType);

f = mFilteredBasicFeature;

return;
