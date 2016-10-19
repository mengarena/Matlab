function f = SBM_DecideSingleTurnDirection(mTurnGyroRows, mUnitAccl, nIdxDataType)
% This function is used to decide the direction of one turn (1: left, -1: right, 0: Uncertain, 9: No turn)
%
% mTurnGyroRows contains the raw gyro rows
% mUnitAccl is the rotation matrix
%

format long;

nTurnDirection = 0;

[nGyroRowCnt ~] = size(mTurnGyroRows);

% Rotate to align the X-Y plane of phone with Earth plane 
mRotatedGyroZ = [];

% Get Rotation speed around Z-axis
for i=1:nGyroRowCnt
    mRotatedGyroZ(i) = mTurnGyroRows(i, nIdxDataType+1) * mUnitAccl(1) + mTurnGyroRows(i, nIdxDataType+2) * mUnitAccl(2) + mTurnGyroRows(i, nIdxDataType+3) * mUnitAccl(3);
end

% Calculte Turn Direction
% 
nTmpTurnDirection = 0;

for i=2:nGyroRowCnt    
    % Turn Direction statistics
    if mRotatedGyroZ(i-1) > 0
        nTmpTurnDirection = nTmpTurnDirection + 1;
    elseif mRotatedGyroZ(i-1) < 0
        nTmpTurnDirection = nTmpTurnDirection - 1;
    end
end
    
if nTmpTurnDirection > 0
    nTurnDirection = 1;   % Turn Left
elseif nTmpTurnDirection < 0
    nTurnDirection = -1;  % Turn Right
end
    
f = nTurnDirection;

return;
