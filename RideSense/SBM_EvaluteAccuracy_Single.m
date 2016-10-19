function SBM_EvaluteAccuracy_Single()
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

format long;

sEvaluationResultFile = 'E:\SensorMatching\Data\SchoolShuttle\Evaluation20151008_OK\EvRet_1_2_3_4_5_6_7_8_9_10_21_22_23_24_25_26_27_28_29_30_41_42_43_44_45_46_47_48_49_50.csv';

mEvalResult = load(sEvaluationResultFile);

mAllAccuracy = [];
nAllAccuracyCnt = 0;

mRouteSegAccuracy = [];
nRouteSegAccuracyCnt = 0;

mHandAllAccuracy = [];
nHandAllAccuracyCnt = 0;

mHandRouteSegAccuracy = [];
nHandRouteSegAccuracyCnt = 0;

mPocketAllAccuracy = [];
nPocketAllAccuracyCnt = 0;

mPocketRouteSegAccuracy = [];
nPocketRouteSegAccuracyCnt = 0;

XTickTxtAll = [];
XTickTxtRouteSeg = [];

disp('########################################################');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% All Accuracy %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% Route, Trace No, SrcSegNo, DstSegNo all must be the same %%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% Route Seg Accuracy %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% Route, SrcSegNo, DstSegNo all must be the same %%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[fAllCorrectAccuracy fRouteSegCorrectAccuracy] = SBM_CalAccuracy(mEvalResult);

nAllAccuracyCnt = nAllAccuracyCnt + 1;
mAllAccuracy(nAllAccuracyCnt) = fAllCorrectAccuracy;
XTickTxtAll{nAllAccuracyCnt} = 'Overall';

nRouteSegAccuracyCnt = nRouteSegAccuracyCnt + 1;
mRouteSegAccuracy(nRouteSegAccuracyCnt) = fRouteSegCorrectAccuracy;
XTickTxtRouteSeg{nRouteSegAccuracyCnt} = 'Overall';

fprintf('All [Route, Trace, Src Seg, Dst Seg] Accuracy: %3.4f\n', fAllCorrectAccuracy);

fprintf('Route Seg [Route, Src Seg, Dst Seg] Accuracy: %3.4f\n', fRouteSegCorrectAccuracy);

disp('-------------------------------------------------------');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% Position based accuracy %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% Check Accuracy based on different Passenger phone position %%%
%%%%%% Also use All Accuracy & Route Seg Accuracy %%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Process Hand Result %%%%%
mHandEvalResult = mEvalResult(mEvalResult(:,3)==1,:);

[fHandAllCorrectAccuracy fHandRouteSegCorrectAccuracy] = SBM_CalAccuracy(mHandEvalResult);

nHandAllAccuracyCnt = nHandAllAccuracyCnt + 1;
mHandAllAccuracy(nHandAllAccuracyCnt) = fHandAllCorrectAccuracy;

nHandRouteSegAccuracyCnt = nHandRouteSegAccuracyCnt + 1;
mHandRouteSegAccuracy(nHandRouteSegAccuracyCnt) = fHandRouteSegCorrectAccuracy;


fprintf('[Hand] All [Route, Trace, Src Seg, Dst Seg] Accuracy: %3.4f\n', fHandAllCorrectAccuracy);

fprintf('[Hand] Route Seg [Route, Src Seg, Dst Seg] Accuracy: %3.4f\n', fHandRouteSegCorrectAccuracy);
disp('-------------------------------------------------------');
%%%% Process Pocket Result %%%%%
mPocketEvalResult = mEvalResult(mEvalResult(:,3)==2,:);

[fPocketAllCorrectAccuracy fPocketRouteSegCorrectAccuracy] = SBM_CalAccuracy(mPocketEvalResult);

nPocketAllAccuracyCnt = nPocketAllAccuracyCnt + 1;
mPocketAllAccuracy(nPocketAllAccuracyCnt) = fPocketAllCorrectAccuracy;

nPocketRouteSegAccuracyCnt = nPocketRouteSegAccuracyCnt + 1;
mPocketRouteSegAccuracy(nPocketRouteSegAccuracyCnt) = fPocketRouteSegCorrectAccuracy;

fprintf('[Pocket] All [Route, Trace, Src Seg, Dst Seg] Accuracy: %3.4f\n', fPocketAllCorrectAccuracy);

fprintf('[Pocket] Route Seg [Route, Src Seg, Dst Seg] Accuracy: %3.4f\n', fPocketRouteSegCorrectAccuracy);

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
    [fSegLenAllCorrectAccuracy fSegLenRouteSegCorrectAccuracy] = SBM_CalAccuracy(mSegLenEvalResult);
    
    nAllAccuracyCnt = nAllAccuracyCnt + 1;
    mAllAccuracy(nAllAccuracyCnt) = fSegLenAllCorrectAccuracy;
    XTickTxtAll{nAllAccuracyCnt} = num2str(i);

    nRouteSegAccuracyCnt = nRouteSegAccuracyCnt + 1;
    mRouteSegAccuracy(nRouteSegAccuracyCnt) = fSegLenRouteSegCorrectAccuracy;
    XTickTxtRouteSeg{nRouteSegAccuracyCnt} = num2str(i);

    fprintf('[Seg Len = %d] All [Route, Trace, Src Seg, Dst Seg] Accuracy: %3.4f\n', i, fSegLenAllCorrectAccuracy);

    fprintf('[Seg Len = %d] Route Seg [Route, Src Seg, Dst Seg] Accuracy: %3.4f\n', i, fSegLenRouteSegCorrectAccuracy);

    disp('-------------------------------------------------------');

    mHandSegLenEvalResult = mSegLenEvalResult(mSegLenEvalResult(:,3)==1,:);
    [fHandSegLenAllCorrectAccuracy fHandSegLenRouteSegCorrectAccuracy] = SBM_CalAccuracy(mHandSegLenEvalResult);
    
    nHandAllAccuracyCnt = nHandAllAccuracyCnt + 1;
    mHandAllAccuracy(nHandAllAccuracyCnt) = fHandSegLenAllCorrectAccuracy;

    nHandRouteSegAccuracyCnt = nHandRouteSegAccuracyCnt + 1;
    mHandRouteSegAccuracy(nHandRouteSegAccuracyCnt) = fHandSegLenRouteSegCorrectAccuracy;
    
    fprintf('[Hand][Seg Len = %d] All [Route, Trace, Src Seg, Dst Seg] Accuracy: %3.4f\n', i, fHandSegLenAllCorrectAccuracy);

    fprintf('[Hand][Seg Len = %d] Route Seg [Route, Src Seg, Dst Seg] Accuracy: %3.4f\n', i, fHandSegLenRouteSegCorrectAccuracy);

    disp('-------------------------------------------------------');

    mPocketSegLenEvalResult = mSegLenEvalResult(mSegLenEvalResult(:,3)==2,:);
    [fPocketSegLenAllCorrectAccuracy fPocketSegLenRouteSegCorrectAccuracy] = SBM_CalAccuracy(mPocketSegLenEvalResult);

    nPocketAllAccuracyCnt = nPocketAllAccuracyCnt + 1;
    mPocketAllAccuracy(nPocketAllAccuracyCnt) = fPocketSegLenAllCorrectAccuracy;

    nPocketRouteSegAccuracyCnt = nPocketRouteSegAccuracyCnt + 1;
    mPocketRouteSegAccuracy(nPocketRouteSegAccuracyCnt) = fPocketSegLenRouteSegCorrectAccuracy;
    
    fprintf('[Pocket][Seg Len = %d] All [Route, Trace, Src Seg, Dst Seg] Accuracy: %3.4f\n', i, fPocketSegLenAllCorrectAccuracy);

    fprintf('[Pocket][Seg Len = %d] Route Seg [Route, Src Seg, Dst Seg] Accuracy: %3.4f\n', i, fPocketSegLenRouteSegCorrectAccuracy);

    disp('########################################################');
end

fprintf('\n');

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

disp('>>>>>>>>>>>>>>DONE<<<<<<<<<<<<<<');

return;
