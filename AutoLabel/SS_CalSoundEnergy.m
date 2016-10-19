function f = SS_CalSoundEnergy(sWavFile, nChannelIdx, nStartSample, nEndSample, nSampleRate, nFrameTime)
% This function calculate the energy of the sound file with Root Mean
% Square
%
% sWavFile:  File path of the wave file
% nChannelIdx:  Channel index (i.e. which channel to use)
% nStartSample: Which sample to use as starting point
% nEndSample: Which sample to use as ending point
% nSampleRate:  Sample rate of the wav file
% nFrameTime: Time of each frame (Unit: ms)
%

format long;

y0 = wavread(sWavFile);

y = y0(nStartSample:nEndSample,nChannelIdx);

nFrameWidth = floor(nSampleRate/(1000/nFrameTime));

nNumSamples = length(y);
nNumFrames = floor(nNumSamples/nFrameWidth);

mEnergy = zeros(1,nNumFrames);
mStartSample = zeros(1, nNumFrames);
mEndSample = zeros(1, nNumFrames);

for nFrameIdx = 1:nNumFrames
   mStartSample(nFrameIdx) = (nFrameIdx-1)*nFrameWidth + 1;
   mEndSample(nFrameIdx) = nFrameIdx*nFrameWidth;
   mFrameIndex = mStartSample(nFrameIdx):mEndSample(nFrameIdx);
   fFrameSum = sum(y(mFrameIndex).^2);
   mEnergy(nFrameIdx) = sqrt(fFrameSum/nFrameWidth);
end

fAvgEnergy = mean(mEnergy);
fStdEnergy = std(mEnergy);

str1 = strcat('Avg Energy = ', num2str(fAvgEnergy));
str2 = strcat(',  Std Energy = ', num2str(fStdEnergy));
strTotal = strcat(str1, str2);
disp(strTotal);

return;
