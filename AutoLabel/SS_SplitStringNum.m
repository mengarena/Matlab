function f = SS_SplitStringNum(sLine, sDelim)
format long;

nDummyValue = 0;
mData = [];
mIdx = strfind(sLine, sDelim);

nDataIdx = 0;

nBegPos = 1;
nEndPos = mIdx(1);

if nBegPos == nEndPos
    nDataIdx = nDataIdx + 1;
    mData(nDataIdx) = nDummyValue;
else 
    nDataIdx = nDataIdx + 1;
    mData(nDataIdx) = str2num(sLine(nBegPos:nEndPos-1));
end

for i=2:length(mIdx)
    nBegPos = mIdx(i-1) + 1;
    nEndPos = mIdx(i) - 1;
    nDataIdx = nDataIdx + 1;
    if nBegPos > nEndPos
        mData(nDataIdx) = nDummyValue;
    else
        mData(nDataIdx) = str2num(sLine(nBegPos:nEndPos));
    end
end

nLenIdx = length(mIdx);
nLastPos = mIdx(nLenIdx);
nLen = length(sLine);

if nLastPos ~= nLen
   nDataIdx = nDataIdx + 1;
   mData(nDataIdx) = str2num(sLine(nLastPos:nLen)); 
end

f = mData;

return;
