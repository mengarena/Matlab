function f = SS_SplitString(sLine, sDelim)

nDummyValue = cellstr('');

mIdx = strfind(sLine, sDelim);

nDataIdx = 0;

nBegPos = 1;
nEndPos = mIdx(1);

if nBegPos == nEndPos
    nDataIdx = nDataIdx + 1;
    mData(nDataIdx) = nDummyValue;
else 
    nDataIdx = nDataIdx + 1;
    mData(nDataIdx) = cellstr(sLine(nBegPos:nEndPos-1));
end

for i=2:length(mIdx)
    nBegPos = mIdx(i-1) + 1;
    nEndPos = mIdx(i) - 1;
    nDataIdx = nDataIdx + 1;
    if nBegPos > nEndPos
        mData(nDataIdx) = nDummyValue;
    else
        mData(nDataIdx) = cellstr(sLine(nBegPos:nEndPos));
    end
end

nLenIdx = length(mIdx);
nLastPos = mIdx(nLenIdx);
nLen = length(sLine);

if nLastPos ~= nLen
   nDataIdx = nDataIdx + 1;
   mData(nDataIdx) = cellstr(sLine(nLastPos+1:nLen)); 
end

f = mData;

return;
