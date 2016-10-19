function f = SBM_FindPassengerUnitAccl_WholeTrace(mUnitAcclInfo, nTurnBeginLine, nTurnEndLine)
% This function is used to find the UnitAccl for Turn's BeginLine/EndLine
% It first search back from nTurnBeginLine, i.e. the UnitAccl should occur
% before nTurnBeginLine
% If not found, search the UnitAccl just next to nTurnEndLine in the
% furture
%
%     mUnitAcclInfo(nUnitAcclInfoCnt, 1) = nWinBeginLine + nBeginLine -1;
%     mUnitAcclInfo(nUnitAcclInfoCnt, 2) = nRealEndLine;                    
%     mUnitAcclInfo(nUnitAcclInfoCnt, 3) = mUnitAccl(1);
%     mUnitAcclInfo(nUnitAcclInfoCnt, 4) = mUnitAccl(2);
%     mUnitAcclInfo(nUnitAcclInfoCnt, 5) = mUnitAccl(3);
%
%  This function returns a mUnitAccl
%

[nUnitAcclCnt ~] = size(mUnitAcclInfo);

mUnitAccl = [];

% Search before turn
for i=1:nUnitAcclCnt
    nUnitAcclEndLine = mUnitAcclInfo(i,2);
    if nUnitAcclEndLine <= nTurnBeginLine
        mUnitAccl = mUnitAcclInfo(i,3:5);
    else
        break;
    end    
end

% Not found, search after turn
if length(mUnitAccl) == 0
    for i=1:nUnitAcclCnt
        nUnitAcclBeginLine = mUnitAcclInfo(i,1);
        if nUnitAcclBeginLine >= nTurnEndLine
            mUnitAccl = mUnitAcclInfo(i,3:5);
            break;
        else
            continue;
        end    
    end    
end

f = mUnitAccl;

return;
