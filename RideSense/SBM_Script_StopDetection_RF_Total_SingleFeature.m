function f = SBM_Script_StopDetection_RF_Total_SingleFeature(mSelectedFeatures)
% SBM_Script_StopDetection_RF_Total
%     (2-11)fMagMeanLinearAccl,fMagMedianLinearAccl,fMagVarLinearAccl,fMagStdLinearAccl,fMagRangeLinearAccl,fMagMCRLinearAccl,fMagMADLinearAccl,fMagSkewLinearAccl,fMagRMSLinearAccl,fMagSMALinearAccl, ...
%     (12)fFreqMaxAmpLinearAccl, ...
%     (13-15)fFreqBucketEnergy5LinearAccl, fFreqBucketRMS5LinearAccl, fFreqMeanBucketAmp5LinearAccl, ...
%     (16-18)fFreqBucketEnergy10LinearAccl,fFreqBucketRMS10LinearAccl,fFreqMeanBucketAmp10LinearAccl, ...
%     (19-21)fFreqBucketEnergy20LinearAccl,fFreqBucketRMS20LinearAccl,fFreqMeanBucketAmp20LinearAccl, ...
%     (22-31)fMagMeanGyro,      fMagMedianGyro,      fMagVarGyro,      fMagStdGyro,      fMagRangeGyro,      fMagMCRGyro,      fMagMADGyro,      fMagSkewGyro,      fMagRMSGyro,      fMagSMAGyro, ...
%     (32)fFreqMaxAmpGyro, ...
%     (33-35)fFreqBucketEnergy5Gyro, fFreqBucketRMS5Gyro, fFreqMeanBucketAmp5Gyro, ...
%     (36-38)fFreqBucketEnergy10Gyro,fFreqBucketRMS10Gyro,fFreqMeanBucketAmp10Gyro, ...
%     (39-41)fFreqBucketEnergy20Gyro,fFreqBucketRMS20Gyro,fFreqMeanBucketAmp20Gyro, ...                    
%     (42-51)fMagMeanBaro,      fMagMedianBaro,      fMagVarBaro,      fMagStdBaro,      fMagRangeBaro,      fMagMCRBaro,      fMagMADBaro,      fMagSkewBaro,      fMagRMSBaro,      fMagSMABaro);

disp('Start Testing Stop Detection [with Random Forest].............');

sResultFile = 'E:\SensorMatching\Data\SchoolShuttle\TrainedModel\RF\Normal\RF_ResultSingleFeature.csv';
fidWrite = fopen(sResultFile, 'a');

mTreeNum = [20 50 100 200];
mPosition = [1 2 3 4 0];    %1: Ref, 2: Pocket, 3: Hand, 4: Pocket+Hand (Passenger),  0-All,  

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%mSelectedFeatures = [2 3 4 5 6 7 8 9 10 11 12 13 14 15];   % Start from 2

sLine = '';
for i = 1:length(mTreeNum)
    for j = 1:length(mPosition)
        fAccuracy = SBM_Script_StopDetection_RF(mSelectedFeatures, mTreeNum(i), mPosition(j));
        if j == 1
            if i == 1
                sLine = sprintf('%2.3f', fAccuracy);
            else
                sLine = sprintf('%s  %2.3f', sLine, fAccuracy);
            end
        elseif j == length(mPosition)
            sLine = sprintf('%s, %2.3f;   ', sLine, fAccuracy);
        else
            sLine = sprintf('%s, %2.3f', sLine, fAccuracy);
        end
    end
end

sLine = sprintf('%s  Feature Idx: [', sLine);
for k = 1:length(mSelectedFeatures)
    sLine = sprintf('%s %d', sLine, mSelectedFeatures(k));
end
sLine = sprintf('%s ]', sLine);

fprintf(fidWrite, '%s\n', sLine);

fclose(fidWrite);
return;

