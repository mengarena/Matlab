function f = SBM_GetPassengerTurnInfo(mUniquedTmCrtTrace,nBeginLine,nEndLine,nIdxDataType)
% This function is used to extract the turn information of the segment of
% passenger trace.
% (decided by the Begin/End line)
%
% In passenger trace, there is no GPS data
%
% Result:
%  For each turn:  Begin Line, End Line, Direction (1--Left, -1--Right, 0--Uncertain, 9--No Turn), Turn Degree,
%
%
% This function is actually used to rotate phone axis to vehicle axis based on gravity (when the vehicle is static)
% It then uses windows to detect turns based on rotated Z-axis
%

format long;

% nDataTypeAccl = 1;
nDataTypeGyro = 3;

mSegTrace = mUniquedTmCrtTrace(nBeginLine:nEndLine,:);

% Preprocessing: Filter
nSampleRateGyro = 200;
mFilteredGyro = SBM_PreprocessSingleSensor(mSegTrace, nIdxDataType, nDataTypeGyro, nSampleRateGyro);

% nSampleRateAccl = 200;
% mFilteredAccl = SBM_PreprocessSingleSensor(mSegTrace, nIdxDataType, nDataTypeAccl, nSampleRateAccl);
 
% Replace back, i.e. replace the raw Accl, Gyro with the
% filtered values
mSegTraceReplaced = mSegTrace;
% mSegTraceReplaced((mSegTraceReplaced(:,nIdxDataType) == nDataTypeAccl),:) = mFilteredAccl;
mSegTraceReplaced((mSegTraceReplaced(:,nIdxDataType) == nDataTypeGyro),:) = mFilteredGyro;
    
% Now detect turns

fTurnTimeWinSize = 6;  % seconds
fTurnTimeWinStep = 0.5;

mTurnInfo = [];  % Each Line: Begin Line, End Line, Direction (0--Left, 1--Right), Turn Degree, Lat, Long 
nTurnCnt = 0;

nTurnDirectionUncertain = 0;

fLastMoment = mUniquedTmCrtTrace(nEndLine, 1);

nTurnWinBeginLine = 1;
fTurnWinStartTm = mSegTraceReplaced(nTurnWinBeginLine, 1);
fTurnWinEndTm = fTurnWinStartTm + fTurnTimeWinSize;

mCandidateTurnInfo = [];   
mCandidateTurnGyroRows = [];

mCellTurnGyroRows = [];
nTurnGyroRowsSetCnt = 0;


while fTurnWinEndTm <= fLastMoment
   nTurnWinEndLine = SBM_GetLineNoByClosestTime(mSegTraceReplaced, nTurnWinBeginLine, fTurnWinEndTm);
   
   if nTurnWinEndLine == -1
       break;
   end
   
   % Check whether this window contains a turn and if it is a turn, return
   % its information
   [bIsTurn fTurnDegree fGpsLat fGpsLng] = SBM_CheckPassengerTurn(mSegTraceReplaced(nTurnWinBeginLine:nTurnWinEndLine,:), nIdxDataType, nDataTypeGyro);
      
   if bIsTurn == 1       
       % When detects a turn, here process to declare it is a turn or just
       % wait (this make sure the sliding window could find the peak turn,
       % i.e. the window find the max turn degree)
       if length(mCandidateTurnInfo) == 0
           mCandidateTurnInfo(1) = nTurnWinBeginLine + nBeginLine - 1; % Line number in Original trace
           mCandidateTurnInfo(2) = nTurnWinEndLine + nBeginLine - 1; % Line number in Original trace
           mCandidateTurnInfo(3) = nTurnDirectionUncertain;
           mCandidateTurnInfo(4) = fTurnDegree;
           mCandidateTurnInfo(5) = fGpsLat;
           mCandidateTurnInfo(6) = fGpsLng;
                      
           mWinTurnTrace = mSegTraceReplaced(nTurnWinBeginLine:nTurnWinEndLine,:);
           mCandidateTurnGyroRows = mWinTurnTrace(find(mWinTurnTrace(:,nIdxDataType) == nDataTypeGyro),:);
           
       else
           % Check whether overlap with the candidate Turn
           if nTurnWinBeginLine + nBeginLine - 1 >= mCandidateTurnInfo(1) && nTurnWinBeginLine + nBeginLine - 1 <= mCandidateTurnInfo(2)  % Overlap
               if fTurnDegree > mCandidateTurnInfo(4)  % Update Candidate Turn
                   mCandidateTurnInfo(1) = nTurnWinBeginLine + nBeginLine - 1; % Line number in Original trace
                   mCandidateTurnInfo(2) = nTurnWinEndLine + nBeginLine - 1; % Line number in Original trace
                   mCandidateTurnInfo(3) = nTurnDirectionUncertain;
                   mCandidateTurnInfo(4) = fTurnDegree;   
                   mCandidateTurnInfo(5) = fGpsLat;
                   mCandidateTurnInfo(6) = fGpsLng;

                   mWinTurnTrace = mSegTraceReplaced(nTurnWinBeginLine:nTurnWinEndLine,:);
                   mCandidateTurnGyroRows = mWinTurnTrace(find(mWinTurnTrace(:,nIdxDataType) == nDataTypeGyro),:);
               end
           else % No overlap, could save the previous Candidate Turn and save current as Candidate
               mTurnInfo = [mTurnInfo; mCandidateTurnInfo];
               nTurnGyroRowsSetCnt = nTurnGyroRowsSetCnt + 1;
               mCellTurnGyroRows{nTurnGyroRowsSetCnt} = mCandidateTurnGyroRows;
               
               mCandidateTurnInfo(1) = nTurnWinBeginLine + nBeginLine - 1; % Line number in Original trace
               mCandidateTurnInfo(2) = nTurnWinEndLine + nBeginLine - 1; % Line number in Original trace
               mCandidateTurnInfo(3) = nTurnDirectionUncertain;
               mCandidateTurnInfo(4) = fTurnDegree; 
               mCandidateTurnInfo(5) = fGpsLat;
               mCandidateTurnInfo(6) = fGpsLng;
               
               mWinTurnTrace = mSegTraceReplaced(nTurnWinBeginLine:nTurnWinEndLine,:);
               mCandidateTurnGyroRows = mWinTurnTrace(find(mWinTurnTrace(:,nIdxDataType) == nDataTypeGyro),:);               
           end
       end
   end
        
   % Move window
   fTurnWinStartTm = fTurnWinStartTm + fTurnTimeWinStep;
   
   if fTurnWinStartTm >= fLastMoment
       break;
   end

   fTurnWinEndTm = fTurnWinStartTm + fTurnTimeWinSize;
   
   nTurnWinBeginLine = SBM_GetLineNoBeyondTime(mSegTraceReplaced, nTurnWinBeginLine, fTurnWinStartTm);
   
end

if length(mCandidateTurnInfo) > 0  % There is one Candidate Turn has not been saved
    mTurnInfo = [mTurnInfo; mCandidateTurnInfo];

    nTurnGyroRowsSetCnt = nTurnGyroRowsSetCnt + 1;
    mCellTurnGyroRows{nTurnGyroRowsSetCnt} = mCandidateTurnGyroRows;
end

mTurnInfoGyroRow = [];
mTurnInfoGyroRow{1} = mTurnInfo;
mTurnInfoGyroRow{2} = mCellTurnGyroRows;

f = mTurnInfoGyroRow;

return;
