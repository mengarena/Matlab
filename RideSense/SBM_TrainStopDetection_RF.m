function f = SBM_TrainStopDetection_RF(mFeature, mLabel, sResultModelFile, nTreeNum)
% This function is used to train a stop detection, which uses Random Forest
%

format long;

SBM_StopDetection_RF = TreeBagger(nTreeNum, mFeature, mLabel, 'Method', 'classification');

save(sResultModelFile, 'SBM_StopDetection_RF');


%% Next time, want to use the model, do following:
%
% RFmodel = load(sResultModelFile);
% SBM_StopDetection_RF = RFmodel.SBM_StopDetection_RF;

% sPredictedLabel = SBM_StopDetection_RF.predict(mTmpFeature);   %
% Predicted Label is String, need to convert to integer

% nPredictedLabel = str2num(sPredictedLabel);


return;
