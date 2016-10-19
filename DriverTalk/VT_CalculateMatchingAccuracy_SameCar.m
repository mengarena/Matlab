function f=VT_CalculateMatchingAccuracy_SameCar(mResult, nThreshold, nSizeLimit)
format long;

nSizeThreshold = 10.0;
[nRow nCol] = size(mResult);

nMatchedCount = 0;
nTotalCountAboveSize = 0;

for i=1:nRow
   if nSizeLimit == 1
       if mResult(i, 4) >= nSizeThreshold
            nTotalCountAboveSize = nTotalCountAboveSize + 1;
           if  mResult(i, 5) >= nThreshold
                nMatchedCount = nMatchedCount + 1;
           end
       end
   else 
       if  mResult(i, 5) >= nThreshold
            nMatchedCount = nMatchedCount + 1;
       end
   end
end

if nSizeLimit == 1
    disp(strcat('Total number of Matching Pair with smaller size above threshold: ', num2str(nTotalCountAboveSize)));
    if nTotalCountAboveSize == 0
        fAccuracy = 0.0;   %% or 1.0 ?
    else
        fAccuracy = nMatchedCount*1.0/nTotalCountAboveSize;
    end
    disp(strcat('Total number of Matched (with smaller size above threshold): ', num2str(nMatchedCount)));

else
    fAccuracy = nMatchedCount*1.0/nRow;
end

f = fAccuracy;

return;
