function f = CalculateOneResult(sClusteringResultFile)

nTotalCnt = 0;
fTotalAccuracy = 0;
nCorrect = 0;

fidRead = fopen(sClusteringResultFile);

while 1
    sLine = fgetl(fidRead);
    if ~ischar(sLine)
        break;
    end
    
    C = SS_SplitString(sLine, ',');
    fAccuracy = str2num(C{2});
    
    if fAccuracy == 1.0
        nCorrect = nCorrect + 1;
    end
    
    fTotalAccuracy = fTotalAccuracy + fAccuracy;
    
    nTotalCnt = nTotalCnt + 1;
    
end

fclose(fidRead);

f = [nTotalCnt nCorrect fTotalAccuracy];

return;
