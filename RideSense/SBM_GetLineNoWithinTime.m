function f = SBM_GetLineNoWithinTime(mSensorTrace, nWinBeginLine, fWinEndTm)
% This function finds the line which is CLOSET but NOT exceed the
% timestamp fWinEndTm
% Search starts from nWinBeginLine

format long;

nWinEndLine = -1;

[nRow ~] = size(mSensorTrace);

if nWinBeginLine >= nRow
    f = nWinEndLine;
    return;
end

for i=nWinBeginLine+1:nRow
    if mSensorTrace(i,1) <= fWinEndTm 
        nWinEndLine = i;
    else
        break;
    end
end

f = nWinEndLine;

return;
