function f = SBM_FindPassengerUnitAccl(mCellUnitAcclInfo, nSegIdx, nTurnBeginLine, nTurnEndLine)
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
% mCellUnitAcclInfo is a cell of mUnitAcclInfo, one cell is for one segment
% If UnitAccl is not found in current segment (decided by nSegIdx), search
% other segment
%
%  This function returns a mUnitAccl
%

nUnitAcclCellNum = length(mCellUnitAcclInfo);

mUnitAccl = [];

if nUnitAcclCellNum == 0
    f = mUnitAccl;
    return;
end

nFind = 0;

% Search before turn
for i = nSegIdx:-1:1
    mUnitAcclInfo = mCellUnitAcclInfo{i};
    [nUnitAcclCnt ~] = size(mUnitAcclInfo);
    
    for j = 1:nUnitAcclCnt
        nUnitAcclEndLine = mUnitAcclInfo(j,2);
        if nUnitAcclEndLine <= nTurnBeginLine
            mUnitAccl = mUnitAcclInfo(j,3:5);
            nFind = 1;
        else
            break;
        end    
    end
    
    if nFind == 1
        break;
    end
end

if length(mUnitAccl) > 0
    f = mUnitAccl;
    return;
end

% Not found, search after turn
nFind = 0;

% Search after turn
for i = nSegIdx+1:nUnitAcclCellNum
    mUnitAcclInfo = mCellUnitAcclInfo{i};
    [nUnitAcclCnt ~] = size(mUnitAcclInfo);
    
    for j = 1:nUnitAcclCnt
        nUnitAcclBeginLine = mUnitAcclInfo(j,1);
        if nUnitAcclBeginLine >= nTurnEndLine
            mUnitAccl = mUnitAcclInfo(j,3:5);
            nFind = 1;
            break;
        else
            continue;
        end    
    end
    
    if nFind == 1
        break;
    end
end

f = mUnitAccl;

return;
