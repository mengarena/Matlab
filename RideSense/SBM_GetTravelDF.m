function f = SBM_GetTravelDF(mDF, nTravelBeginLine, nTravelEndLine)
% This function is used to get the Detailed Features for the travel
% The travel is defined by nTravelBeginLine, nTravelEndLine
% 
% In mDF, each line (i.e. features of one sliding window):
% Start Line, End Line, Field 3~52 (features)
%
% Reurn: Features vectors (i.e. Field 3~52) between the nTravelBeginLine/nTravelEndLine
%
format long;

[nDFCnt nCol] = size(mDF);

nBeginUnitIdx = 0;
nEndUnitIdx = 0;

nLineGap = 99999999;

% look for nBeginUnitIdx
for i = 1:nDFCnt
    nFeatureStartLine = mDF(i,1);
    nFeatureEndLine = mDF(i,2);
    
    nStartGap = abs(nFeatureStartLine - nTravelBeginLine);
    nEndGap = abs(nFeatureEndLine - nTravelBeginLine);
    
    nMinGap = min(nStartGap, nEndGap);
    
    if nMinGap < nLineGap
        nLineGap = nMinGap;
        nBeginUnitIdx = i;
    elseif nMinGap > nLineGap
        break;
    end        
end


nLineGap = 99999999;

% look for nEndUnitIdxwww
for i = 1:nDFCnt
    nFeatureStartLine = mDF(i,1);
    nFeatureEndLine = mDF(i,2);
    
    nStartGap = abs(nFeatureStartLine - nTravelEndLine);
    nEndGap = abs(nFeatureEndLine - nTravelEndLine);
    
    nMinGap = min(nStartGap, nEndGap);
    
    if nMinGap < nLineGap
        nLineGap = nMinGap;
        nEndUnitIdx = i;
    elseif nMinGap > nLineGap
        break;
    end        
end


mPsgDF = [];

if nBeginUnitIdx > 0 && nEndUnitIdx > 0
    mPsgDF = mDF(nBeginUnitIdx:nEndUnitIdx, 3:nCol);   % First, Second columns are not feature, so start from 3rd column
end

f = mPsgDF;

return;
