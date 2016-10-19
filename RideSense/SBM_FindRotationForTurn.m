function f = SBM_FindRotationForTurn(mUniquedTmCrtTrace, nSearchBeginLine, nIdxDataType, nIdxGpsSpeed, nDataTypeAccl)

% This function is used to search the record line which could tell the
% attitude of the phone before the line nSegLine
% The required record must be in static status
% 
% It returns a Unit Accl vector, which could be used to rotate the axis (to
% align X-Y plan with the earth
%

% Better to use filtered version, instead of mUniquedTmCrtTrace

format long;

[nTotalLine ~] = size(mUniquedTmCrtTrace);

mUnitAccl = [];

if nSearchBeginLine == 1
    % Search the static status in the next future (assume the phone's
    % attitude does not change from now to the next static status)
    for i = nSearchBeginLine+1:nTotalLine
        nDataType = mUniquedTmCrtTrace(i, nIdxDataType);
        fGpsSpeed = mUniquedTmCrtTrace(i, nIdxGpsSpeed);

        if fGpsSpeed == 0 && nDataType == nDataTypeAccl
            mUnitAccl = mUniquedTmCrtTrace(i, nIdxDataType+1:nIdxDataType+3)/sqrt(power(mUniquedTmCrtTrace(i, nIdxDataType+1),2) + power(mUniquedTmCrtTrace(i, nIdxDataType+2),2) + power(mUniquedTmCrtTrace(i, nIdxDataType+3),2));
            break;
        end        
    end
else
    % Search the previous static status
    for i = nSearchBeginLine-1:-1:1
        nDataType = mUniquedTmCrtTrace(i, nIdxDataType);
        fGpsSpeed = mUniquedTmCrtTrace(i, nIdxGpsSpeed);

        if fGpsSpeed == 0 && nDataType == nDataTypeAccl
            mUnitAccl = mUniquedTmCrtTrace(i, nIdxDataType+1:nIdxDataType+3)/sqrt(power(mUniquedTmCrtTrace(i, nIdxDataType+1),2) + power(mUniquedTmCrtTrace(i, nIdxDataType+2),2) + power(mUniquedTmCrtTrace(i, nIdxDataType+3),2));
            break;
        end
    end
    
    % If no static status previously, search the static status in the next
    % future
    if length(mUnitAccl) == 0
        for i = nSearchBeginLine+1:nTotalLine
            nDataType = mUniquedTmCrtTrace(i, nIdxDataType);
            fGpsSpeed = mUniquedTmCrtTrace(i, nIdxGpsSpeed);

            if fGpsSpeed == 0 && nDataType == nDataTypeAccl
                mUnitAccl = mUniquedTmCrtTrace(i, nIdxDataType+1:nIdxDataType+3)/sqrt(power(mUniquedTmCrtTrace(i, nIdxDataType+1),2) + power(mUniquedTmCrtTrace(i, nIdxDataType+2),2) + power(mUniquedTmCrtTrace(i, nIdxDataType+3),2));
                break;
            end        
        end    
    end
    
end

f = mUnitAccl;

return;
