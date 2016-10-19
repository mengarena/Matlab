function f = VT_getRandomIdx(nTmpNeighCount, nTargetCnt)
% Get #nTargetCnt integers from the range of 1~nTmpNeighCount

mRetIdx = [];

for i=1:5
    mRetIdx(1,i) = -1;
end

for i=1:nTargetCnt
    nRndNum = 1+floor(nTmpNeighCount*rand);

    while VT_checkExist(mRetIdx, nRndNum)  == 1
        nRndNum = 1+floor(nTmpNeighCount*rand);
    end
    
    mRetIdx(1,i) = nRndNum;
end

f=mRetIdx;

return;
