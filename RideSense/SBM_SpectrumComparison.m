function f = SBM_SpectrumComparison(sRefTraceFile, sRefTitle, sQueryTraceFile, sQueryTitle, nSensorType, fTimeOffset, nCompareSize, nFrameCnt, nFilterFactor)
% The sRefTraceFile and sQeuryTraceFile contain data from the synchronized
% point; After synchronization, it takes some time (i.e. fTimeOffset to put the phone into position) to be ready
%
% nSensorType is the sensor need to be compared
%

% This function is mainly wrote for the comparison of the data in E:\SensorMatching\Data\SchoolShuttle\ForSpectrumAnalysis

mDataType = [1 2 3 4 5 6 7 8 9 10 12];  % No WiFi

% Field Number
mFieldNum = [3 3 3 3 3 1 1 1 1 7 3];

nIndexIndex = find(mDataType == nSensorType);

nSensorFieldNum = mFieldNum(nIndexIndex);

%%%%%%%%
mRefTraceRaw = load(sRefTraceFile);
mQueryTraceRaw = load(sQueryTraceFile);

mRefTrace = mRefTraceRaw(mRefTraceRaw(:,1) > fTimeOffset & mRefTraceRaw(:, 2) == nSensorType, :);  % Sensor type field is 2nd field

mQueryTrace = mQueryTraceRaw(mQueryTraceRaw(:,1) > fTimeOffset & mQueryTraceRaw(:, 2) == nSensorType, :);


% Use the 6th field to put the magnitude
if (nSensorFieldNum == 3)
    mRefTrace(:,6) = sqrt(power(mRefTrace(:,3),2) + power(mRefTrace(:,4),2) + power(mRefTrace(:,5),2));
    mQueryTrace(:,6) = sqrt(power(mQueryTrace(:,3),2) + power(mQueryTrace(:,4),2) + power(mQueryTrace(:,5),2));
else
    mRefTrace(:,6) = mRefTrace(:,3);    
    mQueryTrace(:,6) = mQueryTrace(:,3);    
end    

% Filter
%nFilterFactor = 200; 

mRefTraceFiltered = mRefTrace;
mRefTraceFiltered(:,6) = EMA(mRefTrace(:,6), nFilterFactor);

mQueryTraceFiltered = mQueryTrace;
mQueryTraceFiltered(:,6) = EMA(mQueryTrace(:,6), nFilterFactor);


fFrameTimeStep = nCompareSize;   % Second
fStartTm = mRefTrace(1,1);

for i=1:nFrameCnt
    %% Raw data
    mRefTraceFrame = mRefTrace(mRefTrace(:,1) >= fStartTm &  mRefTrace(:,1) <= fStartTm + fFrameTimeStep, :);
    
    mQueryTraceFrame = mQueryTrace(mQueryTrace(:,1) >= fStartTm &  mQueryTrace(:,1) <= fStartTm + fFrameTimeStep, :);
    
    % Calculate and Show the spectrum on one figure
    fIntervalRef = (mRefTraceFrame(end,1) - mRefTraceFrame(1,1))/2048;
    xxRef = mRefTraceFrame(1,1):fIntervalRef:mRefTraceFrame(end,1);    
    yyRef = spline(mRefTraceFrame(:,1),mRefTraceFrame(:,6),xxRef); 
    
    InterRef = [];
    InterRef(:,1) = xxRef;
    InterRef(:,2) = yyRef;

    mRefSpec = SBM_SegSpectrum(InterRef, 2);
    freqRef = mRefSpec{1};     
    ampRef = mRefSpec{2};

    fIntervalQuery = (mQueryTraceFrame(end,1) - mQueryTraceFrame(1,1))/2048;
    xxQuery = mQueryTraceFrame(1,1):fIntervalQuery:mQueryTraceFrame(end,1);
    yyQuery = spline(mQueryTraceFrame(:,1),mQueryTraceFrame(:,6),xxQuery); 
    
    InterQuery = [];
    InterQuery(:,1) = xxQuery;
    InterQuery(:,2) = yyQuery;

    mQuerySpec = SBM_SegSpectrum(InterQuery, 2);
    freqQuery = mQuerySpec{1};     
    ampQuery = mQuerySpec{2};
   
    
    %% Filtered Data
    mRefTraceFrameFiltered = mRefTraceFiltered(mRefTraceFiltered(:,1) >= fStartTm &  mRefTraceFiltered(:,1) <= fStartTm + fFrameTimeStep, :);
    
    mQueryTraceFrameFiltered = mQueryTraceFiltered(mQueryTraceFiltered(:,1) >= fStartTm &  mQueryTraceFiltered(:,1) <= fStartTm + fFrameTimeStep, :);
    
    % Calculate and Show the spectrum on one figure
    fIntervalRefFiltered = (mRefTraceFrameFiltered(end,1) - mRefTraceFrameFiltered(1,1))/2048;
    xxRefFiltered = mRefTraceFrameFiltered(1,1):fIntervalRefFiltered:mRefTraceFrameFiltered(end,1);
    yyRefFiltered = spline(mRefTraceFrameFiltered(:,1),mRefTraceFrameFiltered(:,6),xxRefFiltered); 
    
    InterRefFiltered = [];
    InterRefFiltered(:,1) = xxRefFiltered;
    InterRefFiltered(:,2) = yyRefFiltered;

    mRefSpecFiltered = SBM_SegSpectrum(InterRefFiltered, 2);
    freqRefFiltered = mRefSpecFiltered{1};     
    ampRefFiltered = mRefSpecFiltered{2};

    fIntervalQueryFiltered = (mQueryTraceFrameFiltered(end,1) - mQueryTraceFrameFiltered(1,1))/2048;
    xxQueryFiltered = mQueryTraceFrameFiltered(1,1):fIntervalQueryFiltered:mQueryTraceFrameFiltered(end,1);
    yyQueryFiltered = spline(mQueryTraceFrameFiltered(:,1),mQueryTraceFrameFiltered(:,6),xxQueryFiltered); 
    
    InterQueryFiltered = [];
    InterQueryFiltered(:,1) = xxQueryFiltered;
    InterQueryFiltered(:,2) = yyQueryFiltered;

    mQuerySpecFiltered = SBM_SegSpectrum(InterQueryFiltered, 2);
    freqQueryFiltered = mQuerySpecFiltered{1};     
    ampQueryFiltered = mQuerySpecFiltered{2};
    
    
    
    %% Plotting
    figure(i);
    subplot(2,2,1);
    plot(freqRef, ampRef);
    title([sRefTitle ' (Raw)']);
    xlabel('Frequency');
    ylabel('Amplitude');

    subplot(2,2,2);
    plot(freqRefFiltered, ampRefFiltered);
    title([sRefTitle ' (Filtered)']);
    xlabel('Frequency');
    ylabel('Amplitude');
    
    subplot(2,2,3);
    plot(freqQuery, ampQuery);
    title([sQueryTitle ' (Raw)']);
    xlabel('Frequency');
    ylabel('Amplitude');

    subplot(2,2,4);
    plot(freqQueryFiltered, ampQueryFiltered);
    title([sQueryTitle ' (Filtered)']);
    xlabel('Frequency');
    ylabel('Amplitude');
   
    fStartTm = fStartTm + fFrameTimeStep + 20;   % last 20 is the gap between frames
end
