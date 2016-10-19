function f = SS_AudioResampleSplit(fid_resultNonBatch, sOrigAudioFile, nStartTime, fEndPortion, nTargetFs, nChunkSize)
% This function is used to resample audio file and split the original audio
% file into small chuck sizes
% Result files are Mono (1 channel)
%
% Parameter:
%   @ fid_resultNonBatch:  The file handler of nonBatch
%   (=pocketsphinx_continuous.exe command line) file
%   For example:  pocketsphinx_continuous -hmm ./hmm/en-us/ -lm
%   ./lm/en-us.dmp -dict ./dict/cmu07a.dic -infile ./audiofile/wg.wav >>
%   result.txt
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

[pathstr, filename, ext] = fileparts(sOrigAudioFile);

sNonBatchSphinxRecogResult = [pathstr '\NonBatchSphinxRecogResult.txt'];

sHmm = './hmm/en-us/';
sLm = './lm/cmusphinx-5.0-en-us.lm.dmp';
sDict = './dict/cmu07a.dic';

sCtlFile = [pathstr '\ctlFile.txt'];
fid_result = fopen(sCtlFile, 'w');

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
    sChunkAudioFile = [pathstr '\' filename '_' num2str(i) ext];
    nStart = (i-1)*nChunkLength + 1;
    nEnd = i*nChunkLength;
    wavwrite(Ytarget(nStart:nEnd,1), nFinalFs, sChunkAudioFile);
    
    fprintf(fid_resultNonBatch, 'pocketsphinx_continuous.exe -hmm %s -lm %s -dict %s -infile %s >> %s\n', sHmm, sLm, sDict, sChunkAudioFile, sNonBatchSphinxRecogResult);
    
    sFileName = [filename '_' num2str(i)];
    fprintf(fid_result, '%s\n', sFileName);
end

% Last Chunk
nStart = nChunkCnt*nChunkLength + 1;
nEnd = nTotalSample;

sChunkAudioFile = [pathstr '\' filename '_' num2str(nChunkCnt+1) ext];

if nStart < nEnd
    wavwrite(Ytarget(nStart:nEnd,1), nFinalFs, sChunkAudioFile);

    fprintf(fid_resultNonBatch, 'pocketsphinx_continuous.exe -hmm %s -lm %s -dict %s -infile %s >> %s\n', sHmm, sLm, sDict, sChunkAudioFile, sNonBatchSphinxRecogResult);

    sFileName = [filename '_' num2str(nChunkCnt+1)];
    fprintf(fid_result, '%s\n', sFileName);
end

fclose(fid_result);

return;
