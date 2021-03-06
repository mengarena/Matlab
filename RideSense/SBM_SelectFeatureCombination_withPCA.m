function f = SBM_SelectFeatureCombination_withPCA()
% This function is used to get the statistics of performance of different
% feature combination
%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The Order of the feature combination list here is different from other
% scripts (e.g SBM_Plot_SelectedFeatureCombination)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

format long;

%sParentFolder = 'E:\SensorMatching\Data\SchoolShuttle\Evaluation';
sParentFolder = 'E:\SensorMatching\Data\SchoolShuttle\Evaluation20160430';

sFilePrefix = 'EvRet';
nPlot = 0;

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

nPcaStartIdx = 68;
nPcaPca2Gap = 52;


% % First set:  Accl (Index: 1--10) +   Gyro (11-20);  Accl+Gyro (21-27);   Baro (28-30);   Accl/Gyro + Baro (31-46)
% % (outdated, because the above indexes have been adjusted to correct order) mFeatureCombIndex = [1 2 3 4 5 6 7 8 9 10    11 12 13 14 15 16 17 18 19 20    23 24 25 26 27 28 46    45 21 22    29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44];  
% %                           Accl                      Gyro                           Accl+Gyro            Baro                   Accl/Gyro + Baro
% %

sSelectFeatureCombWhichWhereWhen = 'E:\SensorMatching\Data\SchoolShuttle\SelectFeatureCombination20160430\WhichWhereWhen.csv';
fid3W = fopen(sSelectFeatureCombWhichWhereWhen, 'w');

sSelectFeatureCombWhichWhere = 'E:\SensorMatching\Data\SchoolShuttle\SelectFeatureCombination20160430\WhichWhere.csv';
fidWhichWhere = fopen(sSelectFeatureCombWhichWhere, 'w');

sSelectFeatureCombWhichWhen = 'E:\SensorMatching\Data\SchoolShuttle\SelectFeatureCombination20160430\WhichWhen.csv';
fidWhichWhen = fopen(sSelectFeatureCombWhichWhen, 'w');

sSelectFeatureCombWhich = 'E:\SensorMatching\Data\SchoolShuttle\SelectFeatureCombination20160430\Which.csv';
fidWhich = fopen(sSelectFeatureCombWhich, 'w');

mStatAllAccuracy = [];
mStatRouteSegAccuracy = [];

%for i = 1:length(mCellSelectedFeatures)
for i = 1:length(mCellSelectedFeatures)
    %nFeatureCombIndex = mFeatureCombIndex(i);
    sResultFile = [sParentFolder '\' sFilePrefix];
    
    mSelectedFeatures = mCellSelectedFeatures{i};
    
    for j = 1:length(mSelectedFeatures)
%        sResultFile = sprintf('%s_%d', sResultFile, mSelectedFeatures(j));
    end
    
%    sResultFile = [sResultFile '.csv'];
    sResultFile = [sResultFile '_' num2str(i) '.csv'];
    
    cellResult = SBM_EvaluteAccuracy(sResultFile, nPlot);

    % "All" means Route No, Trace No, Src Seg No and Dst Seg No all must be correct, 
                     % Column 1: Overall, Column 2: PantPocket, Column 3: Hand
                     % Row 1:  Overall
                     % Row 2~n:  Different Segment Len    
    mAllAccuracy = cellResult{1};    % (1+N)x3   (N = number of SegLen type)  

    mStatAllAccuracy(i,1) = mAllAccuracy(1,1);
    mStatAllAccuracy(i,2) = mAllAccuracy(1,2);
    mStatAllAccuracy(i,3) = mAllAccuracy(1,3);
    
    fprintf(fid3W, '%d, %3.5f, %3.5f, %3.5f\n', i, mAllAccuracy(1,1), mAllAccuracy(1,2), mAllAccuracy(1,3));
    
    % "RouteSeg" means Route No, Src Seg No and Dst Seg No all must be correct, 
                         % Column 1: Overall, Column 2: PantPocket, Column 3: Hand
                         % Row 1:  Overall
                         % Row 2~n:  Different Segment Len    
    mRouteSegAccuracy = cellResult{2};   % (1+N)x3   (N = number of SegLen type)

    mStatRouteSegAccuracy(i,1) = mRouteSegAccuracy(1,1);
    mStatRouteSegAccuracy(i,2) = mRouteSegAccuracy(1,2);
    mStatRouteSegAccuracy(i,3) = mRouteSegAccuracy(1,3);

    fprintf(fidWhichWhere, '%d, %3.5f, %3.5f, %3.5f\n', i, mRouteSegAccuracy(1,1), mRouteSegAccuracy(1,2), mRouteSegAccuracy(1,3));

    
    % "RouteTrace" means Route No, Trace No must be correct, 
                         % Column 1: Overall, Column 2: PantPocket, Column 3: Hand
                         % Row 1:  Overall
                         % Row 2~n:  Different Segment Len    
    mRouteTraceAccuracy = cellResult{3};   % (1+N)x3   (N = number of SegLen type)

    mStatRouteTraceAccuracy(i,1) = mRouteTraceAccuracy(1,1);
    mStatRouteTraceAccuracy(i,2) = mRouteTraceAccuracy(1,2);
    mStatRouteTraceAccuracy(i,3) = mRouteTraceAccuracy(1,3);

    fprintf(fidWhichWhen, '%d, %3.5f, %3.5f, %3.5f\n', i, mRouteTraceAccuracy(1,1), mRouteTraceAccuracy(1,2), mRouteTraceAccuracy(1,3));

    
    % "Route" means Route No must be correct, 
                         % Column 1: Overall, Column 2: PantPocket, Column 3: Hand
                         % Row 1:  Overall
                         % Row 2~n:  Different Segment Len    
    mRouteAccuracy = cellResult{4};   % (1+N)x3   (N = number of SegLen type)

    mStatRouteAccuracy(i,1) = mRouteAccuracy(1,1);
    mStatRouteAccuracy(i,2) = mRouteAccuracy(1,2);
    mStatRouteAccuracy(i,3) = mRouteAccuracy(1,3);

    fprintf(fidWhich, '%d, %3.5f, %3.5f, %3.5f\n', i, mRouteAccuracy(1,1), mRouteAccuracy(1,2), mRouteAccuracy(1,3));
    
    
    % "SegLen" shows different Segment Length statistics (PsgLen = RefLen;  PsgLen<RefLen; PsgLen > RefLen), 
                     % Column1~3: Overall; Column4~6: Pantpocket, Column7~9: Hand
                     % Row 1:  Overall
                     % Row 2~n:  Different Segment Len        
    %mSegLenStat = cellResult{3};    % (1+N)x9   (N = number of SegLen type)
    
end


fclose(fid3W);

fclose(fidWhichWhere);
fclose(fidWhichWhen);
fclose(fidWhich);


fprintf('Deciding Feature Combination...\n');


mStatAllAccuracy = mStatAllAccuracy*100.0;
mStatRouteSegAccuracy = mStatRouteSegAccuracy*100.0;
mStatRouteTraceAccuracy = mStatRouteTraceAccuracy*100.0;
mStatRouteAccuracy = mStatRouteAccuracy*100.0;


xMalVal = 199;
xStep = 5;

myColorAcclT = [0.73 1 1];
myColorAcclF = [0.68 0.92 1];
myColorAcclTF = [0.73 1 1];

myColorGyroT = [0.85 0.95 0.9];
myColorGyroF = [0.76 0.87 0.78];
myColorGyroTF = [0.85 0.95 0.9];

myColorBaroT = [0.93 0.84 0.84];

myColorAcclBaro = [0.93 0.84 0.84];
myColorGyroBaro = [0.93 0.84 0.84];

myColorAcclGyroT =[0.73 1 0.5];
myColorAcclGyroF =[0.53 0.5 1];
myColorAcclGyroTF =[0.73 1 0.5];

myColorAllT =[0.93 0.84 0.84];
myColorAllTF =[0.93 0.84 0.84];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Select Feature %%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(1);

hshade = area([0.5 4.5], [100 100], 'FaceColor', myColorAcclT, 'LineStyle', 'none');   % Accl
hold on;

hshade = area([4.5 8.5], [100 100], 'FaceColor', myColorAcclF, 'LineStyle', 'none');   % Gyro
hold on;

hshade = area([8.5 13.5], [100 100], 'FaceColor', myColorAcclTF, 'LineStyle', 'none');    % Accl + Gyro
hold on;

hshade = area([13.5 17.5], [100 100], 'FaceColor', myColorGyroT, 'LineStyle', 'none');    % Baro
hold on;

hshade = area([17.5 21.5], [100 100], 'FaceColor', myColorGyroF, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([21.5 26.5], [100 100], 'FaceColor', myColorGyroTF, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([26.5 36.5], [100 100], 'FaceColor', myColorAcclGyroTF, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([36.5 40.5], [100 100], 'FaceColor', myColorBaroT, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([40.5 46.5], [100 100], 'FaceColor', myColorAcclBaro, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([46.5 51.5], [100 100], 'FaceColor', myColorGyroBaro, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([51.5 58.5], [100 100], 'FaceColor', myColorAllTF, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([58.5 61.5], [100 100], 'FaceColor', myColorAcclT, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([61.5 65.5], [100 100], 'FaceColor', myColorAcclF, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([65.5 69.5], [100 100], 'FaceColor', myColorAcclTF, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([69.5 72.5], [100 100], 'FaceColor', myColorGyroT, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([72.5 76.5], [100 100], 'FaceColor', myColorGyroF, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([76.5 80.5], [100 100], 'FaceColor', myColorGyroTF, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([80.5 83.5], [100 100], 'FaceColor', myColorAcclGyroT, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([83.5 86.5], [100 100], 'FaceColor', myColorAcclGyroTF, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([86.5 89.5], [100 100], 'FaceColor', myColorAllT, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([89.5 92.5], [100 100], 'FaceColor', myColorAllTF, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([92.5 95.5], [100 100], 'FaceColor', myColorAcclT, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([95.5 99.5], [100 100], 'FaceColor', myColorAcclF, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([99.5 102.5], [100 100], 'FaceColor', myColorAcclTF, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([102.5 105.5], [100 100], 'FaceColor', myColorGyroT, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([105.5 109.5], [100 100], 'FaceColor', myColorGyroF, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([109.5 112.5], [100 100], 'FaceColor', myColorGyroTF, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([112.5 115.5], [100 100], 'FaceColor', myColorAcclGyroT, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([115.5 119.5], [100 100], 'FaceColor', myColorAcclGyroF, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([119.5 122.5], [100 100], 'FaceColor', myColorAcclGyroTF, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([122.5 125.5], [100 100], 'FaceColor', myColorAllT, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([125.5 128.5], [100 100], 'FaceColor', myColorAllTF, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;


%%%%%%%%%%%%%%%%%%%%%%

hshade = area([128.5 131.5], [100 100], 'FaceColor', myColorAcclT, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([131.5 135.5], [100 100], 'FaceColor', myColorAcclF, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([135.5 139.5], [100 100], 'FaceColor', myColorAcclTF, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([139.5 142.5], [100 100], 'FaceColor', myColorGyroT, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([142.5 146.5], [100 100], 'FaceColor', myColorGyroF, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([146.5 150.5], [100 100], 'FaceColor', myColorGyroTF, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([150.5 153.5], [100 100], 'FaceColor', myColorAcclGyroT, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([153.5 156.5], [100 100], 'FaceColor', myColorAcclGyroTF, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([156.5 159.5], [100 100], 'FaceColor', myColorAllT, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([159.5 162.5], [100 100], 'FaceColor', myColorAllTF, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([162.5 165.5], [100 100], 'FaceColor', myColorAcclT, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([165.5 169.5], [100 100], 'FaceColor', myColorAcclF, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([169.5 172.5], [100 100], 'FaceColor', myColorAcclTF, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([172.5 175.5], [100 100], 'FaceColor', myColorGyroT, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([175.5 179.5], [100 100], 'FaceColor', myColorGyroF, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([179.5 182.5], [100 100], 'FaceColor', myColorGyroTF, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([182.5 185.5], [100 100], 'FaceColor', myColorAcclGyroT, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([185.5 189.5], [100 100], 'FaceColor', myColorAcclGyroF, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([189.5 192.5], [100 100], 'FaceColor', myColorAcclGyroTF, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([192.5 195.5], [100 100], 'FaceColor', myColorAllT, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([195.5 198.5], [100 100], 'FaceColor', myColorAllT, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;



% Compare Accuracy of Which/Where/When (Overall) of Different Feature
% Combination
hLine1 = plot(mStatAllAccuracy(:,1), 'r-*', 'LineWidth', 3);
hold on;
hLine2 = plot(mStatAllAccuracy(:,2), 'g-*', 'LineWidth', 3);
hold on;
hLine3 = plot(mStatAllAccuracy(:,3), 'b-*', 'LineWidth', 3);
hold on;
legend([hLine1, hLine2, hLine3], 'Overall', 'Pocket', 'Hand');
title(gca, 'Accuracy of Which/Where/When (Overall)', 'FontName','Times New Roman', 'FontSize', 30);

set(gca, 'FontName','Times New Roman');
set(gca, 'FontSize', 24);
        
xlabelStr = 'Feature Combinations';

xlabel(xlabelStr, 'FontSize', 30);
ylabel('Accuracy (%)', 'FontSize', 30);
set(gca,'ygrid','on');
ylim([0 100]);
set(gca,'YTick',0:10:100);
set(gca,'xgrid','on');
xlim([0 xMalVal]);
set(gca,'XTick',0:xStep:xMalVal);
set(gca, 'Layer', 'top');



mIdxAllAccuracyOverall = find(mStatAllAccuracy(:,1)==max(mStatAllAccuracy(:,1)))
mIdxPocketAccuracyOverall = find(mStatAllAccuracy(:,2)==max(mStatAllAccuracy(:,2)))
mIdxHandAccuracyOverall = find(mStatAllAccuracy(:,3)==max(mStatAllAccuracy(:,3)))

sAllAccuracyOverall = '';
for i = 1:length(mIdxAllAccuracyOverall)
    if i == 1
        sAllAccuracyOverall = num2str(mIdxAllAccuracyOverall(i));
    else
        sAllAccuracyOverall = [sAllAccuracyOverall ',' num2str(mIdxAllAccuracyOverall(i))];
    end
end

sPocketAccuracyOverall = '';
for i = 1:length(mIdxPocketAccuracyOverall)
    if i == 1
        sPocketAccuracyOverall = num2str(mIdxPocketAccuracyOverall(i));
    else
        sPocketAccuracyOverall = [sPocketAccuracyOverall ',' num2str(mIdxPocketAccuracyOverall(i))];
    end
end

sHandAccuracyOverall = '';
for i = 1:length(mIdxHandAccuracyOverall)
    if i == 1
        sHandAccuracyOverall = num2str(mIdxHandAccuracyOverall(i));
    else
        sHandAccuracyOverall = [sHandAccuracyOverall ',' num2str(mIdxHandAccuracyOverall(i))];
    end
end

fprintf('[All] Accuracy Max Value Corresponding [Overall Index] = %s;  [Pocket Index] = %s;  [Hand Index] = %s\n', sAllAccuracyOverall, sPocketAccuracyOverall, sHandAccuracyOverall);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(2);
hshade = area([0.5 4.5], [100 100], 'FaceColor', myColorAcclT, 'LineStyle', 'none');   % Accl
hold on;

hshade = area([4.5 8.5], [100 100], 'FaceColor', myColorAcclF, 'LineStyle', 'none');   % Gyro
hold on;

hshade = area([8.5 13.5], [100 100], 'FaceColor', myColorAcclTF, 'LineStyle', 'none');    % Accl + Gyro
hold on;

hshade = area([13.5 17.5], [100 100], 'FaceColor', myColorGyroT, 'LineStyle', 'none');    % Baro
hold on;

hshade = area([17.5 21.5], [100 100], 'FaceColor', myColorGyroF, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([21.5 26.5], [100 100], 'FaceColor', myColorGyroTF, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([26.5 36.5], [100 100], 'FaceColor', myColorAcclGyroTF, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([36.5 40.5], [100 100], 'FaceColor', myColorBaroT, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([40.5 46.5], [100 100], 'FaceColor', myColorAcclBaro, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([46.5 51.5], [100 100], 'FaceColor', myColorGyroBaro, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([51.5 58.5], [100 100], 'FaceColor', myColorAllTF, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([58.5 61.5], [100 100], 'FaceColor', myColorAcclT, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([61.5 65.5], [100 100], 'FaceColor', myColorAcclF, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([65.5 69.5], [100 100], 'FaceColor', myColorAcclTF, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([69.5 72.5], [100 100], 'FaceColor', myColorGyroT, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([72.5 76.5], [100 100], 'FaceColor', myColorGyroF, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([76.5 80.5], [100 100], 'FaceColor', myColorGyroTF, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([80.5 83.5], [100 100], 'FaceColor', myColorAcclGyroT, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([83.5 86.5], [100 100], 'FaceColor', myColorAcclGyroTF, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([86.5 89.5], [100 100], 'FaceColor', myColorAllT, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([89.5 92.5], [100 100], 'FaceColor', myColorAllTF, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([92.5 95.5], [100 100], 'FaceColor', myColorAcclT, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([95.5 99.5], [100 100], 'FaceColor', myColorAcclF, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([99.5 102.5], [100 100], 'FaceColor', myColorAcclTF, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([102.5 105.5], [100 100], 'FaceColor', myColorGyroT, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([105.5 109.5], [100 100], 'FaceColor', myColorGyroF, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([109.5 112.5], [100 100], 'FaceColor', myColorGyroTF, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([112.5 115.5], [100 100], 'FaceColor', myColorAcclGyroT, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([115.5 119.5], [100 100], 'FaceColor', myColorAcclGyroF, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([119.5 122.5], [100 100], 'FaceColor', myColorAcclGyroTF, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([122.5 125.5], [100 100], 'FaceColor', myColorAllT, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([125.5 128.5], [100 100], 'FaceColor', myColorAllTF, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;


%%%%%%%%%%%%%%%%%%%%%%

hshade = area([128.5 131.5], [100 100], 'FaceColor', myColorAcclT, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([131.5 135.5], [100 100], 'FaceColor', myColorAcclF, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([135.5 139.5], [100 100], 'FaceColor', myColorAcclTF, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([139.5 142.5], [100 100], 'FaceColor', myColorGyroT, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([142.5 146.5], [100 100], 'FaceColor', myColorGyroF, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([146.5 150.5], [100 100], 'FaceColor', myColorGyroTF, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([150.5 153.5], [100 100], 'FaceColor', myColorAcclGyroT, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([153.5 156.5], [100 100], 'FaceColor', myColorAcclGyroTF, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([156.5 159.5], [100 100], 'FaceColor', myColorAllT, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([159.5 162.5], [100 100], 'FaceColor', myColorAllTF, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([162.5 165.5], [100 100], 'FaceColor', myColorAcclT, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([165.5 169.5], [100 100], 'FaceColor', myColorAcclF, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([169.5 172.5], [100 100], 'FaceColor', myColorAcclTF, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([172.5 175.5], [100 100], 'FaceColor', myColorGyroT, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([175.5 179.5], [100 100], 'FaceColor', myColorGyroF, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([179.5 182.5], [100 100], 'FaceColor', myColorGyroTF, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([182.5 185.5], [100 100], 'FaceColor', myColorAcclGyroT, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([185.5 189.5], [100 100], 'FaceColor', myColorAcclGyroF, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([189.5 192.5], [100 100], 'FaceColor', myColorAcclGyroTF, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([192.5 195.5], [100 100], 'FaceColor', myColorAllT, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([195.5 198.5], [100 100], 'FaceColor', myColorAllT, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

% Compare Accuracy of Which/Where (Overall) of Different Feature
% Combination
hLine1 = plot(mStatRouteSegAccuracy(:,1), 'r-*', 'LineWidth', 3);
hold on;
hLine2 = plot(mStatRouteSegAccuracy(:,2), 'g-*', 'LineWidth', 3);
hold on;
hLine3 = plot(mStatRouteSegAccuracy(:,3), 'b-*', 'LineWidth', 3);
hold on;
legend([hLine1, hLine2, hLine3], 'Overall', 'Pocket', 'Hand');
title(gca, 'Accuracy of Which/Where (Overall)', 'FontName','Times New Roman', 'FontSize', 30);

set(gca, 'FontName','Times New Roman');
set(gca, 'FontSize', 24);
        
xlabelStr = 'Feature Combinations';

xlabel(xlabelStr, 'FontSize', 30);
ylabel('Accuracy (%)', 'FontSize', 30);
set(gca,'ygrid','on');
ylim([0 100]);
set(gca,'YTick',0:10:100);
set(gca,'xgrid','on');
xlim([0 xMalVal]);
set(gca,'XTick',0:xStep:xMalVal);
set(gca, 'Layer', 'top');

mIdxRouteSegAccuracyOverall = find(mStatRouteSegAccuracy(:,1)==max(mStatRouteSegAccuracy(:,1)));
mIdxPocketRouteSegAccuracyOverall = find(mStatRouteSegAccuracy(:,2)==max(mStatRouteSegAccuracy(:,2)));
mIdxHandRouteSegAccuracyOverall = find(mStatRouteSegAccuracy(:,3)==max(mStatRouteSegAccuracy(:,3)));


sRouteSegAccuracyOverall = '';
for i = 1:length(mIdxRouteSegAccuracyOverall)
    if i == 1
        sRouteSegAccuracyOverall = num2str(mIdxRouteSegAccuracyOverall(i));
    else
        sRouteSegAccuracyOverall = [sRouteSegAccuracyOverall ',' num2str(mIdxRouteSegAccuracyOverall(i))];
    end
end

sPocketRouteSegAccuracyOverall = '';
for i = 1:length(mIdxPocketRouteSegAccuracyOverall)
    if i == 1
        sPocketRouteSegAccuracyOverall = num2str(mIdxPocketRouteSegAccuracyOverall(i));
    else
        sPocketRouteSegAccuracyOverall = [sPocketRouteSegAccuracyOverall ',' num2str(mIdxPocketRouteSegAccuracyOverall(i))];
    end
end

sHandRouteSegAccuracyOverall = '';
for i = 1:length(mIdxHandRouteSegAccuracyOverall)
    if i == 1
        sHandRouteSegAccuracyOverall = num2str(mIdxHandRouteSegAccuracyOverall(i));
    else
        sHandRouteSegAccuracyOverall = [sHandRouteSegAccuracyOverall ',' num2str(mIdxHandRouteSegAccuracyOverall(i))];
    end
end


fprintf('[Route Seg] Accuracy Max Value Corresponding [Overall Index] = %s;  [Pocket Index] = %s;  [Hand Index] = %s\n', sRouteSegAccuracyOverall, sPocketRouteSegAccuracyOverall, sHandRouteSegAccuracyOverall);




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(3);
hshade = area([0.5 4.5], [100 100], 'FaceColor', myColorAcclT, 'LineStyle', 'none');   % Accl
hold on;

hshade = area([4.5 8.5], [100 100], 'FaceColor', myColorAcclF, 'LineStyle', 'none');   % Gyro
hold on;

hshade = area([8.5 13.5], [100 100], 'FaceColor', myColorAcclTF, 'LineStyle', 'none');    % Accl + Gyro
hold on;

hshade = area([13.5 17.5], [100 100], 'FaceColor', myColorGyroT, 'LineStyle', 'none');    % Baro
hold on;

hshade = area([17.5 21.5], [100 100], 'FaceColor', myColorGyroF, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([21.5 26.5], [100 100], 'FaceColor', myColorGyroTF, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([26.5 36.5], [100 100], 'FaceColor', myColorAcclGyroTF, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([36.5 40.5], [100 100], 'FaceColor', myColorBaroT, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([40.5 46.5], [100 100], 'FaceColor', myColorAcclBaro, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([46.5 51.5], [100 100], 'FaceColor', myColorGyroBaro, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([51.5 58.5], [100 100], 'FaceColor', myColorAllTF, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([58.5 61.5], [100 100], 'FaceColor', myColorAcclT, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([61.5 65.5], [100 100], 'FaceColor', myColorAcclF, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([65.5 69.5], [100 100], 'FaceColor', myColorAcclTF, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([69.5 72.5], [100 100], 'FaceColor', myColorGyroT, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([72.5 76.5], [100 100], 'FaceColor', myColorGyroF, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([76.5 80.5], [100 100], 'FaceColor', myColorGyroTF, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([80.5 83.5], [100 100], 'FaceColor', myColorAcclGyroT, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([83.5 86.5], [100 100], 'FaceColor', myColorAcclGyroTF, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([86.5 89.5], [100 100], 'FaceColor', myColorAllT, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([89.5 92.5], [100 100], 'FaceColor', myColorAllTF, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([92.5 95.5], [100 100], 'FaceColor', myColorAcclT, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([95.5 99.5], [100 100], 'FaceColor', myColorAcclF, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([99.5 102.5], [100 100], 'FaceColor', myColorAcclTF, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([102.5 105.5], [100 100], 'FaceColor', myColorGyroT, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([105.5 109.5], [100 100], 'FaceColor', myColorGyroF, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([109.5 112.5], [100 100], 'FaceColor', myColorGyroTF, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([112.5 115.5], [100 100], 'FaceColor', myColorAcclGyroT, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([115.5 119.5], [100 100], 'FaceColor', myColorAcclGyroF, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([119.5 122.5], [100 100], 'FaceColor', myColorAcclGyroTF, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([122.5 125.5], [100 100], 'FaceColor', myColorAllT, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([125.5 128.5], [100 100], 'FaceColor', myColorAllTF, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;


%%%%%%%%%%%%%%%%%%%%%%

hshade = area([128.5 131.5], [100 100], 'FaceColor', myColorAcclT, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([131.5 135.5], [100 100], 'FaceColor', myColorAcclF, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([135.5 139.5], [100 100], 'FaceColor', myColorAcclTF, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([139.5 142.5], [100 100], 'FaceColor', myColorGyroT, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([142.5 146.5], [100 100], 'FaceColor', myColorGyroF, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([146.5 150.5], [100 100], 'FaceColor', myColorGyroTF, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([150.5 153.5], [100 100], 'FaceColor', myColorAcclGyroT, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([153.5 156.5], [100 100], 'FaceColor', myColorAcclGyroTF, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([156.5 159.5], [100 100], 'FaceColor', myColorAllT, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([159.5 162.5], [100 100], 'FaceColor', myColorAllTF, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([162.5 165.5], [100 100], 'FaceColor', myColorAcclT, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([165.5 169.5], [100 100], 'FaceColor', myColorAcclF, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([169.5 172.5], [100 100], 'FaceColor', myColorAcclTF, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([172.5 175.5], [100 100], 'FaceColor', myColorGyroT, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([175.5 179.5], [100 100], 'FaceColor', myColorGyroF, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([179.5 182.5], [100 100], 'FaceColor', myColorGyroTF, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([182.5 185.5], [100 100], 'FaceColor', myColorAcclGyroT, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([185.5 189.5], [100 100], 'FaceColor', myColorAcclGyroF, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([189.5 192.5], [100 100], 'FaceColor', myColorAcclGyroTF, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([192.5 195.5], [100 100], 'FaceColor', myColorAllT, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([195.5 198.5], [100 100], 'FaceColor', myColorAllT, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

% Compare Accuracy of Which/When (Overall) of Different Feature
% Combination
hLine1 = plot(mStatRouteTraceAccuracy(:,1), 'r-*', 'LineWidth', 3);
hold on;
hLine2 = plot(mStatRouteTraceAccuracy(:,2), 'g-*', 'LineWidth', 3);
hold on;
hLine3 = plot(mStatRouteTraceAccuracy(:,3), 'b-*', 'LineWidth', 3);
hold on;
legend([hLine1, hLine2, hLine3], 'Overall', 'Pocket', 'Hand');
title(gca, 'Accuracy of Which/When (Overall)', 'FontName','Times New Roman', 'FontSize', 30);

set(gca, 'FontName','Times New Roman');
set(gca, 'FontSize', 24);
        
xlabelStr = 'Feature Combinations';

xlabel(xlabelStr, 'FontSize', 30);
ylabel('Accuracy (%)', 'FontSize', 30);
set(gca,'ygrid','on');
ylim([0 100]);
set(gca,'YTick',0:10:100);
set(gca,'xgrid','on');
xlim([0 xMalVal]);
set(gca,'XTick',0:xStep:xMalVal);
set(gca, 'Layer', 'top');

mIdxRouteTraceAccuracyOverall = find(mStatRouteTraceAccuracy(:,1)==max(mStatRouteTraceAccuracy(:,1)));
mIdxPocketRouteTraceAccuracyOverall = find(mStatRouteTraceAccuracy(:,2)==max(mStatRouteTraceAccuracy(:,2)));
mIdxHandRouteTraceAccuracyOverall = find(mStatRouteTraceAccuracy(:,3)==max(mStatRouteTraceAccuracy(:,3)));


sRouteTraceAccuracyOverall = '';
for i = 1:length(mIdxRouteTraceAccuracyOverall)
    if i == 1
        sRouteTraceAccuracyOverall = num2str(mIdxRouteTraceAccuracyOverall(i));
    else
        sRouteTraceAccuracyOverall = [sRouteTraceAccuracyOverall ',' num2str(mIdxRouteTraceAccuracyOverall(i))];
    end
end

sPocketRouteTraceAccuracyOverall = '';
for i = 1:length(mIdxPocketRouteTraceAccuracyOverall)
    if i == 1
        sPocketRouteTraceAccuracyOverall = num2str(mIdxPocketRouteTraceAccuracyOverall(i));
    else
        sPocketRouteTraceAccuracyOverall = [sPocketRouteTraceAccuracyOverall ',' num2str(mIdxPocketRouteTraceAccuracyOverall(i))];
    end
end

sHandRouteTraceAccuracyOverall = '';
for i = 1:length(mIdxHandRouteTraceAccuracyOverall)
    if i == 1
        sHandRouteTraceAccuracyOverall = num2str(mIdxHandRouteTraceAccuracyOverall(i));
    else
        sHandRouteTraceAccuracyOverall = [sHandRouteTraceAccuracyOverall ',' num2str(mIdxHandRouteTraceAccuracyOverall(i))];
    end
end


fprintf('[Route Trace] Accuracy Max Value Corresponding [Overall Index] = %s;  [Pocket Index] = %s;  [Hand Index] = %s\n', sRouteTraceAccuracyOverall, sPocketRouteTraceAccuracyOverall, sHandRouteTraceAccuracyOverall);







%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(4);
hshade = area([0.5 4.5], [100 100], 'FaceColor', myColorAcclT, 'LineStyle', 'none');   % Accl
hold on;

hshade = area([4.5 8.5], [100 100], 'FaceColor', myColorAcclF, 'LineStyle', 'none');   % Gyro
hold on;

hshade = area([8.5 13.5], [100 100], 'FaceColor', myColorAcclTF, 'LineStyle', 'none');    % Accl + Gyro
hold on;

hshade = area([13.5 17.5], [100 100], 'FaceColor', myColorGyroT, 'LineStyle', 'none');    % Baro
hold on;

hshade = area([17.5 21.5], [100 100], 'FaceColor', myColorGyroF, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([21.5 26.5], [100 100], 'FaceColor', myColorGyroTF, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([26.5 36.5], [100 100], 'FaceColor', myColorAcclGyroTF, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([36.5 40.5], [100 100], 'FaceColor', myColorBaroT, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([40.5 46.5], [100 100], 'FaceColor', myColorAcclBaro, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([46.5 51.5], [100 100], 'FaceColor', myColorGyroBaro, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([51.5 58.5], [100 100], 'FaceColor', myColorAllTF, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([58.5 61.5], [100 100], 'FaceColor', myColorAcclT, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([61.5 65.5], [100 100], 'FaceColor', myColorAcclF, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([65.5 69.5], [100 100], 'FaceColor', myColorAcclTF, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([69.5 72.5], [100 100], 'FaceColor', myColorGyroT, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([72.5 76.5], [100 100], 'FaceColor', myColorGyroF, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([76.5 80.5], [100 100], 'FaceColor', myColorGyroTF, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([80.5 83.5], [100 100], 'FaceColor', myColorAcclGyroT, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([83.5 86.5], [100 100], 'FaceColor', myColorAcclGyroTF, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([86.5 89.5], [100 100], 'FaceColor', myColorAllT, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([89.5 92.5], [100 100], 'FaceColor', myColorAllTF, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([92.5 95.5], [100 100], 'FaceColor', myColorAcclT, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([95.5 99.5], [100 100], 'FaceColor', myColorAcclF, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([99.5 102.5], [100 100], 'FaceColor', myColorAcclTF, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([102.5 105.5], [100 100], 'FaceColor', myColorGyroT, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([105.5 109.5], [100 100], 'FaceColor', myColorGyroF, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([109.5 112.5], [100 100], 'FaceColor', myColorGyroTF, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([112.5 115.5], [100 100], 'FaceColor', myColorAcclGyroT, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([115.5 119.5], [100 100], 'FaceColor', myColorAcclGyroF, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([119.5 122.5], [100 100], 'FaceColor', myColorAcclGyroTF, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([122.5 125.5], [100 100], 'FaceColor', myColorAllT, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([125.5 128.5], [100 100], 'FaceColor', myColorAllTF, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;


%%%%%%%%%%%%%%%%%%%%%%

hshade = area([128.5 131.5], [100 100], 'FaceColor', myColorAcclT, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([131.5 135.5], [100 100], 'FaceColor', myColorAcclF, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([135.5 139.5], [100 100], 'FaceColor', myColorAcclTF, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([139.5 142.5], [100 100], 'FaceColor', myColorGyroT, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([142.5 146.5], [100 100], 'FaceColor', myColorGyroF, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([146.5 150.5], [100 100], 'FaceColor', myColorGyroTF, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([150.5 153.5], [100 100], 'FaceColor', myColorAcclGyroT, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([153.5 156.5], [100 100], 'FaceColor', myColorAcclGyroTF, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([156.5 159.5], [100 100], 'FaceColor', myColorAllT, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([159.5 162.5], [100 100], 'FaceColor', myColorAllTF, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([162.5 165.5], [100 100], 'FaceColor', myColorAcclT, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([165.5 169.5], [100 100], 'FaceColor', myColorAcclF, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([169.5 172.5], [100 100], 'FaceColor', myColorAcclTF, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([172.5 175.5], [100 100], 'FaceColor', myColorGyroT, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([175.5 179.5], [100 100], 'FaceColor', myColorGyroF, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([179.5 182.5], [100 100], 'FaceColor', myColorGyroTF, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([182.5 185.5], [100 100], 'FaceColor', myColorAcclGyroT, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([185.5 189.5], [100 100], 'FaceColor', myColorAcclGyroF, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([189.5 192.5], [100 100], 'FaceColor', myColorAcclGyroTF, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([192.5 195.5], [100 100], 'FaceColor', myColorAllT, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

hshade = area([195.5 198.5], [100 100], 'FaceColor', myColorAllT, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

% Compare Accuracy of Which (Overall) of Different Feature
% Combination
hLine1 = plot(mStatRouteAccuracy(:,1), 'r-*', 'LineWidth', 3);
hold on;
hLine2 = plot(mStatRouteAccuracy(:,2), 'g-*', 'LineWidth', 3);
hold on;
hLine3 = plot(mStatRouteAccuracy(:,3), 'b-*', 'LineWidth', 3);
hold on;
legend([hLine1, hLine2, hLine3], 'Overall', 'Pocket', 'Hand');
title(gca, 'Accuracy of Which (Overall)', 'FontName','Times New Roman', 'FontSize', 30);

set(gca, 'FontName','Times New Roman');
set(gca, 'FontSize', 24);
        
xlabelStr = 'Feature Combinations';

xlabel(xlabelStr, 'FontSize', 30);
ylabel('Accuracy (%)', 'FontSize', 30);
set(gca,'ygrid','on');
ylim([0 100]);
set(gca,'YTick',0:10:100);
set(gca,'xgrid','on');
xlim([0 xMalVal]);
set(gca,'XTick',0:xStep:xMalVal);
set(gca, 'Layer', 'top');

mIdxRouteAccuracyOverall = find(mStatRouteAccuracy(:,1)==max(mStatRouteAccuracy(:,1)));
mIdxPocketRouteAccuracyOverall = find(mStatRouteAccuracy(:,2)==max(mStatRouteAccuracy(:,2)));
mIdxHandRouteAccuracyOverall = find(mStatRouteAccuracy(:,3)==max(mStatRouteAccuracy(:,3)));


sRouteAccuracyOverall = '';
for i = 1:length(mIdxRouteAccuracyOverall)
    if i == 1
        sRouteAccuracyOverall = num2str(mIdxRouteAccuracyOverall(i));
    else
        sRouteAccuracyOverall = [sRouteAccuracyOverall ',' num2str(mIdxRouteAccuracyOverall(i))];
    end
end

sPocketRouteAccuracyOverall = '';
for i = 1:length(mIdxPocketRouteAccuracyOverall)
    if i == 1
        sPocketRouteAccuracyOverall = num2str(mIdxPocketRouteAccuracyOverall(i));
    else
        sPocketRouteAccuracyOverall = [sPocketRouteAccuracyOverall ',' num2str(mIdxPocketRouteAccuracyOverall(i))];
    end
end

sHandRouteAccuracyOverall = '';
for i = 1:length(mIdxHandRouteAccuracyOverall)
    if i == 1
        sHandRouteAccuracyOverall = num2str(mIdxHandRouteAccuracyOverall(i));
    else
        sHandRouteAccuracyOverall = [sHandRouteAccuracyOverall ',' num2str(mIdxHandRouteAccuracyOverall(i))];
    end
end


fprintf('[Route] Accuracy Max Value Corresponding [Overall Index] = %s;  [Pocket Index] = %s;  [Hand Index] = %s\n', sRouteAccuracyOverall, sPocketRouteAccuracyOverall, sHandRouteAccuracyOverall);







return;





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Compare performance with different Feature Combination

mFeatureCombinationIdx = [2 10 12 20 22 25 28 31 33 40 44]; % Index of Feature Combination to Compare

mCompareCombinationAllAccuracy = mStatAllAccuracy(mFeatureCombinationIdx, :);

mCompareCombinationRouteSegAccuracy = mStatRouteSegAccuracy(mFeatureCombinationIdx, :);

mCompareCombinationAllAccuracy = mCompareCombinationAllAccuracy*100.0;
mCompareCombinationRouteSegAccuracy = mCompareCombinationRouteSegAccuracy*100.0;


xTickTextSegLen = [];
for i = 1:length(mFeatureCombinationIdx)
    xTickTextSegLen{i} = num2str(i);
end

% Compare Different Feature Combinations (Corresponding to Different usage
% of Sensors) based on Accuracy of Which/Where/When
figure(3);

bar(mCompareCombinationAllAccuracy);  %colormap(gray);

title(gca, 'Accuracy of Which/Where/When', 'FontName','Times New Roman', 'FontSize', 30);

set(gca, 'FontName','Times New Roman');
set(gca, 'FontSize', 30);
        
set(gca, 'XTickLabel', xTickTextSegLen);
set(gca,'YTick',0:10:100);
    
xlabelStr = 'Index of Feature Combination';

xlabel(xlabelStr, 'FontSize', 36);
ylabel('Accuracy (%)', 'FontSize', 36);
set(gca,'ygrid','on');
ylim([0 100]);
legend('Overall', 'Pocket', 'Hand');



% Compare Different Feature Combinations (Corresponding to Different usage
% of Sensors) based on Accuracy of Which/Where
figure(4);

bar(mCompareCombinationRouteSegAccuracy);  %colormap(gray);

title(gca, 'Accuracy of Which/Where', 'FontName','Times New Roman', 'FontSize', 30);

set(gca, 'FontName','Times New Roman');
set(gca, 'FontSize', 30);
        
set(gca, 'XTickLabel', xTickTextSegLen);
set(gca,'YTick',0:10:100);
    
xlabelStr = 'Index of Feature Combination';

xlabel(xlabelStr, 'FontSize', 36);
ylabel('Accuracy (%)', 'FontSize', 36);
set(gca,'ygrid','on');
ylim([0 100]);
legend('Overall', 'Pocket', 'Hand');


disp('>>>>>>>>>>>>>>DONE<<<<<<<<<<<<<<');

return;