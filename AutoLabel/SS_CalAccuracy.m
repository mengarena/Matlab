function f = SS_CalAccuracy(sRankFile)
% This function is used to get the Number of prediction which is in Top1, Top2 and Top3 for the matching between OCR-Web

mData = load(sRankFile);

nCnt = length(mData);

nRank1 = 0;
nRank2 = 0;
nRank3 = 0;

for i=1:nCnt
    if mData(i) == 1
        nRank1 = nRank1 + 1;
    end
    
    if mData(i) == 1 || mData(i) == 2
        nRank2 = nRank2 + 1;
    end
    
    if mData(i) == 1 || mData(i) == 2 || mData(i) == 3
        nRank3 = nRank3 + 1;
    end
end

mCnt = [nCnt nRank1 nRank2 nRank3];

f = mCnt;

return;
