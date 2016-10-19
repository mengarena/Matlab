function f = SBM_Script_EvaluationTotal_PCA_Param(startIdx, endIdx)

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
mCellSelectedFeatures{3} = [1 2 3 4 51 52 53 53 55 56];
mCellSelectedFeatures{4} = [1 2 3 4 5 6 7 8 9 10 51 52 53 53 55 56];

% Accl Frequency
mCellSelectedFeatures{5} = [11 12 13 14];
mCellSelectedFeatures{6} = [11 15 16 17];
mCellSelectedFeatures{7} = [11 18 19 20];
mCellSelectedFeatures{8} = [11 12 13 14 15 16 17 18 19 20];

% Accl Time & Frequency
mCellSelectedFeatures{9} = [1 2 3 4 11 12 13 14];
mCellSelectedFeatures{10} = [1 2 3 4 5 6 7 8 9 10 11 12 13 14];
mCellSelectedFeatures{11} = [1 2 3 4 5 6 7 8 9 10 11 15 16 17];
mCellSelectedFeatures{12} = [1 2 3 4 5 6 7 8 9 10 11 18 19 20];
mCellSelectedFeatures{13} = [1 2 3 4 5 6 7 8 9 10 51 52 53 53 55 56 11 12 13 14];


% Gyro Time
mCellSelectedFeatures{14} = [21 22 23 24];
mCellSelectedFeatures{15} = [21 22 23 24 57 58 59 60 61 62];
mCellSelectedFeatures{16} = [21 22 23 24 25 26 27 28 29 30];
mCellSelectedFeatures{17} = [21 22 23 24 25 26 27 28 29 30 57 58 59 60 61 62];

% Gyro Frequency
mCellSelectedFeatures{18} = [31 32 33 34];
mCellSelectedFeatures{19} = [31 35 36 37];
mCellSelectedFeatures{20} = [31 38 39 40];
mCellSelectedFeatures{21} = [31 32 33 34 35 36 37 38 39 40];

% Gyro Time & Frequency
mCellSelectedFeatures{22} = [21 22 23 24 31 32 33 34];
mCellSelectedFeatures{23} = [21 22 23 24 25 26 27 28 29 30 31 32 33 34];
mCellSelectedFeatures{24} = [21 22 23 24 25 26 27 28 29 30 31 35 36 37];
mCellSelectedFeatures{25} = [21 22 23 24 25 26 27 28 29 30 31 38 39 40];
mCellSelectedFeatures{26} = [21 22 23 24 25 26 27 28 29 30 57 58 59 60 61 62 31 32 33 34];

% Accl & Gyro (Time)
mCellSelectedFeatures{27} = [1 2 3 4 21 22 23 24];
mCellSelectedFeatures{28} = [1 2 3 4 5 6 7 8 10 21 22 23 24 25 26 27 28 30];
mCellSelectedFeatures{29} = [1 2 3 4 5 6 7 8 9 10 21 22 23 24 25 26 27 28 29 30];
mCellSelectedFeatures{30} = [1 2 3 4 5 6 7 8 9 10 51 52 53 53 55 56 21 22 23 24 25 26 27 28 29 30 57 58 59 60 61 62];  % All time features

mCellSelectedFeatures{31} = [11 12 13 14 31 32 33 34];   % Freequency
mCellSelectedFeatures{32} = [1 2 3 4 11 12 13 14 21 22 23 24 31 32 33 34];   % Time & Freequency
mCellSelectedFeatures{33} = [1 2 3 4 51 52 53 53 55 56 11 12 13 14 21 22 23 24 57 58 59 60 61 62 31 32 33 34];   % Time & Freequency

mCellSelectedFeatures{34} = [1 2 3 4 11 18 19 20 21 22 23 24 31 38 39 40];  % Index starts from 1

% Accl & Gyro
mCellSelectedFeatures{35} = [1 2 3 4 5 6 7 8 9 10 11 12 13 14 21 22 23 24 25 26 27 28 29 30 31 32 33 34];
mCellSelectedFeatures{36} = [1 2 3 4 5 6 7 8 9 10 51 52 53 53 55 56 11 12 13 14 21 22 23 24 25 26 27 28 29 30 57 58 59 60 61 62 31 32 33 34];  % All time plus some frequency

% Baro
mCellSelectedFeatures{37} = [41];  % Baro only

mCellSelectedFeatures{38} = [41 42 43 44];
mCellSelectedFeatures{39} = [41 42 43 44 45 46 47 48 49 50];
mCellSelectedFeatures{40} = [41 42 43 44 45 46 47 48 49 50 63 64 65 66 67];


% Accl % Baro
mCellSelectedFeatures{41} = [1 2 3 4 41 42 43 44];
mCellSelectedFeatures{42} = [1 2 3 4 5 6 7 8 10 41 42 43 44 45 46 47 48 50];
mCellSelectedFeatures{43} = [1 2 3 4 5 6 7 8 9 10 41 42 43 44 45 46 47 48 49 50];
mCellSelectedFeatures{44} = [1 2 3 4 5 6 7 8 9 10 51 52 53 53 55 56 41 42 43 44 45 46 47 48 49 50 63 64 65 66 67];  % All time features

mCellSelectedFeatures{45} = [11 12 13 14 41 42 43 44];
mCellSelectedFeatures{46} = [1 2 3 4 5 6 7 8 9 10 11 12 13 14 41 42 43 44 45 46 47 48 49 50];

% Gyro & Baro
mCellSelectedFeatures{47} = [21 22 23 24 41 42 43 44];
mCellSelectedFeatures{48} = [21 22 23 24 25 26 27 28 30 41 42 43 44 45 46 47 48 50];
mCellSelectedFeatures{49} = [21 22 23 24 25 26 27 28 29 30 41 42 43 44 45 46 47 48 49 50];

mCellSelectedFeatures{50} = [31 32 33 34 41 42 43 44];
mCellSelectedFeatures{51} = [21 22 23 24 25 26 27 28 29 30 31 32 33 34 41 42 43 44 45 46 47 48 49 50];

% Accl & Gyro & Baro
mCellSelectedFeatures{52} = [1 2 3 4 21 22 23 24 41 42 43 44];
mCellSelectedFeatures{53} = [1 2 3 4 5 6 7 8 9 10 21 22 23 24 25 26 27 28 29 30 41 42 43 44 45 46 47 48 49 50];
mCellSelectedFeatures{54} = [1 2 3 4 5 6 7 8 9 10 51 52 53 53 55 56 21 22 23 24 25 26 27 28 29 30 57 58 59 60 61 62 41 42 43 44 45 46 47 48 49 50  63 64 65 66 67];
mCellSelectedFeatures{55} = [1 2 3 4 11 12 13 14 21 22 23 24 31 32 33 34 41 42 43 44];
mCellSelectedFeatures{56} = [1 2 3 4 11 15 16 17 21 22 23 24 31 35 36 37 41 42 43 44];
mCellSelectedFeatures{57} = [1 2 3 4 11 18 19 20 21 22 23 24 31 38 39 40 41 42 43 44];
mCellSelectedFeatures{58} = [1 2 3 4 5 6 7 8 9 10 11 12 13 14 21 22 23 24 25 26 27 28 29 30 31 32 33 34 41 42 43 44 45 46 47 48 49 50];

% ================here below PCA features==================
% Accl Time
mCellSelectedFeatures{59} = [68 69 70 71];
mCellSelectedFeatures{60} = [68 69 70 71 72 73 74 75 76 77];
mCellSelectedFeatures{61} = [68 69 70 71 72 73 74 75 76 77 108 109 110  112 113];

% Accl Frequency
mCellSelectedFeatures{62} = [78 79 80 81];
mCellSelectedFeatures{63} = [78 82 83 84];
mCellSelectedFeatures{64} = [78 85 86 87];
mCellSelectedFeatures{65} = [78 79 80 81 82 83 84 85 86 87];


% Accl Time + Frequency
mCellSelectedFeatures{66} = [68 69 70 71 78 79 80 81];
mCellSelectedFeatures{67} = [68 69 70 71 72 73 74 75 76 77 78 79 80 81];
mCellSelectedFeatures{68} = [68 69 70 71 72 73 74 75 76 77 108 109 110  112 113 78 79 80 81];
mCellSelectedFeatures{69} = [68 69 70 71 72 73 74 75 76 77 108 109 110  112 113 78 79 80 81 82 83 84 85 86 87];


% Gyro Time
mCellSelectedFeatures{70} = [88 89 90 91];
mCellSelectedFeatures{71} = [88 89 90 91 92 93 94 95 96 97];
mCellSelectedFeatures{72} = [88 89 90 91 92 93 94 95 96 97 114 115 116  118 119];


% Gyro Frequency
mCellSelectedFeatures{73} = [98 99 100 101];
mCellSelectedFeatures{74} = [98 102 103 104];
mCellSelectedFeatures{75} = [98 105 106 107];
mCellSelectedFeatures{76} = [98 99 100 101 102 103 104 105 106 107];

% Gyro Time + Frequency
mCellSelectedFeatures{77} = [88 89 90 91 98 99 100 101];
mCellSelectedFeatures{78} = [88 89 90 91 92 93 94 95 96 97 98 99 100 101];
mCellSelectedFeatures{79} = [88 89 90 91 92 93 94 95 96 97 114 115 116  118 119 98 99 100 101];
mCellSelectedFeatures{80} = [88 89 90 91 92 93 94 95 96 97 114 115 116  118 119 98 99 100 101 102 103 104 105 106 107];


% PCA Accl + PCA Gyro Time
mCellSelectedFeatures{81} = [68 69 70 71 88 89 90 91];
mCellSelectedFeatures{82} = [68 69 70 71 72 73 74 75 76 77 88 89 90 91 92 93 94 95 96 97];
mCellSelectedFeatures{83} = [68 69 70 71 72 73 74 75 76 77 108 109 110  112 113 88 89 90 91 92 93 94 95 96 97 114 115 116  118 119];

% PCA Accl + PCA Gyro Time + Frequency
mCellSelectedFeatures{84} = [68 69 70 71 88 89 90 91 78 79 80 81 82 83 84 85 86 87 98 99 100 101 102 103 104 105 106 107];
mCellSelectedFeatures{85} = [68 69 70 71 72 73 74 75 76 77 88 89 90 91 92 93 94 95 96 97 78 79 80 81 82 83 84 85 86 87 98 99 100 101 102 103 104 105 106 107];
mCellSelectedFeatures{86} = [68 69 70 71 72 73 74 75 76 77 108 109 110  112 113 88 89 90 91 92 93 94 95 96 97 114 115 116  118 119 78 79 80 81 82 83 84 85 86 87 98 99 100 101 102 103 104 105 106 107];


% PCA Accl + PCA Gyro + Baro Time
mCellSelectedFeatures{87} = [68 69 70 71 88 89 90 91 41 42 43 44 45 46 47 48 49 50 63 64 65 66 67];
mCellSelectedFeatures{88} = [68 69 70 71 72 73 74 75 76 77 88 89 90 91 92 93 94 95 96 97 41 42 43 44 45 46 47 48 49 50 63 64 65 66 67];
mCellSelectedFeatures{89} = [68 69 70 71 72 73 74 75 76 77 108 109 110  112 113 88 89 90 91 92 93 94 95 96 97 114 115 116  118 119 41 42 43 44 45 46 47 48 49 50 63 64 65 66 67];

% PCA Accl + PCA Gyro + Baro Time + Frequency
mCellSelectedFeatures{90} = [68 69 70 71 88 89 90 91 78 79 80 81 82 83 84 85 86 87 98 99 100 101 102 103 104 105 106 107 41 42 43 44 45 46 47 48 49 50 63 64 65 66 67];
mCellSelectedFeatures{91} = [68 69 70 71 72 73 74 75 76 77 88 89 90 91 92 93 94 95 96 97 78 79 80 81 82 83 84 85 86 87 98 99 100 101 102 103 104 105 106 107 41 42 43 44 45 46 47 48 49 50 63 64 65 66 67];
mCellSelectedFeatures{92} = [68 69 70 71 72 73 74 75 76 77 108 109 110  112 113 88 89 90 91 92 93 94 95 96 97 114 115 116  118 119 78 79 80 81 82 83 84 85 86 87 98 99 100 101 102 103 104 105 106 107 41 42 43 44 45 46 47 48 49 50 63 64 65 66 67];

%here below RAW (filter) + PCA features

% Raw Accl + PCA Accl Time
mCellSelectedFeatures{93} = [1 2 3 4 68 69 70 71];   
mCellSelectedFeatures{94} = [1 2 3 4 5 6 7 8 9 10 68 69 70 71 72 73 74 75 76 77];
mCellSelectedFeatures{95} = [1 2 3 4 5 6 7 8 9 10 51 52 53 53 55 56 68 69 70 71 72 73 74 75 76 77 108 109 110  112 113];


% Raw Accl + PCA Accl Frequency
mCellSelectedFeatures{96} = [11 12 13 14 78 79 80 81];
mCellSelectedFeatures{97} = [11 15 16 17 78 82 83 84];
mCellSelectedFeatures{98} = [11 18 19 20 78 85 86 87];
mCellSelectedFeatures{99} = [11 12 13 14 15 16 17 18 19 20 78 79 80 81 82 83 84 85 86 87];

% Raw Accl + PCA Accl Time + Frequency
mCellSelectedFeatures{100} = [1 2 3 4 68 69 70 71 11 12 13 14 78 79 80 81];  
mCellSelectedFeatures{101} = [1 2 3 4 5 6 7 8 9 10 68 69 70 71 72 73 74 75 76 77 11 12 13 14 78 79 80 81];
mCellSelectedFeatures{102} = [1 2 3 4 5 6 7 8 9 10 51 52 53 53 55 56 68 69 70 71 72 73 74 75 76 77 108 109 110  112 113 11 12 13 14 78 79 80 81];


% Raw Gyro + PCA Gyro Time
mCellSelectedFeatures{103} = [21 22 23 24 88 89 90 91];
mCellSelectedFeatures{104} = [21 22 23 24 25 26 27 28 29 30 88 89 90 91 92 93 94 95 96 97];
mCellSelectedFeatures{105} = [21 22 23 24 25 26 27 28 29 30 57 58 59 60 61 62 88 89 90 91 92 93 94 95 96 97 114 115 116  118 119];

% Raw Gyro + PCA Gyro Frequency
mCellSelectedFeatures{106} = [31 32 33 34 98 99 100 101];
mCellSelectedFeatures{107} = [31 35 36 37 98 102 103 104];
mCellSelectedFeatures{108} = [31 38 39 40 98 105 106 107];
mCellSelectedFeatures{109} = [31 32 33 34 35 36 37 38 39 40 98 99 100 101 102 103 104 105 106 107];

% Raw Gyro + PCA Gyro Time + Frequency
mCellSelectedFeatures{110} = [21 22 23 24 88 89 90 91 31 32 33 34 98 99 100 101];
mCellSelectedFeatures{111} = [21 22 23 24 25 26 27 28 29 30 88 89 90 91 92 93 94 95 96 97 31 32 33 34 98 99 100 101];
mCellSelectedFeatures{112} = [21 22 23 24 25 26 27 28 29 30 57 58 59 60 61 62 88 89 90 91 92 93 94 95 96 97 114 115 116  118 119 31 32 33 34 98 99 100 101];


% Raw Accl + PCA Accl + Raw Gyro + PCA Gyro Time
mCellSelectedFeatures{113} = [1 2 3 4 68 69 70 71 21 22 23 24 88 89 90 91]; 
mCellSelectedFeatures{114} = [1 2 3 4 5 6 7 8 9 10 68 69 70 71 72 73 74 75 76 77 21 22 23 24 25 26 27 28 29 30 88 89 90 91 92 93 94 95 96 97];
mCellSelectedFeatures{115} = [1 2 3 4 5 6 7 8 9 10 51 52 53 53 55 56 68 69 70 71 72 73 74 75 76 77 108 109 110  112 113 21 22 23 24 25 26 27 28 29 30 57 58 59 60 61 62 88 89 90 91 92 93 94 95 96 97 114 115 116  118 119];

% Raw Accl + PCA Accl + Raw Gyro + PCA Gyro Frequency
mCellSelectedFeatures{116} = [11 12 13 14 78 79 80 81 31 32 33 34 98 99 100 101];
mCellSelectedFeatures{117} = [11 15 16 17 78 82 83 84 31 35 36 37 98 102 103 104];
mCellSelectedFeatures{118} = [11 18 19 20 78 85 86 87 31 38 39 40 98 105 106 107];
mCellSelectedFeatures{119} = [11 12 13 14 15 16 17 18 19 20 78 79 80 81 82 83 84 85 86 87 31 32 33 34 35 36 37 38 39 40 98 99 100 101 102 103 104 105 106 107];

% Raw Accl + PCA Accl + Raw Gyro + PCA Gyro Time + Frequency
mCellSelectedFeatures{120} = [1 2 3 4 68 69 70 71 21 22 23 24 88 89 90 91 11 12 13 14 78 79 80 81 31 32 33 34 98 99 100 101]; 
mCellSelectedFeatures{121} = [1 2 3 4 5 6 7 8 9 10 68 69 70 71 72 73 74 75 76 77 21 22 23 24 25 26 27 28 29 30 88 89 90 91 92 93 94 95 96 97 11 12 13 14 78 79 80 81 31 32 33 34 98 99 100 101];
mCellSelectedFeatures{122} = [1 2 3 4 5 6 7 8 9 10 51 52 53 53 55 56 68 69 70 71 72 73 74 75 76 77 108 109 110  112 113 21 22 23 24 25 26 27 28 29 30 57 58 59 60 61 62 88 89 90 91 92 93 94 95 96 97 114 115 116  118 119 11 12 13 14 78 79 80 81 31 32 33 34 98 99 100 101];

% Raw Accl + PCA Accl + Raw Gyro + PCA Gyro + Baro Time
mCellSelectedFeatures{123} = [1 2 3 4 68 69 70 71 21 22 23 24 88 89 90 91 41 42 43 44 45 46 47 48 49 50 63 64 65 66 67]; 
mCellSelectedFeatures{124} = [1 2 3 4 5 6 7 8 9 10 68 69 70 71 72 73 74 75 76 77 21 22 23 24 25 26 27 28 29 30 88 89 90 91 92 93 94 95 96 97 41 42 43 44 45 46 47 48 49 50 63 64 65 66 67];
mCellSelectedFeatures{125} = [1 2 3 4 5 6 7 8 9 10 51 52 53 53 55 56 68 69 70 71 72 73 74 75 76 77 108 109 110  112 113 21 22 23 24 25 26 27 28 29 30 57 58 59 60 61 62 88 89 90 91 92 93 94 95 96 97 114 115 116  118 119 41 42 43 44 45 46 47 48 49 50 63 64 65 66 67];

% Raw Accl + PCA Accl + Raw Gyro + PCA Gyro + Baro Time + Fruquency
mCellSelectedFeatures{126} = [1 2 3 4 68 69 70 71 21 22 23 24 88 89 90 91 11 12 13 14 78 79 80 81 31 32 33 34 98 99 100 101 41 42 43 44 45 46 47 48 49 50 63 64 65 66 67]; 
mCellSelectedFeatures{127} = [1 2 3 4 5 6 7 8 9 10 68 69 70 71 72 73 74 75 76 77 21 22 23 24 25 26 27 28 29 30 88 89 90 91 92 93 94 95 96 97 11 12 13 14 78 79 80 81 31 32 33 34 98 99 100 101 41 42 43 44 45 46 47 48 49 50 63 64 65 66 67];
mCellSelectedFeatures{128} = [1 2 3 4 5 6 7 8 9 10 51 52 53 53 55 56 68 69 70 71 72 73 74 75 76 77 108 109 110  112 113 21 22 23 24 25 26 27 28 29 30 57 58 59 60 61 62 88 89 90 91 92 93 94 95 96 97 114 115 116  118 119 11 12 13 14 78 79 80 81 31 32 33 34 98 99 100 101 41 42 43 44 45 46 47 48 49 50 63 64 65 66 67];


% === Add on 2016/04/30, for PCA2 ==========================
% Accl Time
mCellSelectedFeatures{59} = [68 69 70 71 120 121 122 123];
mCellSelectedFeatures{60} = [68 69 70 71 72 73 74 75 76 77   120 121 122 123 124 125 126 127 128 129];
mCellSelectedFeatures{61} = [68 69 70 71 72 73 74 75 76 77 108 109 110 112 113   120 121 122 123 124 125 126 127 128 129  160 161 162 164 165];

% Accl Frequency
mCellSelectedFeatures{62} = [78 79 80 81   130 131 132 133];
mCellSelectedFeatures{63} = [78 82 83 84   130 134 135 136];
mCellSelectedFeatures{64} = [78 85 86 87   130 137 138 139];
mCellSelectedFeatures{65} = [78 79 80 81 82 83 84 85 86 87   130 131 132 133 134 135 136 137 138 139];


% Accl Time + Frequency
mCellSelectedFeatures{66} = [68 69 70 71 78 79 80 81  120 121 122 123 130 131 132 133];
mCellSelectedFeatures{67} = [68 69 70 71 72 73 74 75 76 77 78 79 80 81   120 121 122 123 124 125 126 127 128 129 130 131 132 133];
mCellSelectedFeatures{68} = [68 69 70 71 72 73 74 75 76 77 108 109 110  112 113 78 79 80 81       120 121 122 123 124 125 126 127 128 129  160 161 162 164 165   130 131 132 133];
mCellSelectedFeatures{69} = [68 69 70 71 72 73 74 75 76 77 108 109 110  112 113 78 79 80 81 82 83 84 85 86 87  120 121 122 123 124 125 126 127 128 129  160 161 162 164 165   130 131 132 133 134 135 136 137 138 139];


% Gyro Time
mCellSelectedFeatures{70} = [88 89 90 91];
mCellSelectedFeatures{71} = [88 89 90 91 92 93 94 95 96 97];
mCellSelectedFeatures{72} = [88 89 90 91 92 93 94 95 96 97 114 115 116  118 119];


% Gyro Frequency
mCellSelectedFeatures{73} = [98 99 100 101];
mCellSelectedFeatures{74} = [98 102 103 104];
mCellSelectedFeatures{75} = [98 105 106 107];
mCellSelectedFeatures{76} = [98 99 100 101 102 103 104 105 106 107];

% Gyro Time + Frequency
mCellSelectedFeatures{77} = [88 89 90 91 98 99 100 101];
mCellSelectedFeatures{78} = [88 89 90 91 92 93 94 95 96 97 98 99 100 101];
mCellSelectedFeatures{79} = [88 89 90 91 92 93 94 95 96 97 114 115 116  118 119 98 99 100 101];
mCellSelectedFeatures{80} = [88 89 90 91 92 93 94 95 96 97 114 115 116  118 119 98 99 100 101 102 103 104 105 106 107];


% PCA Accl + PCA Gyro Time
mCellSelectedFeatures{81} = [68 69 70 71 88 89 90 91];
mCellSelectedFeatures{82} = [68 69 70 71 72 73 74 75 76 77 88 89 90 91 92 93 94 95 96 97];
mCellSelectedFeatures{83} = [68 69 70 71 72 73 74 75 76 77 108 109 110  112 113 88 89 90 91 92 93 94 95 96 97 114 115 116  118 119];

% PCA Accl + PCA Gyro Time + Frequency
mCellSelectedFeatures{84} = [68 69 70 71 88 89 90 91 78 79 80 81 82 83 84 85 86 87 98 99 100 101 102 103 104 105 106 107];
mCellSelectedFeatures{85} = [68 69 70 71 72 73 74 75 76 77 88 89 90 91 92 93 94 95 96 97 78 79 80 81 82 83 84 85 86 87 98 99 100 101 102 103 104 105 106 107];
mCellSelectedFeatures{86} = [68 69 70 71 72 73 74 75 76 77 108 109 110  112 113 88 89 90 91 92 93 94 95 96 97 114 115 116  118 119 78 79 80 81 82 83 84 85 86 87 98 99 100 101 102 103 104 105 106 107];


% PCA Accl + PCA Gyro + Baro Time
mCellSelectedFeatures{87} = [68 69 70 71 88 89 90 91 41 42 43 44 45 46 47 48 49 50 63 64 65 66 67];
mCellSelectedFeatures{88} = [68 69 70 71 72 73 74 75 76 77 88 89 90 91 92 93 94 95 96 97 41 42 43 44 45 46 47 48 49 50 63 64 65 66 67];
mCellSelectedFeatures{89} = [68 69 70 71 72 73 74 75 76 77 108 109 110  112 113 88 89 90 91 92 93 94 95 96 97 114 115 116  118 119 41 42 43 44 45 46 47 48 49 50 63 64 65 66 67];

% PCA Accl + PCA Gyro + Baro Time + Frequency
mCellSelectedFeatures{90} = [68 69 70 71 88 89 90 91 78 79 80 81 82 83 84 85 86 87 98 99 100 101 102 103 104 105 106 107 41 42 43 44 45 46 47 48 49 50 63 64 65 66 67];
mCellSelectedFeatures{91} = [68 69 70 71 72 73 74 75 76 77 88 89 90 91 92 93 94 95 96 97 78 79 80 81 82 83 84 85 86 87 98 99 100 101 102 103 104 105 106 107 41 42 43 44 45 46 47 48 49 50 63 64 65 66 67];
mCellSelectedFeatures{92} = [68 69 70 71 72 73 74 75 76 77 108 109 110  112 113 88 89 90 91 92 93 94 95 96 97 114 115 116  118 119 78 79 80 81 82 83 84 85 86 87 98 99 100 101 102 103 104 105 106 107 41 42 43 44 45 46 47 48 49 50 63 64 65 66 67];

%here below RAW (filter) + PCA features

% Raw Accl + PCA Accl Time
mCellSelectedFeatures{93} = [1 2 3 4 68 69 70 71];   
mCellSelectedFeatures{94} = [1 2 3 4 5 6 7 8 9 10 68 69 70 71 72 73 74 75 76 77];
mCellSelectedFeatures{95} = [1 2 3 4 5 6 7 8 9 10 51 52 53 53 55 56 68 69 70 71 72 73 74 75 76 77 108 109 110  112 113];


% Raw Accl + PCA Accl Frequency
mCellSelectedFeatures{96} = [11 12 13 14 78 79 80 81];
mCellSelectedFeatures{97} = [11 15 16 17 78 82 83 84];
mCellSelectedFeatures{98} = [11 18 19 20 78 85 86 87];
mCellSelectedFeatures{99} = [11 12 13 14 15 16 17 18 19 20 78 79 80 81 82 83 84 85 86 87];

% Raw Accl + PCA Accl Time + Frequency
mCellSelectedFeatures{100} = [1 2 3 4 68 69 70 71 11 12 13 14 78 79 80 81];  
mCellSelectedFeatures{101} = [1 2 3 4 5 6 7 8 9 10 68 69 70 71 72 73 74 75 76 77 11 12 13 14 78 79 80 81];
mCellSelectedFeatures{102} = [1 2 3 4 5 6 7 8 9 10 51 52 53 53 55 56 68 69 70 71 72 73 74 75 76 77 108 109 110  112 113 11 12 13 14 78 79 80 81];


% Raw Gyro + PCA Gyro Time
mCellSelectedFeatures{103} = [21 22 23 24 88 89 90 91];
mCellSelectedFeatures{104} = [21 22 23 24 25 26 27 28 29 30 88 89 90 91 92 93 94 95 96 97];
mCellSelectedFeatures{105} = [21 22 23 24 25 26 27 28 29 30 57 58 59 60 61 62 88 89 90 91 92 93 94 95 96 97 114 115 116  118 119];

% Raw Gyro + PCA Gyro Frequency
mCellSelectedFeatures{106} = [31 32 33 34 98 99 100 101];
mCellSelectedFeatures{107} = [31 35 36 37 98 102 103 104];
mCellSelectedFeatures{108} = [31 38 39 40 98 105 106 107];
mCellSelectedFeatures{109} = [31 32 33 34 35 36 37 38 39 40 98 99 100 101 102 103 104 105 106 107];

% Raw Gyro + PCA Gyro Time + Frequency
mCellSelectedFeatures{110} = [21 22 23 24 88 89 90 91 31 32 33 34 98 99 100 101];
mCellSelectedFeatures{111} = [21 22 23 24 25 26 27 28 29 30 88 89 90 91 92 93 94 95 96 97 31 32 33 34 98 99 100 101];
mCellSelectedFeatures{112} = [21 22 23 24 25 26 27 28 29 30 57 58 59 60 61 62 88 89 90 91 92 93 94 95 96 97 114 115 116  118 119 31 32 33 34 98 99 100 101];


% Raw Accl + PCA Accl + Raw Gyro + PCA Gyro Time
mCellSelectedFeatures{113} = [1 2 3 4 68 69 70 71 21 22 23 24 88 89 90 91]; 
mCellSelectedFeatures{114} = [1 2 3 4 5 6 7 8 9 10 68 69 70 71 72 73 74 75 76 77 21 22 23 24 25 26 27 28 29 30 88 89 90 91 92 93 94 95 96 97];
mCellSelectedFeatures{115} = [1 2 3 4 5 6 7 8 9 10 51 52 53 53 55 56 68 69 70 71 72 73 74 75 76 77 108 109 110  112 113 21 22 23 24 25 26 27 28 29 30 57 58 59 60 61 62 88 89 90 91 92 93 94 95 96 97 114 115 116  118 119];

% Raw Accl + PCA Accl + Raw Gyro + PCA Gyro Frequency
mCellSelectedFeatures{116} = [11 12 13 14 78 79 80 81 31 32 33 34 98 99 100 101];
mCellSelectedFeatures{117} = [11 15 16 17 78 82 83 84 31 35 36 37 98 102 103 104];
mCellSelectedFeatures{118} = [11 18 19 20 78 85 86 87 31 38 39 40 98 105 106 107];
mCellSelectedFeatures{119} = [11 12 13 14 15 16 17 18 19 20 78 79 80 81 82 83 84 85 86 87 31 32 33 34 35 36 37 38 39 40 98 99 100 101 102 103 104 105 106 107];

% Raw Accl + PCA Accl + Raw Gyro + PCA Gyro Time + Frequency
mCellSelectedFeatures{120} = [1 2 3 4 68 69 70 71 21 22 23 24 88 89 90 91 11 12 13 14 78 79 80 81 31 32 33 34 98 99 100 101]; 
mCellSelectedFeatures{121} = [1 2 3 4 5 6 7 8 9 10 68 69 70 71 72 73 74 75 76 77 21 22 23 24 25 26 27 28 29 30 88 89 90 91 92 93 94 95 96 97 11 12 13 14 78 79 80 81 31 32 33 34 98 99 100 101];
mCellSelectedFeatures{122} = [1 2 3 4 5 6 7 8 9 10 51 52 53 53 55 56 68 69 70 71 72 73 74 75 76 77 108 109 110  112 113 21 22 23 24 25 26 27 28 29 30 57 58 59 60 61 62 88 89 90 91 92 93 94 95 96 97 114 115 116  118 119 11 12 13 14 78 79 80 81 31 32 33 34 98 99 100 101];

% Raw Accl + PCA Accl + Raw Gyro + PCA Gyro + Baro Time
mCellSelectedFeatures{123} = [1 2 3 4 68 69 70 71 21 22 23 24 88 89 90 91 41 42 43 44 45 46 47 48 49 50 63 64 65 66 67]; 
mCellSelectedFeatures{124} = [1 2 3 4 5 6 7 8 9 10 68 69 70 71 72 73 74 75 76 77 21 22 23 24 25 26 27 28 29 30 88 89 90 91 92 93 94 95 96 97 41 42 43 44 45 46 47 48 49 50 63 64 65 66 67];
mCellSelectedFeatures{125} = [1 2 3 4 5 6 7 8 9 10 51 52 53 53 55 56 68 69 70 71 72 73 74 75 76 77 108 109 110  112 113 21 22 23 24 25 26 27 28 29 30 57 58 59 60 61 62 88 89 90 91 92 93 94 95 96 97 114 115 116  118 119 41 42 43 44 45 46 47 48 49 50 63 64 65 66 67];

% Raw Accl + PCA Accl + Raw Gyro + PCA Gyro + Baro Time + Fruquency
mCellSelectedFeatures{126} = [1 2 3 4 68 69 70 71 21 22 23 24 88 89 90 91 11 12 13 14 78 79 80 81 31 32 33 34 98 99 100 101 41 42 43 44 45 46 47 48 49 50 63 64 65 66 67]; 
mCellSelectedFeatures{127} = [1 2 3 4 5 6 7 8 9 10 68 69 70 71 72 73 74 75 76 77 21 22 23 24 25 26 27 28 29 30 88 89 90 91 92 93 94 95 96 97 11 12 13 14 78 79 80 81 31 32 33 34 98 99 100 101 41 42 43 44 45 46 47 48 49 50 63 64 65 66 67];
mCellSelectedFeatures{128} = [1 2 3 4 5 6 7 8 9 10 51 52 53 53 55 56 68 69 70 71 72 73 74 75 76 77 108 109 110  112 113 21 22 23 24 25 26 27 28 29 30 57 58 59 60 61 62 88 89 90 91 92 93 94 95 96 97 114 115 116  118 119 11 12 13 14 78 79 80 81 31 32 33 34 98 99 100 101 41 42 43 44 45 46 47 48 49 50 63 64 65 66 67];


% ==========================================================


%for i = 1:length(mCellSelectedFeatures)
for i = startIdx:endIdx
    fprintf('Evaluating Feature Set [%d]......\n', i);
    mSelectedFeatures = mCellSelectedFeatures{i};
    SBM_Evaluation(mSelectedFeatures, nUseFilter, i);
end

fprintf('\nFinish Time: %s\n', datestr(clock, 'yyyy-mm-dd HH:MM:SS'));

disp('>>>>>>>>>>>>>>DONE<<<<<<<<<<<<<<');
