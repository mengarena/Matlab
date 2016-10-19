function [bIsTurn nTurnIdx] = SBM_CheckIsTurn(mTurns, nLine)
% This function checks whether nLine is within a turn
%
% In mTurns, each row: Begin Line, End Line, Turn Degree, Direction (0--Left, 1--Right) 
%

bIsTurn = 0;
nTurnIdx = 0;

[nTurnCnt ~] = size(mTurns);

for i = 1:nTurnCnt
    nBeginLine = mTurns(i, 1);
    nEndLine = mTurns(i, 2);
    if nBeginLine <= nLine && nLine <= nEndLine
        bIsTurn = 1;
        nTurnIdx = i;
        break;
    end
end

return;
