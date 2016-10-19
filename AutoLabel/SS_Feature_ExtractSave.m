function f = SS_Feature_ExtractSave(sAudioFile, nUsageType, fDataRatio)
% This function is used to extract the features from the given audio file
% ane save it in a feature file.
% If audiofile is e:\ddd\eee.txt,  the feature file will be
% e:\ddd\eee_Feature_Train.csv
%
% Parameter:
%   @ sAudioFile:  The file path name of the audio file
%   @ nUsageType:  What is the usage of the feature:
%               1:   For Training---The feature will be extracted from the
%               fDataRatio of the data from the beginning of the valid data
%               2:   for Test---The feature will be extracted from the last
%               fDataRatio of the valid data
%   @ fDataRatio:  The portion of the valid data used to extract features
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

format long;

% Parameter:
%%%nSampleRate = 44100;
nFrameLen = 40;  % ms
nFrameStep = 20; % ms
nPreCut = 15;    % s
fPostCut = 0.1;  % 10%

[pathstr, filename, ext] = fileparts(sAudioFile);

if nUsageType == 1
    sFeatureFile = [pathstr '\' filename '_Feature_Train.csv'];
elseif nUsageType == 2
    sFeatureFile = [pathstr '\' filename '_Feature_Test.csv'];
else
    sFeatureFile = [pathstr '\' filename '_Feature.csv'];
    nUsageType = 1;  % Let it extract from the beginning
end

%%%[matEng, matZcr, matMfcc] = SS_ExtractFeature_Audio(sAudioFile, nSampleRate, nFrameLen, nFrameStep, nPreCut, fPostCut, nUsageType, fDataRatio);
[matEng, matZcr, matMfcc] = SS_ExtractFeature_Audio(sAudioFile, nFrameLen, nFrameStep, nPreCut, fPostCut, nUsageType, fDataRatio);

nFeatureLen = length(matEng);

[nRow nCol] = size(matMfcc);

% Save feature into file; all the feature for a frame will be in one line
fid_result = fopen(sFeatureFile,'w');
 
for i = 1:nFeatureLen
    fprintf(fid_result,'%f,%f', matEng(i,1),  matZcr(i,1));
    for j=1:nCol
        fprintf(fid_result,',%f', matMfcc(i,j));
    end
    fprintf(fid_result,'\n');
end

fclose(fid_result);

return;

