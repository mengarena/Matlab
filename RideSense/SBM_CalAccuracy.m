function [fAllAccuracy fRouteSegAccuracy  fRouteTraceAccuracy fRouteAccuracy fSegLenCorrect fSegLenChargedMoreRatio fSegLenChargedLessRatio fMeanDTWDistAllCorrect fMeanDTWDistRouteSegCorrect fMeanDTWDistRouteTraceCorrect fMeanDTWDistRouteCorrect] = SBM_CalAccuracy(mEvalResult)
% This function is used to calculate the All Accuracy and Route Seg
% Accuracy of the given mEvalResult
%
% In mEvalResult, each line:
% (Passenger) 
% (1) RouteNo, (2) TraceNo, (3) Position (1-hand, 2-pocket), (4) SegLen, (5) SrcSegNo, (6) DstSegNo, 
% (Reference-matched) 
% (7) RouteNo, (8) TraceNo, (9) SegLen, (10) SrcSegNo,(11) DstSegNo, 
% (12)Total Raw Ref Segment Combination, (13) Number of Ref Segment Combination after 1st-stage
% reducing search space (i.e. the actual number goes
% through Detailed Feature based matching)  [Exception:  if nFeatureMatchingRefCombCnt = 1,  directly conclude without Detailed-feature based matching]
% (14) Matched DTW Distance

[nTotalRowCnt ~] = size(mEvalResult);
if nTotalRowCnt == 0
    fAllAccuracy = 0;         % Which/Where/When
    fRouteSegAccuracy = 0;    % Which/Where
    fRouteTraceAccuracy = 0;  % Which/When
    fRouteAccuracy = 0;       % Which
    
    fSegLenCorrect = 0;
    fSegLenChargedMoreRatio = 0;
    fSegLenChargedLessRatio = 0;
    
    fMeanDTWDistAllCorrect = 0.0;         % Which/Where/When
    fMeanDTWDistRouteSegCorrect = 0.0;    % Which/Where
    fMeanDTWDistRouteTraceCorrect = 0.0;  % Which/When
    fMeanDTWDistRouteCorrect = 0.0;       % Which
    return;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% All Accuracy %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% Route, Trace No, SrcSegNo, DstSegNo all must be the same %%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% Route Seg Accuracy %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% Route, SrcSegNo, DstSegNo all must be the same %%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
nAllCorrectNum = 0;   % Route, Trace, Src Seg No, Dst Seg No all must be the same (could know which, where to where, when)
nRouteSegCorrectNum = 0;   % Route, Src Seg No, Dst Seg No must be the same (could know which , where to where)
nRouteTraceCorrectNum = 0; % Route No and Trace no should be the same
nRouteCorrectNum = 0;   % Route No should be the same

nSegLenCorrectNum = 0;  % The segment len of Passenger trace must be the same as the reference trace
nSegLenPsgFewerNum = 0;  % In matched trace, Psg Seg Len < Ref Seg Len  (will be charged more than needed)
nSegLenPsgMoreNum = 0;   % In matched trace, Psg Seg Len > Ref Seg Len (will be charged less than needed)

nActualMatchedNum = 0;


%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Added on 2016/05/19
mMatchedDTWDistAllCorrect = [];
mMatchedDTWDistRouteSegCorrect = [];
mMatchedDTWDistRouteTraceCorrect = [];
mMatchedDTWDistRouteCorrect = [];
%%%%%%%%%%%%%%%%%%%%%%%%%%%

for i = 1:nTotalRowCnt
    if mEvalResult(i,1) == mEvalResult(i,7) && mEvalResult(i,2) == mEvalResult(i,8) && mEvalResult(i,5) == mEvalResult(i,10) && mEvalResult(i,6) == mEvalResult(i,11)
        nAllCorrectNum = nAllCorrectNum + 1;
        mMatchedDTWDistAllCorrect(nAllCorrectNum) = mEvalResult(i,14);  % Matched DTW Distance (added on 2016/05/19)
    end
    
    if mEvalResult(i,1) == mEvalResult(i,7) && mEvalResult(i,5) == mEvalResult(i,10) && mEvalResult(i,6) == mEvalResult(i,11)
        nRouteSegCorrectNum = nRouteSegCorrectNum + 1;
        mMatchedDTWDistRouteSegCorrect(nRouteSegCorrectNum) = mEvalResult(i,14);  % Matched DTW Distance (added on 2016/05/19)
    end
        
    if mEvalResult(i,1) == mEvalResult(i,7) && mEvalResult(i,2) == mEvalResult(i,8)
        nRouteTraceCorrectNum = nRouteTraceCorrectNum + 1;
        mMatchedDTWDistRouteTraceCorrect(nRouteTraceCorrectNum) = mEvalResult(i,14);  % Matched DTW Distance (added on 2016/05/19)
    end
    
    if mEvalResult(i,1) == mEvalResult(i,7)
        nRouteCorrectNum = nRouteCorrectNum + 1;
        mMatchedDTWDistRouteCorrect(nRouteCorrectNum) = mEvalResult(i,14);  % Matched DTW Distance (added on 2016/05/19)
    end
    
    if mEvalResult(i,4) == mEvalResult(i,9) && mEvalResult(i,9) > 0
        nSegLenCorrectNum = nSegLenCorrectNum + 1; 
    elseif mEvalResult(i,4) < mEvalResult(i,9) && mEvalResult(i,9) > 0  % Passenger Seg Len < matched Ref Seg Len, will be charged more
        nSegLenPsgFewerNum = nSegLenPsgFewerNum + 1;
    elseif mEvalResult(i,4) > mEvalResult(i,9) && mEvalResult(i,9) > 0  % Passenger Seg Len > matched Ref Seg Len, will be charged less 
        nSegLenPsgMoreNum = nSegLenPsgMoreNum + 1;
    end
    
    if mEvalResult(i,9) > 0
        nActualMatchedNum = nActualMatchedNum + 1;
    end
end


fAllAccuracy = nAllCorrectNum*1.0/nTotalRowCnt;
fRouteSegAccuracy = nRouteSegCorrectNum*1.0/nTotalRowCnt;
fRouteTraceAccuracy = nRouteTraceCorrectNum*1.0/nTotalRowCnt;
fRouteAccuracy = nRouteCorrectNum*1.0/nTotalRowCnt;

fSegLenCorrect = nSegLenCorrectNum*1.0/nActualMatchedNum;
fSegLenChargedMoreRatio = nSegLenPsgFewerNum*1.0/nActualMatchedNum;
fSegLenChargedLessRatio = nSegLenPsgMoreNum*1.0/nActualMatchedNum;

fMeanDTWDistAllCorrect = 0.0;
fMeanDTWDistRouteSegCorrect = 0.0;
fMeanDTWDistRouteTraceCorrect = 0.0;
fMeanDTWDistRouteCorrect = 0.0;

if nAllCorrectNum > 0
    fMeanDTWDistAllCorrect = mean(mMatchedDTWDistAllCorrect);
end

if nRouteSegCorrectNum > 0
    fMeanDTWDistRouteSegCorrect = mean(mMatchedDTWDistRouteSegCorrect);
end

if nRouteTraceCorrectNum > 0
    fMeanDTWDistRouteTraceCorrect = mean(mMatchedDTWDistRouteTraceCorrect);
end

if nRouteCorrectNum > 0
    fMeanDTWDistRouteCorrect = mean(mMatchedDTWDistRouteCorrect);
end

return;
