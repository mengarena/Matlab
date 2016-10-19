function f=VT_checkExist(mList, nValue)

[nRow nCol] = size(mList);

nExist = 0;

for i=1:nCol
    if mList(1,i) ~= -1 && mList(1,i) == nValue
        nExist = 1;
        break;
    end
end

f=nExist;

return;

