function f = SBM_EvaluteAccuracy(sEvaluationResultFile, nPlot)
% This function is used to calculate the accuracy of sensor based (detailed
% feature) matching
%
% In sEvaluationResultFile, each line:
% (Passenger) 
% (1) RouteNo, (2) TraceNo, (3) Position (1-hand, 2-pocket), (4) SegLen, (5) SrcSegNo, (6) DstSegNo, 
% (Reference-matched) 
% (7) RouteNo, (8) TraceNo, (9) SegLen, (10) SrcSegNo,(11) DstSegNo, 
% (12)Total Raw Ref Segment Combination, (13) Number of Ref Segment Combination after 1st-stage
% reducing search space (i.e. the actual number goes
% through Detailed Feature based matching)  [Exception:  if nFeatureMatchingRefCombCnt = 1,  directly conclude without Detailed-feature based matching]
% (14) Matched DTW Distance
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%sEvaluationResultFile = 'E:\SensorMatching\Data\SchoolShuttle\Evaluation20160226\EvRet_1_2_3_4_21_22_23_24.csv';
%sEvaluationResultFile = 'E:\SensorMatching\Data\SchoolShuttle\Evaluation20160226\EvRet_41_42_43_44_45_46_47_48_49_50.csv';

%sEvaluationResultFile = 'E:\SensorMatching\Data\SchoolShuttle\Evaluation_HotmobileVersion\EvRet_1_2_3_4_21_22_23_24.csv';

nPlot = 1;

format long;

mEvalResult = load(sEvaluationResultFile);


mAllAccuracy = [];   % "All" means Route No, Trace No, Src Seg No and Dst Seg No all must be correct, [Which/Where/When]
                     % Column 1: Overall, Column 2: PantPocket, Column 3: Hand
                     % Row 1:  Overall
                     % Row 2~n:  Different Segment Len
nAllAccuracyCnt = 0;

mRouteSegAccuracy = [];  % "RouteSeg" means Route No, Src Seg No and Dst Seg No all must be correct, [Which/Where]
                         % Column 1: Overall, Column 2: PantPocket, Column 3: Hand
                         % Row 1:  Overall
                         % Row 2~n:  Different Segment Len
nRouteSegAccuracyCnt = 0;

mRouteTraceAccuracy = [];  % "RouteTrace" means Route No, Trace No must be correct,  [Which/When]
                           % Column 1: Overall, Column 2: PantPocket, Column 3: Hand
                           % Row 1:  Overall
                           % Row 2~n:  Different Segment Len
nRouteTraceAccuracyCnt = 0;

mRouteAccuracy = [];  % "Route" means Route No must be correct,    [Which]
                      % Column 1: Overall, Column 2: PantPocket, Column 3: Hand
                      % Row 1:  Overall
                      % Row 2~n:  Different Segment Len
nRouteAccuracyCnt = 0;


mSegLenStat = [];    % "SegLen" shows different Segment Length statistics (PsgLen = RefLen;  PsgLen<RefLen; PsgLen > RefLen), 
                     % Column1~3: Overall; Column4~6: Pantpocket, Column7~9: Hand
                     % Row 1:  Overall
                     % Row 2~n:  Different Segment Len                     
nSegLenStatCnt = 0;


XTickTxtAll = [];
XTickTxtRouteSeg = [];
XTickTxtRouteTrace = [];
XTickTxtRoute = [];

xTickTextSegLen = [];

disp('########################################################');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% All Accuracy %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% Route, Trace No, SrcSegNo, DstSegNo all must be the same %%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% Route Seg Accuracy %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% Route, SrcSegNo, DstSegNo all must be the same %%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% Route Trace Accuracy %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% Route, Trace No all must be the same %%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% Route Accuracy %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% Route all must be the same %%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[fAllAccuracy fRouteSegAccuracy fRouteTraceAccuracy fRouteAccuracy fAllSegLenCorrect fAllSegLenChargedMoreRatio fAllSegLenChargedLessRatio fAllMeanDTWDistAllCorrect fAllMeanDTWDistRouteSegCorrect fAllMeanDTWDistRouteTraceCorrect fAllMeanDTWDistRouteCorrect] = SBM_CalAccuracy(mEvalResult);

mPocketEvalResult = mEvalResult(mEvalResult(:,3)==2,:);
[fPocketAllAccuracy fPocketRouteSegAccuracy fPocketRouteTraceAccuracy fPocketRouteAccuracy fPocketSegLenCorrect fPocketSegLenChargedMoreRatio fPocketSegLenChargedLessRatio fPocketMeanDTWDistAllCorrect fPocketMeanDTWDistRouteSegCorrect fPocketMeanDTWDistRouteTraceCorrect fPocketMeanDTWDistRouteCorrect] = SBM_CalAccuracy(mPocketEvalResult);

mHandEvalResult = mEvalResult(mEvalResult(:,3)==1,:);
[fHandAllAccuracy fHandRouteSegAccuracy fHandRouteTraceAccuracy fHandRouteAccuracy fHandSegLenCorrect fHandSegLenChargedMoreRatio fHandSegLenChargedLessRatio fHandMeanDTWDistAllCorrect fHandMeanDTWDistRouteSegCorrect fHandMeanDTWDistRouteTraceCorrect fHandMeanDTWDistRouteCorrect] = SBM_CalAccuracy(mHandEvalResult);

nAllAccuracyCnt = nAllAccuracyCnt + 1;
mAllAccuracy(nAllAccuracyCnt,1) = fAllAccuracy;
mAllAccuracy(nAllAccuracyCnt,2) = fPocketAllAccuracy;
mAllAccuracy(nAllAccuracyCnt,3) = fHandAllAccuracy;

XTickTxtAll{nAllAccuracyCnt} = 'Overall';


nRouteSegAccuracyCnt = nRouteSegAccuracyCnt + 1;
mRouteSegAccuracy(nRouteSegAccuracyCnt, 1) = fRouteSegAccuracy;
mRouteSegAccuracy(nRouteSegAccuracyCnt, 2) = fPocketRouteSegAccuracy;
mRouteSegAccuracy(nRouteSegAccuracyCnt, 3) = fHandRouteSegAccuracy;

XTickTxtRouteSeg{nRouteSegAccuracyCnt} = 'Overall';


nRouteTraceAccuracyCnt = nRouteTraceAccuracyCnt + 1;
mRouteTraceAccuracy(nRouteTraceAccuracyCnt, 1) = fRouteTraceAccuracy;
mRouteTraceAccuracy(nRouteTraceAccuracyCnt, 2) = fPocketRouteTraceAccuracy;
mRouteTraceAccuracy(nRouteTraceAccuracyCnt, 3) = fHandRouteTraceAccuracy;

XTickTxtRouteTrace{nRouteTraceAccuracyCnt} = 'Overall';


nRouteAccuracyCnt = nRouteAccuracyCnt + 1;
mRouteAccuracy(nRouteAccuracyCnt, 1) = fRouteAccuracy;
mRouteAccuracy(nRouteAccuracyCnt, 2) = fPocketRouteAccuracy;
mRouteAccuracy(nRouteAccuracyCnt, 3) = fHandRouteAccuracy;

XTickTxtRoute{nRouteAccuracyCnt} = 'Overall';


nSegLenStatCnt = nSegLenStatCnt + 1;
mSegLenStat(nSegLenStatCnt, 1) = fAllSegLenCorrect;
mSegLenStat(nSegLenStatCnt, 2) = fAllSegLenChargedMoreRatio;
mSegLenStat(nSegLenStatCnt, 3) = fAllSegLenChargedLessRatio;

mSegLenStat(nSegLenStatCnt, 4) = fPocketSegLenCorrect;
mSegLenStat(nSegLenStatCnt, 5) = fPocketSegLenChargedMoreRatio;
mSegLenStat(nSegLenStatCnt, 6) = fPocketSegLenChargedLessRatio;

mSegLenStat(nSegLenStatCnt, 7) = fHandSegLenCorrect;
mSegLenStat(nSegLenStatCnt, 8) = fHandSegLenChargedMoreRatio;
mSegLenStat(nSegLenStatCnt, 9) = fHandSegLenChargedLessRatio;

xTickTextSegLen{nSegLenStatCnt} = 'Overall';

fprintf('All [Route, Trace, Src Seg, Dst Seg] Accuracy: %3.4f\n', fAllAccuracy);

fprintf('Route Seg [Route, Src Seg, Dst Seg] Accuracy: %3.4f\n', fRouteSegAccuracy);

fprintf('Route Trace [Route, Trace] Accuracy: %3.4f\n', fRouteTraceAccuracy);

fprintf('Route [Route] Accuracy: %3.4f\n', fRouteAccuracy);

fprintf('Seg Len [Psg Len == Ref Len] Stat: [Correct] %3.4f;  [Charged More] %3.4f;  [Charged Less] %3.4f\n', fAllSegLenCorrect, fAllSegLenChargedMoreRatio, fAllSegLenChargedLessRatio);

fprintf('[All] Mean Matched DTW Distance: [Which/Where/When] = %3.4f\n', fAllMeanDTWDistAllCorrect);
fprintf('[All] Mean Matched DTW Distance: [Which/Where] = %3.4f\n', fAllMeanDTWDistRouteSegCorrect);
fprintf('[All] Mean Matched DTW Distance: [Which/When] = %3.4f\n', fAllMeanDTWDistRouteTraceCorrect);
fprintf('[All] Mean Matched DTW Distance: [Which] = %3.4f\n', fAllMeanDTWDistRouteCorrect);

disp('-------------------------------------------------------');

fprintf('[Pocket] All [Route, Trace, Src Seg, Dst Seg] Accuracy: %3.4f\n', fPocketAllAccuracy);

fprintf('[Pocket] Route Seg [Route, Src Seg, Dst Seg] Accuracy: %3.4f\n', fPocketRouteSegAccuracy);

fprintf('[Pocket] Route Trace [Route, Trace] Accuracy: %3.4f\n', fPocketRouteTraceAccuracy);

fprintf('[Pocket] Route [Route] Accuracy: %3.4f\n', fPocketRouteAccuracy);

fprintf('[Pocket] Seg Len [Psg Len == Ref Len] Stat: [Correct] %3.4f;  [Charged More] %3.4f;  [Charged Less] %3.4f\n', fPocketSegLenCorrect, fPocketSegLenChargedMoreRatio, fPocketSegLenChargedLessRatio);

fprintf('[Pocket] Mean Matched DTW Distance: [Which/Where/When] = %3.4f\n', fPocketMeanDTWDistAllCorrect);
fprintf('[Pocket] Mean Matched DTW Distance: [Which/Where] = %3.4f\n', fPocketMeanDTWDistRouteSegCorrect);
fprintf('[Pocket] Mean Matched DTW Distance: [Which/When] = %3.4f\n', fPocketMeanDTWDistRouteTraceCorrect);
fprintf('[Pocket] Mean Matched DTW Distance: [Which] = %3.4f\n', fPocketMeanDTWDistRouteCorrect);

disp('-------------------------------------------------------');

fprintf('[Hand] All [Route, Trace, Src Seg, Dst Seg] Accuracy: %3.4f\n', fHandAllAccuracy);

fprintf('[Hand] Route Seg [Route, Src Seg, Dst Seg] Accuracy: %3.4f\n', fHandRouteSegAccuracy);

fprintf('[Hand] Route Trace [Route, Trace] Accuracy: %3.4f\n', fHandRouteTraceAccuracy);

fprintf('[Hand] Route [Route] Accuracy: %3.4f\n', fHandRouteAccuracy);

fprintf('[Hand] Seg Len [Psg Len == Ref Len] Stat: [Correct] %3.4f;  [Charged More] %3.4f;  [Charged Less] %3.4f\n', fHandSegLenCorrect, fHandSegLenChargedMoreRatio, fHandSegLenChargedLessRatio);

fprintf('[Hand] Mean Matched DTW Distance: [Which/Where/When] = %3.4f\n', fHandMeanDTWDistAllCorrect);
fprintf('[Hand] Mean Matched DTW Distance: [Which/Where] = %3.4f\n', fHandMeanDTWDistRouteSegCorrect);
fprintf('[Hand] Mean Matched DTW Distance: [Which/When] = %3.4f\n', fHandMeanDTWDistRouteTraceCorrect);
fprintf('[Hand] Mean Matched DTW Distance: [Which] = %3.4f\n', fHandMeanDTWDistRouteCorrect);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Segment Length based Accuracy %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('########################################################');

mSegLen = unique(mEvalResult(:,4));
nMaxSegLen = max(mSegLen);

% For each segment length, also check accuracy of:
% All Accuracy, Route Seg Accuacy, Hand All Accuracy, Hand Route Seg
% Accuracy, Pocket All Accuracy, Pocket Route Seg Accuracy
for i = 1:nMaxSegLen
    mSegLenEvalResult = mEvalResult(mEvalResult(:,4)==i,:);    
    [fSegLenAllAccuracy fSegLenRouteSegAccuracy fSegLenRouteTraceAccuracy fSegLenRouteAccuracy fAllSegLenCorrect fAllSegLenChargedMoreRatio fAllSegLenChargedLessRatio fAllSegLenMeanDTWDistAllCorrect fAllSegLenMeanDTWDistRouteSegCorrect fAllSegLenMeanDTWDistRouteTraceCorrect fAllSegLenMeanDTWDistRouteCorrect] = SBM_CalAccuracy(mSegLenEvalResult);

    mPocketSegLenEvalResult = mSegLenEvalResult(mSegLenEvalResult(:,3)==2,:);
    [fPocketSegLenAllAccuracy fPocketSegLenRouteSegAccuracy fPocketSegLenRouteTraceAccuracy fPocketSegLenRouteAccuracy fPocketSegLenCorrect fPocketSegLenChargedMoreRatio fPocketSegLenChargedLessRatio fPocketSegLenMeanDTWDistAllCorrect fPocketSegLenMeanDTWDistRouteSegCorrect fPocketSegLenMeanDTWDistRouteTraceCorrect fPocketSegLenMeanDTWDistRouteCorrect] = SBM_CalAccuracy(mPocketSegLenEvalResult);
    
    mHandSegLenEvalResult = mSegLenEvalResult(mSegLenEvalResult(:,3)==1,:);
    [fHandSegLenAllAccuracy fHandSegLenRouteSegAccuracy fHandSegLenRouteTraceAccuracy fHandSegLenRouteAccuracy fHandSegLenCorrect fHandSegLenChargedMoreRatio fHandSegLenChargedLessRatio fHandSegLenMeanDTWDistAllCorrect fHandSegLenMeanDTWDistRouteSegCorrect fHandSegLenMeanDTWDistRouteTraceCorrect fHandSegLenMeanDTWDistRouteCorrect] = SBM_CalAccuracy(mHandSegLenEvalResult);

    %%%%%%%
    nAllAccuracyCnt = nAllAccuracyCnt + 1;
    mAllAccuracy(nAllAccuracyCnt, 1) = fSegLenAllAccuracy;
    mAllAccuracy(nAllAccuracyCnt, 2) = fPocketSegLenAllAccuracy;
    mAllAccuracy(nAllAccuracyCnt, 3) = fHandSegLenAllAccuracy;
    
    XTickTxtAll{nAllAccuracyCnt} = num2str(i);

    %%%%%%
    nRouteSegAccuracyCnt = nRouteSegAccuracyCnt + 1;
    mRouteSegAccuracy(nRouteSegAccuracyCnt, 1) = fSegLenRouteSegAccuracy;
    mRouteSegAccuracy(nRouteSegAccuracyCnt, 2) = fPocketSegLenRouteSegAccuracy;
    mRouteSegAccuracy(nRouteSegAccuracyCnt, 3) = fHandSegLenRouteSegAccuracy;
    
    XTickTxtRouteSeg{nRouteSegAccuracyCnt} = num2str(i);

    %%%%%%
    nRouteTraceAccuracyCnt = nRouteTraceAccuracyCnt + 1;
    mRouteTraceAccuracy(nRouteTraceAccuracyCnt, 1) = fSegLenRouteTraceAccuracy;
    mRouteTraceAccuracy(nRouteTraceAccuracyCnt, 2) = fPocketSegLenRouteTraceAccuracy;
    mRouteTraceAccuracy(nRouteTraceAccuracyCnt, 3) = fHandSegLenRouteTraceAccuracy;
    
    XTickTxtRouteTrace{nRouteTraceAccuracyCnt} = num2str(i);

    %%%%%%
    nRouteAccuracyCnt = nRouteAccuracyCnt + 1;
    mRouteAccuracy(nRouteAccuracyCnt, 1) = fSegLenRouteAccuracy;
    mRouteAccuracy(nRouteAccuracyCnt, 2) = fPocketSegLenRouteAccuracy;
    mRouteAccuracy(nRouteAccuracyCnt, 3) = fHandSegLenRouteAccuracy;
    
    XTickTxtRoute{nRouteAccuracyCnt} = num2str(i);
   
    %%%%%
    nSegLenStatCnt = nSegLenStatCnt + 1;
    mSegLenStat(nSegLenStatCnt,1) = fAllSegLenCorrect;
    mSegLenStat(nSegLenStatCnt,2) = fAllSegLenChargedMoreRatio;
    mSegLenStat(nSegLenStatCnt,3) = fAllSegLenChargedLessRatio;
    
    mSegLenStat(nSegLenStatCnt,4) = fPocketSegLenCorrect;
    mSegLenStat(nSegLenStatCnt,5) = fPocketSegLenChargedMoreRatio;
    mSegLenStat(nSegLenStatCnt,6) = fPocketSegLenChargedLessRatio;
    
    mSegLenStat(nSegLenStatCnt,7) = fHandSegLenCorrect;
    mSegLenStat(nSegLenStatCnt,8) = fHandSegLenChargedMoreRatio;
    mSegLenStat(nSegLenStatCnt,9) = fHandSegLenChargedLessRatio;
    
    xTickTextSegLen{nSegLenStatCnt} = num2str(i);
        
    fprintf('[Seg Len = %d] All [Route, Trace, Src Seg, Dst Seg] Accuracy: %3.4f\n', i, fSegLenAllAccuracy);

    fprintf('[Seg Len = %d] Route Seg [Route, Src Seg, Dst Seg] Accuracy: %3.4f\n', i, fSegLenRouteSegAccuracy);

    fprintf('[Seg Len = %d] Route Seg [Route, Trace] Accuracy: %3.4f\n', i, fSegLenRouteTraceAccuracy);

    fprintf('[Seg Len = %d] Route Seg [Route] Accuracy: %3.4f\n', i, fSegLenRouteAccuracy);
   
    fprintf('Seg Len [Psg Len == Ref Len] Stat: [Correct] %3.4f;  [Charged More] %3.4f;  [Charged Less] %3.4f\n', fAllSegLenCorrect, fAllSegLenChargedMoreRatio, fAllSegLenChargedLessRatio);

    fprintf('[All Seg Len = %d] Mean Matched DTW Distance: [Which/Where/When] = %3.4f\n', i, fAllSegLenMeanDTWDistAllCorrect);
    fprintf('[All Seg Len = %d] Mean Matched DTW Distance: [Which/Where] = %3.4f\n', i, fAllSegLenMeanDTWDistRouteSegCorrect);
    fprintf('[All Seg Len = %d] Mean Matched DTW Distance: [Which/When] = %3.4f\n', i, fAllSegLenMeanDTWDistRouteTraceCorrect);
    fprintf('[All Seg Len = %d] Mean Matched DTW Distance: [Which] = %3.4f\n', i, fAllSegLenMeanDTWDistRouteCorrect);
   
    disp('-------------------------------------------------------');
    
    fprintf('[Hand][Seg Len = %d] All [Route, Trace, Src Seg, Dst Seg] Accuracy: %3.4f\n', i, fHandSegLenAllAccuracy);

    fprintf('[Hand][Seg Len = %d] Route Seg [Route, Src Seg, Dst Seg] Accuracy: %3.4f\n', i, fHandSegLenRouteSegAccuracy);

    fprintf('[Hand][Seg Len = %d] Route Seg [Route, Trace] Accuracy: %3.4f\n', i, fHandSegLenRouteTraceAccuracy);

    fprintf('[Hand][Seg Len = %d] Route Seg [Route] Accuracy: %3.4f\n', i, fHandSegLenRouteAccuracy);
    
    fprintf('[Hand] Seg Len [Psg Len == Ref Len] Stat: [Correct] %3.4f;  [Charged More] %3.4f;  [Charged Less] %3.4f\n', fHandSegLenCorrect, fHandSegLenChargedMoreRatio, fHandSegLenChargedLessRatio);
   
    fprintf('[Hand Seg Len = %d] Mean Matched DTW Distance: [Which/Where/When] = %3.4f\n', i, fHandSegLenMeanDTWDistAllCorrect);
    fprintf('[Hand Seg Len = %d] Mean Matched DTW Distance: [Which/Where] = %3.4f\n', i, fHandSegLenMeanDTWDistRouteSegCorrect);
    fprintf('[Hand Seg Len = %d] Mean Matched DTW Distance: [Which/When] = %3.4f\n', i, fHandSegLenMeanDTWDistRouteTraceCorrect);
    fprintf('[Hand Seg Len = %d] Mean Matched DTW Distance: [Which] = %3.4f\n', i, fHandSegLenMeanDTWDistRouteCorrect);
    
    disp('-------------------------------------------------------');
    
    fprintf('[Pocket][Seg Len = %d] All [Route, Trace, Src Seg, Dst Seg] Accuracy: %3.4f\n', i, fPocketSegLenAllAccuracy);

    fprintf('[Pocket][Seg Len = %d] Route Seg [Route, Src Seg, Dst Seg] Accuracy: %3.4f\n', i, fPocketSegLenRouteSegAccuracy);

    fprintf('[Pocket][Seg Len = %d] Route Seg [Route, Trace] Accuracy: %3.4f\n', i, fPocketSegLenRouteTraceAccuracy);
    
    fprintf('[Pocket][Seg Len = %d] Route Seg [Route] Accuracy: %3.4f\n', i, fPocketSegLenRouteAccuracy);
    
    fprintf('[Pocket] Seg Len [Psg Len == Ref Len] Stat: [Correct] %3.4f;  [Charged More] %3.4f;  [Charged Less] %3.4f\n', fPocketSegLenCorrect, fPocketSegLenChargedMoreRatio, fPocketSegLenChargedLessRatio);

    fprintf('[Pocket Seg Len = %d] Mean Matched DTW Distance: [Which/Where/When] = %3.4f\n', i, fPocketSegLenMeanDTWDistAllCorrect);
    fprintf('[Pocket Seg Len = %d] Mean Matched DTW Distance: [Which/Where] = %3.4f\n', i, fPocketSegLenMeanDTWDistRouteSegCorrect);
    fprintf('[Pocket Seg Len = %d] Mean Matched DTW Distance: [Which/When] = %3.4f\n', i, fPocketSegLenMeanDTWDistRouteTraceCorrect);
    fprintf('[Pocket Seg Len = %d] Mean Matched DTW Distance: [Which] = %3.4f\n', i, fPocketSegLenMeanDTWDistRouteCorrect);
    
    disp('########################################################');
end

fprintf('\n');



[nTotalRowCnt ~] = size(mEvalResult);
mSegLenCntByType = [];   %  How many record exists for each type of Seg Len, Index is Segment Len

for i = 1:nMaxSegLen
    mSegLenCntByType(i,1) = 0;
    mSegLenCntByType(i,2) = 0;    
end

for i=1:nTotalRowCnt
    nSegLen = mEvalResult(i,4);
    mSegLenCntByType(nSegLen, 1) = mSegLenCntByType(nSegLen, 1) + 1;
    
    if mEvalResult(i,9) > 0   % Matched 
        mSegLenCntByType(nSegLen, 2) = mSegLenCntByType(nSegLen, 2) + 1;
    end
end

 mSegLenCntByType
 
 nTotalRowCnt
 
 nNoMatchedNum = sum(mSegLenCntByType(:,1)) - sum(mSegLenCntByType(:,2))


mResult = [];
mResult{1} = mAllAccuracy;    % (1+N)x3   (N = number of SegLen type)
mResult{2} = mRouteSegAccuracy;   % (1+N)x3   (N = number of SegLen type)
mResult{3} = mRouteTraceAccuracy;   % (1+N)x3   (N = number of SegLen type)
mResult{4} = mRouteAccuracy;   % (1+N)x3   (N = number of SegLen type)
mResult{5} = mSegLenStat;   % (1+N)x9   (N = number of SegLen type)


f = mResult;


if nPlot == 0
    return;
end


% Convert to 100 percentage
mAllAccuracy = mAllAccuracy*100.0;
mRouteSegAccuracy = mRouteSegAccuracy*100.0;
mRouteTraceAccuracy = mRouteTraceAccuracy*100.0;
mRouteAccuracy = mRouteAccuracy*100.0;

mSegLenStat = mSegLenStat * 100.0;  

mOverallAccuracyCombinedA = [];

% Overall   (Which/Where/When; Which/Where; Which/When; Which)
mOverallAccuracyCombinedA(1,1) = mAllAccuracy(1,1);
mOverallAccuracyCombinedA(1,2) = mRouteSegAccuracy(1,1);
mOverallAccuracyCombinedA(1,3) = mRouteTraceAccuracy(1,1);
mOverallAccuracyCombinedA(1,4) = mRouteAccuracy(1,1);

% Pocket   (Which/Where/When; Which/Where; Which/When; Which)
mOverallAccuracyCombinedA(2,1) = mAllAccuracy(1,2);
mOverallAccuracyCombinedA(2,2) = mRouteSegAccuracy(1,2);
mOverallAccuracyCombinedA(2,3) = mRouteTraceAccuracy(1,2);
mOverallAccuracyCombinedA(2,4) = mRouteAccuracy(1,2);

% Hand   (Which/Where/When; Which/Where; Which/When; Which)
mOverallAccuracyCombinedA(3,1) = mAllAccuracy(1,3);
mOverallAccuracyCombinedA(3,2) = mRouteSegAccuracy(1,3);
mOverallAccuracyCombinedA(3,3) = mRouteTraceAccuracy(1,3);
mOverallAccuracyCombinedA(3,4) = mRouteAccuracy(1,3);



mOverallAccuracyCombinedB = [];

% Which/Where/When   (Overall, Pocket, Hand)
mOverallAccuracyCombinedB(1,1) = mAllAccuracy(1,1);
mOverallAccuracyCombinedB(1,2) = mAllAccuracy(1,2);
mOverallAccuracyCombinedB(1,3) = mAllAccuracy(1,3);

% Which/Where   (Overall, Pocket, Hand)
mOverallAccuracyCombinedB(2,1) = mRouteSegAccuracy(1,1);
mOverallAccuracyCombinedB(2,2) = mRouteSegAccuracy(1,2);
mOverallAccuracyCombinedB(2,3) = mRouteSegAccuracy(1,3);

% Which/When   (Overall, Pocket, Hand)
mOverallAccuracyCombinedB(3,1) = mRouteTraceAccuracy(1,1);
mOverallAccuracyCombinedB(3,2) = mRouteTraceAccuracy(1,2);
mOverallAccuracyCombinedB(3,3) = mRouteTraceAccuracy(1,3);

% Which   (Overall, Pocket, Hand)
mOverallAccuracyCombinedB(4,1) = mRouteAccuracy(1,1);
mOverallAccuracyCombinedB(4,2) = mRouteAccuracy(1,2);
mOverallAccuracyCombinedB(4,3) = mRouteAccuracy(1,3);

%%%%%%% Plot %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% All (Which/Where/When) Accuracy (Route No, Trace No, Src Seg No, Dst Seg No. all be the same;  
% Bar Chart:  Three bars:  Overall,  Pantpocket, Hand)  (For overall result, no Seg Len information involved)

figure(1);

bar(mAllAccuracy(1,:), 0.4); %colormap(gray);

title(gca, 'Accuracy of Which/Where/When (Overall)', 'FontName','Times New Roman', 'FontSize', 50);

XTickTxt = {'Overall'; 'Pocket'; 'Hand'};

set(gca, 'FontName','Times New Roman');
set(gca, 'FontSize', 50);
        
set(gca, 'XTickLabel', XTickTxt);
set(gca,'YTick',0:10:100);
    
xlabelStr = 'Position of Phone';

xlabel(xlabelStr, 'FontSize', 50);
ylabel('Accuracy (%)', 'FontSize', 50);
set(gca,'ygrid','on');
ylim([0 100]);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Route Segment (Which/Where) Accuracy (Route No, Src Seg No, Dst Seg No. all be the same;  
% Bar Chart:  Three bars:  Overall,  Pantpocket, Hand)  (For overall result, no Seg Len information involved)

figure(2);

bar(mRouteSegAccuracy(1,:), 0.4); 

title(gca, 'Accuracy of Which/Where (Overall)', 'FontName','Times New Roman', 'FontSize', 50);

XTickTxt = {'Overall'; 'Pocket'; 'Hand'};

set(gca, 'FontName','Times New Roman');
set(gca, 'FontSize', 50);
        
set(gca, 'XTickLabel', XTickTxt);
set(gca,'YTick',0:10:100);
    
xlabelStr = 'Position of Phone';

xlabel(xlabelStr, 'FontSize', 50);
ylabel('Accuracy (%)', 'FontSize', 50);
set(gca,'ygrid','on');
ylim([0 100]);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Route Trace (Which/When) Accuracy (Route No, Trace No. are the same;  
% Bar Chart:  Three bars:  Overall,  Pantpocket, Hand)  (For overall result, no Seg Len information involved)

figure(3);

bar(mRouteTraceAccuracy(1,:), 0.4); 

title(gca, 'Accuracy of Which/When (Overall)', 'FontName','Times New Roman', 'FontSize', 50);

XTickTxt = {'Overall'; 'Pocket'; 'Hand'};

set(gca, 'FontName','Times New Roman');
set(gca, 'FontSize', 50);
        
set(gca, 'XTickLabel', XTickTxt);
set(gca,'YTick',0:10:100);
    
xlabelStr = 'Position of Phone';

xlabel(xlabelStr, 'FontSize', 50);
ylabel('Accuracy (%)', 'FontSize', 50);
set(gca,'ygrid','on');
ylim([0 100]);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Route (Which) Accuracy (Route No. are the same;  
% Bar Chart:  Three bars:  Overall,  Pantpocket, Hand)  (For overall result, no Seg Len information involved)

figure(4);

bar(mRouteAccuracy(1,:), 0.4); 

title(gca, 'Accuracy of Which (Overall)', 'FontName','Times New Roman', 'FontSize', 50);

XTickTxt = {'Overall'; 'Pocket'; 'Hand'};

set(gca, 'FontName','Times New Roman');
set(gca, 'FontSize', 50);
        
set(gca, 'XTickLabel', XTickTxt);
set(gca,'YTick',0:10:100);
    
xlabelStr = 'Position of Phone';

xlabel(xlabelStr, 'FontSize', 50);
ylabel('Accuracy (%)', 'FontSize', 50);
set(gca,'ygrid','on');
ylim([0 100]);


%return;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Segment Length related All (Which/Where/When) Accuracy (Route No, Trace No, Src Seg No, Dst Seg No. all be the same;  
% Bar Chart:  Three bars:  Overall,  Pantpocket, Hand)  (For overall result, no Seg Len information involved)

figure(5);
plot(mAllAccuracy(2:nAllAccuracyCnt, 1), 'r-x', 'linewidth', 4);
hold on;
plot(mAllAccuracy(2:nAllAccuracyCnt, 2), 'g-x', 'linewidth', 4);
hold on;
plot(mAllAccuracy(2:nAllAccuracyCnt, 3), 'b-x', 'linewidth', 4);

title(gca, 'Accuracy of Which/Where/When (Number of Segments)', 'FontName','Times New Roman', 'FontSize', 50);

set(gca, 'FontName','Times New Roman');
set(gca, 'FontSize', 50);

set(gca, 'XTickLabel',  XTickTxtAll(2:nAllAccuracyCnt));
set(gca,'YTick',0:10:100);
    
xlabelStr = 'Number of Segments';

xlabel(xlabelStr, 'FontSize', 50);
ylabel('Accuracy (%)', 'FontSize', 50);
set(gca,'ygrid','on');
ylim([0 100]);
legend('Overall', 'Pocket', 'Hand');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Segment Length related Route Segment (Which/Where) Accuracy (Route No, Src Seg No, Dst Seg No. all be the same;  
% Bar Chart:  Three bars:  Overall,  Pantpocket, Hand)  (For overall result, no Seg Len information involved)

figure(6);
plot(mRouteSegAccuracy(2:nRouteSegAccuracyCnt, 1), 'r-x', 'linewidth', 4);
hold on;
plot(mRouteSegAccuracy(2:nRouteSegAccuracyCnt, 2), 'g-x', 'linewidth', 4);
hold on;
plot(mRouteSegAccuracy(2:nRouteSegAccuracyCnt, 3), 'b-x', 'linewidth', 4);

title(gca, 'Accuracy of Which/Where (Number of Segments)', 'FontName','Times New Roman', 'FontSize', 50);

set(gca, 'FontName','Times New Roman');
set(gca, 'FontSize', 50);
        
set(gca, 'XTickLabel',  XTickTxtRouteSeg(2:nRouteSegAccuracyCnt));
set(gca,'YTick',0:10:100);
    
xlabelStr = 'Number of Segments';

xlabel(xlabelStr, 'FontSize', 50);
ylabel('Accuracy (%)', 'FontSize', 50);
set(gca,'ygrid','on');
ylim([0 100]);
legend('Overall', 'Pocket', 'Hand');



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Segment Length related Route Trace (Which/When) Accuracy (Route No, Trace No. are the same;  
% Bar Chart:  Three bars:  Overall,  Pantpocket, Hand)  (For overall result, no Seg Len information involved)

figure(7);
plot(mRouteTraceAccuracy(2:nRouteTraceAccuracyCnt, 1), 'r-x', 'linewidth', 4);
hold on;
plot(mRouteTraceAccuracy(2:nRouteTraceAccuracyCnt, 2), 'g-x', 'linewidth', 4);
hold on;
plot(mRouteTraceAccuracy(2:nRouteTraceAccuracyCnt, 3), 'b-x', 'linewidth', 4);

title(gca, 'Accuracy of Which/When (Number of Segments)', 'FontName','Times New Roman', 'FontSize', 50);

set(gca, 'FontName','Times New Roman');
set(gca, 'FontSize', 50);
        
set(gca, 'XTickLabel',  XTickTxtRouteTrace(2:nRouteTraceAccuracyCnt));
set(gca,'YTick',0:10:100);
    
xlabelStr = 'Number of Segments';

xlabel(xlabelStr, 'FontSize', 50);
ylabel('Accuracy (%)', 'FontSize', 50);
set(gca,'ygrid','on');
ylim([0 100]);
legend('Overall', 'Pocket', 'Hand');



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Segment Length related Route Trace (Which) Accuracy (Route No, is the same;  
% Bar Chart:  Three bars:  Overall,  Pantpocket, Hand)  (For overall result, no Seg Len information involved)

figure(8);
plot(mRouteAccuracy(2:nRouteAccuracyCnt, 1), 'r-x', 'linewidth', 4);
hold on;
plot(mRouteAccuracy(2:nRouteAccuracyCnt, 2), 'g-x', 'linewidth', 4);
hold on;
plot(mRouteAccuracy(2:nRouteAccuracyCnt, 3), 'b-x', 'linewidth', 4);

title(gca, 'Accuracy of Which (Number of Segments)', 'FontName','Times New Roman', 'FontSize', 50);

set(gca, 'FontName','Times New Roman');
set(gca, 'FontSize', 50);
        
set(gca, 'XTickLabel',  XTickTxtRoute(2:nRouteAccuracyCnt));
set(gca,'YTick',0:10:100);
    
xlabelStr = 'Number of Segments';

xlabel(xlabelStr, 'FontSize', 50);
ylabel('Accuracy (%)', 'FontSize', 50);
set(gca,'ygrid','on');
ylim([0 100]);
legend('Overall', 'Pocket', 'Hand');



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [All] Check Accuracy of Charging, How accurately each passenger will be charged
% Multi Bar Chart;  3 Groups:  Overall, Pants Pocket, Hand;  In each Group,
% 3 bars:  Correct, Charged Less, Charged More

figure(9);
bar(mSegLenStat(:,1:3), 'stacked'); %colormap(gray);

title(gca, 'Accuracy of Recognition on the Number of Traveled Segments (Phone Position: Overall)', 'FontName','Times New Roman', 'FontSize', 37);

set(gca, 'FontName','Times New Roman');
set(gca, 'FontSize', 37);
        
set(gca, 'XTickLabel', xTickTextSegLen);
set(gca,'YTick',0:10:100);
    
xlabelStr = 'Number of Segments';

xlabel(xlabelStr, 'FontSize', 37);
ylabel('Percentage (%)', 'FontSize', 37);
set(gca,'ygrid','on');
ylim([0 100]);
legend('Correct', 'More', 'Less');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [Pants Pocket] Check Accuracy of Charging, How accurately each passenger will be charged
% Multi Bar Chart;  3 Groups:  Overall, Pants Pocket, Hand;  In each Group,
% 3 bars:  Correct, Charged Less, Charged More

figure(10);
bar(mSegLenStat(:,4:6), 'stacked'); % colormap(gray);

title(gca, 'Accuracy of Recognition on the Number of Traveled Segments (Phone Position: Pocket)', 'FontName','Times New Roman', 'FontSize', 37);

set(gca, 'FontName','Times New Roman');
set(gca, 'FontSize', 37);
        
set(gca, 'XTickLabel', xTickTextSegLen);
set(gca,'YTick',0:10:100);
    
xlabelStr = 'Number of Segments';

xlabel(xlabelStr, 'FontSize', 37);
ylabel('Percentage (%)', 'FontSize', 37);
set(gca,'ygrid','on');
ylim([0 100]);
legend('Correct', 'More', 'Less');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [Hand] Check Accuracy of Charging, How accurately each passenger will be charged
% Multi Bar Chart;  3 Groups:  Overall, Pants Pocket, Hand;  In each Group,
% 3 bars:  Correct, Charged Less, Charged More

figure(11);
bar(mSegLenStat(:,7:9), 'stacked');  %colormap(gray);

title(gca, 'Accuracy of Recognition on the Number of Traveled Segments (Phone Position: Hand)', 'FontName','Times New Roman', 'FontSize', 37);

set(gca, 'FontName','Times New Roman');
set(gca, 'FontSize', 37);
        
set(gca, 'XTickLabel', xTickTextSegLen);
set(gca,'YTick',0:10:100);
    
xlabelStr = 'Number of Segments';

xlabel(xlabelStr, 'FontSize', 37);
ylabel('Percentage (%)', 'FontSize', 37);
set(gca,'ygrid','on');
ylim([0 100]);
legend('Correct', 'More', 'Less');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CDF of Searching Space Reduction
% figure (8)

SBM_ReduceSearchSpace_CDF(mEvalResult, 12);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Merge Overall Accuracy Together

figure(13);

bar(mOverallAccuracyCombinedA); 

title(gca, 'Overall Accuracy', 'FontName','Times New Roman', 'FontSize', 50);

XTickTxt = {'Overall'; 'Pocket'; 'Hand'};

set(gca, 'FontName','Times New Roman');
set(gca, 'FontSize', 40);
        
set(gca, 'XTickLabel', XTickTxt);
set(gca,'YTick',0:10:100);
    
xlabelStr = 'Position of Phone';

xlabel(xlabelStr, 'FontSize', 50);
ylabel('Accuracy (%)', 'FontSize', 50);
set(gca,'ygrid','on');
ylim([0 100]);
legend('Which/Where/When', 'Which/Where', 'Which/When', 'Which');



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Merge Overall Accuracy Together

figure(14);

bar(mOverallAccuracyCombinedB); 

title(gca, 'Overall Accuracy', 'FontName','Times New Roman', 'FontSize', 50);

XTickTxt = {'Which/Where/When'; 'Which/Where'; 'Which/When'; 'Which'};

set(gca, 'FontName','Times New Roman');
set(gca, 'FontSize', 40);
        
set(gca, 'XTickLabel', XTickTxt);
set(gca,'YTick',0:10:100);
    
xlabelStr = 'Measurement Scenario';

xlabel(xlabelStr, 'FontSize', 50);
ylabel('Accuracy (%)', 'FontSize', 50);
set(gca,'ygrid','on');
ylim([0 100]);
legend('Overall', 'Pocket', 'Hand');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Merge Overall Accuracy Together   

figure(15);

bar(mOverallAccuracyCombinedA(:,1:2)); 

title(gca, 'Overall Accuracy', 'FontName','Times New Roman', 'FontSize', 50);

XTickTxt = {'Overall'; 'Pocket'; 'Hand'};

set(gca, 'FontName','Times New Roman');
set(gca, 'FontSize', 40);
        
set(gca, 'XTickLabel', XTickTxt);
set(gca,'YTick',0:10:100);
    
xlabelStr = 'Position of Phone';

xlabel(xlabelStr, 'FontSize', 50);
ylabel('Accuracy (%)', 'FontSize', 50);
set(gca,'ygrid','on');
ylim([0 100]);
legend('Which/Where/When', 'Which/Where');



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Merge Overall Accuracy Together

figure(16);

bar(mOverallAccuracyCombinedB(1:2,:)); 

title(gca, 'Overall Accuracy', 'FontName','Times New Roman', 'FontSize', 50);

XTickTxt = {'Which/Where/When'; 'Which/Where'};

set(gca, 'FontName','Times New Roman');
set(gca, 'FontSize', 40);
        
set(gca, 'XTickLabel', XTickTxt);
set(gca,'YTick',0:10:100);
    
xlabelStr = 'Measurement Scenario';

xlabel(xlabelStr, 'FontSize', 50);
ylabel('Accuracy (%)', 'FontSize', 50);
set(gca,'ygrid','on');
ylim([0 100]);
legend('Overall', 'Pocket', 'Hand');


disp('>>>>>>>>>>>>>>DONE<<<<<<<<<<<<<<');

return;
