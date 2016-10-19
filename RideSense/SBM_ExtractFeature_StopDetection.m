function f = SBM_ExtractFeature_StopDetection(sUniquedTmCrtTrace, fStartAfterTm, fStopBeforeTm, nIdxDataType)
% This function is used to extract features for Stop Detection
%  
% fStartAfterTm:  How much time at the beginning should be removed  (the
% data between these moments contains human motion)
% fStopBeforeTm:  How much time before the end should be removed (the data
% between these moments contains human motion)
%
% Get following Features and Ground Truth
%
%     (1-10)fMagMeanLinearAccl,fMagMedianLinearAccl,fMagVarLinearAccl,fMagStdLinearAccl,fMagRangeLinearAccl,fMagMCRLinearAccl,fMagMADLinearAccl,fMagSkewLinearAccl,fMagRMSLinearAccl,fMagSMALinearAccl, ...
%     (11)fFreqMaxAmpLinearAccl, ...
%     (12-14)fFreqBucketEnergy5LinearAccl, fFreqBucketRMS5LinearAccl, fFreqMeanBucketAmp5LinearAccl, ...
%     (15-17)fFreqBucketEnergy10LinearAccl,fFreqBucketRMS10LinearAccl,fFreqMeanBucketAmp10LinearAccl, ...
%     (18-20)fFreqBucketEnergy20LinearAccl,fFreqBucketRMS20LinearAccl,fFreqMeanBucketAmp20LinearAccl, ...
%     (21-30)fMagMeanGyro,      fMagMedianGyro,      fMagVarGyro,      fMagStdGyro,      fMagRangeGyro,      fMagMCRGyro,      fMagMADGyro,      fMagSkewGyro,      fMagRMSGyro,      fMagSMAGyro, ...
%     (31)fFreqMaxAmpGyro, ...
%     (32-34)fFreqBucketEnergy5Gyro, fFreqBucketRMS5Gyro, fFreqMeanBucketAmp5Gyro, ...
%     (35-37)fFreqBucketEnergy10Gyro,fFreqBucketRMS10Gyro,fFreqMeanBucketAmp10Gyro, ...
%     (38-40)fFreqBucketEnergy20Gyro,fFreqBucketRMS20Gyro,fFreqMeanBucketAmp20Gyro, ...                    
%     (41-50)fMagMeanBaro,      fMagMedianBaro,      fMagVarBaro,      fMagStdBaro,      fMagRangeBaro,      fMagMCRBaro,      fMagMADBaro,      fMagSkewBaro,      fMagRMSBaro,      fMagSMABaro);
% 
%
%
fprintf('Start Time: %s\n', datestr(clock, 'yyyy-mm-dd HH:MM:SS'));

format long;

fprintf('Processing....%s\n', sUniquedTmCrtTrace);
nFiltered = 1;

sMotionFeatureFilePostFix = 'SegMF_N';   % Motion Feature (N=Normal filter 100/200=0.5, 100 (/200), 15 (/30), no GPS gap between/after current window

[pathstr, filename, ext] = fileparts(sUniquedTmCrtTrace);
sResultSegMFFile = [pathstr '\' filename '_' sMotionFeatureFilePostFix '.csv'];
fidWriteMF = fopen(sResultSegMFFile, 'w');

mUniquedTmCrtTrace = load(sUniquedTmCrtTrace);

[nTotalRowCnt ~] = size(mUniquedTmCrtTrace);

fInitTime = mUniquedTmCrtTrace(1,1);
fLastTime = mUniquedTmCrtTrace(nTotalRowCnt,1);

nRealStartLine = 1;
nRealStopLine = nTotalRowCnt;

for i = 2:nTotalRowCnt
    if mUniquedTmCrtTrace(i,1) - fInitTime >= fStartAfterTm
        break;
    end
    
    nRealStartLine = i;
end

for i = nTotalRowCnt-1:-1:1
    if fLastTime - mUniquedTmCrtTrace(i,1) >= fStopBeforeTm
        break;
    end

    nRealStopLine = i;
end


mUniquedTmCrtTraceSelected = mUniquedTmCrtTrace(nRealStartLine:nRealStopLine, :);

if nFiltered   
    mCellMotionFiltered = SBM_PreprocessSensors(mUniquedTmCrtTraceSelected, nIdxDataType);

    mFilteredLinearAccl = mCellMotionFiltered{1};
    mFilteredGyro = mCellMotionFiltered{2};
    mFilteredBaro = mCellMotionFiltered{3};
end

% Replace back, i.e. replace the raw LinearAccl, Gyro, Baro with the
% filtered values
mUniquedTmCrtTraceReplaced = mUniquedTmCrtTraceSelected;

if nFiltered
    mUniquedTmCrtTraceReplaced((mUniquedTmCrtTraceReplaced(:,nIdxDataType) == 2),:) = mFilteredLinearAccl;
    mUniquedTmCrtTraceReplaced((mUniquedTmCrtTraceReplaced(:,nIdxDataType) == 3),:) = mFilteredGyro;
    mUniquedTmCrtTraceReplaced((mUniquedTmCrtTraceReplaced(:,nIdxDataType) == 7),:) = mFilteredBaro;
end

[nRowCnt ~] = size(mUniquedTmCrtTraceReplaced);

bOverlapping = 1;
fWindowSize = 1.0;  % seconds
fWindowStep = fWindowSize*0.5;  % If Non-overlapping, set this to fWindowSize

fLastMoment = mUniquedTmCrtTraceReplaced(nRowCnt,1);

% Window sensor data and calculate features
fWinBeginTm = mUniquedTmCrtTraceReplaced(1,1);
fWinEndTm = fWinBeginTm + fWindowSize;
nWinBeginLine = 1;

while fWinEndTm <= fLastMoment 
    nWinEndLine = SBM_GetLineNoWithinTime(mUniquedTmCrtTraceReplaced, nWinBeginLine, fWinEndTm);
    if nWinEndLine == -1
        break;
    end

    [IsQualified nGroundTruth] = SBM_IsQualifiedForStopFeature(mUniquedTmCrtTraceReplaced, nWinBeginLine, nWinEndLine, nIdxDataType);  % 1:  Stop, 0: Non-Stop
    
    if IsQualified == 1
        % Process sensor data within a window and extract features
        mWinSensor = mUniquedTmCrtTraceReplaced(nWinBeginLine:nWinEndLine, :);
        mWinLinearAccl = mWinSensor((mWinSensor(:,nIdxDataType) == 2),:);
        mWinGyro = mWinSensor((mWinSensor(:,nIdxDataType) == 3),:);
        mWinBaro = mWinSensor((mWinSensor(:,nIdxDataType) == 7),:);

        mWinLinearAcclFeature = SBM_GetWinLinearAcclFeature(mWinLinearAccl, nIdxDataType);
        mWinGyroFeature = SBM_GetWinGyroFeature(mWinGyro, nIdxDataType);
        mWinBaroFeature = SBM_GetWinBaroFeature(mWinBaro, nIdxDataType);

        if length(mWinLinearAcclFeature) > 0 && length(mWinGyroFeature) > 0 && length(mWinBaroFeature) > 0
            fMagMeanLinearAccl = mWinLinearAcclFeature(1);
            fMagMedianLinearAccl = mWinLinearAcclFeature(2);
            fMagVarLinearAccl = mWinLinearAcclFeature(3);
            fMagStdLinearAccl = mWinLinearAcclFeature(4);
            fMagRangeLinearAccl = mWinLinearAcclFeature(5);
            fMagMCRLinearAccl = mWinLinearAcclFeature(6);
            fMagMADLinearAccl = mWinLinearAcclFeature(7);
            fMagSkewLinearAccl = mWinLinearAcclFeature(8);
            fMagRMSLinearAccl = mWinLinearAcclFeature(9);
            fMagSMALinearAccl = mWinLinearAcclFeature(10);
            
            fFreqMaxAmpLinearAccl = mWinLinearAcclFeature(11);
            fFreqBucketEnergy5LinearAccl = mWinLinearAcclFeature(12);
            fFreqBucketRMS5LinearAccl = mWinLinearAcclFeature(13);
            fFreqMeanBucketAmp5LinearAccl = mWinLinearAcclFeature(14);
            fFreqBucketEnergy10LinearAccl = mWinLinearAcclFeature(15);
            fFreqBucketRMS10LinearAccl = mWinLinearAcclFeature(16);
            fFreqMeanBucketAmp10LinearAccl = mWinLinearAcclFeature(17);
            fFreqBucketEnergy20LinearAccl = mWinLinearAcclFeature(18);
            fFreqBucketRMS20LinearAccl = mWinLinearAcclFeature(19);
            fFreqMeanBucketAmp20LinearAccl = mWinLinearAcclFeature(20);
            
            fMagMeanGyro = mWinGyroFeature(1);
            fMagMedianGyro = mWinGyroFeature(2);
            fMagVarGyro = mWinGyroFeature(3);
            fMagStdGyro = mWinGyroFeature(4);
            fMagRangeGyro = mWinGyroFeature(5);
            fMagMCRGyro = mWinGyroFeature(6);
            fMagMADGyro = mWinGyroFeature(7);
            fMagSkewGyro = mWinGyroFeature(8);
            fMagRMSGyro = mWinGyroFeature(9);
            fMagSMAGyro = mWinGyroFeature(10);
            
            fFreqMaxAmpGyro = mWinGyroFeature(11);
            fFreqBucketEnergy5Gyro = mWinGyroFeature(12);
            fFreqBucketRMS5Gyro = mWinGyroFeature(13);
            fFreqMeanBucketAmp5Gyro = mWinGyroFeature(14);
            fFreqBucketEnergy10Gyro = mWinGyroFeature(15);
            fFreqBucketRMS10Gyro = mWinGyroFeature(16);
            fFreqMeanBucketAmp10Gyro = mWinGyroFeature(17);
            fFreqBucketEnergy20Gyro = mWinGyroFeature(18);
            fFreqBucketRMS20Gyro = mWinGyroFeature(19);
            fFreqMeanBucketAmp20Gyro = mWinGyroFeature(20);
                        
            fMagMeanBaro = mWinBaroFeature(1);
            fMagMedianBaro = mWinBaroFeature(2);
            fMagVarBaro = mWinBaroFeature(3);            
            fMagStdBaro = mWinBaroFeature(4);
            fMagRangeBaro = mWinBaroFeature(5);
            fMagMCRBaro = mWinBaroFeature(6);
            fMagMADBaro = mWinBaroFeature(7);
            fMagSkewBaro = mWinBaroFeature(8);
            fMagRMSBaro = mWinBaroFeature(9);
            fMagSMABaro = mWinBaroFeature(10);  

            fprintf(fidWriteMF, '%d, %4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,  %4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,  %4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f\n', nGroundTruth, ...
                    fMagMeanLinearAccl,fMagMedianLinearAccl,fMagVarLinearAccl,fMagStdLinearAccl,fMagRangeLinearAccl,fMagMCRLinearAccl,fMagMADLinearAccl,fMagSkewLinearAccl,fMagRMSLinearAccl,fMagSMALinearAccl, ...
                    fFreqMaxAmpLinearAccl, ...
                    fFreqBucketEnergy5LinearAccl, fFreqBucketRMS5LinearAccl, fFreqMeanBucketAmp5LinearAccl, ...
                    fFreqBucketEnergy10LinearAccl,fFreqBucketRMS10LinearAccl,fFreqMeanBucketAmp10LinearAccl, ...
                    fFreqBucketEnergy20LinearAccl,fFreqBucketRMS20LinearAccl,fFreqMeanBucketAmp20LinearAccl, ...
                    fMagMeanGyro,      fMagMedianGyro,      fMagVarGyro,      fMagStdGyro,      fMagRangeGyro,      fMagMCRGyro,      fMagMADGyro,      fMagSkewGyro,      fMagRMSGyro,      fMagSMAGyro, ...
                    fFreqMaxAmpGyro, ...
                    fFreqBucketEnergy5Gyro, fFreqBucketRMS5Gyro, fFreqMeanBucketAmp5Gyro, ...
                    fFreqBucketEnergy10Gyro,fFreqBucketRMS10Gyro,fFreqMeanBucketAmp10Gyro, ...
                    fFreqBucketEnergy20Gyro,fFreqBucketRMS20Gyro,fFreqMeanBucketAmp20Gyro, ...                    
                    fMagMeanBaro,      fMagMedianBaro,      fMagVarBaro,      fMagStdBaro,      fMagRangeBaro,      fMagMCRBaro,      fMagMADBaro,      fMagSkewBaro,      fMagRMSBaro,      fMagSMABaro);

        end
    end
    
    % Move Window
    fWinBeginTm = fWinBeginTm + fWindowStep;

    if fWinBeginTm >= fLastMoment
        break;
    end

    nWinBeginLine = SBM_GetLineNoBeyondTime(mUniquedTmCrtTraceReplaced, nWinBeginLine, fWinBeginTm);
    if nWinBeginLine == -1
        break;
    end

    fWinEndTm = fWinBeginTm + fWindowSize; 
end 


fclose(fidWriteMF);

fprintf('\nFinish Time: %s\n', datestr(clock, 'yyyy-mm-dd HH:MM:SS'));

return;

