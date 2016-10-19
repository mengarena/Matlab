% SBM_Script_StopDetection_SVM_Total
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

disp('Start Testing Stop Detection [with SVM].............');

sResultFile = 'E:\SensorMatching\Data\SchoolShuttle\TrainedModel\SVM\Normal\SVM_Result.csv';
fidWrite = fopen(sResultFile, 'a');

mPosition = [1 2 3 4 0];    %1: Ref, 2: Pocket, 3: Hand, 4: Pocket+Hand (Passenger),  0-All,  


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
mSelectedFeatures = [2 3 4 5 12 19 20 21 22 23 24 25 32 39 40 41];   % Start from 2

sLine = '';
for j = 1:length(mPosition)
    fAccuracy = SBM_Script_StopDetection_SVM(mSelectedFeatures, mPosition(j));
    if j == 1
        sLine = sprintf('%2.3f', fAccuracy);
    elseif j == length(mPosition)
        sLine = sprintf('%s, %2.3f;   ', sLine, fAccuracy);
    else
        sLine = sprintf('%s, %2.3f', sLine, fAccuracy);
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
mSelectedFeatures = [2 3 4 5 6 7 8 9 10 11 12 13 14 15];   % Start from 2

sLine = '';
for j = 1:length(mPosition)
    fAccuracy = SBM_Script_StopDetection_SVM(mSelectedFeatures, mPosition(j));
    if j == 1
        sLine = sprintf('%2.3f', fAccuracy);
    elseif j == length(mPosition)
        sLine = sprintf('%s, %2.3f;   ', sLine, fAccuracy);
    else
        sLine = sprintf('%s, %2.3f', sLine, fAccuracy);
    end
end

sLine = sprintf('%s  Feature Idx: [', sLine);
for k = 1:length(mSelectedFeatures)
    sLine = sprintf('%s %d', sLine, mSelectedFeatures(k));
end
sLine = sprintf('%s ]', sLine);

fprintf(fidWrite, '%s\n', sLine);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
mSelectedFeatures = [2 3 4 5 12 13 14 15];   % Start from 2

sLine = '';
for j = 1:length(mPosition)
    fAccuracy = SBM_Script_StopDetection_SVM(mSelectedFeatures, mPosition(j));
    if j == 1
        sLine = sprintf('%2.3f', fAccuracy);
    elseif j == length(mPosition)
        sLine = sprintf('%s, %2.3f;   ', sLine, fAccuracy);
    else
        sLine = sprintf('%s, %2.3f', sLine, fAccuracy);
    end
end

sLine = sprintf('%s  Feature Idx: [', sLine);
for k = 1:length(mSelectedFeatures)
    sLine = sprintf('%s %d', sLine, mSelectedFeatures(k));
end
sLine = sprintf('%s ]', sLine);

fprintf(fidWrite, '%s\n', sLine);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
mSelectedFeatures = [2 3 4 5 12 16 17 18];   % Start from 2

sLine = '';
for j = 1:length(mPosition)
    fAccuracy = SBM_Script_StopDetection_SVM(mSelectedFeatures, mPosition(j));
    if j == 1
        sLine = sprintf('%2.3f', fAccuracy);
    elseif j == length(mPosition)
        sLine = sprintf('%s, %2.3f;   ', sLine, fAccuracy);
    else
        sLine = sprintf('%s, %2.3f', sLine, fAccuracy);
    end
end

sLine = sprintf('%s  Feature Idx: [', sLine);
for k = 1:length(mSelectedFeatures)
    sLine = sprintf('%s %d', sLine, mSelectedFeatures(k));
end
sLine = sprintf('%s ]', sLine);

fprintf(fidWrite, '%s\n', sLine);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
mSelectedFeatures = [2 3 4 5 12 19 20 21];   % Start from 2

sLine = '';
for j = 1:length(mPosition)
    fAccuracy = SBM_Script_StopDetection_SVM(mSelectedFeatures, mPosition(j));
    if j == 1
        sLine = sprintf('%2.3f', fAccuracy);
    elseif j == length(mPosition)
        sLine = sprintf('%s, %2.3f;   ', sLine, fAccuracy);
    else
        sLine = sprintf('%s, %2.3f', sLine, fAccuracy);
    end
end

sLine = sprintf('%s  Feature Idx: [', sLine);
for k = 1:length(mSelectedFeatures)
    sLine = sprintf('%s %d', sLine, mSelectedFeatures(k));
end
sLine = sprintf('%s ]', sLine);

fprintf(fidWrite, '%s\n', sLine);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
mSelectedFeatures = [2 3 4 5 12];

sLine = '';
for j = 1:length(mPosition)
    fAccuracy = SBM_Script_StopDetection_SVM(mSelectedFeatures, mPosition(j));
    if j == 1
        sLine = sprintf('%2.3f', fAccuracy);
    elseif j == length(mPosition)
        sLine = sprintf('%s, %2.3f;   ', sLine, fAccuracy);
    else
        sLine = sprintf('%s, %2.3f', sLine, fAccuracy);
    end
end

sLine = sprintf('%s  Feature Idx: [', sLine);
for k = 1:length(mSelectedFeatures)
    sLine = sprintf('%s %d', sLine, mSelectedFeatures(k));
end
sLine = sprintf('%s ]', sLine);

fprintf(fidWrite, '%s\n', sLine);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
mSelectedFeatures = [2 3 4 5 12 22 23 24 25 32];

sLine = '';
for j = 1:length(mPosition)
    fAccuracy = SBM_Script_StopDetection_SVM(mSelectedFeatures, mPosition(j));
    if j == 1
        sLine = sprintf('%2.3f', fAccuracy);
    elseif j == length(mPosition)
        sLine = sprintf('%s, %2.3f;   ', sLine, fAccuracy);
    else
        sLine = sprintf('%s, %2.3f', sLine, fAccuracy);
    end
end

sLine = sprintf('%s  Feature Idx: [', sLine);
for k = 1:length(mSelectedFeatures)
    sLine = sprintf('%s %d', sLine, mSelectedFeatures(k));
end
sLine = sprintf('%s ]', sLine);

fprintf(fidWrite, '%s\n', sLine);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
mSelectedFeatures = [12 13 14 15];

sLine = '';
for j = 1:length(mPosition)
    fAccuracy = SBM_Script_StopDetection_SVM(mSelectedFeatures, mPosition(j));
    if j == 1
        sLine = sprintf('%2.3f', fAccuracy);
    elseif j == length(mPosition)
        sLine = sprintf('%s, %2.3f;   ', sLine, fAccuracy);
    else
        sLine = sprintf('%s, %2.3f', sLine, fAccuracy);
    end
end

sLine = sprintf('%s  Feature Idx: [', sLine);
for k = 1:length(mSelectedFeatures)
    sLine = sprintf('%s %d', sLine, mSelectedFeatures(k));
end
sLine = sprintf('%s ]', sLine);

fprintf(fidWrite, '%s\n', sLine);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
mSelectedFeatures = [12 16 17 18];

sLine = '';
for j = 1:length(mPosition)
    fAccuracy = SBM_Script_StopDetection_SVM(mSelectedFeatures, mPosition(j));
    if j == 1
        sLine = sprintf('%2.3f', fAccuracy);
    elseif j == length(mPosition)
        sLine = sprintf('%s, %2.3f;   ', sLine, fAccuracy);
    else
        sLine = sprintf('%s, %2.3f', sLine, fAccuracy);
    end
end

sLine = sprintf('%s  Feature Idx: [', sLine);
for k = 1:length(mSelectedFeatures)
    sLine = sprintf('%s %d', sLine, mSelectedFeatures(k));
end
sLine = sprintf('%s ]', sLine);

fprintf(fidWrite, '%s\n', sLine);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
mSelectedFeatures = [12 19 20 21];

sLine = '';
for j = 1:length(mPosition)
    fAccuracy = SBM_Script_StopDetection_SVM(mSelectedFeatures, mPosition(j));
    if j == 1
        sLine = sprintf('%2.3f', fAccuracy);
    elseif j == length(mPosition)
        sLine = sprintf('%s, %2.3f;   ', sLine, fAccuracy);
    else
        sLine = sprintf('%s, %2.3f', sLine, fAccuracy);
    end
end

sLine = sprintf('%s  Feature Idx: [', sLine);
for k = 1:length(mSelectedFeatures)
    sLine = sprintf('%s %d', sLine, mSelectedFeatures(k));
end
sLine = sprintf('%s ]', sLine);

fprintf(fidWrite, '%s\n', sLine);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
mSelectedFeatures = [2 3 4 5 22 23 24 25];

sLine = '';
for j = 1:length(mPosition)
    fAccuracy = SBM_Script_StopDetection_SVM(mSelectedFeatures, mPosition(j));
    if j == 1
        sLine = sprintf('%2.3f', fAccuracy);
    elseif j == length(mPosition)
        sLine = sprintf('%s, %2.3f;   ', sLine, fAccuracy);
    else
        sLine = sprintf('%s, %2.3f', sLine, fAccuracy);
    end
end

sLine = sprintf('%s  Feature Idx: [', sLine);
for k = 1:length(mSelectedFeatures)
    sLine = sprintf('%s %d', sLine, mSelectedFeatures(k));
end
sLine = sprintf('%s ]', sLine);

fprintf(fidWrite, '%s\n', sLine);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
mSelectedFeatures = [2 3 4 5 12 13 14 15 22 23 24 25 32 33 34 35];

sLine = '';
for j = 1:length(mPosition)
    fAccuracy = SBM_Script_StopDetection_SVM(mSelectedFeatures, mPosition(j));
    if j == 1
        sLine = sprintf('%2.3f', fAccuracy);
    elseif j == length(mPosition)
        sLine = sprintf('%s, %2.3f;   ', sLine, fAccuracy);
    else
        sLine = sprintf('%s, %2.3f', sLine, fAccuracy);
    end
end

sLine = sprintf('%s  Feature Idx: [', sLine);
for k = 1:length(mSelectedFeatures)
    sLine = sprintf('%s %d', sLine, mSelectedFeatures(k));
end
sLine = sprintf('%s ]', sLine);

fprintf(fidWrite, '%s\n', sLine);


fclose(fidWrite);


disp('>>>>>>>>>>>>>>Mission Accomplished!<<<<<<<<<<<<<<');

