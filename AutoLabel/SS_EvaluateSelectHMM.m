function s = SS_EvaluateSelectHMM()
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function is used to evaluate how well the HMM is performing and help
% to select HMM.
% 
% Many HMMs have been trained with different #hidden states and
% #observation, but we don't know which combination is the best.
% This function calculate the accuracy of HMM when classifying the test
% data.
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

format bank;

mStates = [3 6 9 12 15 18];
mObservations = [15 20 25 30];  % = the K in K-means

sBaseFolder = 'E:\UIUC\TryAudioModel\';

sPlaceNames = [ ...
    'BarnesNoble              '; ...
    'Cravings                 '; ... 
    'Walsgreen                '; ...
    'CSL                      '; ...
    'Street                   '
];

cellPlaceNames = cellstr(sPlaceNames);

sResultEvaluationFile = [sBaseFolder 'HmmEvalutionSelection\HmmEvalSel.csv'];
fid_result = fopen(sResultEvaluationFile, 'w');

% This matrix saves the accuracy for different state-observation
% combination. 1st column: state; 2nd column: observation; 3rd column:
% corresponding accuracy
mAccuracy = [];
nIndex = 0;

mAccuracyTable = [];

for i=1:length(mStates)
    for j=1:length(mObservations)
        mTotalScore = 0;
        
        for k=1:length(cellPlaceNames)
            sHmmClassifiedResultFile = [sBaseFolder 'HMMClassifiedTestData\HMMClassificationResult_' cellPlaceNames{k} '_' num2str(mStates(i)) '_' num2str(mObservations(j)) '.csv'];
            mResult = load(sHmmClassifiedResultFile);
            
            if mResult(1,1) == k
                mTotalScore = mTotalScore + 1;
            end
        end
        
        nIndex = nIndex + 1;
        mAccuracy(nIndex, 1) = mStates(i);
        mAccuracy(nIndex, 2) = mObservations(j);
        mAccuracy(nIndex, 3) = roundn(mTotalScore/length(cellPlaceNames), -2);   % Two digits after dot
        
        mAccuracyTable(i,j) = mAccuracy(nIndex, 3);
        
        fprintf(fid_result, '%d,%d,%f\n', mAccuracy(nIndex, 1), mAccuracy(nIndex, 2), mAccuracy(nIndex, 3));
    end
end

fclose(fid_result);

f = figure('Position',[100 100 500 350]);

for i=1:length(mStates)
    rNames{i} = num2str(mStates(i));
end

for j=1:length(mObservations)
    cNames{j} = num2str(mObservations(j));
end

t = uitable('Parent',f,'Data',mAccuracyTable,'ColumnName',cNames,'RowName',rNames,'Position',[20 20 460 200]);

return;
