function f = SS_TotalTrainHMM()
% Train a set of HMMs based on the observation sequence files.
% The sequence files contain the class IDs of the feature vectors clustered
% by K-Means
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fprintf('Start Time: %s\n', datestr(clock, 'yyyy-mm-dd HH:MM:SS'));

mState = [3 6 9 12 15 18];   % Try different hidden status number

mObservation = [15 20 25 30];  % Number of symbols (i.e. K in K-means)

sBaseFolder = 'E:\UIUC\TryAudioModel\';

sPlaceNames = [ ...
    'BarnesNoble              '; ...
    'Cravings                 '; ... 
    'Walsgreen                '; ...
    'CSL                      '; ...
    'Street                   '
];

cellPlaceNames = cellstr(sPlaceNames);

for i = 1:length(mObservation)
    for j = 1:length(cellPlaceNames)
        sObservationFile = [sBaseFolder 'KMeansResult\' cellPlaceNames{j} '_KmeansIdx_' num2str(mObservation(i)) '.csv'];
        fprintf('Training HMM based on :  %s\n', sObservationFile);
        for k=1:length(mState)
            SS_TrainParticularHMM(mState(k), mObservation(i), sObservationFile);
        end
    end
end

fprintf('Finish Time: %s\n', datestr(clock, 'yyyy-mm-dd HH:MM:SS'));

return;
