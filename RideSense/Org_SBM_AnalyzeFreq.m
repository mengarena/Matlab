function f = Org_SBM_AnalyzeFreq()
% This is suitable for hand-phone trace only

format long;

%sTrace = 'E:\SensorMatching\Data\SchoolShuttle\20150924\Evening2_full_good\hand_Uniqued_TmCrt.csv';
%sTraceInfo = 'E:\SensorMatching\Data\SchoolShuttle\20150924\Evening2_full_good\hand_Uniqued_TmCrt_InfoG.csv';

sTrace = 'E:\SensorMatching\Data\SchoolShuttle\20150925_morning\Blue2_full_good\pantpocket_Uniqued_TmCrt.csv';
sTraceInfo = 'E:\SensorMatching\Data\SchoolShuttle\20150925_morning\Blue2_full_good\pantpocket_Uniqued_TmCrt_InfoG.csv';

mTrace = load(sTrace);
mTraceInfo = load(sTraceInfo);

mMoveInfo = mTraceInfo(mTraceInfo(:,1) == 1,:);
nMoveStartLine = mMoveInfo(3,2);
nMoveEndLine = mMoveInfo(3,3);

mStopInfo = mTraceInfo(mTraceInfo(:,1) == 0,:);  % Station information in _Uniqued_TmCrt
mStopStartLine = mStopInfo(3,2);
mStopEndLine = mStopInfo(3,3);

mMoveTrace = mTrace(nMoveStartLine:nMoveEndLine,:);

mStopTrace = mTrace(mStopStartLine:mStopEndLine,:);

mMoveTraceLinearAccl = mMoveTrace(mMoveTrace(:,3) == 2,:);
[nMoveLineCnt ~] = size(mMoveTraceLinearAccl)

mStopTraceLinearAccl = mStopTrace(mStopTrace(:,3) == 2,:);
[nStopLineCnt ~] = size(mStopTraceLinearAccl)

mMyMove = [];

for i = 100:299
    mMyMove(i-100+1,1) = mMoveTraceLinearAccl(i,1);  % Timestamp
    mMyMove(i-100+1,2) = sqrt(power(mMoveTraceLinearAccl(i,3),2) + power(mMoveTraceLinearAccl(i,4),2) + power(mMoveTraceLinearAccl(i,5),2)); % Magnitude of Linear Accl
end

fIntervalMove = (mMyMove(200,1) - mMyMove(1,1))/255;  % To make 256 samples
xxMove = mMyMove(1,1):fIntervalMove:mMyMove(200,1);  % 256 timestamps
yyMove = spline(mMyMove(:,1),mMyMove(:,2),xxMove); % Interpolate the samples
length(yyMove)
InterMove = [];
InterMove(:,1) = xxMove;
InterMove(:,2) = yyMove;

mMoveSpec = SBM_SegSpectrum(InterMove, 2);
freqMove = mMoveSpec{1};     
ampMove = mMoveSpec{2};   

mMyStop = [];

for i = 100:299
    mMyStop(i-100+1,1) = mStopTraceLinearAccl(i,1);
    mMyStop(i-100+1,2) = sqrt(power(mStopTraceLinearAccl(i,3),2) + power(mStopTraceLinearAccl(i,4),2) + power(mStopTraceLinearAccl(i,5),2));
end

fIntervalStop = (mMyStop(200,1) - mMyStop(1,1))/255;
xxStop = mMyStop(1,1):fIntervalStop:mMyStop(200,1);
yyStop = spline(mMyStop(:,1),mMyStop(:,2),xxStop); 
InterStop = [];
InterStop(:,1) = xxStop;
InterStop(:,2) = yyStop;

mStopSpec = SBM_SegSpectrum(InterStop, 2);
freqStop = mStopSpec{1};     
ampStop = mStopSpec{2};

figure(1);
subplot(2,1,1);
plot(freqMove, ampMove);
title('Move');

subplot(2,1,2);
plot(freqStop, ampStop);
title('Stop');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Above is raw data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Below is filtered data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

mMyMoveFiltered = [];

mMyMoveFiltered = mMyMove;
mMyMoveFiltered(:,2) = EMA(mMyMove(:,2), 100);

fIntervalMoveFiltered = (mMyMoveFiltered(200,1) - mMyMoveFiltered(1,1))/255;
xxMoveFiltered = mMyMoveFiltered(1,1):fIntervalMoveFiltered:mMyMoveFiltered(200,1);
yyMoveFiltered = spline(mMyMoveFiltered(:,1),mMyMoveFiltered(:,2),xxMoveFiltered); 
length(yyMoveFiltered)
InterMoveFiltered = [];
InterMoveFiltered(:,1) = xxMoveFiltered;
InterMoveFiltered(:,2) = yyMoveFiltered;

mMoveFilteredSpec = SBM_SegSpectrum(InterMoveFiltered, 2);
freqMoveFiltered = mMoveFilteredSpec{1};     
ampMoveFiltered = mMoveFilteredSpec{2};   


mMyStopFiltered = [];

mMyStopFiltered = mMyStop;
mMyStopFiltered(:,2) = EMA(mMyStop(:,2), 100);

fIntervalStopFiltered = (mMyStopFiltered(200,1) - mMyStopFiltered(1,1))/255;
xxStopFiltered = mMyStopFiltered(1,1):fIntervalStopFiltered:mMyStopFiltered(200,1);
yyStopFiltered = spline(mMyStopFiltered(:,1),mMyStopFiltered(:,2),xxStopFiltered); 
length(yyStopFiltered)
InterStopFiltered = [];
InterStopFiltered(:,1) = xxStopFiltered;
InterStopFiltered(:,2) = yyStopFiltered;


mStopFilteredSpec = SBM_SegSpectrum(InterStopFiltered, 2);
freqStopFiltered = mStopFilteredSpec{1};     
ampStopFiltered = mStopFilteredSpec{2};   


figure(2);
subplot(2,1,1);
plot(freqMoveFiltered, ampMoveFiltered);
title('Move (Filtered)');

subplot(2,1,2);
plot(freqStopFiltered, ampStopFiltered);
title('Stop (Filtered)');

return;
