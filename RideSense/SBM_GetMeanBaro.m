function f = SBM_GetMeanBaro(mBaseTrace, nDataTypeIdx, nStartLine, nEndLine)
% Calculate the mean barometer value between given lines

format long;

mBaroValue = [];

nBaroRow = 0;

for i = nStartLine:nEndLine
    if mBaseTrace(i, nDataTypeIdx) == 7   % Barometer
        nBaroRow = nBaroRow + 1;
        mBaroValue(nBaroRow) = mBaseTrace(i, nDataTypeIdx+1);
    end
end

if nBaroRow == 0
    f = -1;
else
    f = mean(mBaroValue);
end

return;
