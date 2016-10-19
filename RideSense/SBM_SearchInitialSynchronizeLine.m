function [fMaxLinearAcclMag nSynchronizeLine] = SBM_SearchInitialSynchronizeLine(sRawTraceFile, fTimeFromAppOn, bWithLabel, sLabelStartWith)

% This function is used to search the synchronized line at the beginning
% The synchronized line is the line which has max linear accl magnitude
% within x minutes from the beginning
%
% fTimeFromAppOn: decide the range of searching (from the first line),
% unit: s
%
% It returns a line number
%

format long;

nSynchronizeLine = 0;
fMaxLinearAcclMag = 0;

nTotalLine = 0;

nDataTypeLinearAccl = 2;

if bWithLabel == 0
    nIdxDataType = 2;
    nIdxLinearAccl = 6;    
else
    nIdxDataType = 3;
    nIdxLinearAccl = 7;
end

nIdxLabel = 2;

bInitRow = 0;
fInitTime = 0;

mLinearAcclMag = [];

fidRead = fopen(sRawTraceFile);

while 1
    sLine = fgetl(fidRead);
    if ~ischar(sLine)
        break;
    end

    nTotalLine = nTotalLine + 1;
    
    C = SplitStringX(sLine, ',');

    if bInitRow == 0
        bInitRow = 1;
        fInitTime = str2num(C{1});
    end

    if bWithLabel == 1
        if strcmpi(strtrim(C{nIdxLabel}),sLabelStartWith) == 1
            break;
        end
    end
    
    fTime = CalculateTimeInS(fInitTime, str2num(C{1}));

    if fTime >= fTimeFromAppOn
        break;
    end

    nDataType = str2num(C{nIdxDataType});
    
    if nDataType ~= nDataTypeLinearAccl
        continue;
    end
    
    mLinearAcclMag(nTotalLine) = sqrt(power(str2num(C{nIdxLinearAccl}),2) + power(str2num(C{nIdxLinearAccl+1}),2) + power(str2num(C{nIdxLinearAccl+2}),2));
    
end

fclose(fidRead);

[fMaxLinearAcclMag nSynchronizeLine] = max(mLinearAcclMag);

return;
