function [bIsTurn nTurnDirection fTurnDegree fGpsLat fGpsLng] = SBM_CheckTurn(mWinTurnTrace, nIdxDataType, nDataTypeGyro, mUnitAccl)
% This function is used to check whether current window contains a Turn
% If it contains a turn, calculate its Turn Direction, Degree, and also its
% Lat, Long
%
% Accl and Gyro in mUniquedTmCrtTraceReplaced has been low-pass filtered
%
% Turn Direction:  1: left, -1: right, 0: Uncertain, 9: No turn 
%
% How to decide Turn Direction:
% When Coordinate system aligned, turn is around Z-axis
% If Z-axis Gyro > 0 ===> Turn Left;  If Z-axis Gyro < 0 ===> Turn Right
%
% This if for Reference Trace, which has GPS information
%

format long;

fTurnDegreeThreshold = 35;

bIsTurn = 0;
nTurnDirection = 9;
fTurnDegree = 9999;
fGpsLat = 9999;
fGpsLng = 9999;

mGyroRows = mWinTurnTrace(find(mWinTurnTrace(:,nIdxDataType) == nDataTypeGyro),:);

[nGyroRowCnt ~] = size(mGyroRows);

% Rotate to align the X-Y plane of phone with Earth plane 
mRotatedGyroZ = [];

if length(mUnitAccl) > 0
    %disp('Using Rotation Feature');
    % Get Rotation speed around Z-axis
    for i=1:nGyroRowCnt
        mRotatedGyroZ(i) = mGyroRows(i, nIdxDataType+1) * mUnitAccl(1) + mGyroRows(i, nIdxDataType+2) * mUnitAccl(2) + mGyroRows(i, nIdxDataType+3) * mUnitAccl(3);
    end
else
    for i=1:nGyroRowCnt
        mRotatedGyroZ(i) = sqrt(power(mGyroRows(i, nIdxDataType+1),2) + power(mGyroRows(i, nIdxDataType+2),2) + power(mGyroRows(i, nIdxDataType+3),2));
    end    
end

% Calculte Turn Degree and Direction
% 
nTmpTurnDirection = 0;
fTotalTurnDegree = 0;

for i=2:nGyroRowCnt
    % Calculate Turn Degree
    fAngleSpeed = mRotatedGyroZ(i-1);
%    fTimeGap = mWinTurnTrace(i, 1) - mWinTurnTrace(i-1, 1);
    fTimeGap = mGyroRows(i, 1) - mGyroRows(i-1, 1);

    fTotalTurnDegree = fTotalTurnDegree + fAngleSpeed * fTimeGap;
    
    % Turn Direction statistics
    if mRotatedGyroZ(i-1) > 0
        nTmpTurnDirection = nTmpTurnDirection + 1;
    elseif mRotatedGyroZ(i-1) < 0
        nTmpTurnDirection = nTmpTurnDirection - 1;
    end
end

fTotalTurnDegree = fTotalTurnDegree/pi*180;   % Degree

if abs(fTotalTurnDegree) >= fTurnDegreeThreshold
    bIsTurn = 1;
    
    if length(mUnitAccl) > 0
        if nTmpTurnDirection > 0
            nTurnDirection = 1;   % Turn Left
        elseif nTmpTurnDirection < 0
            nTurnDirection = -1;  % Turn Right
        end
    else
        nTurnDirection = 0;   % Turn Direction is Uncertain
    end
    
    fTurnDegree = fTotalTurnDegree;
    fGpsLat = mean(mGyroRows(:,nIdxDataType+4));
    fGpsLng = mean(mGyroRows(:,nIdxDataType+5));
end


return;

