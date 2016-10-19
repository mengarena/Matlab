function f = SBM_GetTurnInfo(mUniquedTmCrtTrace,nBeginLine,nEndLine,nIdxDataType)
% This function is used to extract the turn information of the segment
% (decided by the Begin/End line)
%
% Result:
%  For each turn:  Begin Line, End Line, Direction (1--Left, -1--Right, 0--Uncertain, 9--No Turn), Turn Degree, Lat, Long 
%

% This function is actually used to rotate phone axis to vehicle axis based on gravity (when the vehicle is static)
% It then uses windows to detect turns based on rotated Z-axis
%

format long;

nDataTypeAccl = 1;
nDataTypeGyro = 3;

nIdxGpsSpeed = nIdxDataType + 7;

mSegTrace = mUniquedTmCrtTrace(nBeginLine:nEndLine,:);

% Preprocessing: Filter
nSampleRateGyro = 200;
mFilteredGyro = SBM_PreprocessSingleSensor(mSegTrace, nIdxDataType, nDataTypeGyro, nSampleRateGyro);

nSampleRateAccl = 200;
mFilteredAccl = SBM_PreprocessSingleSensor(mSegTrace, nIdxDataType, nDataTypeAccl, nSampleRateAccl);
 
% Replace back, i.e. replace the raw Accl, Gyro with the
% filtered values
mSegTraceReplaced = mSegTrace;
mSegTraceReplaced((mSegTraceReplaced(:,nIdxDataType) == nDataTypeAccl),:) = mFilteredAccl;
mSegTraceReplaced((mSegTraceReplaced(:,nIdxDataType) == nDataTypeGyro),:) = mFilteredGyro;
    
% Now detect turns

fTurnTimeWinSize = 6;  % seconds
fTurnTimeWinStep = 0.5;

mTurnInfo = [];  % Each Line: Begin Line, End Line, Direction (0--Left, 1--Right), Turn Degree, Lat, Long 
nTurnCnt = 0;

mUnitAccl = [];

fLastMoment = mUniquedTmCrtTrace(nEndLine, 1);

nTurnWinBeginLine = 1;
fTurnWinStartTm = mSegTraceReplaced(nTurnWinBeginLine, 1);
fTurnWinEndTm = fTurnWinStartTm + fTurnTimeWinSize;

mCandidateTurnInfo = [];   

%while nSegLine <= nEndLine
while fTurnWinEndTm <= fLastMoment
   nTurnWinEndLine = SBM_GetLineNoByClosestTime(mSegTraceReplaced, nTurnWinBeginLine, fTurnWinEndTm);
   
   if nTurnWinEndLine == -1
       break;
   end
   
   % Find the recent moment before current turn window when the phone is
   % static. Based on the Accelerometer readings to estimate the attitude
   % of the phone and hence get the rotation matrix which could rotate the
   % coordiate system to align the X-Y plane with the Earth plane
   mUnitAccl = SBM_FindRotationForTurn(mUniquedTmCrtTrace, nTurnWinBeginLine + nBeginLine - 1, nIdxDataType, nIdxGpsSpeed, nDataTypeAccl);  % Improve, use filtered instead of mUniquedTmCrtTrace
   
   % Check whether this window contains a turn and if it is a turn, return
   % its information
   [bIsTurn nTurnDirection fTurnDegree fGpsLat fGpsLng] = SBM_CheckTurn(mSegTraceReplaced(nTurnWinBeginLine:nTurnWinEndLine,:), nIdxDataType, nDataTypeGyro, mUnitAccl);
      
   if bIsTurn == 1
       % When detects a turn, here process to declare it is a turn or just
       % wait (this make sure the sliding window could find the peak turn,
       % i.e. the window find the max turn degree)
       if length(mCandidateTurnInfo) == 0
           mCandidateTurnInfo(1) = nTurnWinBeginLine + nBeginLine - 1; % Line number in Original trace
           mCandidateTurnInfo(2) = nTurnWinEndLine + nBeginLine - 1; % Line number in Original trace
           mCandidateTurnInfo(3) = nTurnDirection;
           mCandidateTurnInfo(4) = fTurnDegree;
           mCandidateTurnInfo(5) = fGpsLat;
           mCandidateTurnInfo(6) = fGpsLng;           
       else
           % Check whether overlap with the candidate Turn
           if nTurnWinBeginLine + nBeginLine - 1 >= mCandidateTurnInfo(1) && nTurnWinBeginLine + nBeginLine - 1 <= mCandidateTurnInfo(2)  % Overlap
               if fTurnDegree > mCandidateTurnInfo(4)  % Update Candidate Turn
                   mCandidateTurnInfo(1) = nTurnWinBeginLine + nBeginLine - 1; % Line number in Original trace
                   mCandidateTurnInfo(2) = nTurnWinEndLine + nBeginLine - 1; % Line number in Original trace
                   mCandidateTurnInfo(3) = nTurnDirection;
                   mCandidateTurnInfo(4) = fTurnDegree;   
                   mCandidateTurnInfo(5) = fGpsLat;
                   mCandidateTurnInfo(6) = fGpsLng;                      
               end
           else % No overlap, could save the previous Candidate Turn and save current as Candidate
               mTurnInfo = [mTurnInfo; mCandidateTurnInfo];
               
               mCandidateTurnInfo(1) = nTurnWinBeginLine + nBeginLine - 1; % Line number in Original trace
               mCandidateTurnInfo(2) = nTurnWinEndLine + nBeginLine - 1; % Line number in Original trace
               mCandidateTurnInfo(3) = nTurnDirection;
               mCandidateTurnInfo(4) = fTurnDegree; 
               mCandidateTurnInfo(5) = fGpsLat;
               mCandidateTurnInfo(6) = fGpsLng;                
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
end

f = mTurnInfo;

return;
