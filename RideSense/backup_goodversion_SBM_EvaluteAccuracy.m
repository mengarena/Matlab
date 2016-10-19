function f = backup_goodversion_SBM_EvaluteAccuracy(sEvaluationResultFile, nPlot)
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

% sEvaluationResultFile = 'E:\SensorMatching\Data\SchoolShuttle\Evaluation\EvRet_1_2_3_4_5_6_7_8_9_10_21_22_23_24_25_26_27_28_29_30.csv';
% nPlot = 1;

format long;

mEvalResult = load(sEvaluationResultFile);


mAllAccuracy = [];   % "All" means Route No, Trace No, Src Seg No and Dst Seg No all must be correct, 
                     % Column 1: Overall, Column 2: PantPocket, Column 3: Hand
                     % Row 1:  Overall
                     % Row 2~n:  Different Segment Len
nAllAccuracyCnt = 0;

mRouteSegAccuracy = [];  % "RouteSeg" means Route No, Src Seg No and Dst Seg No all must be correct, 
                         % Column 1: Overall, Column 2: PantPocket, Column 3: Hand
                         % Row 1:  Overall
                         % Row 2~n:  Different Segment Len
nRouteSegAccuracyCnt = 0;

mSegLenStat = [];    % "SegLen" shows different Segment Length statistics (PsgLen = RefLen;  PsgLen<RefLen; PsgLen > RefLen), 
                     % Column1~3: Overall; Column4~6: Pantpocket, Column7~9: Hand
                     % Row 1:  Overall
                     % Row 2~n:  Different Segment Len                     
nSegLenStatCnt = 0;


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

mPocketEvalResult = mEvalResult(mEvalResult(:,3)==2,:);
[fPocketAllCorrectAccuracy fPocketRouteSegCorrectAccuracy fPocketSegLenCorrect fPocketSegLenChargedMoreRatio fPocketSegLenChargedLessRatio] = SBM_CalAccuracy(mPocketEvalResult);

mHandEvalResult = mEvalResult(mEvalResult(:,3)==1,:);
[fHandAllCorrectAccuracy fHandRouteSegCorrectAccuracy fHandSegLenCorrect fHandSegLenChargedMoreRatio fHandSegLenChargedLessRatio] = SBM_CalAccuracy(mHandEvalResult);

nAllAccuracyCnt = nAllAccuracyCnt + 1;
mAllAccuracy(nAllAccuracyCnt,1) = fAllCorrectAccuracy;
mAllAccuracy(nAllAccuracyCnt,2) = fPocketAllCorrectAccuracy;
mAllAccuracy(nAllAccuracyCnt,3) = fHandAllCorrectAccuracy;

XTickTxtAll{nAllAccuracyCnt} = 'Overall';

nRouteSegAccuracyCnt = nRouteSegAccuracyCnt + 1;
mRouteSegAccuracy(nRouteSegAccuracyCnt, 1) = fRouteSegCorrectAccuracy;
mRouteSegAccuracy(nRouteSegAccuracyCnt, 2) = fPocketRouteSegCorrectAccuracy;
mRouteSegAccuracy(nRouteSegAccuracyCnt, 3) = fHandRouteSegCorrectAccuracy;

XTickTxtRouteSeg{nRouteSegAccuracyCnt} = 'Overall';

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

fprintf('All [Route, Trace, Src Seg, Dst Seg] Accuracy: %3.4f\n', fAllCorrectAccuracy);

fprintf('Route Seg [Route, Src Seg, Dst Seg] Accuracy: %3.4f\n', fRouteSegCorrectAccuracy);

fprintf('Seg Len [Psg Len == Ref Len] Stat: [Correct] %3.4f;  [Charged More] %3.4f;  [Charged Less] %3.4f\n', fAllSegLenCorrect, fAllSegLenChargedMoreRatio, fAllSegLenChargedLessRatio);

disp('-------------------------------------------------------');

fprintf('[Pocket] All [Route, Trace, Src Seg, Dst Seg] Accuracy: %3.4f\n', fPocketAllCorrectAccuracy);

fprintf('[Pocket] Route Seg [Route, Src Seg, Dst Seg] Accuracy: %3.4f\n', fPocketRouteSegCorrectAccuracy);

fprintf('[Pocket] Seg Len [Psg Len == Ref Len] Stat: [Correct] %3.4f;  [Charged More] %3.4f;  [Charged Less] %3.4f\n', fPocketSegLenCorrect, fPocketSegLenChargedMoreRatio, fPocketSegLenChargedLessRatio);

disp('-------------------------------------------------------');

fprintf('[Hand] All [Route, Trace, Src Seg, Dst Seg] Accuracy: %3.4f\n', fHandAllCorrectAccuracy);

fprintf('[Hand] Route Seg [Route, Src Seg, Dst Seg] Accuracy: %3.4f\n', fHandRouteSegCorrectAccuracy);

fprintf('[Hand] Seg Len [Psg Len == Ref Len] Stat: [Correct] %3.4f;  [Charged More] %3.4f;  [Charged Less] %3.4f\n', fHandSegLenCorrect, fHandSegLenChargedMoreRatio, fHandSegLenChargedLessRatio);


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

    mPocketSegLenEvalResult = mSegLenEvalResult(mSegLenEvalResult(:,3)==2,:);
    [fPocketSegLenAllCorrectAccuracy fPocketSegLenRouteSegCorrectAccuracy fPocketSegLenCorrect fPocketSegLenChargedMoreRatio fPocketSegLenChargedLessRatio] = SBM_CalAccuracy(mPocketSegLenEvalResult);
    
    mHandSegLenEvalResult = mSegLenEvalResult(mSegLenEvalResult(:,3)==1,:);
    [fHandSegLenAllCorrectAccuracy fHandSegLenRouteSegCorrectAccuracy fHandSegLenCorrect fHandSegLenChargedMoreRatio fHandSegLenChargedLessRatio] = SBM_CalAccuracy(mHandSegLenEvalResult);

    %%%%%%%
    nAllAccuracyCnt = nAllAccuracyCnt + 1;
    mAllAccuracy(nAllAccuracyCnt, 1) = fSegLenAllCorrectAccuracy;
    mAllAccuracy(nAllAccuracyCnt, 2) = fPocketSegLenAllCorrectAccuracy;
    mAllAccuracy(nAllAccuracyCnt, 3) = fHandSegLenAllCorrectAccuracy;
    
    XTickTxtAll{nAllAccuracyCnt} = num2str(i);

    %%%%%%
    nRouteSegAccuracyCnt = nRouteSegAccuracyCnt + 1;
    mRouteSegAccuracy(nRouteSegAccuracyCnt, 1) = fSegLenRouteSegCorrectAccuracy;
    mRouteSegAccuracy(nRouteSegAccuracyCnt, 2) = fPocketSegLenRouteSegCorrectAccuracy;
    mRouteSegAccuracy(nRouteSegAccuracyCnt, 3) = fHandSegLenRouteSegCorrectAccuracy;
    
    XTickTxtRouteSeg{nRouteSegAccuracyCnt} = num2str(i);

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
        
    fprintf('[Seg Len = %d] All [Route, Trace, Src Seg, Dst Seg] Accuracy: %3.4f\n', i, fSegLenAllCorrectAccuracy);

    fprintf('[Seg Len = %d] Route Seg [Route, Src Seg, Dst Seg] Accuracy: %3.4f\n', i, fSegLenRouteSegCorrectAccuracy);

    fprintf('Seg Len [Psg Len == Ref Len] Stat: [Correct] %3.4f;  [Charged More] %3.4f;  [Charged Less] %3.4f\n', fAllSegLenCorrect, fAllSegLenChargedMoreRatio, fAllSegLenChargedLessRatio);
    
    disp('-------------------------------------------------------');
    
    fprintf('[Hand][Seg Len = %d] All [Route, Trace, Src Seg, Dst Seg] Accuracy: %3.4f\n', i, fHandSegLenAllCorrectAccuracy);

    fprintf('[Hand][Seg Len = %d] Route Seg [Route, Src Seg, Dst Seg] Accuracy: %3.4f\n', i, fHandSegLenRouteSegCorrectAccuracy);

    fprintf('[Hand] Seg Len [Psg Len == Ref Len] Stat: [Correct] %3.4f;  [Charged More] %3.4f;  [Charged Less] %3.4f\n', fHandSegLenCorrect, fHandSegLenChargedMoreRatio, fHandSegLenChargedLessRatio);
    
    disp('-------------------------------------------------------');
    
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
    
    if mEvalResult(i,9) > 0   % Matched 
        mSegLenCntByType(nSegLen, 2) = mSegLenCntByType(nSegLen, 2) + 1;
    end
end

% mSegLenCntByType
% 
% nTotalRowCnt
% 
% nNoMatchedNum = sum(mSegLenCntByType(:,1)) - sum(mSegLenCntByType(:,2))


mResult = [];
mResult{1} = mAllAccuracy;    % (1+N)x3   (N = number of SegLen type)
mResult{2} = mRouteSegAccuracy;   % (1+N)x3   (N = number of SegLen type)
mResult{3} = mSegLenStat;   % (1+N)x9   (N = number of SegLen type)


f = mResult;


if nPlot == 0
    return;
end


% Convert to 100 percentage
mAllAccuracy = mAllAccuracy*100.0;
mRouteSegAccuracy = mRouteSegAccuracy*100.0;
mSegLenStat = mSegLenStat * 100.0;  


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
% Segment Length related All (Which/Where/When) Accuracy (Route No, Trace No, Src Seg No, Dst Seg No. all be the same;  
% Bar Chart:  Three bars:  Overall,  Pantpocket, Hand)  (For overall result, no Seg Len information involved)

figure(3);
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

figure(4);
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
% [All] Check Accuracy of Charging, How accurately each passenger will be charged
% Multi Bar Chart;  3 Groups:  Overall, Pants Pocket, Hand;  In each Group,
% 3 bars:  Correct, Charged Less, Charged More

figure(5);
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

figure(6);
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

figure(7);
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

SBM_ReduceSearchSpace_CDF(mEvalResult, 8);


disp('>>>>>>>>>>>>>>DONE<<<<<<<<<<<<<<');

return;
