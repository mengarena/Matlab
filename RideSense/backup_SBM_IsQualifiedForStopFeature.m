function [IsQualified nGroundTruth] = backup_SBM_IsQualifiedForStopFeature(mUniquedTmCrtTraceReplaced, nWinBeginLine, nWinEndLine, fGpsGap, nIdxDataType)
% This function is used to check whether the windowed sensor data is
% qualified for feature extraction for Stop Detection (Stop or Moving)
%
% Trace example: (S=stop, M=Moving, decided by GPS Speed)
% SSSSMMMMMMMMSSSSSMMMSSSSSMMMMMSSSSS
% 
% Due to low sample rate of GPS, GPS speed might be lag behind the actual
% motion, so the sensor data around the motion converion is not reliable
% (or say Qualified) for Stop/Moving detection
%

format long;

IsQualified = 0;
nGroundTruth = -1;   % % 1:  Stop, 0: Non-Stop

[nRowCnt ~] = size(mUniquedTmCrtTraceReplaced);

bSpeedZero = 0;
bSpeedNonZero = 0;

for i = nWinBeginLine:nWinEndLine
    if mUniquedTmCrtTraceReplaced(i, nIdxDataType+7) == 0   % Gps Speed
        bSpeedZero = 1;
    elseif mUniquedTmCrtTraceReplaced(i, nIdxDataType+7) >= 999
        return;
    else
        bSpeedNonZero = 1;
    end
    
    if bSpeedZero == 1 && bSpeedNonZero == 1
        return;
    end
end

nWinStatus = -1;

if bSpeedZero == 1
    nWinStatus = 0;
elseif bSpeedNonZero == 1
    nWinStatus = 1;
end
    
    
nBeforeWinSpeedStatus = -2;  % If all speed == 0, 0; if all speed == 1, 1; if mixed, -1  

if nWinBeginLine > 1
    fWinBeginTm = mUniquedTmCrtTraceReplaced(nWinBeginLine, 1);

    % Check before
    for i = nWinBeginLine-1:-1:1
        fTimeGap = fWinBeginTm - mUniquedTmCrtTraceReplaced(i, 1);
        if fTimeGap >= fGpsGap
            break;
        end
        
        fTmpGpsSpeed = mUniquedTmCrtTraceReplaced(i, nIdxDataType+7);
        
        if fTmpGpsSpeed >= 999
            return;
        elseif fTmpGpsSpeed > 0
            if nBeforeWinSpeedStatus ~= -2 && nBeforeWinSpeedStatus ~= 1
                IsQualified = 0;
                return;
            end
            
            nBeforeWinSpeedStatus = 1;
        else  % Speed = 0
            if nBeforeWinSpeedStatus ~= -2 && nBeforeWinSpeedStatus ~= 0
                IsQualified = 0;
                return;
            end
            
            nBeforeWinSpeedStatus = 0;
        end
               
    end  
end

if nBeforeWinSpeedStatus~= -2 && nBeforeWinSpeedStatus ~= nWinStatus
    IsQualified = 0;
    return;
end

nAfterWinSpeedStatus = -2;

if nWinEndLine < nRowCnt
    fWinEndTm = mUniquedTmCrtTraceReplaced(nWinEndLine, 1);

    % Check before
    for i = nWinEndLine+1:nRowCnt
        fTimeGap = mUniquedTmCrtTraceReplaced(i, 1) - fWinEndTm;
        if fTimeGap >= fGpsGap
            break;
        end
        
        fTmpGpsSpeed = mUniquedTmCrtTraceReplaced(i, nIdxDataType+7);
        
        if fTmpGpsSpeed >= 999
            return;
        elseif fTmpGpsSpeed > 0
            if nAfterWinSpeedStatus ~= -2 && nAfterWinSpeedStatus ~= 1
                IsQualified = 0;
                return;
            end
            
            nAfterWinSpeedStatus = 1;
        else  % Speed = 0
            if nAfterWinSpeedStatus ~= -2 && nAfterWinSpeedStatus ~= 0
                IsQualified = 0;
                return;
            end
            
            nAfterWinSpeedStatus = 0;
        end
               
    end  
end


if nAfterWinSpeedStatus~= -2 && nAfterWinSpeedStatus ~= nWinStatus
    IsQualified = 0;
    return;
end


IsQualified = 1;
nGroundTruth = nWinStatus;

return;
