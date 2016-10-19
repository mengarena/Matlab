function f = SS_TrainParticularHMM(nState, nObservation, sObservationFile)
% Train a particular HMM for the given Observation file
%
% Parameter:
%   @ nState: The number of status
%   @ nObservation: The number of observation
%   @ sObservationFile: Sequence of observation
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

mObSeq = load(sObservationFile);

mTrainRet = SS_TrainHMM(nState, nObservation, mObSeq);

mTRANS_EST = mTrainRet(1:nState, 1:nState);
mEMIS_EST = mTrainRet(1:nState, nState+1:nState+nObservation);

[pathstr, filename, ext] = fileparts(sObservationFile);

C = strsplit(filename, '_');

sBaseFolder = 'E:\UIUC\TryAudioModel\';

% Save state transition matrix
sTransFile = [sBaseFolder 'HmmMatrix\' C{1} '_HMM_TRANS_' num2str(nState) '_' num2str(nObservation) '.csv'];

fid_resultTrans = fopen(sTransFile, 'w');

[nTransRow nTransCol] = size(mTRANS_EST);
for i=1:nTransRow
    for j=1:nTransCol
        fprintf(fid_resultTrans, '%f,', mTRANS_EST(i,j));
    end
    fprintf(fid_resultTrans, '\n');
end

fclose(fid_resultTrans);

% Save observation emission matrix
sEmisFile = [sBaseFolder 'HmmMatrix\' C{1} '_HMM_EMIS_' num2str(nState) '_' num2str(nObservation) '.csv'];

fid_resultEmis = fopen(sEmisFile, 'w');

[nEmisRow nEmisCol] = size(mEMIS_EST);
for i=1:nEmisRow
    for j=1:nEmisCol
        fprintf(fid_resultEmis, '%f,', mEMIS_EST(i,j));
    end
    fprintf(fid_resultEmis, '\n');
end

fclose(fid_resultEmis);

f = 0;

return;
