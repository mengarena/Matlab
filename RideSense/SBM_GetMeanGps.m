function [fMeanGpsLat, fMeanGpsLng, fMeanGpsAlt] = SBM_GetMeanGps(mBaseTrace, nDataTypeIdx, nStartLine, nEndLine)
% Calculate the mean Gps value between given lines

format long;

mGpsValue = [];

nGpsRow = 0;

for i = nStartLine:nEndLine
    if mBaseTrace(i, nDataTypeIdx) == 10   % Gps
        nGpsRow = nGpsRow + 1;
        mGpsValue(nGpsRow, 1) = mBaseTrace(i, nDataTypeIdx+4);  % Lat
        mGpsValue(nGpsRow, 2) = mBaseTrace(i, nDataTypeIdx+5);  % Long
        mGpsValue(nGpsRow, 3) = mBaseTrace(i, nDataTypeIdx+6);  % Altitude  
    end
end

if nGpsRow == 0
%     fMeanGpsLat = -1;
%     fMeanGpsLng = -1;
%     fMeanGpsAlt = -1;
    fMeanGpsLat = (mBaseTrace(nStartLine, nDataTypeIdx+4) + mBaseTrace(nEndLine, nDataTypeIdx+4))/2;
    fMeanGpsLng = (mBaseTrace(nStartLine, nDataTypeIdx+5) + mBaseTrace(nEndLine, nDataTypeIdx+5))/2;
    fMeanGpsAlt = (mBaseTrace(nStartLine, nDataTypeIdx+6) + mBaseTrace(nEndLine, nDataTypeIdx+6))/2;
elseif nGpsRow == 1
    fMeanGpsLat = mGpsValue(1,1);
    fMeanGpsLng = mGpsValue(1,2);
    fMeanGpsAlt = mGpsValue(1,3);    
else
    mMean = mean(mGpsValue);
    fMeanGpsLat = mMean(1);
    fMeanGpsLng = mMean(2);
    fMeanGpsAlt = mMean(3);
end

return;
