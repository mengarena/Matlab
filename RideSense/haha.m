mWinLinearAccl = [12 1; 13 1; 13 1; 13 1; 14 1; 15 1; 16 1; 16 1; 18 1; 19 1; 19 1; 19 1; 29 1];
nRow = length(mWinLinearAccl);
fMinTimeGap = 0.00033;
fPreviousRawTm = 0;

for i = 2:nRow
    if mWinLinearAccl(i,1) == mWinLinearAccl(i-1,1) || mWinLinearAccl(i,1) == fPreviousRawTm
        fPreviousRawTm = mWinLinearAccl(i,1);
        mWinLinearAccl(i,1) = mWinLinearAccl(i-1,1) + fMinTimeGap;
    end
end

mWinLinearAccl(:,1)