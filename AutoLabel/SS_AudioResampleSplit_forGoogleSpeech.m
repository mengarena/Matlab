function f = SS_AudioResampleSplit_forGoogleSpeech(fid_flac, fid_wget, sOrigAudioFile, nStartTime, fEndPortion, nTargetFs, nChunkSize)
% This function is used to resample audio file and split the original audio
% file into small chuck sizes
% Result files are Mono (1 channel)
%
% This function also generate the command lines for FLAC to convert audio
% files from .wav to .flac
%
% Parameter:
%   @ fid_flac:  File handler for FLAC group script (this script will be
%   used to convert .wav into .flac)
%   Command line example:  flac  aaa.wav
%   @ fid_wget:  File handler for Wget group script (this script will be
%   used to do speech recognition with Google Speech service)
%   Command line example:  wget --post-file good.flac --header "Content-Type: audio/x-flac; rate=44100" -O - "http://www.google.com/speech-api/v2/recognize?lang=en-US&output=json&key=AIzaSyC2LBqd8Io-plDpqXKFI8k-pvMBnfImkLI" >> resultServer.txt
%   @ sOrigAudioFile:  Original audio file
%   @ nStartTime:  The valid start time (unit: s) of the audio file
%   @ fEndPortion:  The invalid end portion of the audio file (e.g. 0.1
%   means the last 10% of the audio file is invalid).
%   @ nTargetFs:    Target sample rate. If nTargetFs = 0, use original
%   sample rate.
%   @ nChunkSize:   Result chunk size (unit: s)
%

format long;

warning('off','all');

sGoogleSpeechKey = 'AIzaSyC2LBqd8Io-plDpqXKFI8k-pvMBnfImkLI';

[pathstr, filename, ext] = fileparts(sOrigAudioFile);

sGoogleSpeechResultFile = [pathstr '\GoogleSpeechRecogResult.txt'];

[Y, Fs] = wavread(sOrigAudioFile);

[r c] = size(Y);

nStartSamplePoint = Fs*nStartTime + 1;
nEndSamplePoint = floor(r*(1-fEndPortion));

Y1 = Y(nStartSamplePoint:nEndSamplePoint,1);

if nTargetFs == 0       % Use original sample rate
    Ytarget = Y1;
    nFinalFs = Fs;
else
    Ytarget = resample(Y1, nTargetFs, Fs);  % Resample to the target sample
    nFinalFs = nTargetFs;
end

nTotalSample = length(Ytarget);    

nChunkLength = nFinalFs * nChunkSize;

nChunkCnt = floor(nTotalSample/nChunkLength);  % How many chunks

for i=1:nChunkCnt
    sChunkAudioFile = [pathstr '\' 'g_' filename '_' num2str(i) ext];  % For Google Speech
    nStart = (i-1)*nChunkLength + 1;
    nEnd = i*nChunkLength;
    wavwrite(Ytarget(nStart:nEnd,1), nFinalFs, sChunkAudioFile);
        
    fprintf(fid_flac, 'flac %s\n', sChunkAudioFile);
    
    sFlacFile = [pathstr '\' 'g_' filename '_' num2str(i) '.flac'];
    fprintf(fid_wget, 'wget --post-file %s --header "Content-Type: audio/x-flac; rate=%d" -O - "http://www.google.com/speech-api/v2/recognize?lang=en-US&output=json&key=%s" >> %s\n', sFlacFile, nFinalFs, sGoogleSpeechKey, sGoogleSpeechResultFile);
end

% Last Chunk
nStart = nChunkCnt*nChunkLength + 1;
nEnd = nTotalSample;

sChunkAudioFile = [pathstr '\' 'g_' filename '_' num2str(nChunkCnt+1) ext];

if nStart < nEnd
    wavwrite(Ytarget(nStart:nEnd,1), nFinalFs, sChunkAudioFile);
    
    fprintf(fid_flac, 'flac %s\n', sChunkAudioFile);
    
    sFlacFile = [pathstr '\' 'g_' filename '_' num2str(nChunkCnt+1) '.flac'];
    fprintf(fid_wget, 'wget --post-file %s --header "Content-Type: audio/x-flac; rate=%d" -O - "http://www.google.com/speech-api/v2/recognize?lang=en-US&output=json&key=%s" >> %s\n', sFlacFile, nFinalFs, sGoogleSpeechKey, sGoogleSpeechResultFile);
end

return;
