function f = SS_GetClusterAccuracy(sClusterResultFile)

format long;

fidRead = fopen(sClusterResultFile);

nAccuracyIndex = 1;

mAccuracy = [];
nCnt = 0;

while 1
    sLine = fgetl(fidRead);
    if ~ischar(sLine)
        break;
    end
    
    C = SS_SplitString(sLine, ';');
    fAccuracy = str2num(C{nAccuracyIndex});
    
    if isnan(fAccuracy)
    else
        nCnt = nCnt + 1;
        mAccuracy(1,nCnt) = fAccuracy*100;
    end
end

fclose(fidRead);


f = mAccuracy;

return;
