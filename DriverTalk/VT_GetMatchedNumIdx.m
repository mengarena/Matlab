function f=VT_GetMatchedNumIdx(mResult)

[nRow nCol] = size(mResult);

mRet = [];
nIdx = 1;
for i=1:nRow
    if mResult(i, 2) ~= 0
       mRet(nIdx, 1) = i;
       mRet(nIdx, 2) = mResult(i, 2);
       mRet(nIdx, 3) = mResult(i, 3);
       mRet(nIdx, 4) = mResult(i, 4);
       nIdx = nIdx + 1;
    end
end

f = mRet;

return;
