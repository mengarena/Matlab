function f = SBM_GetLineNoBeyondTime(mSensorTrace, nWinBeginLine, fWinBeginTm)
% This function searches and find the lines which has timestamp closest to
% fWinBeginTm but >= fWinBeginTm
% Search starts from nWinBeginLine
%

format long;

nResultWinBeginLine = -1;

[nRow ~] = size(mSensorTrace);

if nWinBeginLine >= nRow
    f = nResultWinBeginLine;
    return;
end

for i = nWinBeginLine+1:nRow
    if mSensorTrace(i,1) >= fWinBeginTm
        nResultWinBeginLine = i;
        break;
    end
end

f = nResultWinBeginLine;

return;
