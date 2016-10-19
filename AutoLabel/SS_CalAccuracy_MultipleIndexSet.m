function f = SS_CalAccuracy_MultipleIndexSet(sRankFile)
% This function is used to get the Number of prediction which is in Top1, Top2 and Top3 for the matching between OCR-Web

mData = load(sRankFile);

[nRow nCnt] = size(mData);

%nCnt = length(mData);

mRank1 = [];
mRank2 = [];
mRank3 = [];

for j=1:nRow
    mRank1(j) = 0;
    mRank2(j) = 0;
    mRank3(j) = 0;
    
    for i=1:nCnt
        if mData(j,i) == 1
            mRank1(j) = mRank1(j) + 1;
        end

        if mData(j,i) == 1 || mData(j,i) == 2
            mRank2(j) = mRank2(j) + 1;
        end

        if mData(j,i) == 1 || mData(j,i) == 2 || mData(j,i) == 3
            mRank3(j) = mRank3(j) + 1;
        end
    end
   
end

for j=1:nRow
    mRank1(j) = mRank1(j)*1.0/nCnt*100;
    mRank2(j) = mRank2(j)*1.0/nCnt*100;
    mRank3(j) = mRank3(j)*1.0/nCnt*100;
end

mAccuracy = [mean(mRank1) std(mRank1) mean(mRank2) std(mRank2) mean(mRank3) std(mRank3)];

f = mAccuracy;

return;
