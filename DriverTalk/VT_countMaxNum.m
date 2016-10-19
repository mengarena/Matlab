function f = VT_countMaxNum(mat1)

[nRow nCol] = size(mat1);

nCount = 0;

for i=1:nRow
    if mat1(i,1) > 2000
        nCount = nCount + 1;
    end
end

nCount

fPer = nCount*1.0/nRow


f = 0;

return;
