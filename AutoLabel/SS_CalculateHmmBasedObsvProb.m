function f = SS_CalculateHmmBasedObsvProb(mTestObservation, nMeans, sGroundTruth)
% This function is used to calculate the HMM model based (posterior)
% probabilities for an observation sequance based on each HMM model.
% The HMM model which gives the highest probability should be the class for
% the given observation sequence.
%
% Parameter: 
%   @ mTestObservation: The observation sequence which should be classified
%   by the HMMs
%   @ nMeans:  The value of K used in K-means when classified the test
%   feature vector (and also the training feature vector)
%   @sGroundTruth:  The ground truth place name
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

format long;

% HMM models
% Number of states
mState = [3 6 9 12 15 18];

sBaseFolder = 'E:\UIUC\TryAudioModel\';

sModelNames = [ ...
    'BarnesNoble              '; ...
    'Cravings                 '; ... 
    'Walsgreen                '; ...
    'CSL                      '; ...
    'Street                   '
];

cellModelNames = cellstr(sModelNames);

for i=1:length(mState)
    mTmpProb = [];
    nIdx = 0;
    fMax = -1000000;
    nClass = 0;

    % Try to be classified by every HMM models
    for k=1:length(cellModelNames)
        sTransMatrixFile = [sBaseFolder 'HmmMatrix\' cellModelNames{k} '_HMM_TRANS_' num2str(mState(i)) '_'  num2str(nMeans) '.csv'];
        sEmisMatrixFile = [sBaseFolder 'HmmMatrix\' cellModelNames{k} '_HMM_EMIS_' num2str(mState(i)) '_'  num2str(nMeans) '.csv'];

        mTrans = load(sTransMatrixFile);
        mEmis = load(sEmisMatrixFile);

        [pStates, logpSeq]  = hmmdecode(mTestObservation, mTrans, mEmis);

         nIdx = nIdx + 1;
         mTmpProb(nIdx) = logpSeq;
         if fMax < logpSeq
            fMax = logpSeq;
            nClass = k;
         end

    end

    % In each result file, the line will be:
    % Classified Class ID, probability of being HMM1 class, probability of being HMM2 class, ... 
    sResultProbFile = [sBaseFolder 'HMMClassifiedTestData\HMMClassificationResult_' sGroundTruth '_' num2str(mState(i)) '_' num2str(nMeans) '.csv'];
    fid_result = fopen(sResultProbFile, 'w');

    % Classified Class
    fprintf(fid_result, '%d', nClass);

    for mm = 1:nIdx
        fprintf(fid_result, ',%f', mTmpProb(mm));
    end

    fprintf(fid_result, '\n');
    fclose(fid_result);
end

return;
