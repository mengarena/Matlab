function f = SS_ClassifyAudioClip(sAudioFile, nStartTime, nEndTime)
% This function is used to classify the audio clip based on HMM
% When an audio clip is given, classify it with a set of HMMs
%
% @ Usage Example: SS_ClassifyAudioClip('E:\tmp\aa.wav', 0, 5)
% @ nStartTime:  Start time of the audio clip, unit: second
% @ nEndTime:  End time of the audio clip, unit; second
% 
% Pre-condition:
%   A) The Mean/Std during standardizing the training data is available (which are used to standardize the audio clip data
%   B) A set of HMMs have been trained and the corresponding transition and
%   emission matrix are available.
%
% Steps:
%   1) Extract feature vectors
%   2) Standardize the feature vectors according to the Mean/Std generated
%   during large-scale standardization during pre-processing training data
%   3) Classify the standardized featuer vectors with K-means centroid,
%   which generate the Class ID sequence, i.e. Observation sequence
%   4) Classify the Observation sequence with HMMs, the HMM which gives the
%   highest probability is the Class for the audio clip
%
% Parameter:
%   @ sAudioFile:   The audio file
%   @ nStartTime:   (Unit: S, start from 0) The start time of the audio clip to be classified
%   @ nEndTime:     (Unit: S) The end time of the audio clip to be classified
%   * For nStartTime and nEndTime:  [nStartTime, nEndTime)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
fprintf('Start Time: %s\n', datestr(clock, 'yyyy-mm-dd HH:MM:SS'));

format long;

% How many hidden states and Observation to use
nState = 12;
nObservation = 20;

sBaseFolder = 'E:\UIUC\TryAudioModel\';

% Centroid of K-Means
sKmeansCentroidFile = [sBaseFolder 'KMeansResult\' 'KmeansCentroid_' num2str(nObservation) '.csv'];
mKmeansCentroid = load(sKmeansCentroidFile);

% Mean/Std for standardization
sStandardizationParamFile = [sBaseFolder  'StandarizationParam\' 'StandarizationParam_' num2str(nObservation) '.csv'];
mStandardizationParam = load(sStandardizationParamFile);

% Parameter:
nFrameLen = 40;  % ms
nFrameStep = 20; % ms

[data, nSampleRate] = wavread(sAudioFile);

nFrameSampleCnt = floor(nSampleRate*nFrameLen/1000);  % #Samples in a frame
nStepSampleCnt = floor(nSampleRate*nFrameStep/1000);  % #Samples in a step

% Only one channel
Y = data(:,1);

nTotalLen = length(Y);

nFirstSample = nSampleRate*nStartTime + 1;
nLastSample = nSampleRate*nEndTime;

% Here is the parameter for MFCC
Tw = nFrameLen;     % frame duration (ms)
Ts = nFrameStep;    % frame shift (ms)
alpha = 0.95;       % pre-empahsis coefficient
M = 20;             % number of filterbank channels
C = 12;             % number of cepstral coefficients
L = 22;             % cepstral sine lifter parameter
LF = 0;             % lower frequency limit (Hz)
HF = floor(nSampleRate/2);  % upper frequency limit (Hz)

mFeatureVector = [];
nCnt = 0;

nFrameStart = nFirstSample;
nFrameEnd = nFrameStart + nFrameSampleCnt - 1;

% Step 1: Move frames to extract features
while nFrameEnd <= nLastSample
    mFrame = Y(nFrameStart:nFrameEnd, 1);
    
    fRMS = rms(mFrame);   % Frame energy
    fZCR = SS_ZeroCrossRate(mFrame);  % Zero crossing rate
    
    [mMFCC, FBEs, frames] = mfcc(mFrame, nSampleRate, Tw, Ts, alpha, @hamming, [LF HF], M, C+1, L);   % Calcualte MFCC
            
    nCnt = nCnt + 1;
    mFeatureVector(nCnt, 1) = fRMS; % Energy
    mFeatureVector(nCnt, 2) = fZCR;
    
    [nRow nCol] = size(mMFCC);
    for i=1:nRow
        mFeatureVector(nCnt, i+2) = mMFCC(i,1);
    end
    
    % Move to next frame
    nFrameStart = nFrameStart  + nStepSampleCnt;
    nFrameEnd = nFrameEnd + nStepSampleCnt;
end

% Step 2: Standardize the feature vectors based on the Mean/Std
mFeatureVectorZ = [];
[nRow nCol] = size(mFeatureVector);

for t = 1:nRow
    for s = 1:nCol
        mFeatureVectorZ(t,s) = (mFeatureVector(t,s) - mStandardizationParam(s,1))/mStandardizationParam(s,2);
    end
end

% Step 3: Classify standardized feature vectors based on the K-mean Centroid
% i.e. Get the Observation sequence
mClassID = SS_ClassifyBasedOnKmeans(mKmeansCentroid, mFeatureVectorZ);

% Step 4: Classify the Observation sequence with HMMs
% HMM models
sModelNames = [ ...
    'BarnesNoble              '; ...
    'Cravings                 '; ... 
    'Walsgreen                '; ...
    'CSL                      '; ...
    'Street                   '
];

cellModelNames = cellstr(sModelNames);

mHmmClassifiedResult = [];  % Store the probability of each HMM classification

nIdx = 0;
fMax = -1000000;
nClass = 0;

% Try to be classified by every HMM models
for k=1:length(cellModelNames)
    sTransMatrixFile = [sBaseFolder 'HmmMatrix\' cellModelNames{k} '_HMM_TRANS_' num2str(nState) '_'  num2str(nObservation) '.csv'];
    sEmisMatrixFile = [sBaseFolder 'HmmMatrix\' cellModelNames{k} '_HMM_EMIS_' num2str(nState) '_'  num2str(nObservation) '.csv'];

    mTrans = load(sTransMatrixFile);
    mEmis = load(sEmisMatrixFile);

    [pStates, logpSeq]  = hmmdecode(mClassID, mTrans, mEmis);

     nIdx = nIdx + 1;
     mHmmClassifiedResult(nIdx) = logpSeq;
end

[maxProb nClassIdx] = max(mHmmClassifiedResult);

f = nClassIdx;   % The given audio clip belongs to this Class

fprintf('Store Category is: %s\n', cellModelNames{nClassIdx});

fprintf('Finish Time: %s\n', datestr(clock, 'yyyy-mm-dd HH:MM:SS'));

return;
