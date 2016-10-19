function f = SBM_SpectrumComparison_AllPosition(sRefTraceFile, sRefTitle, sHandTraceFile, sHandTitle, sPantTraceFile, sPantTitle, nSensorType, nCompareSize, nFrameCnt, nFilterFactor, nFigBaseNo)
%
% nSensorType is the sensor need to be compared
%

% Here sRefTraceFile, sHandTraceFile, sPantTraceFile are _TmCrt.csv
% The corresponding InfoG file will be xxx_InfoG.csv
%

if nSensorType == 7   % Baro
    xFreqMax = 50;
    xStep = 2;
else                  % Linear Accl or Gyro
    xFreqMax = 108;
    xStep = 4;
end

mDataType = [1 2 3 4 5 6 7 8 9 10 12];  % No WiFi

% Field Number
mFieldNum = [3 3 3 3 3 1 1 1 1 7 3];

nIndexIndex = find(mDataType == nSensorType);

nSensorFieldNum = mFieldNum(nIndexIndex);

% Get _InfoG.csv files
sInFoGPostFix = 'InfoG';   % General Information

[pathstr, filename, ext] = fileparts(sRefTraceFile);
sRefTraceInfoGFile = [pathstr '\' filename '_' sInFoGPostFix '.csv'];

[pathstr, filename, ext] = fileparts(sHandTraceFile);
sHandTraceInfoGFile = [pathstr '\' filename '_' sInFoGPostFix '.csv'];

[pathstr, filename, ext] = fileparts(sPantTraceFile);
sPantTraceInfoGFile = [pathstr '\' filename '_' sInFoGPostFix '.csv'];

mRefInfoG = load(sRefTraceInfoGFile);
mHandInfoG = load(sHandTraceInfoGFile);
mPantInfoG = load(sPantTraceInfoGFile);

mRefMove = mRefInfoG(mRefInfoG(:,1)== 1, :);
mRefStop = mRefInfoG(mRefInfoG(:,1)== 0, :);

mHandMove = mHandInfoG(mHandInfoG(:,1)== 1, :);
mHandStop = mHandInfoG(mHandInfoG(:,1)== 0, :);

mPantMove = mPantInfoG(mPantInfoG(:,1)== 1, :);
mPantStop = mPantInfoG(mPantInfoG(:,1)== 0, :);

%%%%%%%%
mRefTraceOrg = load(sRefTraceFile);
mHandTraceOrg = load(sHandTraceFile);
mPantTraceOrg = load(sPantTraceFile);


mRefTraceRaw = [];
mRefTraceRaw(:,1) = mRefTraceOrg(mRefTraceOrg(:,2) == nSensorType, 1);
if mFieldNum == 1
    mRefTraceRaw(:,2) = mRefTraceOrg(mRefTraceOrg(:,2) == nSensorType, 3);
else
    mRefTraceRaw(:,2) = sqrt(power(mRefTraceOrg(mRefTraceOrg(:,2) == nSensorType,3),2) + power(mRefTraceOrg(mRefTraceOrg(:,2) == nSensorType,4),2) + power(mRefTraceOrg(mRefTraceOrg(:,2) == nSensorType,5),2));    
end


mHandTraceRaw = [];
mHandTraceRaw(:,1) = mHandTraceOrg(mHandTraceOrg(:,3) == nSensorType, 1);
if mFieldNum == 1
    mHandTraceRaw(:,2) = mHandTraceOrg(mHandTraceOrg(:,3) == nSensorType, 4);
else
    mHandTraceRaw(:,2) = sqrt(power(mHandTraceOrg(mHandTraceOrg(:,3) == nSensorType,4),2) + power(mHandTraceOrg(mHandTraceOrg(:,3) == nSensorType,5),2) + power(mHandTraceOrg(mHandTraceOrg(:,3) == nSensorType,6),2));    
end


mPantTraceRaw = [];
mPantTraceRaw(:,1) = mPantTraceOrg(mPantTraceOrg(:,2) == nSensorType, 1);
if mFieldNum == 1
    mPantTraceRaw(:,2) = mPantTraceOrg(mPantTraceOrg(:,2) == nSensorType, 3);
else
    mPantTraceRaw(:,2) = sqrt(power(mPantTraceOrg(mPantTraceOrg(:,2) == nSensorType,3),2) + power(mPantTraceOrg(mPantTraceOrg(:,2) == nSensorType,4),2) + power(mPantTraceOrg(mPantTraceOrg(:,2) == nSensorType,5),2));    
end

% Filter
mRefTraceFiltered = mRefTraceRaw;
mRefTraceFiltered(:,2) = EMA(mRefTraceRaw(:,2), nFilterFactor);

mHandTraceFiltered = mHandTraceRaw;
mHandTraceFiltered(:,2) = EMA(mHandTraceRaw(:,2), nFilterFactor);

mPantTraceFiltered = mPantTraceRaw;
mPantTraceFiltered(:,2) = EMA(mPantTraceRaw(:,2), nFilterFactor);


fFrameTimeStep = nCompareSize;   % Second


%%% First Compare Move Units
[nMoveUnitCnt ~] = size(mHandMove);

nMoveFrameIdx = 0;

for i=1:nMoveUnitCnt
    
    nHandUnitStartLine = mHandMove(i,2);
    nHandUnitEndLine = mHandMove(i,3);

    nRefUnitStartLine = mRefMove(i,2);
    nRefUnitEndLine = mRefMove(i,3);

    nPantUnitStartLine = mPantMove(i,2);
    nPantUnitEndLine = mPantMove(i,3);
   
    fHandUnitStartTm = mHandTraceOrg(nHandUnitStartLine, 1);
    fHandUnitEndTm = mHandTraceOrg(nHandUnitEndLine, 1);

    fRefUnitStartTm = mRefTraceOrg(nRefUnitStartLine, 1);
    fRefUnitEndTm = mRefTraceOrg(nRefUnitEndLine, 1);

    fPantUnitStartTm = mPantTraceOrg(nPantUnitStartLine, 1);
    fPantUnitEndTm = mPantTraceOrg(nPantUnitEndLine, 1);
    
    fHandStartTm = fHandUnitStartTm;    
    fRefStartTm = fRefUnitStartTm;
    fPantStartTm = fPantUnitStartTm;
    
    fHandEndTm = fHandStartTm + fFrameTimeStep;

    while fHandEndTm <= fHandUnitEndTm
        
        fRefEndTm = fRefStartTm + fFrameTimeStep;
        fPantEndTm = fPantStartTm + fFrameTimeStep;

        if (fRefEndTm > fRefUnitEndTm) | (fPantEndTm > fPantUnitEndTm)
            break;
        end
        
        % Get a frame
        mRefTraceFrame = mRefTraceRaw(mRefTraceRaw(:,1) >= fRefStartTm & mRefTraceRaw(:,1) <= fRefEndTm, :);
        mHandTraceFrame = mHandTraceRaw(mHandTraceRaw(:,1) >= fHandStartTm & mHandTraceRaw(:,1) <= fHandEndTm, :);
        mPantTraceFrame = mPantTraceRaw(mPantTraceRaw(:,1) >= fPantStartTm & mPantTraceRaw(:,1) <= fPantEndTm, :);
       
        % Calculate and Show the spectrum on one figure
        fIntervalRef = (mRefTraceFrame(end,1) - mRefTraceFrame(1,1))/2048;
        xxRef = mRefTraceFrame(1,1):fIntervalRef:mRefTraceFrame(end,1);    
        yyRef = spline(mRefTraceFrame(:,1),mRefTraceFrame(:,2),xxRef); 

        InterRef = [];
        InterRef(:,1) = xxRef;
        InterRef(:,2) = yyRef;

        mRefSpec = SBM_SegSpectrum(InterRef, 2);
        freqRef = mRefSpec{1};     
        ampRef = mRefSpec{2};

        % Hand
        fIntervalHand = (mHandTraceFrame(end,1) - mHandTraceFrame(1,1))/2048;
        xxHand = mHandTraceFrame(1,1):fIntervalHand:mHandTraceFrame(end,1);
        yyHand = spline(mHandTraceFrame(:,1),mHandTraceFrame(:,2),xxHand); 

        InterHand = [];
        InterHand(:,1) = xxHand;
        InterHand(:,2) = yyHand;

        mHandSpec = SBM_SegSpectrum(InterHand, 2);
        freqHand = mHandSpec{1};     
        ampHand = mHandSpec{2};

        % Pantpocket
        fIntervalPant = (mPantTraceFrame(end,1) - mPantTraceFrame(1,1))/2048;
        xxPant = mPantTraceFrame(1,1):fIntervalPant:mPantTraceFrame(end,1);
        yyPant = spline(mPantTraceFrame(:,1),mPantTraceFrame(:,2),xxPant); 

        InterPant = [];
        InterPant(:,1) = xxPant;
        InterPant(:,2) = yyPant;

        mPantSpec = SBM_SegSpectrum(InterPant, 2);
        freqPant = mPantSpec{1};     
        ampPant = mPantSpec{2};

        
        %% Filtered Data
        mRefTraceFrameFiltered = mRefTraceFiltered(mRefTraceFiltered(:,1) >= fRefStartTm &  mRefTraceFiltered(:,1) <= fRefEndTm, :);
        mHandTraceFrameFiltered = mHandTraceFiltered(mHandTraceFiltered(:,1) >= fHandStartTm &  mHandTraceFiltered(:,1) <= fHandEndTm, :);
        mPantTraceFrameFiltered = mPantTraceFiltered(mPantTraceFiltered(:,1) >= fPantStartTm &  mPantTraceFiltered(:,1) <= fPantEndTm, :);

        % Calculate and Show the spectrum on one figure
        % Ref: Seat
        fIntervalRefFiltered = (mRefTraceFrameFiltered(end,1) - mRefTraceFrameFiltered(1,1))/2048;
        xxRefFiltered = mRefTraceFrameFiltered(1,1):fIntervalRefFiltered:mRefTraceFrameFiltered(end,1);
        yyRefFiltered = spline(mRefTraceFrameFiltered(:,1),mRefTraceFrameFiltered(:,2),xxRefFiltered); 

        InterRefFiltered = [];
        InterRefFiltered(:,1) = xxRefFiltered;
        InterRefFiltered(:,2) = yyRefFiltered;

        mRefSpecFiltered = SBM_SegSpectrum(InterRefFiltered, 2);
        freqRefFiltered = mRefSpecFiltered{1};     
        ampRefFiltered = mRefSpecFiltered{2};

        % Hand
        fIntervalHandFiltered = (mHandTraceFrameFiltered(end,1) - mHandTraceFrameFiltered(1,1))/2048;
        xxHandFiltered = mHandTraceFrameFiltered(1,1):fIntervalHandFiltered:mHandTraceFrameFiltered(end,1);
        yyHandFiltered = spline(mHandTraceFrameFiltered(:,1),mHandTraceFrameFiltered(:,2),xxHandFiltered); 

        InterHandFiltered = [];
        InterHandFiltered(:,1) = xxHandFiltered;
        InterHandFiltered(:,2) = yyHandFiltered;

        mHandSpecFiltered = SBM_SegSpectrum(InterHandFiltered, 2);
        freqHandFiltered = mHandSpecFiltered{1};     
        ampHandFiltered = mHandSpecFiltered{2};

        % Pantpocket
        fIntervalPantFiltered = (mPantTraceFrameFiltered(end,1) - mPantTraceFrameFiltered(1,1))/2048;
        xxPantFiltered = mPantTraceFrameFiltered(1,1):fIntervalPantFiltered:mPantTraceFrameFiltered(end,1);
        yyPantFiltered = spline(mPantTraceFrameFiltered(:,1),mPantTraceFrameFiltered(:,2),xxPantFiltered); 

        InterPantFiltered = [];
        InterPantFiltered(:,1) = xxPantFiltered;
        InterPantFiltered(:,2) = yyPantFiltered;

        mPantSpecFiltered = SBM_SegSpectrum(InterPantFiltered, 2);
        freqPantFiltered = mPantSpecFiltered{1};     
        ampPantFiltered = mPantSpecFiltered{2};

        nMoveFrameIdx = nMoveFrameIdx + 1;

        %% Plotting
        figure(nFigBaseNo+nMoveFrameIdx);        
        % Plot in Frequency domain
        subplot(3,2,1);
        plot(freqRef, ampRef);
        title([sRefTitle ' (Move Raw)']);
        xlabel('Frequency');
        ylabel('Amplitude');
        set(gca,'xgrid','on');
        set(gca,'ygrid','on');
        xlim([0 xFreqMax]);
        set(gca,'XTick',0:xStep:xFreqMax);
        
        subplot(3,2,2);
        plot(freqRefFiltered, ampRefFiltered);
        title([sRefTitle ' (Move Filtered)']);
        xlabel('Frequency');
        ylabel('Amplitude');
        set(gca,'xgrid','on');
        set(gca,'ygrid','on');
        xlim([0 xFreqMax]);
        set(gca,'XTick',0:xStep:xFreqMax);

        % Hand
        subplot(3,2,3);
        plot(freqHand, ampHand);
        title([sHandTitle ' (Move Raw)']);
        xlabel('Frequency');
        ylabel('Amplitude');
        set(gca,'xgrid','on');
        set(gca,'ygrid','on');
        xlim([0 xFreqMax]);
        set(gca,'XTick',0:xStep:xFreqMax);

        subplot(3,2,4);
        plot(freqHandFiltered, ampHandFiltered);
        title([sHandTitle ' (Move Filtered)']);
        xlabel('Frequency');
        ylabel('Amplitude');
        set(gca,'xgrid','on');
        set(gca,'ygrid','on');
        xlim([0 xFreqMax]);
        set(gca,'XTick',0:xStep:xFreqMax);

        % Pant
        subplot(3,2,5);
        plot(freqPant, ampPant);
        title([sPantTitle ' (Move Raw)']);
        xlabel('Frequency');
        ylabel('Amplitude');
        set(gca,'xgrid','on');
        set(gca,'ygrid','on');
        xlim([0 xFreqMax]);
        set(gca,'XTick',0:xStep:xFreqMax);

        subplot(3,2,6);
        plot(freqPantFiltered, ampPantFiltered);
        title([sPantTitle ' (Move Filtered)']);
        xlabel('Frequency');
        ylabel('Amplitude');
        set(gca,'xgrid','on');
        set(gca,'ygrid','on');
        xlim([0 xFreqMax]);
        set(gca,'XTick',0:xStep:xFreqMax);

        if nMoveFrameIdx >= nFrameCnt
            break;
        end
        
        fHandStartTm = fHandStartTm + fFrameTimeStep + 20;   % last 20 is the gap between frames
        fRefStartTm = fRefStartTm + fFrameTimeStep + 20;
        fPantStartTm = fPantStartTm + fFrameTimeStep + 20;
        
        fHandEndTm = fHandStartTm + fFrameTimeStep;
    end
    
    if nMoveFrameIdx >= nFrameCnt
        break;
    end
end



%%% Second Compare Stop Units
[nStopUnitCnt ~] = size(mHandStop);

nStopFrameIdx = 0;

% Only process the stops in-between
for i=2:nStopUnitCnt-1
    
    nHandUnitStartLine = mHandStop(i,2);
    nHandUnitEndLine = mHandStop(i,3);

    nRefUnitStartLine = mRefStop(i,2);
    nRefUnitEndLine = mRefStop(i,3);

    nPantUnitStartLine = mPantStop(i,2);
    nPantUnitEndLine = mPantStop(i,3);
   
    fHandUnitStartTm = mHandTraceOrg(nHandUnitStartLine, 1);
    fHandUnitEndTm = mHandTraceOrg(nHandUnitEndLine, 1);

    fRefUnitStartTm = mRefTraceOrg(nRefUnitStartLine, 1);
    fRefUnitEndTm = mRefTraceOrg(nRefUnitEndLine, 1);

    fPantUnitStartTm = mPantTraceOrg(nPantUnitStartLine, 1);
    fPantUnitEndTm = mPantTraceOrg(nPantUnitEndLine, 1);
    
    fHandStartTm = fHandUnitStartTm;    
    fRefStartTm = fRefUnitStartTm;
    fPantStartTm = fPantUnitStartTm;
    
    fHandEndTm = fHandStartTm + fFrameTimeStep;

    while fHandEndTm <= fHandUnitEndTm
        
        fRefEndTm = fRefStartTm + fFrameTimeStep;
        fPantEndTm = fPantStartTm + fFrameTimeStep;

        if (fRefEndTm > fRefUnitEndTm) | (fPantEndTm > fPantUnitEndTm)
            break;
        end
        
        % Get a frame
        mRefTraceFrame = mRefTraceRaw(mRefTraceRaw(:,1) >= fRefStartTm & mRefTraceRaw(:,1) <= fRefEndTm, :);
        mHandTraceFrame = mHandTraceRaw(mHandTraceRaw(:,1) >= fHandStartTm & mHandTraceRaw(:,1) <= fHandEndTm, :);
        mPantTraceFrame = mPantTraceRaw(mPantTraceRaw(:,1) >= fPantStartTm & mPantTraceRaw(:,1) <= fPantEndTm, :);
       
        % Calculate and Show the spectrum on one figure
        % Ref: Seat
        fIntervalRef = (mRefTraceFrame(end,1) - mRefTraceFrame(1,1))/2048;
        xxRef = mRefTraceFrame(1,1):fIntervalRef:mRefTraceFrame(end,1);    
        yyRef = spline(mRefTraceFrame(:,1),mRefTraceFrame(:,2),xxRef); 

        InterRef = [];
        InterRef(:,1) = xxRef;
        InterRef(:,2) = yyRef;

        mRefSpec = SBM_SegSpectrum(InterRef, 2);
        freqRef = mRefSpec{1};     
        ampRef = mRefSpec{2};

        % Hand
        fIntervalHand = (mHandTraceFrame(end,1) - mHandTraceFrame(1,1))/2048;
        xxHand = mHandTraceFrame(1,1):fIntervalHand:mHandTraceFrame(end,1);
        yyHand = spline(mHandTraceFrame(:,1),mHandTraceFrame(:,2),xxHand); 

        InterHand = [];
        InterHand(:,1) = xxHand;
        InterHand(:,2) = yyHand;

        mHandSpec = SBM_SegSpectrum(InterHand, 2);
        freqHand = mHandSpec{1};     
        ampHand = mHandSpec{2};

        % Pantpocket
        fIntervalPant = (mPantTraceFrame(end,1) - mPantTraceFrame(1,1))/2048;
        xxPant = mPantTraceFrame(1,1):fIntervalPant:mPantTraceFrame(end,1);
        yyPant = spline(mPantTraceFrame(:,1),mPantTraceFrame(:,2),xxPant); 

        InterPant = [];
        InterPant(:,1) = xxPant;
        InterPant(:,2) = yyPant;

        mPantSpec = SBM_SegSpectrum(InterPant, 2);
        freqPant = mPantSpec{1};     
        ampPant = mPantSpec{2};

        
        %% Filtered Data
        mRefTraceFrameFiltered = mRefTraceFiltered(mRefTraceFiltered(:,1) >= fRefStartTm &  mRefTraceFiltered(:,1) <= fRefEndTm, :);
        mHandTraceFrameFiltered = mHandTraceFiltered(mHandTraceFiltered(:,1) >= fHandStartTm &  mHandTraceFiltered(:,1) <= fHandEndTm, :);
        mPantTraceFrameFiltered = mPantTraceFiltered(mPantTraceFiltered(:,1) >= fPantStartTm &  mPantTraceFiltered(:,1) <= fPantEndTm, :);

        % Calculate and Show the spectrum on one figure
        % Ref: Seat
        fIntervalRefFiltered = (mRefTraceFrameFiltered(end,1) - mRefTraceFrameFiltered(1,1))/2048;
        xxRefFiltered = mRefTraceFrameFiltered(1,1):fIntervalRefFiltered:mRefTraceFrameFiltered(end,1);
        yyRefFiltered = spline(mRefTraceFrameFiltered(:,1),mRefTraceFrameFiltered(:,2),xxRefFiltered); 

        InterRefFiltered = [];
        InterRefFiltered(:,1) = xxRefFiltered;
        InterRefFiltered(:,2) = yyRefFiltered;

        mRefSpecFiltered = SBM_SegSpectrum(InterRefFiltered, 2);
        freqRefFiltered = mRefSpecFiltered{1};     
        ampRefFiltered = mRefSpecFiltered{2};

        % Hand
        fIntervalHandFiltered = (mHandTraceFrameFiltered(end,1) - mHandTraceFrameFiltered(1,1))/2048;
        xxHandFiltered = mHandTraceFrameFiltered(1,1):fIntervalHandFiltered:mHandTraceFrameFiltered(end,1);
        yyHandFiltered = spline(mHandTraceFrameFiltered(:,1),mHandTraceFrameFiltered(:,2),xxHandFiltered); 

        InterHandFiltered = [];
        InterHandFiltered(:,1) = xxHandFiltered;
        InterHandFiltered(:,2) = yyHandFiltered;

        mHandSpecFiltered = SBM_SegSpectrum(InterHandFiltered, 2);
        freqHandFiltered = mHandSpecFiltered{1};     
        ampHandFiltered = mHandSpecFiltered{2};

        % Pantpocket
        fIntervalPantFiltered = (mPantTraceFrameFiltered(end,1) - mPantTraceFrameFiltered(1,1))/2048;
        xxPantFiltered = mPantTraceFrameFiltered(1,1):fIntervalPantFiltered:mPantTraceFrameFiltered(end,1);
        yyPantFiltered = spline(mPantTraceFrameFiltered(:,1),mPantTraceFrameFiltered(:,2),xxPantFiltered); 

        InterPantFiltered = [];
        InterPantFiltered(:,1) = xxPantFiltered;
        InterPantFiltered(:,2) = yyPantFiltered;

        mPantSpecFiltered = SBM_SegSpectrum(InterPantFiltered, 2);
        freqPantFiltered = mPantSpecFiltered{1};     
        ampPantFiltered = mPantSpecFiltered{2};

        nStopFrameIdx = nStopFrameIdx + 1;

        %% Plotting
        figure(30+nFigBaseNo+nStopFrameIdx);
        subplot(3,2,1);
        plot(freqRef, ampRef);
        title([sRefTitle ' (Stop Raw)']);
        xlabel('Frequency');
        ylabel('Amplitude');
        set(gca,'xgrid','on');
        set(gca,'ygrid','on');
        xlim([0 xFreqMax]);
        set(gca,'XTick',0:xStep:xFreqMax);
        
        subplot(3,2,2);
        plot(freqRefFiltered, ampRefFiltered);
        title([sRefTitle ' (Stop Filtered)']);
        xlabel('Frequency');
        ylabel('Amplitude');
        set(gca,'xgrid','on');
        set(gca,'ygrid','on');
        xlim([0 xFreqMax]);
        set(gca,'XTick',0:xStep:xFreqMax);

        % Hand
        subplot(3,2,3);
        plot(freqHand, ampHand);
        title([sHandTitle ' (Stop Raw)']);
        xlabel('Frequency');
        ylabel('Amplitude');
        set(gca,'xgrid','on');
        set(gca,'ygrid','on');
        xlim([0 xFreqMax]);
        set(gca,'XTick',0:xStep:xFreqMax);

        subplot(3,2,4);
        plot(freqHandFiltered, ampHandFiltered);
        title([sHandTitle ' (Stop Filtered)']);
        xlabel('Frequency');
        ylabel('Amplitude');
        set(gca,'xgrid','on');
        set(gca,'ygrid','on');
        xlim([0 xFreqMax]);
        set(gca,'XTick',0:xStep:xFreqMax);

        % Pant
        subplot(3,2,5);
        plot(freqPant, ampPant);
        title([sPantTitle ' (Stop Raw)']);
        xlabel('Frequency');
        ylabel('Amplitude');
        set(gca,'xgrid','on');
        set(gca,'ygrid','on');
        xlim([0 xFreqMax]);
        set(gca,'XTick',0:xStep:xFreqMax);

        subplot(3,2,6);
        plot(freqPantFiltered, ampPantFiltered);
        title([sPantTitle ' (Stop Filtered)']);
        xlabel('Frequency');
        ylabel('Amplitude');
        set(gca,'xgrid','on');
        set(gca,'ygrid','on');
        xlim([0 xFreqMax]);
        set(gca,'XTick',0:xStep:xFreqMax);

        if nStopFrameIdx >= nFrameCnt
            break;
        end
        
        fHandStartTm = fHandStartTm + fFrameTimeStep + 20;   % last 20 is the gap between frames
        fRefStartTm = fRefStartTm + fFrameTimeStep + 20;
        fPantStartTm = fPantStartTm + fFrameTimeStep + 20;
        
        fHandEndTm = fHandStartTm + fFrameTimeStep;
    end
    
    if nStopFrameIdx >= nFrameCnt
        break;
    end
end


return;
