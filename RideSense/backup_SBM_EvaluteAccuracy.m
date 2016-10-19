function f = backup_SBM_EvaluteAccuracy(sEvaluationResultFile)
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

sEvaluationResultFile = 'E:\SensorMatching\Data\SchoolShuttle\Evaluation\EvRet_1_2_3_4_5_6_7_8_9_10_21_22_23_24_25_26_27_28_29_30.csv';

format long;

mEvalResult = load(sEvaluationResultFile);


mAllAccuracy = [];
nAllAccuracyCnt = 0;

mRouteSegAccuracy = [];
nRouteSegAccuracyCnt = 0;

mAllSegLenStat = [];
nAllSegLenStatCnt = 0;



mHandAllAccuracy = [];
nHandAllAccuracyCnt = 0;

mHandRouteSegAccuracy = [];
nHandRouteSegAccuracyCnt = 0;

mHandSegLenStat = [];
nHandSegLenStatCnt = 0;



mPocketAllAccuracy = [];
nPocketAllAccuracyCnt = 0;

mPocketRouteSegAccuracy = [];
nPocketRouteSegAccuracyCnt = 0;

mPocketSegLenStat = [];
nPocketSegLenStatCnt = 0;



XTickTxtAll = [];
XTickTxtRouteSeg = [];
xTickTextSegLen = [];

disp('########################################################');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% All Accuracy %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% Route, Trace No, SrcSegNo, DstSegNo all must be the same %%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% Route Seg Accuracy %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% Route, SrcSegNo, DstSegNo all must be the same %%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[fAllCorrectAccuracy fRouteSegCorrectAccuracy fAllSegLenCorrect fAllSegLenChargedMoreRatio fAllSegLenChargedLessRatio] = SBM_CalAccuracy(mEvalResult);

nAllAccuracyCnt = nAllAccuracyCnt + 1;
mAllAccuracy(nAllAccuracyCnt) = fAllCorrectAccuracy;
XTickTxtAll{nAllAccuracyCnt} = 'Overall';

nRouteSegAccuracyCnt = nRouteSegAccuracyCnt + 1;
mRouteSegAccuracy(nRouteSegAccuracyCnt) = fRouteSegCorrectAccuracy;
XTickTxtRouteSeg{nRouteSegAccuracyCnt} = 'Overall';

nAllSegLenStatCnt = nAllSegLenStatCnt + 1;
mAllSegLenStat(nAllSegLenStatCnt, 1) = fAllSegLenCorrect;
mAllSegLenStat(nAllSegLenStatCnt, 2) = fAllSegLenChargedMoreRatio;
mAllSegLenStat(nAllSegLenStatCnt, 3) = fAllSegLenChargedLessRatio;

xTickTextSegLen{nAllSegLenStatCnt} = 'Overall';

fprintf('All [Route, Trace, Src Seg, Dst Seg] Accuracy: %3.4f\n', fAllCorrectAccuracy);

fprintf('Route Seg [Route, Src Seg, Dst Seg] Accuracy: %3.4f\n', fRouteSegCorrectAccuracy);

fprintf('Seg Len [Psg Len == Ref Len] Stat: [Correct] %3.4f;  [Charged More] %3.4f;  [Charged Less] %3.4f\n', fAllSegLenCorrect, fAllSegLenChargedMoreRatio, fAllSegLenChargedLessRatio);

disp('-------------------------------------------------------');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% Position based accuracy %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% Check Accuracy based on different Passenger phone position %%%
%%%%%% Also use All Accuracy & Route Seg Accuracy %%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Process Hand Result %%%%%
mHandEvalResult = mEvalResult(mEvalResult(:,3)==1,:);

[fHandAllCorrectAccuracy fHandRouteSegCorrectAccuracy fHandSegLenCorrect fHandSegLenChargedMoreRatio fHandSegLenChargedLessRatio] = SBM_CalAccuracy(mHandEvalResult);

nHandAllAccuracyCnt = nHandAllAccuracyCnt + 1;
mHandAllAccuracy(nHandAllAccuracyCnt) = fHandAllCorrectAccuracy;

nHandRouteSegAccuracyCnt = nHandRouteSegAccuracyCnt + 1;
mHandRouteSegAccuracy(nHandRouteSegAccuracyCnt) = fHandRouteSegCorrectAccuracy;

nHandSegLenStatCnt = nHandSegLenStatCnt + 1;
mHandSegLenStat(nHandSegLenStatCnt, 1) = fHandSegLenCorrect;
mHandSegLenStat(nHandSegLenStatCnt, 2) = fHandSegLenChargedMoreRatio;
mHandSegLenStat(nHandSegLenStatCnt, 3) = fHandSegLenChargedLessRatio;

fprintf('[Hand] All [Route, Trace, Src Seg, Dst Seg] Accuracy: %3.4f\n', fHandAllCorrectAccuracy);

fprintf('[Hand] Route Seg [Route, Src Seg, Dst Seg] Accuracy: %3.4f\n', fHandRouteSegCorrectAccuracy);

fprintf('[Hand] Seg Len [Psg Len == Ref Len] Stat: [Correct] %3.4f;  [Charged More] %3.4f;  [Charged Less] %3.4f\n', fHandSegLenCorrect, fHandSegLenChargedMoreRatio, fHandSegLenChargedLessRatio);

disp('-------------------------------------------------------');
%%%% Process Pocket Result %%%%%
mPocketEvalResult = mEvalResult(mEvalResult(:,3)==2,:);

[fPocketAllCorrectAccuracy fPocketRouteSegCorrectAccuracy fPocketSegLenCorrect fPocketSegLenChargedMoreRatio fPocketSegLenChargedLessRatio] = SBM_CalAccuracy(mPocketEvalResult);

nPocketAllAccuracyCnt = nPocketAllAccuracyCnt + 1;
mPocketAllAccuracy(nPocketAllAccuracyCnt) = fPocketAllCorrectAccuracy;

nPocketRouteSegAccuracyCnt = nPocketRouteSegAccuracyCnt + 1;
mPocketRouteSegAccuracy(nPocketRouteSegAccuracyCnt) = fPocketRouteSegCorrectAccuracy;

nPocketSegLenStatCnt = nPocketSegLenStatCnt + 1;
mPocketSegLenStat(nPocketSegLenStatCnt, 1) = fPocketSegLenCorrect;
mPocketSegLenStat(nPocketSegLenStatCnt, 2) = fPocketSegLenChargedMoreRatio;
mPocketSegLenStat(nPocketSegLenStatCnt, 3) = fPocketSegLenChargedLessRatio;

fprintf('[Pocket] All [Route, Trace, Src Seg, Dst Seg] Accuracy: %3.4f\n', fPocketAllCorrectAccuracy);

fprintf('[Pocket] Route Seg [Route, Src Seg, Dst Seg] Accuracy: %3.4f\n', fPocketRouteSegCorrectAccuracy);

fprintf('[Pocket] Seg Len [Psg Len == Ref Len] Stat: [Correct] %3.4f;  [Charged More] %3.4f;  [Charged Less] %3.4f\n', fPocketSegLenCorrect, fPocketSegLenChargedMoreRatio, fPocketSegLenChargedLessRatio);

disp('-------------------------------------------------------');

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
    [fSegLenAllCorrectAccuracy fSegLenRouteSegCorrectAccuracy fAllSegLenCorrect fAllSegLenChargedMoreRatio fAllSegLenChargedLessRatio] = SBM_CalAccuracy(mSegLenEvalResult);
    
    nAllAccuracyCnt = nAllAccuracyCnt + 1;
    mAllAccuracy(nAllAccuracyCnt) = fSegLenAllCorrectAccuracy;
    XTickTxtAll{nAllAccuracyCnt} = num2str(i);

    nRouteSegAccuracyCnt = nRouteSegAccuracyCnt + 1;
    mRouteSegAccuracy(nRouteSegAccuracyCnt) = fSegLenRouteSegCorrectAccuracy;
    XTickTxtRouteSeg{nRouteSegAccuracyCnt} = num2str(i);

    nAllSegLenStatCnt = nAllSegLenStatCnt + 1;
    mAllSegLenStat(nAllSegLenStatCnt,1) = fAllSegLenCorrect;
    mAllSegLenStat(nAllSegLenStatCnt,2) = fAllSegLenChargedMoreRatio;
    mAllSegLenStat(nAllSegLenStatCnt,3) = fAllSegLenChargedLessRatio;
    
    xTickTextSegLen{nAllSegLenStatCnt} = num2str(i);
        
    fprintf('[Seg Len = %d] All [Route, Trace, Src Seg, Dst Seg] Accuracy: %3.4f\n', i, fSegLenAllCorrectAccuracy);

    fprintf('[Seg Len = %d] Route Seg [Route, Src Seg, Dst Seg] Accuracy: %3.4f\n', i, fSegLenRouteSegCorrectAccuracy);

    fprintf('Seg Len [Psg Len == Ref Len] Stat: [Correct] %3.4f;  [Charged More] %3.4f;  [Charged Less] %3.4f\n', fAllSegLenCorrect, fAllSegLenChargedMoreRatio, fAllSegLenChargedLessRatio);
    
    disp('-------------------------------------------------------');

    mHandSegLenEvalResult = mSegLenEvalResult(mSegLenEvalResult(:,3)==1,:);
    [fHandSegLenAllCorrectAccuracy fHandSegLenRouteSegCorrectAccuracy fHandSegLenCorrect fHandSegLenChargedMoreRatio fHandSegLenChargedLessRatio] = SBM_CalAccuracy(mHandSegLenEvalResult);
    
    nHandAllAccuracyCnt = nHandAllAccuracyCnt + 1;
    mHandAllAccuracy(nHandAllAccuracyCnt) = fHandSegLenAllCorrectAccuracy;

    nHandRouteSegAccuracyCnt = nHandRouteSegAccuracyCnt + 1;
    mHandRouteSegAccuracy(nHandRouteSegAccuracyCnt) = fHandSegLenRouteSegCorrectAccuracy;
    
    nHandSegLenStatCnt = nHandSegLenStatCnt + 1;
    mHandSegLenStat(nHandSegLenStatCnt,1) = fHandSegLenCorrect;
    mHandSegLenStat(nHandSegLenStatCnt,2) = fHandSegLenChargedMoreRatio;
    mHandSegLenStat(nHandSegLenStatCnt,3) = fHandSegLenChargedLessRatio;
    
    fprintf('[Hand][Seg Len = %d] All [Route, Trace, Src Seg, Dst Seg] Accuracy: %3.4f\n', i, fHandSegLenAllCorrectAccuracy);

    fprintf('[Hand][Seg Len = %d] Route Seg [Route, Src Seg, Dst Seg] Accuracy: %3.4f\n', i, fHandSegLenRouteSegCorrectAccuracy);

    fprintf('[Hand] Seg Len [Psg Len == Ref Len] Stat: [Correct] %3.4f;  [Charged More] %3.4f;  [Charged Less] %3.4f\n', fHandSegLenCorrect, fHandSegLenChargedMoreRatio, fHandSegLenChargedLessRatio);
    
    disp('-------------------------------------------------------');

    mPocketSegLenEvalResult = mSegLenEvalResult(mSegLenEvalResult(:,3)==2,:);
    [fPocketSegLenAllCorrectAccuracy fPocketSegLenRouteSegCorrectAccuracy fPocketSegLenCorrect fPocketSegLenChargedMoreRatio fPocketSegLenChargedLessRatio] = SBM_CalAccuracy(mPocketSegLenEvalResult);

    nPocketAllAccuracyCnt = nPocketAllAccuracyCnt + 1;
    mPocketAllAccuracy(nPocketAllAccuracyCnt) = fPocketSegLenAllCorrectAccuracy;

    nPocketRouteSegAccuracyCnt = nPocketRouteSegAccuracyCnt + 1;
    mPocketRouteSegAccuracy(nPocketRouteSegAccuracyCnt) = fPocketSegLenRouteSegCorrectAccuracy;
    
    nPocketSegLenStatCnt = nPocketSegLenStatCnt + 1;
    mPocketSegLenStat(nPocketSegLenStatCnt,1) = fPocketSegLenCorrect;
    mPocketSegLenStat(nPocketSegLenStatCnt,2) = fPocketSegLenChargedMoreRatio;
    mPocketSegLenStat(nPocketSegLenStatCnt,3) = fPocketSegLenChargedLessRatio;
    
    fprintf('[Pocket][Seg Len = %d] All [Route, Trace, Src Seg, Dst Seg] Accuracy: %3.4f\n', i, fPocketSegLenAllCorrectAccuracy);

    fprintf('[Pocket][Seg Len = %d] Route Seg [Route, Src Seg, Dst Seg] Accuracy: %3.4f\n', i, fPocketSegLenRouteSegCorrectAccuracy);

    fprintf('[Pocket] Seg Len [Psg Len == Ref Len] Stat: [Correct] %3.4f;  [Charged More] %3.4f;  [Charged Less] %3.4f\n', fPocketSegLenCorrect, fPocketSegLenChargedMoreRatio, fPocketSegLenChargedLessRatio);
    
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
    
    if mEvalResult(i,9) > 0
        mSegLenCntByType(nSegLen, 2) = mSegLenCntByType(nSegLen, 2) + 1;
    end
end

mSegLenCntByType

nTotalRowCnt

sum(mSegLenCntByType(:,1)) - sum(mSegLenCntByType(:,2))

mResult = [];
mResult{1} = mAllAccuracy;
mResult{2} = mRouteSegAccuracy;
mResult{3} = mAllSegLenStat;
mResult{4} = mHandAllAccuracy;
mResult{5} = mHandRouteSegAccuracy;
mResult{6} = mHandSegLenStat;
mResult{7} = mPocketAllAccuracy;
mResult{8} = mPocketRouteSegAccuracy;
mResult{9} = mPocketSegLenStat;


f = mResult;

%%%% Plot %%%%%

figure(1);
plot(mAllAccuracy, 'r-*');
hold on;
plot(mHandAllAccuracy, 'g-*');
hold on;
plot(mPocketAllAccuracy, 'b-*');
legend('All Positions', 'Hand', 'Pants Pocket');

title(gca, 'Which/Where/When Accuacy', 'FontName','Times New Roman', 'FontSize', 48);
set(gca,'FontName','Times New Roman', 'FontSize', 36);
xlabel('Segment Length', 'FontName','Times New Roman', 'FontSize', 44);    
ylabel('Accuacy','FontName','Times New Roman', 'FontSize', 44);

set(gca, 'XTickLabel', XTickTxtAll);




figure(2);
plot(mRouteSegAccuracy, 'r-*');
hold on;
plot(mHandRouteSegAccuracy, 'g-*');
hold on;
plot(mPocketRouteSegAccuracy, 'b-*');
legend('All Positions', 'Hand', 'Pants Pocket');

title(gca, 'Which/Where Accuacy', 'FontName','Times New Roman', 'FontSize', 48);
set(gca,'FontName','Times New Roman', 'FontSize', 36);
xlabel('Segment Length', 'FontName','Times New Roman', 'FontSize', 44);    
ylabel('Accuacy','FontName','Times New Roman', 'FontSize', 44);

set(gca, 'XTickLabel', XTickTxtRouteSeg);




figure(3);
subplot(1,3,1);
plot(mAllSegLenStat(:,1), 'r-*');
hold on;
plot(mAllSegLenStat(:,2), 'g-*');
hold on;
plot(mAllSegLenStat(:,3), 'b-*');
hold on;

title(gca, '[All] Seg Len Correctness', 'FontName','Times New Roman', 'FontSize', 24);
legend('Correct', 'Charged More', 'Charged Less');
set(gca,'FontName','Times New Roman', 'FontSize', 18);
xlabel('Segment Length', 'FontName','Times New Roman', 'FontSize', 22);    
ylabel('Accuacy','FontName','Times New Roman', 'FontSize', 22);

set(gca, 'XTickLabel', xTickTextSegLen);


subplot(1,3,2);
plot(mHandSegLenStat(:,1), 'r-*');
hold on;
plot(mHandSegLenStat(:,2), 'g-*');
hold on;
plot(mHandSegLenStat(:,3), 'b-*');
hold on;

title(gca, '[Hand] Seg Len Correctness', 'FontName','Times New Roman', 'FontSize', 24);
legend('Correct', 'Charged More', 'Charged Less');
set(gca,'FontName','Times New Roman', 'FontSize', 18);
xlabel('Segment Length', 'FontName','Times New Roman', 'FontSize', 22);    
ylabel('Accuacy','FontName','Times New Roman', 'FontSize', 22);

set(gca, 'XTickLabel', xTickTextSegLen);


subplot(1,3,3);
plot(mPocketSegLenStat(:,1), 'r-*');
hold on;
plot(mPocketSegLenStat(:,2), 'g-*');
hold on;
plot(mPocketSegLenStat(:,3), 'b-*');

title(gca, '[Pocket] Seg Len Correctness', 'FontName','Times New Roman', 'FontSize', 24);
legend('Correct', 'Charged More', 'Charged Less');
set(gca,'FontName','Times New Roman', 'FontSize', 18);
xlabel('Segment Length', 'FontName','Times New Roman', 'FontSize', 22);    
ylabel('Accuacy','FontName','Times New Roman', 'FontSize', 22);

set(gca, 'XTickLabel', xTickTextSegLen);

disp('>>>>>>>>>>>>>>DONE<<<<<<<<<<<<<<');

return;
