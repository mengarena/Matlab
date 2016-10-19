function [IsQualified nGroundTruth] = SBM_IsQualifiedForStopFeature(mUniquedTmCrtTraceReplaced, nWinBeginLine, nWinEndLine, nIdxDataType)
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
% In a window, if one speed >= 999, not qualified
% if one speed is >0 and <999 and no recored has speed >= 999, this window is qualified and it is in moving status
% if all speed = 0, this window is qualified and it is in stop.
%
% Result:
% IsQualified: 0 or 1
% nGroundTruth: Valid only when IsQualified = 1;  Value:  1: Stop;  
% 0: Non-Stop
%

format long;

fGpsGap = 0.0;   % GPS's sample rate is low (1Hz), so when the bus actually convert from moving to stop, the GPS speed might not reflect it immediately (i.e. still not be 0), after fGpsGap, GPS speed becomes 0;
                 % when the bus converts from stop to moving, the vehicle
                 % is moving, but the GPS speed might not reflect it
                 % immediately, and still be 0, so the last portion of the
                 % "stop" part in M M M 0 0 0 0 0 0 0 M M is not trustable

IsQualified = 0;
nGroundTruth = 1;   % % 1:  Stop, 0: Non-Stop

[nRowCnt ~] = size(mUniquedTmCrtTraceReplaced);

for i = nWinBeginLine:nWinEndLine
    if mUniquedTmCrtTraceReplaced(i, nIdxDataType+7) >= 999
        nGroundTruth = -1;
        return;
    elseif mUniquedTmCrtTraceReplaced(i, nIdxDataType+7) < 999 && mUniquedTmCrtTraceReplaced(i, nIdxDataType+7) > 0
        nGroundTruth = 0;   % Non-stop  (if one non-stop, the whole window is non-stop)
    end    
end
    

if nWinBeginLine > 1
    nBeforeWinStatus = -1;  % If all speed == 0, 0; if one speed == 1, 1;  

    fWinBeginTm = mUniquedTmCrtTraceReplaced(nWinBeginLine, 1);

    % Check before
    for i = nWinBeginLine-1:-1:1
        fTimeGap = fWinBeginTm - mUniquedTmCrtTraceReplaced(i, 1);
        if fTimeGap >= fGpsGap
            break;
        end
        
        fTmpGpsSpeed = mUniquedTmCrtTraceReplaced(i, nIdxDataType+7);
        
        if fTmpGpsSpeed >= 999
            nBeforeWinStatus = -1;
            break;
        elseif fTmpGpsSpeed > 0 && fTmpGpsSpeed < 999
            nBeforeWinStatus = 0;   % Non-stop
        else % Speed = 0
            if nBeforeWinStatus == -1
                nBeforeWinStatus = 1;
            end
        end
               
    end
    
    if nBeforeWinStatus ~= -1 && nBeforeWinStatus ~= nGroundTruth
        IsQualified = 0;
        return;
    end    
end


if nWinEndLine < nRowCnt
    nAfterWinStatus = -1;

    fWinEndTm = mUniquedTmCrtTraceReplaced(nWinEndLine, 1);

    % Check before
    for i = nWinEndLine+1:nRowCnt
        fTimeGap = mUniquedTmCrtTraceReplaced(i, 1) - fWinEndTm;
        if fTimeGap >= fGpsGap
            break;
        end
        
        fTmpGpsSpeed = mUniquedTmCrtTraceReplaced(i, nIdxDataType+7);
        
        if fTmpGpsSpeed >= 999 
            nAfterWinStatus = -1;
            break;
        elseif fTmpGpsSpeed > 0 && fTmpGpsSpeed < 999
            nAfterWinStatus = 0;  % Non-stop
        else
            if nAfterWinStatus == -1
                nAfterWinStatus = 1;
            end
        end
               
    end
    
    if nAfterWinStatus ~= -1 && nAfterWinStatus ~= nGroundTruth
        IsQualified = 0;
        return;
    end
end


IsQualified = 1;

return;
