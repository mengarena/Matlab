function f=Sky_tmpGetList(nSmallPktCnt, nodeID)

sInputFile = 'C:\\cygwin\\home\\meng\\ns-allinone-2.34\\ns-2.34\\Dense_sp_Trace\\SkyEye_Dense_80_2048_5_0.csv';

format long;

mTrace = load(sInputFile);

[nRow nCol] = size(mTrace);

nTmpCnt = 0;

tmpTm = [];
nIdx = 0;

for i=1:nRow
%    if mTrace(i,3) == nodeID && mTrace(i,1) == 1 && mTrace(i,5) == 2048
    if mTrace(i,3) == nodeID && mTrace(i,1) == 1
        if mTrace(i,5) == 2048
            nTmpCnt = nTmpCnt + 1;
            if nTmpCnt == 1
                %disp(strcat(num2str(mTrace(i,1)), ',', num2str(mTrace(i,2)), ',', num2str(mTrace(i,3)), ',', num2str(mTrace(i,4)), ',', num2str(mTrace(i,5))));
                nIdx = nIdx + 1;
                tmpTm(1,nIdx) = mTrace(i,2);
            end
    
            if nTmpCnt == nSmallPktCnt
                nTmpCnt = 0;
            end
        else
            %disp(strcat(num2str(mTrace(i,1)), ',', num2str(mTrace(i,2)), ',', num2str(mTrace(i,3)), ',', num2str(mTrace(i,4)), ',', num2str(mTrace(i,5))));
            nTmpCnt = 0;
        end
    end
end

tmpTmGap = [];

for i=2:nIdx
    tmpTmGap(i,1) = tmpTm(1,i) - tmpTm(1,i-1);
end

plot(tmpTmGap(:),'r*');


