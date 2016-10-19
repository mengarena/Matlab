function f = SBM_GetLineNoByClosestTime(mBaseTrace, nStartRow, fTime)
% Get the line no whose time is CLOSEST to the given timestamp fTime
%

format long;

nTimeIdx = 1;
[nRow ~] = size(mBaseTrace);

nSelectedLineNo = 0;

fMinGap = 99999;

for i = nStartRow:nRow
    fTmpGap = abs(mBaseTrace(i, nTimeIdx) - fTime);
    if fTmpGap < fMinGap
        nSelectedLineNo = i;
        fMinGap = fTmpGap;
    elseif fTmpGap > fMinGap
        break;
    end
end

f = nSelectedLineNo;

return;
