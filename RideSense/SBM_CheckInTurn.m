function [nInTurn nTurnIdx] = SBM_CheckInTurn(mTurns, nWinBeginLine, nWinEndLine)
% For each turn:  Begin Line (in original trace), End Line, Direction (1--Left, -1--Right, 0-Uncertain,9--No Turn), Turn Degree 
% nWinBeginLine,nWinEndLine: Line no in original trace

format long;

nInTurn = 0;
nTurnIdx = 0;

[nTurnCnt ~] = size(mTurns);

if nTurnCnt == 0
    return;
end

for i = 1:nTurnCnt
    nTurnBeginLine = mTurns(i, 1);
    nTurnEndLine = mTurns(i, 2);
    
    if nTurnBeginLine <= nWinBeginLine && nWinBeginLine <= nTurnEndLine
        nInTurn = 1;
        nTurnIdx = i;
        break;
    elseif nTurnBeginLine <= nWinEndLine && nWinEndLine <= nTurnEndLine
        nInTurn = 1;
        nTurnIdx = i;
        break;
    end
end


return;
