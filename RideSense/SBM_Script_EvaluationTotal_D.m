% SBM_Script_EvaluationTotal_D

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

fprintf('Start Time: %s\n', datestr(clock, 'yyyy-mm-dd HH:MM:SS'));

disp('Evaluating......');

nUseFilter = 1;

mCellSelectedFeatures = [];

% Accl Time
mCellSelectedFeatures{1} = [1 2 3 4];
mCellSelectedFeatures{2} = [1 2 3 4 5 6 7 8 9 10];

% Accl Frequency
mCellSelectedFeatures{3} = [11 12 13 14];
mCellSelectedFeatures{4} = [11 15 16 17];
mCellSelectedFeatures{5} = [11 18 19 20];
mCellSelectedFeatures{6} = [11 12 13 14 15 16 17 18 19 20];

% Accl Time & Frequency
mCellSelectedFeatures{7} = [1 2 3 4 11 12 13 14];
mCellSelectedFeatures{8} = [1 2 3 4 5 6 7 8 9 10 11 12 13 14];
mCellSelectedFeatures{9} = [1 2 3 4 5 6 7 8 9 10 11 15 16 17];
mCellSelectedFeatures{10} = [1 2 3 4 5 6 7 8 9 10 11 18 19 20];

% Gyro Time
mCellSelectedFeatures{11} = [21 22 23 24];
mCellSelectedFeatures{12} = [21 22 23 24 25 26 27 28 29 30];

% Gyro Frequency
mCellSelectedFeatures{13} = [31 32 33 34];
mCellSelectedFeatures{14} = [31 35 36 37];
mCellSelectedFeatures{15} = [31 38 39 40];
mCellSelectedFeatures{16} = [31 32 33 34 35 36 37 38 39 40];

% Gyro Time & Frequency
mCellSelectedFeatures{17} = [21 22 23 24 31 32 33 34];
mCellSelectedFeatures{18} = [21 22 23 24 25 26 27 28 30 31 32 33 34];
mCellSelectedFeatures{19} = [21 22 23 24 25 26 27 28 30 31 35 36 37];
mCellSelectedFeatures{20} = [21 22 23 24 25 26 27 28 30 31 38 39 40];

% Baro
mCellSelectedFeatures{21} = [41 42 43 44];
mCellSelectedFeatures{22} = [41 42 43 44 45 46 47 48 49 50];

% Accl & Gyro
mCellSelectedFeatures{23} = [1 2 3 4 21 22 23 24];
mCellSelectedFeatures{24} = [1 2 3 4 5 6 7 8 10 21 22 23 24 25 26 27 28 30];
mCellSelectedFeatures{25} = [1 2 3 4 5 6 7 8 9 10 21 22 23 24 25 26 27 28 29 30];

mCellSelectedFeatures{26} = [11 12 13 14 31 32 33 34];
mCellSelectedFeatures{27} = [1 2 3 4 11 12 13 14 21 22 23 24 31 32 33 34];

mCellSelectedFeatures{28} = [1 2 3 4 11 18 19 20 21 22 23 24 31 38 39 40];  % Index starts from 1

% Accl % Baro
mCellSelectedFeatures{29} = [1 2 3 4 41 42 43 44];
mCellSelectedFeatures{30} = [1 2 3 4 5 6 7 8 10 41 42 43 44 45 46 47 48 50];
mCellSelectedFeatures{31} = [1 2 3 4 5 6 7 8 9 10 41 42 43 44 45 46 47 48 49 50];

mCellSelectedFeatures{32} = [11 12 13 14 41 42 43 44];
mCellSelectedFeatures{33} = [1 2 3 4 5 6 7 8 9 10 11 12 13 14 41 42 43 44 45 46 47 48 49 50];

% Gyro & Baro
mCellSelectedFeatures{34} = [21 22 23 24 41 42 43 44];
mCellSelectedFeatures{35} = [21 22 23 24 25 26 27 28 30 41 42 43 44 45 46 47 48 50];
mCellSelectedFeatures{36} = [21 22 23 24 25 26 27 28 29 30 41 42 43 44 45 46 47 48 49 50];

mCellSelectedFeatures{37} = [31 32 33 34 41 42 43 44];
mCellSelectedFeatures{38} = [21 22 23 24 25 26 27 28 29 30 31 32 33 34 41 42 43 44 45 46 47 48 49 50];

% Accl & Gyro & Baro
mCellSelectedFeatures{39} = [1 2 3 4 21 22 23 24 41 42 43 44];
mCellSelectedFeatures{40} = [1 2 3 4 5 6 7 8 9 10 21 22 23 24 25 26 27 28 29 30 41 42 43 44 45 46 47 48 49 50];
mCellSelectedFeatures{41} = [1 2 3 4 11 12 13 14 21 22 23 24 31 32 33 34 41 42 43 44];
mCellSelectedFeatures{42} = [1 2 3 4 11 15 16 17 21 22 23 24 31 35 36 37 41 42 43 44];
mCellSelectedFeatures{43} = [1 2 3 4 11 18 19 20 21 22 23 24 31 38 39 40 41 42 43 44];
mCellSelectedFeatures{44} = [1 2 3 4 5 6 7 8 9 10 11 12 13 14 21 22 23 24 25 26 27 28 29 30 31 32 33 34 41 42 43 44 45 46 47 48 49 50];

mCellSelectedFeatures{45} = [41];   % Baro only

% Accl & Gyro
mCellSelectedFeatures{46} = [1 2 3 4 5 6 7 8 9 10 11 12 13 14 21 22 23 24 25 26 27 28 29 30 31 32 33 34];


for i = 37:length(mCellSelectedFeatures)
%for i = 22:22

    fprintf('Evaluating Feature Set [%d]......\n', i);
    mSelectedFeatures = mCellSelectedFeatures{i};
    SBM_Evaluation(mSelectedFeatures, nUseFilter);
end

fprintf('\nFinish Time: %s\n', datestr(clock, 'yyyy-mm-dd HH:MM:SS'));

disp('>>>>>>>>>>>>>>DONE<<<<<<<<<<<<<<');
