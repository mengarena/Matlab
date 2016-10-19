function f = SS_TrainHMM(nState, nObservation, mObSeq)
% This function is used to train HMM.
%
% Parameter:
%     @ nState:  Number of hidden status
%     @ nObservation:  Number of observation
%     @ mObSeq:   Sequence of observation (it is the sequence of feature
%     vectors. Here the feature vectors have been clustered. So the
%     sequence here is actually 
%

format long;

% Generate initial Transition matrix (i.e. A)
mTRANS = [];
% Uniform distribution
for i=1:nState
    for j=1:nState
        mTRANS(i,j) = 1.0/nState;
    end
end

% Generate initial Emission matrix (i.e. B)
mEMIS = [];

% Uniform distribution
for i=1:nState
    for j=1:nObservation
        mEMIS(i,j) = 1.0/nObservation;
    end
end

[TRANS_EST, EMIS_EST] = hmmtrain(mObSeq, mTRANS, mEMIS);

f = [TRANS_EST ,EMIS_EST];

return;
