function f = SBM_Script_EvaluationTotal_PCA_Param_UsingSelectedFeatures(startIdx, endIdx)

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
mCellSelectedFeatures{1} = [1:4];
mCellSelectedFeatures{2} = [1:10];
mCellSelectedFeatures{3} = [1:4,  51:56];
mCellSelectedFeatures{4} = [1:10, 51:56];

% Accl Frequency
mCellSelectedFeatures{5} = [11:14];
mCellSelectedFeatures{6} = [11, 15:17];
mCellSelectedFeatures{7} = [11, 18:20];
mCellSelectedFeatures{8} = [11:20];

% Accl Time & Frequency
mCellSelectedFeatures{9} = [1:4, 11:14];
mCellSelectedFeatures{10} = [1:14];
mCellSelectedFeatures{11} = [1:11, 15:17];
mCellSelectedFeatures{12} = [1:11, 18:20];
mCellSelectedFeatures{13} = [1:10, 51:56, 11:14];


% Gyro Time
mCellSelectedFeatures{14} = [21:24];
mCellSelectedFeatures{15} = [21:24, 57:62];
mCellSelectedFeatures{16} = [21:30];
mCellSelectedFeatures{17} = [21:30, 57:62];

% Gyro Frequency
mCellSelectedFeatures{18} = [31:34];
mCellSelectedFeatures{19} = [31, 35:37];
mCellSelectedFeatures{20} = [31, 38:40];
mCellSelectedFeatures{21} = [31:40];

% Gyro Time & Frequency
mCellSelectedFeatures{22} = [21:24, 31:34];
mCellSelectedFeatures{23} = [21:34];
mCellSelectedFeatures{24} = [21:31, 35:37];
mCellSelectedFeatures{25} = [21:31, 38:40];
mCellSelectedFeatures{26} = [21:30, 57:62, 31:34];

% Accl & Gyro (Time)
mCellSelectedFeatures{27} = [1:4, 21:24];
mCellSelectedFeatures{28} = [1:8, 10, 21:28, 30];
mCellSelectedFeatures{29} = [1:10, 21:30];
mCellSelectedFeatures{30} = [1:10, 51:56, 21:30, 57:62];  % All time features

mCellSelectedFeatures{31} = [11:14, 31:34];   % Frequency
mCellSelectedFeatures{32} = [1:4, 11:14, 21:24, 31:34];   % Time & Freequency
mCellSelectedFeatures{33} = [1:4, 51:56, 11:14, 21:24, 57:62, 31:34];   % Time & Freequency

mCellSelectedFeatures{34} = [1:4, 11, 18:24, 31, 38:40];  % Index starts from 1

% Accl & Gyro
mCellSelectedFeatures{35} = [1:14, 21:34];
mCellSelectedFeatures{36} = [1:10, 51:56, 11:14, 21:30, 57:62, 31:34];  % All time plus some frequency

% Baro
mCellSelectedFeatures{37} = [41];  % Baro only

mCellSelectedFeatures{38} = [41:44];
mCellSelectedFeatures{39} = [41:50];
mCellSelectedFeatures{40} = [41:50, 63:67];


% Accl % Baro
mCellSelectedFeatures{41} = [1:4, 41:44];
mCellSelectedFeatures{42} = [1:8, 10, 41:48, 50];
mCellSelectedFeatures{43} = [1:10, 41:50];
mCellSelectedFeatures{44} = [1:10, 51:56, 41:50, 63:67];  % All time features

mCellSelectedFeatures{45} = [11:14, 41:44];
mCellSelectedFeatures{46} = [1:14,  41:50];

% Gyro & Baro
mCellSelectedFeatures{47} = [21:24, 41:44];
mCellSelectedFeatures{48} = [21:28, 30, 41:48, 50];
mCellSelectedFeatures{49} = [21:30, 41:50];

mCellSelectedFeatures{50} = [31:34, 41:44];
mCellSelectedFeatures{51} = [21:34, 41:50];

% Accl & Gyro & Baro
mCellSelectedFeatures{52} = [1:4, 21:24, 41:44];
mCellSelectedFeatures{53} = [1:10, 21:30, 41:50];
mCellSelectedFeatures{54} = [1:10, 51:56, 21:30, 57:62, 41:50, 63:67];
mCellSelectedFeatures{55} = [1:4,  11:14, 21:24, 31:34, 41:44];
mCellSelectedFeatures{56} = [1:4,  11, 15:17, 21:24, 31, 35:37, 41:44];
mCellSelectedFeatures{57} = [1:4,  11, 18:24, 31, 38:44];
mCellSelectedFeatures{58} = [1:14, 21:34, 41:50];

% ================here below PCA features==================
% Accl Time
mCellSelectedFeatures{59} = [68:71];
mCellSelectedFeatures{60} = [68:77];
mCellSelectedFeatures{61} = [68:77, 108:110, 112:113];

% Accl Frequency
mCellSelectedFeatures{62} = [78:81];
mCellSelectedFeatures{63} = [78, 82:84];
mCellSelectedFeatures{64} = [78, 85:87];
mCellSelectedFeatures{65} = [78:87];


% Accl Time + Frequency
mCellSelectedFeatures{66} = [68:71, 78:81];
mCellSelectedFeatures{67} = [68:81];
mCellSelectedFeatures{68} = [68:77, 108:110, 112:113, 78:81];
mCellSelectedFeatures{69} = [68:77, 108:110, 112:113, 78:87];


% Gyro Time
mCellSelectedFeatures{70} = [88:91];
mCellSelectedFeatures{71} = [88:97];
mCellSelectedFeatures{72} = [88:97, 114:116, 118:119];


% Gyro Frequency
mCellSelectedFeatures{73} = [98:101];
mCellSelectedFeatures{74} = [98, 102:104];
mCellSelectedFeatures{75} = [98, 105:107];
mCellSelectedFeatures{76} = [98:107];

% Gyro Time + Frequency
mCellSelectedFeatures{77} = [88:91, 98:101];
mCellSelectedFeatures{78} = [88:101];
mCellSelectedFeatures{79} = [88:97, 114:116,  118:119, 98:101];
mCellSelectedFeatures{80} = [88:97, 114:116,  118:119, 98:107];


% PCA Accl + PCA Gyro Time
mCellSelectedFeatures{81} = [68:71, 88:91];
mCellSelectedFeatures{82} = [68:77, 88:97];
mCellSelectedFeatures{83} = [68:77, 108:110,  112:113, 88:97, 114:116,  118:119];

% PCA Accl + PCA Gyro Time + Frequency
mCellSelectedFeatures{84} = [68:71, 88:91, 78:87, 98:107];
mCellSelectedFeatures{85} = [68:77, 88:97, 78:87, 98:107];
mCellSelectedFeatures{86} = [68:77, 108:110,  112:113, 88:97, 114:116,  118:119, 78:87, 98:107];


% PCA Accl + PCA Gyro + Baro Time
mCellSelectedFeatures{87} = [68:71, 88:91, 41:50, 63:67];
mCellSelectedFeatures{88} = [68:77, 88:97, 41:50, 63:67];
mCellSelectedFeatures{89} = [68:77, 108:110,  112:113, 88:97, 114:116,  118:119, 41:50, 63:67];

% PCA Accl + PCA Gyro + Baro Time + Frequency
mCellSelectedFeatures{90} = [68:71, 88:91, 78:87, 98:107, 41:50, 63:67];
mCellSelectedFeatures{91} = [68:77, 88:97, 78:87, 98:107, 41:50, 63:67];
mCellSelectedFeatures{92} = [68:77, 108:110,  112:113, 88:97, 114:116,  118:119, 78:87, 98:107, 41:50, 63:67];

%here below RAW (filter) + PCA features

% Raw Accl + PCA Accl Time
mCellSelectedFeatures{93} = [1:4, 68:71];   
mCellSelectedFeatures{94} = [1:10, 68:77];
mCellSelectedFeatures{95} = [1:10, 51:56, 68:77, 108:110,  112:113];


% Raw Accl + PCA Accl Frequency
mCellSelectedFeatures{96} = [11:14, 78:81];
mCellSelectedFeatures{97} = [11, 15:17, 78, 82:84];
mCellSelectedFeatures{98} = [11, 18:20, 78, 85:87];
mCellSelectedFeatures{99} = [11:20, 78:87];

% Raw Accl + PCA Accl Time + Frequency
mCellSelectedFeatures{100} = [1:4, 68:71, 11:14, 78:81];  
mCellSelectedFeatures{101} = [1:10, 68:77, 11:14, 78:81];
mCellSelectedFeatures{102} = [1:10, 51:56, 68:77, 108:110,  112:113, 11:14, 78:81];


% Raw Gyro + PCA Gyro Time
mCellSelectedFeatures{103} = [21:24, 88:91];
mCellSelectedFeatures{104} = [21:30, 88:97];
mCellSelectedFeatures{105} = [21:30, 57:62, 88:97, 114:116,  118:119];

% Raw Gyro + PCA Gyro Frequency
mCellSelectedFeatures{106} = [31:34, 98:101];
mCellSelectedFeatures{107} = [31, 35:37, 98, 102:104];
mCellSelectedFeatures{108} = [31, 38:40, 98, 105:107];
mCellSelectedFeatures{109} = [31:40, 98:107];

% Raw Gyro + PCA Gyro Time + Frequency
mCellSelectedFeatures{110} = [21:24, 88:91, 31:34, 98:101];
mCellSelectedFeatures{111} = [21:30, 88:97, 31:34, 98:101];
mCellSelectedFeatures{112} = [21:30, 57:62, 88:97, 114:116,  118:119, 31:34, 98:101];


% Raw Accl + PCA Accl + Raw Gyro + PCA Gyro Time
mCellSelectedFeatures{113} = [1:4, 68:71, 21:24, 88:91]; 
mCellSelectedFeatures{114} = [1:10, 68:77, 21:30, 88:97];
mCellSelectedFeatures{115} = [1:10, 51:56, 68:77, 108:110,  112:113, 21:30, 57:62, 88:97, 114:116,  118:119];

% Raw Accl + PCA Accl + Raw Gyro + PCA Gyro Frequency
mCellSelectedFeatures{116} = [11:14, 78:81, 31:34, 98:101];
mCellSelectedFeatures{117} = [11, 15:17, 78, 82:84, 31, 35:37, 98, 102:104];
mCellSelectedFeatures{118} = [11, 18:20, 78, 85:87, 31, 38:40, 98, 105:107];
mCellSelectedFeatures{119} = [11:20, 78:87, 31:40, 98:107];

% Raw Accl + PCA Accl + Raw Gyro + PCA Gyro Time + Frequency
mCellSelectedFeatures{120} = [1:4, 68:71, 21:24, 88:91, 11:14, 78:81, 31:34, 98:101]; 
mCellSelectedFeatures{121} = [1:10, 68:77, 21:30, 88:97, 11:14, 78:81, 31:34, 98:101];
mCellSelectedFeatures{122} = [1:10, 51:56, 68:77, 108:110,  112:113, 21:30, 57:62, 88:97, 114:116,  118:119, 11:14, 78:81, 31:34, 98:101];

% Raw Accl + PCA Accl + Raw Gyro + PCA Gyro + Baro Time
mCellSelectedFeatures{123} = [1:4, 68:71, 21:24, 88:91, 41:50, 63:67]; 
mCellSelectedFeatures{124} = [1:10, 68:77, 21:30, 88:97, 41:50, 63:67];
mCellSelectedFeatures{125} = [1:10, 51:56, 68:77, 108:110,  112:113, 21:30,  57:62, 88:97, 114:116,  118:119, 41:50, 63:67];

% Raw Accl + PCA Accl + Raw Gyro + PCA Gyro + Baro Time + Fruquency
mCellSelectedFeatures{126} = [1:4, 68:71, 21:24, 88:91, 11:14, 78:81, 31:34, 98:101, 41:50, 63:67]; 
mCellSelectedFeatures{127} = [1:10, 68:77, 21:30, 88:97, 11:14, 78:81, 31:34, 98:101, 41:50, 63:67];
mCellSelectedFeatures{128} = [1:10, 51:56, 68:77, 108:110,  112:113, 21:30, 57:62, 88:97, 114:116,  118:119, 11:14, 78:81, 31:34, 98:101, 41:50, 63:67];


% === Add on 2016/04/30, for PCA 2 ==========================
% Here from mCellSelectedFeatures{129} to mCellSelectedFeatures{198}
% currently still contains only PCA, now need to include PCA2 features
% The PCA index starts from 68, PCA2 starts from 120; i.e. the GAP between
% them is 52;
% So for following features, if the feature index i >= 68, needs to include
% feature index i+52

% Accl Time
mCellSelectedFeatures{129} = [68:71];
mCellSelectedFeatures{130} = [68:77];
mCellSelectedFeatures{131} = [68:77, 108:110, 112:113];

% Accl Frequency
mCellSelectedFeatures{132} = [78:81];
mCellSelectedFeatures{133} = [78, 82:84];
mCellSelectedFeatures{134} = [78, 85:87];
mCellSelectedFeatures{135} = [78:87];


% Accl Time + Frequency
mCellSelectedFeatures{136} = [68:71, 78:81];
mCellSelectedFeatures{137} = [68:81];
mCellSelectedFeatures{138} = [68:77, 108:110, 112:113, 78:81];
mCellSelectedFeatures{139} = [68:77, 108:110, 112:113, 78:87];


% Gyro Time
mCellSelectedFeatures{140} = [88:91];
mCellSelectedFeatures{141} = [88:97];
mCellSelectedFeatures{142} = [88:97, 114:116, 118:119];


% Gyro Frequency
mCellSelectedFeatures{143} = [98:101];
mCellSelectedFeatures{144} = [98, 102:104];
mCellSelectedFeatures{145} = [98, 105:107];
mCellSelectedFeatures{146} = [98:107];

% Gyro Time + Frequency
mCellSelectedFeatures{147} = [88:91, 98:101];
mCellSelectedFeatures{148} = [88:101];
mCellSelectedFeatures{149} = [88:97, 114:116,  118:119, 98:101];
mCellSelectedFeatures{150} = [88:97, 114:116,  118:119, 98:107];


% PCA Accl + PCA Gyro Time
mCellSelectedFeatures{151} = [68:71, 88:91];
mCellSelectedFeatures{152} = [68:77, 88:97];
mCellSelectedFeatures{153} = [68:77, 108:110,  112:113, 88:97, 114:116,  118:119];

% PCA Accl + PCA Gyro Time + Frequency
mCellSelectedFeatures{154} = [68:71, 88:91, 78:87, 98:107];
mCellSelectedFeatures{155} = [68:77, 88:97, 78:87, 98:107];
mCellSelectedFeatures{156} = [68:77, 108:110,  112:113, 88:97, 114:116,  118:119, 78:87, 98:107];


% PCA Accl + PCA Gyro + Baro Time
mCellSelectedFeatures{157} = [68:71, 88:91, 41:50, 63:67];
mCellSelectedFeatures{158} = [68:77, 88:97, 41:50, 63:67];
mCellSelectedFeatures{159} = [68:77, 108:110,  112:113, 88:97, 114:116,  118:119, 41:50, 63:67];

% PCA Accl + PCA Gyro + Baro Time + Frequency
mCellSelectedFeatures{160} = [68:71, 88:91, 78:87, 98:107, 41:50, 63:67];
mCellSelectedFeatures{161} = [68:77, 88:97, 78:87, 98:107, 41:50, 63:67];
mCellSelectedFeatures{162} = [68:77, 108:110,  112:113, 88:97, 114:116,  118:119, 78:87, 98:107, 41:50, 63:67];

%here below RAW (filter) + PCA features

% Raw Accl + PCA Accl Time
mCellSelectedFeatures{163} = [1:4, 68:71];   
mCellSelectedFeatures{164} = [1:10, 68:77];
mCellSelectedFeatures{165} = [1:10, 51:56, 68:77, 108:110,  112:113];


% Raw Accl + PCA Accl Frequency
mCellSelectedFeatures{166} = [11:14, 78:81];
mCellSelectedFeatures{167} = [11, 15:17, 78, 82:84];
mCellSelectedFeatures{168} = [11, 18:20, 78, 85:87];
mCellSelectedFeatures{169} = [11:20, 78:87];

% Raw Accl + PCA Accl Time + Frequency
mCellSelectedFeatures{170} = [1:4, 68:71, 11:14, 78:81];  
mCellSelectedFeatures{171} = [1:10, 68:77, 11:14, 78:81];
mCellSelectedFeatures{172} = [1:10, 51:56, 68:77, 108:110,  112:113, 11:14, 78:81];


% Raw Gyro + PCA Gyro Time
mCellSelectedFeatures{173} = [21:24, 88:91];
mCellSelectedFeatures{174} = [21:30, 88:97];
mCellSelectedFeatures{175} = [21:30, 57:62, 88:97, 114:116,  118:119];

% Raw Gyro + PCA Gyro Frequency
mCellSelectedFeatures{176} = [31:34, 98:101];
mCellSelectedFeatures{177} = [31, 35:37, 98, 102:104];
mCellSelectedFeatures{178} = [31, 38:40, 98, 105:107];
mCellSelectedFeatures{179} = [31:40, 98:107];

% Raw Gyro + PCA Gyro Time + Frequency
mCellSelectedFeatures{180} = [21:24, 88:91, 31:34, 98:101];
mCellSelectedFeatures{181} = [21:30, 88:97, 31:34, 98:101];
mCellSelectedFeatures{182} = [21:30, 57:62, 88:97, 114:116,  118:119, 31:34, 98:101];


% Raw Accl + PCA Accl + Raw Gyro + PCA Gyro Time
mCellSelectedFeatures{183} = [1:4, 68:71, 21:24, 88:91]; 
mCellSelectedFeatures{184} = [1:10, 68:77, 21:30, 88:97];
mCellSelectedFeatures{185} = [1:10, 51:56, 68:77, 108:110,  112:113, 21:30, 57:62, 88:97, 114:116,  118:119];

% Raw Accl + PCA Accl + Raw Gyro + PCA Gyro Frequency
mCellSelectedFeatures{186} = [11:14, 78:81, 31:34, 98:101];
mCellSelectedFeatures{187} = [11, 15:17, 78, 82:84, 31, 35:37, 98, 102:104];
mCellSelectedFeatures{188} = [11, 18:20, 78, 85:87, 31, 38:40, 98, 105:107];
mCellSelectedFeatures{189} = [11:20, 78:87, 31:40, 98:107];

% Raw Accl + PCA Accl + Raw Gyro + PCA Gyro Time + Frequency
mCellSelectedFeatures{190} = [1:4, 68:71, 21:24, 88:91, 11:14, 78:81, 31:34, 98:101]; 
mCellSelectedFeatures{191} = [1:10, 68:77, 21:30, 88:97, 11:14, 78:81, 31:34, 98:101];
mCellSelectedFeatures{192} = [1:10, 51:56, 68:77, 108:110,  112:113, 21:30, 57:62, 88:97, 114:116,  118:119, 11:14, 78:81, 31:34, 98:101];

% Raw Accl + PCA Accl + Raw Gyro + PCA Gyro + Baro Time
mCellSelectedFeatures{193} = [1:4, 68:71, 21:24, 88:91, 41:50, 63:67]; 
mCellSelectedFeatures{194} = [1:10, 68:77, 21:30, 88:97, 41:50, 63:67];
mCellSelectedFeatures{195} = [1:10, 51:56, 68:77, 108:110,  112:113, 21:30,  57:62, 88:97, 114:116,  118:119, 41:50, 63:67];

% Raw Accl + PCA Accl + Raw Gyro + PCA Gyro + Baro Time + Fruquency
mCellSelectedFeatures{196} = [1:4, 68:71, 21:24, 88:91, 11:14, 78:81, 31:34, 98:101, 41:50, 63:67]; 
mCellSelectedFeatures{197} = [1:10, 68:77, 21:30, 88:97, 11:14, 78:81, 31:34, 98:101, 41:50, 63:67];
mCellSelectedFeatures{198} = [1:10, 51:56, 68:77, 108:110,  112:113, 21:30, 57:62, 88:97, 114:116,  118:119, 11:14, 78:81, 31:34, 98:101, 41:50, 63:67];

% ==========================================================
mCellSelectedFeatures{199} = [2,9,56,62,80,81,138,159];    % Linear Accl + Gyro
    
mCellSelectedFeatures{200} = [41,42,49,50];   % Baro


% Add on 5/16/2016
mCellSelectedFeatures{201} = [2,9,62,138];    % Linear Accl + Gyro (only common good features both from yellow and 5 routes): Index: 2,9,42,141
mCellSelectedFeatures{202} = [1,2,9,56,58,62,81,83,138,139,159];    % Linear Accl + Gyro  (Only all common good feature in both 4 scenarios(i.e. www,ww, ww, w) based on 5 routes on single features

% Linear Accl + Gyro (Only all common good features in both 4 scenarios based on 5 routes on single + major common good features)
mCellSelectedFeatures{203} = [1,2,9,56,58,62,80,81,83,86,138,139,159];    

% Linear Accl + Gyro (Only all common good features in both 4 scenarios based on 5 routes on single + major common good features of 5 routes)
% + Major common good features of Yellow
mCellSelectedFeatures{204} = [1,2,9,52,56,58,62,77,80,81,83,86,129,138,139,159,171];    

mCellSelectedFeatures{205} = [2,9,62];    % *Linear Accl + Gyro (only common good features both from yellow and 5 routes): Index: 2,9,42,141

mCellSelectedFeatures{206} = [1,2,9,62];    % *Linear Accl + Gyro (only part common good features both from yellow and 5 routes): Index: 2,9,42,141

mCellSelectedFeatures{207} = [1,2,9,62,138];    % Linear Accl + Gyro (only part common good features both from yellow)

mCellSelectedFeatures{208} = [1,2,9,52,62,77,80,129,138,171];    % Linear Accl + Gyro (only common good features both from yellow)

mCellSelectedFeatures{209} = [1,2,9,52,56,62,71,74,77,80,129,138,162,171];    % Linear Accl + Gyro (only major(2)/common good features both from yellow

mCellSelectedFeatures{210} = [1,2,9,52,53,56,16,19,28,59,60,62,71,72,74,76,77,110,80,81,97,114,119,129,122,123,126,128,160,162,133,138,139,171,159];    % Linear Accl + Gyro (only major(2+1)/common good features both from yellow

% ==========================================================
nPcaStartIdx = 68;
nPcaPca2Gap = 52;

%for i = 1:length(mCellSelectedFeatures)
for i = startIdx:endIdx
    fprintf('Evaluating Feature Set [%d]......\n', i);
    mSelectedFeatures = mCellSelectedFeatures{i};
    
    if i >= 129 && i <= 198  % For these feature combinations (with PCA2), need to add features for PCA2, which is +52 based on PCA features, PCA feature starts from 68
        mSelectedFeaturesWithPCA2 = [];
        idx = 0;
        for j = 1:length(mSelectedFeatures)
            if mSelectedFeatures(j) >= nPcaStartIdx
                idx = idx + 1;
                mSelectedFeaturesWithPCA2(idx) = mSelectedFeatures(j) + nPcaPca2Gap;
            end
        end
        
        mSelectedFeatures = [mSelectedFeatures, mSelectedFeaturesWithPCA2];
    end
    
    SBM_Evaluation(mSelectedFeatures, nUseFilter, i);
end

fprintf('\nFinish Time: %s\n', datestr(clock, 'yyyy-mm-dd HH:MM:SS'));

disp('>>>>>>>>>>>>>>DONE<<<<<<<<<<<<<<');
