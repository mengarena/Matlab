function f = SBM_GetTravelBF(mBF, nTravelBeginLine, nTravelEndLine)
% This function is used to select Basic Feature for a travel
% The travel is decided by nTravelBeginLine/nTravelEndLine
%
% In mBF, each line:  
% Type (0=Stop, 1=Moving, 2=Turn), Duration/Direction, Start Line, End Line, Lat, Long
%
format long;

[nBFCnt ~] = size(mBF);

nSelectedBFBeginLine = 1;
nSelectedBFEndLine = nBFCnt;

nLineGap = 99999999;
nBeginUnitIdx = 0;
nEndUnitIdx = 0;

for i = 1:nBFCnt
    nBFUnitBeginLine = mBF(i,3);
    
    nTmpLineGap = abs(nBFUnitBeginLine-nTravelBeginLine);
    if nTmpLineGap < nLineGap
        nLineGap = nTmpLineGap;
        nBeginUnitIdx = i;
    elseif nTmpLineGap > nLineGap
        break;
    end
end

nLineGap = 99999999;

for i = 1:nBFCnt
    nBFUnitEndLine = mBF(i,4);
    
    nTmpLineGap = abs(nBFUnitEndLine-nTravelEndLine);
    if nTmpLineGap < nLineGap
        nLineGap = nTmpLineGap;
        nEndUnitIdx = i;
    elseif nTmpLineGap > nLineGap
        break;
    end
end

mTravelBF = [];

if nBeginUnitIdx > 0 && nEndUnitIdx > 0
    mTravelBF = mBF(nBeginUnitIdx:nEndUnitIdx,:);
end

f = mTravelBF; 

return;
