function f = SS_TotalHmmClassification()
% This function classifies a group of K-mean classified test Class ID
% sequences
%
fprintf('Start Time: %s\n', datestr(clock, 'yyyy-mm-dd HH:MM:SS'));

format long;

sBaseFolder = 'E:\UIUC\TryAudioModel\';

sPlaceNames = [ ...
    'BarnesNoble              '; ...
    'Cravings                 '; ... 
    'Walsgreen                '; ...
    'CSL                      '; ...
    'Street                   '
];

cellPlaceNames = cellstr(sPlaceNames);

mK = [15 20 25 30];

for i=1:length(mK)
    for j=1:length(cellPlaceNames)
        sTestKmeansClassIDFile = [sBaseFolder 'KMeansClassifiedTestFeatureData\' cellPlaceNames{j} '_KmeansIdx_' num2str(mK(i)) '.csv'];
        fprintf('HMM Classifying [K=%d]:  %s\n', mK(i), sTestKmeansClassIDFile);
        mTestObservation = load(sTestKmeansClassIDFile);
        SS_CalculateHmmBasedObsvProb(mTestObservation', mK(i), cellPlaceNames{j});
    end    
end

fprintf('Finish Time: %s\n', datestr(clock, 'yyyy-mm-dd HH:MM:SS'));

return;
