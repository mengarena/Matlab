function f = SBM_SpectrumComparison_AllPosition_Time(sRefTraceFile, sRefTitle, sHandTraceFile, sHandTitle, sPantTraceFile, sPantTitle, nSensorType, nCompareSize, nFrameCnt, nFilterFactor, nFigBaseNo)
%
% nSensorType is the sensor need to be compared
%

% Here sRefTraceFile, sHandTraceFile, sPantTraceFile are _TmCrt.csv
% The corresponding InfoG file will be xxx_InfoG.csv
%

% Plot in Time Domain

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
        
        mRefTraceFrame(:,1) = mRefTraceFrame(:,1) - mRefTraceFrame(1,1);
        mHandTraceFrame(:,1) = mHandTraceFrame(:,1) - mHandTraceFrame(1,1);
        mPantTraceFrame(:,1) = mPantTraceFrame(:,1) - mPantTraceFrame(1,1);
       
        %% Filtered Data
        mRefTraceFrameFiltered = mRefTraceFiltered(mRefTraceFiltered(:,1) >= fRefStartTm &  mRefTraceFiltered(:,1) <= fRefEndTm, :);
        mHandTraceFrameFiltered = mHandTraceFiltered(mHandTraceFiltered(:,1) >= fHandStartTm &  mHandTraceFiltered(:,1) <= fHandEndTm, :);
        mPantTraceFrameFiltered = mPantTraceFiltered(mPantTraceFiltered(:,1) >= fPantStartTm &  mPantTraceFiltered(:,1) <= fPantEndTm, :);

        mRefTraceFrameFiltered(:,1) = mRefTraceFrameFiltered(:,1) - mRefTraceFrameFiltered(1,1);
        mHandTraceFrameFiltered(:,1) = mHandTraceFrameFiltered(:,1) - mHandTraceFrameFiltered(1,1);
        mPantTraceFrameFiltered(:,1) = mPantTraceFrameFiltered(:,1) - mPantTraceFrameFiltered(1,1);
        
        nMoveFrameIdx = nMoveFrameIdx + 1;

        fMaxX = 0;
        fMaxY = 0;
        
        if mRefTraceFrame(end,1) > fMaxX
            fMaxX = mRefTraceFrame(end,1);
        end
                
        if mHandTraceFrame(end,1) > fMaxX
            fMaxX = mHandTraceFrame(end,1);
        end
        
        if mPantTraceFrame(end,1) > fMaxX
            fMaxX = mPantTraceFrame(end,1);
        end
        
        if mRefTraceFrameFiltered(end,1) > fMaxX
            fMaxX = mRefTraceFrameFiltered(end,1);
        end
        
        if mHandTraceFrameFiltered(end,1) > fMaxX
            fMaxX = mHandTraceFrameFiltered(end,1);
        end
        
        if mPantTraceFrameFiltered(end,1) > fMaxX
            fMaxX = mPantTraceFrameFiltered(end,1);
        end
       
        if max(mRefTraceFrame(:,2)) > fMaxY
            fMaxY = max(mRefTraceFrame(:,2));
        end
       
        if max(mHandTraceFrame(:,2)) > fMaxY
            fMaxY = max(mHandTraceFrame(:,2));
        end

        if max(mPantTraceFrame(:,2)) > fMaxY
            fMaxY = max(mPantTraceFrame(:,2));
        end

        if max(mRefTraceFrameFiltered(:,2)) > fMaxY
            fMaxY = max(mRefTraceFrameFiltered(:,2));
        end
       
        if max(mHandTraceFrameFiltered(:,2)) > fMaxY
            fMaxY = max(mHandTraceFrameFiltered(:,2));
        end

        if max(mPantTraceFrameFiltered(:,2)) > fMaxY
            fMaxY = max(mPantTraceFrameFiltered(:,2));
        end
        
        %% Plotting
        figure(nFigBaseNo+nMoveFrameIdx);        
        % Plot in Time domain
        subplot(3,2,1);
        plot(mRefTraceFrame(:,1), mRefTraceFrame(:,2));
        title([sRefTitle ' (Move Raw)' '-' int2str(nMoveFrameIdx)]);
        xlabel('Time (s)');
        ylabel(sRefTitle);
        set(gca,'xgrid','on');
        set(gca,'ygrid','on');
        xlim([0 fMaxX]);
        %ylim([0 fMaxY]);
        
        subplot(3,2,2);
        plot(mRefTraceFrameFiltered(:,1), mRefTraceFrameFiltered(:,2));
        title([sRefTitle ' (Move Filtered)']);
        xlabel('Time (s)');
        ylabel(sRefTitle);
        set(gca,'xgrid','on');
        set(gca,'ygrid','on');
        xlim([0 fMaxX]);
        %ylim([0 fMaxY]);

        % Hand
        subplot(3,2,3);
        plot(mHandTraceFrame(:,1), mHandTraceFrame(:,2));
        title([sHandTitle ' (Move Raw)']);
        xlabel('Time (s)');
        ylabel(sHandTitle);
        set(gca,'xgrid','on');
        set(gca,'ygrid','on');
        xlim([0 fMaxX]);
        %ylim([0 fMaxY]);

        subplot(3,2,4);
        plot(mHandTraceFrameFiltered(:,1), mHandTraceFrameFiltered(:,2));
        title([sHandTitle ' (Move Filtered)']);
        xlabel('Time (s)');
        ylabel(sHandTitle);
        set(gca,'xgrid','on');
        set(gca,'ygrid','on');
        xlim([0 fMaxX]);
        %ylim([0 fMaxY]);

        % Pant
        subplot(3,2,5);
        plot(mPantTraceFrame(:,1), mPantTraceFrame(:,2));
        title([sPantTitle ' (Move Raw)']);
        xlabel('Time (s)');
        ylabel(sPantTitle);
        set(gca,'xgrid','on');
        set(gca,'ygrid','on');
        xlim([0 fMaxX]);
        %ylim([0 fMaxY]);

        subplot(3,2,6);
        plot(mPantTraceFrameFiltered(:,1), mPantTraceFrameFiltered(:,2));
        title([sPantTitle ' (Move Filtered)']);
        xlabel('Time (s)');
        ylabel(sPantTitle);
        set(gca,'xgrid','on');
        set(gca,'ygrid','on');
        xlim([0 fMaxX]);
        %ylim([0 fMaxY]);

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
        
        mRefTraceFrame(:,1) = mRefTraceFrame(:,1) - mRefTraceFrame(1,1);
        mHandTraceFrame(:,1) = mHandTraceFrame(:,1) - mHandTraceFrame(1,1);
        mPantTraceFrame(:,1) = mPantTraceFrame(:,1) - mPantTraceFrame(1,1);
        
        %% Filtered Data
        mRefTraceFrameFiltered = mRefTraceFiltered(mRefTraceFiltered(:,1) >= fRefStartTm &  mRefTraceFiltered(:,1) <= fRefEndTm, :);
        mHandTraceFrameFiltered = mHandTraceFiltered(mHandTraceFiltered(:,1) >= fHandStartTm &  mHandTraceFiltered(:,1) <= fHandEndTm, :);
        mPantTraceFrameFiltered = mPantTraceFiltered(mPantTraceFiltered(:,1) >= fPantStartTm &  mPantTraceFiltered(:,1) <= fPantEndTm, :);

        mRefTraceFrameFiltered(:,1) = mRefTraceFrameFiltered(:,1) - mRefTraceFrameFiltered(1,1);
        mHandTraceFrameFiltered(:,1) = mHandTraceFrameFiltered(:,1) - mHandTraceFrameFiltered(1,1);
        mPantTraceFrameFiltered(:,1) = mPantTraceFrameFiltered(:,1) - mPantTraceFrameFiltered(1,1);
        
        nStopFrameIdx = nStopFrameIdx + 1;

        fMaxX = 0;
        fMaxY = 0;
        
        if mRefTraceFrame(end,1) > fMaxX
            fMaxX = mRefTraceFrame(end,1);
        end
                
        if mHandTraceFrame(end,1) > fMaxX
            fMaxX = mHandTraceFrame(end,1);
        end
        
        if mPantTraceFrame(end,1) > fMaxX
            fMaxX = mPantTraceFrame(end,1);
        end
        
        if mRefTraceFrameFiltered(end,1) > fMaxX
            fMaxX = mRefTraceFrameFiltered(end,1);
        end
        
        if mHandTraceFrameFiltered(end,1) > fMaxX
            fMaxX = mHandTraceFrameFiltered(end,1);
        end
        
        if mPantTraceFrameFiltered(end,1) > fMaxX
            fMaxX = mPantTraceFrameFiltered(end,1);
        end
       
        if max(mRefTraceFrame(:,2)) > fMaxY
            fMaxY = max(mRefTraceFrame(:,2));
        end
       
        if max(mHandTraceFrame(:,2)) > fMaxY
            fMaxY = max(mHandTraceFrame(:,2));
        end

        if max(mPantTraceFrame(:,2)) > fMaxY
            fMaxY = max(mPantTraceFrame(:,2));
        end

        if max(mRefTraceFrameFiltered(:,2)) > fMaxY
            fMaxY = max(mRefTraceFrameFiltered(:,2));
        end
       
        if max(mHandTraceFrameFiltered(:,2)) > fMaxY
            fMaxY = max(mHandTraceFrameFiltered(:,2));
        end

        if max(mPantTraceFrameFiltered(:,2)) > fMaxY
            fMaxY = max(mPantTraceFrameFiltered(:,2));
        end
                
        %% Plotting
        figure(30+nFigBaseNo+nStopFrameIdx);
        % Plot in Time domain
        subplot(3,2,1);
        plot(mRefTraceFrame(:,1), mRefTraceFrame(:,2));
        title([sRefTitle ' (Stop Raw)' '-' int2str(30+nStopFrameIdx)]);
        xlabel('Time (s)');
        ylabel(sRefTitle);
        set(gca,'xgrid','on');
        set(gca,'ygrid','on');
        xlim([0 fMaxX]);
        %ylim([0 fMaxY]);
        
        subplot(3,2,2);
        plot(mRefTraceFrameFiltered(:,1), mRefTraceFrameFiltered(:,2));
        title([sRefTitle ' (Stop Filtered)']);
        xlabel('Time (s)');
        ylabel(sRefTitle);
        set(gca,'xgrid','on');
        set(gca,'ygrid','on');
        xlim([0 fMaxX]);
        %ylim([0 fMaxY]);

        % Hand
        subplot(3,2,3);
        plot(mHandTraceFrame(:,1), mHandTraceFrame(:,2));
        title([sHandTitle ' (Stop Raw)']);
        xlabel('Time (s)');
        ylabel(sHandTitle);
        set(gca,'xgrid','on');
        set(gca,'ygrid','on');
        xlim([0 fMaxX]);
        %ylim([0 fMaxY]);

        subplot(3,2,4);
        plot(mHandTraceFrameFiltered(:,1), mHandTraceFrameFiltered(:,2));
        title([sHandTitle ' (Stop Filtered)']);
        xlabel('Time (s)');
        ylabel(sHandTitle);
        set(gca,'xgrid','on');
        set(gca,'ygrid','on');
        xlim([0 fMaxX]);
        %ylim([0 fMaxY]);

        % Pant
        subplot(3,2,5);
        plot(mPantTraceFrame(:,1), mPantTraceFrame(:,2));
        title([sPantTitle ' (Stop Raw)']);
        xlabel('Time (s)');
        ylabel(sPantTitle);
        set(gca,'xgrid','on');
        set(gca,'ygrid','on');
        xlim([0 fMaxX]);
        %ylim([0 fMaxY]);

        subplot(3,2,6);
        plot(mPantTraceFrameFiltered(:,1), mPantTraceFrameFiltered(:,2));
        title([sPantTitle ' (Stop Filtered)']);
        xlabel('Time (s)');
        ylabel(sPantTitle);
        set(gca,'xgrid','on');
        set(gca,'ygrid','on');
        xlim([0 fMaxX]);
        %ylim([0 fMaxY]);

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
