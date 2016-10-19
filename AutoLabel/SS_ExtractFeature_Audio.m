function [matEng, matZcr, matMfcc] = SS_ExtractFeature_Audio(sAudioFile, nFrameLen, nFrameStep, nPreCut, fPostCut, nUsageType, fDataRatio)
% This function is used to extract the frame-based features from audio
% file.
% It extract the following features:
%   1) Frame energy
%   2) Zero crossing rate
%   3) MFCC 
%
% Parameter:
%   @ sAudioFile:  Audio file (.wav)
%   @ nSampleRate:  Sample rate (e.g. 44100)
%   @ nFrameLen (ms):   Length of a frame in milli-second (e.g. 40 ms)
%   @ nFrameStep (ms):  Step of frames (i.e. overlap) in milli-second (e.g. 20 ms)
%   @ nPreCut (s):    How many seconds could be cut from the beginning of the
%   Audio file, e.g. 15 seconds (During data collection, user needs to start the program
%   outside of the store and then enter the store. so usually the first 15
%   seconds of the audio file contains data collected outside of the store.
%   so not used.
%   @ fPostCut (%):   The percentage at the end of the audio file, which should
%   not be used. (During data collection, when the user walked out the
%   store, he needs to stop the data collection program. The program needs
%   to write the data in the buffer onto SD card. If there are many data,
%   it needs more time to write, during this period, the audio collection
%   might still be going on.) So usually, 10% is cut off.
%   @ nUsageType:  The usage of the feature: 1--for Training;  2--for Test
%   @ fDataRatio (%): The data between the beginning-cut and end-cut is considered as valid. 
%   But as a data, some will be used for training, some might be used for validate and some might be used for test.
%   so here fDataRatio is deciding the percentage of the data used for training or test. 
%   If it is for training, this percentage will be taken from the beginning of the valid data.
%   If it is for test, this percentage will be taken at the end of the valid data.
%   It is usually set as 0.8 for training, 0.2 for test.
%
% Flow:
%   1) Read wav file and get one-channel data; the data is in time-domain.
%   2) Extract a frame
%   3) Calculate energy:  by using RMS of the amplitude
%   4) Calculate the Zero crossing rate
%   5) Call mfcc to calculate mfcc
%   6) Possibly other features
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

format long;

matEng = [];
matZcr = [];
matMfcc = [];

[data, nSampleRate] = wavread(sAudioFile);

nFrameSampleCnt = floor(nSampleRate*nFrameLen/1000);  % #Samples in a frame
nStepSampleCnt = floor(nSampleRate*nFrameStep/1000);  % #Samples in a step

nPreCutSampleCnt = nSampleRate*nPreCut;  % The number of samples should be thrown away at the beginning of the audio file

% Only one channel
Y = data(:,1);

nTotalLen = length(Y);

nPostCutSampleCnt = floor(nTotalLen*fPostCut);   % The number of samples should be thrown away at the end of the audio file

nValidSampleCnt = nTotalLen - nPreCutSampleCnt - nPostCutSampleCnt;   % Total valid sample
nUsedSampleCnt = floor(nValidSampleCnt*fDataRatio);   % The number of samples will be used (for training or test)

if nUsageType == 1  % For training
    nFirstSample = nPreCutSampleCnt + 1;
    nLastSample = nPreCutSampleCnt + nUsedSampleCnt;   % The last frame which will be used for training
else % For test
    nFirstSample = nPreCutSampleCnt + nValidSampleCnt - nUsedSampleCnt + 1;
    nLastSample = nPreCutSampleCnt + nValidSampleCnt;
end

nFrameStart = nFirstSample;
nFrameEnd = nFrameStart + nFrameSampleCnt - 1;

% Here is the parameter for MFCC
Tw = nFrameLen;     % frame duration (ms)
Ts = nFrameStep;    % frame shift (ms)
alpha = 0.95;       % pre-empahsis coefficient
M = 20;             % number of filterbank channels
C = 12;             % number of cepstral coefficients
L = 22;             % cepstral sine lifter parameter
LF = 0;             % lower frequency limit (Hz)
HF = floor(nSampleRate/2);  % upper frequency limit (Hz)

nFeatureIdx = 0;

% Move frames to calcualte features
while nFrameEnd <= nLastSample
    mFrame = Y(nFrameStart:nFrameEnd, 1);
    
    fRMS = rms(mFrame);   % Frame energy
    fZCR = SS_ZeroCrossRate(mFrame);  % Zero crossing rate
    
    [mMFCC, FBEs, frames] = mfcc(mFrame, nSampleRate, Tw, Ts, alpha, @hamming, [LF HF], M, C+1, L);   % Calcualte MFCC
    
    nFeatureIdx = nFeatureIdx + 1;
    
    matEng(nFeatureIdx, 1) = fRMS; 
    matZcr(nFeatureIdx, 1) = fZCR;
    matMfcc(nFeatureIdx, :) = mMFCC';
    
    % Move to next frame
    nFrameStart = nFrameStart  + nStepSampleCnt;
    nFrameEnd = nFrameEnd + nStepSampleCnt;
end

f = [matEng, matZcr, matMfcc];

return;


