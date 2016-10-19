function f = VT_CorrectDivideTime(nHighway, nDense)


format long;


if nHighway == 1
    fCorrectStartTime = 200.0;
    fEndTime = 2000.0;
else
    fCorrectStartTime = 460.0;
    fEndTime = 1010.0;
end

fWrongTotalTime = fEndTime - 290.0;

fCorrectTotalTime = fEndTime - fCorrectStartTime;

fRatio = fWrongTotalTime/fCorrectTotalTime;

if nHighway == 1
    mTransRange = [60 80 100];
    sPlace = 'E:\\USC_Project\\Vehicle_Talk\\ForCorrection\\VT_Highway_Output\\Meng_NonFixedImgCnt\\';
else
    mTransRange = [40 60 80];
    sPlace = 'E:\\USC_Project\\Vehicle_Talk\\ForCorrection\\VT_City_Output\\Meng_NonFixedImgCnt\\';
end    

nSmallPktSize = 1024;

mImgSize = [10 12 14 16 18];

if nDense == 1
    sOrgFilePre = 'Dense_sp_RcvEventStats\\Dense_RcvEventStats';
    sCorrectedFilePre = 'Dense_sp_RcvEventStats_Corrected\\Dense_RcvEventStats';
else
    sOrgFilePre = 'Sparse_sp_RcvEventStats\\Sparse_RcvEventStats';
    sCorrectedFilePre = 'Sparse_sp_RcvEventStats_Corrected\\Sparse_RcvEventStats';
end

nRangeCount = length(mTransRange);
nImgCount = length(mImgSize);


for i = 1:nRangeCount
    nRange = mTransRange(1,i);
    
    for j = 1:nImgCount
        nImgSize = mImgSize(1,j);
        
        sOrgFile = sprintf('%s%s_%s_%s_0.csv', sPlace, sOrgFilePre, num2str(nRange),num2str(nImgSize));
        mOrg = load(sOrgFile);
        
        sCorrectedFile = sprintf('%s%s_%s_%s_0.csv', sPlace, sCorrectedFilePre, num2str(nRange),num2str(nImgSize));
        fidCorrected = fopen(sCorrectedFile, 'w');
        
        fCorrectAvg = mOrg(1, 4)*fRatio;
        fCorrectStd = mOrg(1, 5)*fRatio;
        fCorrectMax = mOrg(1, 6)*fRatio;
        fCorrectMin = mOrg(1, 7)*fRatio;
        
        fprintf(fidCorrected, '%d,%d,%d,%f,%f,%f,%f,%d\n', mOrg(1,1), mOrg(1,2), mOrg(1,3), fCorrectAvg, fCorrectStd, fCorrectMax, fCorrectMin, mOrg(1,8));
        
        fclose(fidCorrected);
            
    end
    
end


f = 0;

return;