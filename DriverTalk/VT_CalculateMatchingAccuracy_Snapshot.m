function f=VT_CalculateMatchingAccuracy_Snapshot(mResult, nThreshold, nSizeLimit)

format long;

mGroundTruth_SameCar_Snapshot = [164 691 692];

[nRowGT nColGT] = size(mGroundTruth_SameCar_Snapshot);

[nRow nCol] = size(mResult);

nCorrectCount = 0;

for i=1:nRow
    nSameCarSnapshot = 0;
    
    for j=1:nColGT
        if i==mGroundTruth_SameCar_Snapshot(1,j)
            nSameCarSnapshot = 1;
            break;
        end
    end
    
    if nSameCarSnapshot == 0
        if mResult(i,2) < nThreshold
            nCorrectCount = nCorrectCount + 1;
        end
    else
        if mResult(i,2) >= nThreshold
            nCorrectCount = nCorrectCount + 1;
        end
    end
   
end

fAccuracy = nCorrectCount*1.0/nRow;

f = fAccuracy;

return;
