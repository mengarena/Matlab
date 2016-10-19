function f = SBM_Script_StopDetection_RF(mSelectedFeatures, nTreeNum, nPosition)

% SBM_Script_TrainStopDetection_Total
fprintf('Start Time: %s\n', datestr(clock, 'yyyy-mm-dd HH:MM:SS'));

sArrTrainDataFiles = [
    'E:\SensorMatching\Data\SchoolShuttle\20150925_morning\Yellow_half_good\Ref_Uniqued_TmCrt_SegMF_N.csv                   '; ...
    'E:\SensorMatching\Data\SchoolShuttle\20150925_morning\Yellow_half_good\hand_Uniqued_TmCrt_SegMF_N.csv                  '; ...
    'E:\SensorMatching\Data\SchoolShuttle\20150925_morning\Yellow_half_good\pantpocket_Uniqued_TmCrt_SegMF_N.csv            '; ...
    
    'E:\SensorMatching\Data\SchoolShuttle\20150925_afternoon\Green1_half_Bad\pantpocket_Uniqued_TmCrt_SegMF_N.csv           '; ...
    'E:\SensorMatching\Data\SchoolShuttle\20150925_afternoon\Green1_half_Bad\hand_Uniqued_TmCrt_SegMF_N.csv                 '; ...

    'E:\SensorMatching\Data\SchoolShuttle\20150925_afternoon\Green2_full_Bad\pantpocket_Uniqued_TmCrt_SegMF_N.csv           '; ...
    'E:\SensorMatching\Data\SchoolShuttle\20150925_afternoon\Green2_full_Bad\hand_Uniqued_TmCrt_SegMF_N.csv                 '; ...

    'E:\SensorMatching\Data\SchoolShuttle\20150925_afternoon\Red_half_Bad\pantpocket_Uniqued_TmCrt_SegMF_N.csv              '; ...
    'E:\SensorMatching\Data\SchoolShuttle\20150925_afternoon\Red_half_Bad\Ref_Uniqued_TmCrt_SegMF_N.csv                     '; ...

    'E:\SensorMatching\Data\SchoolShuttle\20150925_afternoon\Green3_full_AlmostGood\pantpocket_Uniqued_TmCrt_SegMF_N.csv    '; ...
    'E:\SensorMatching\Data\SchoolShuttle\20150925_afternoon\Green3_full_AlmostGood\hand_Uniqued_TmCrt_SegMF_N.csv          '; ...
    'E:\SensorMatching\Data\SchoolShuttle\20150925_afternoon\Green3_full_AlmostGood\Ref_Uniqued_TmCrt_SegMF_N.csv           '; ...

    'E:\SensorMatching\Data\SchoolShuttle\20150928_withPhani\Red1_abnormal_almostgood\pantpocket_Uniqued_TmCrt_SegMF_N.csv  '; ...
    'E:\SensorMatching\Data\SchoolShuttle\20150928_withPhani\Red1_abnormal_almostgood\hand_Uniqued_TmCrt_SegMF_N.csv        '; ...
    'E:\SensorMatching\Data\SchoolShuttle\20150928_withPhani\Red1_abnormal_almostgood\Ref_Uniqued_TmCrt_SegMF_N.csv         '; ...

    'E:\SensorMatching\Data\SchoolShuttle\20150929_withXiang\Green1_half_almostgood\hand_Uniqued_TmCrt_SegMF_N.csv          '; ...
    'E:\SensorMatching\Data\SchoolShuttle\20150929_withXiang\Green1_half_almostgood\pantpocket_Uniqued_TmCrt_SegMF_N.csv    '; ...
    'E:\SensorMatching\Data\SchoolShuttle\20150929_withXiang\Green1_half_almostgood\Ref_Uniqued_TmCrt_SegMF_N.csv           '; ...
];

cellTrainDataFiles = cellstr(sArrTrainDataFiles);


%Index: Feature:  
%  2:  fMagMeanLinearAccl
%  3:  fMagStdLinearAccl
%  4:  fMagRangeLinearAccl
%  5:  fMagMCRLinearAccl
%  6:  fMagMADLinearAccl
%  7:  fMagSkewLinearAccl
%  8:  fMagRMSLinearAccl
%  9:  fMagSMALinearAccl

% 10:  fMagMeanGyro
% 11:  fMagStdGyro
% 12:  fMagRangeGyro
% 13:  fMagMCRGyro
% 14:  fMagMADGyro
% 15:  fMagSkewGyro
% 16:  fMagRMSGyro
% 17:  fMagSMAGyro

% 18:  fMagMeanBaro
% 19:  fMagStdBaro
% 20:  fMagRangeBaro
% 21:  fMagMCRBaro
% 22:  fMagMADBaro
% 23:  fMagSkewBaro
% 24:  fMagRMSBaro
% 25:  fMagSMABaro
%
%mSelectedFeatures = [2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25];
% mSelectedFeatures = [3];
% 
% nTreeNum = 20;
% 
% nPosition = 0;  % 0-all, 1: Ref, 2: Pocket, 3: Hand

if nPosition == 0
    sFolder = 'all';
elseif nPosition == 1
    sFolder = 'Ref';
elseif nPosition == 2
    sFolder = 'Pocket';
elseif nPosition == 3
    sFolder = 'Hand';
elseif nPosition == 4    % combine Pocket & Hand
    sFolder = 'Passenger';
end

sHand = 'Hand';
sPocket = 'Pocket';

mTrainData = [];

for i = 1:length(cellTrainDataFiles)
    if nPosition ~= 0
        if nPosition == 4
            mCheckHand = [];
            mCheckPocket = [];
            mCheckHand = strfind(lower(cellTrainDataFiles{i}), lower(sHand));
            mCheckPocket = strfind(lower(cellTrainDataFiles{i}), lower(sPocket));
            if length(mCheckHand) == 0 && length(mCheckPocket) == 0
                continue;
            end
        else
            mCheck = [];
            mCheck = strfind(lower(cellTrainDataFiles{i}), lower(sFolder));
            if length(mCheck) == 0
                continue;
            end
        end
    end
    
    mSingleFileTrainData = load(cellTrainDataFiles{i});
    mTrainData = [mTrainData; mSingleFileTrainData];
end

nIdxLabel = 1;

sTrainedRF_Model_Prefix = ['E:\SensorMatching\Data\SchoolShuttle\TrainedModel\RF\Normal\' sFolder '\' num2str(nTreeNum) 'tree\StopDetection_RF'];
    
if 1
    
    sTrainedRF_Model_File = sTrainedRF_Model_Prefix;
    for i = 1:length(mSelectedFeatures)
        sTrainedRF_Model_File = [sTrainedRF_Model_File '_' num2str(mSelectedFeatures(i))];
    end

    sTrainedRF_Model_File = [sTrainedRF_Model_File '.mat'];

    mSelectedTrainFeatureData = mTrainData(:,mSelectedFeatures);
    mLabel = mTrainData(:, nIdxLabel);

    [nFeatureRows ~] = size(mSelectedTrainFeatureData);

    nFeatureRows

    disp('Start Training [Random Forest] for Stop Detection.....');

    SBM_TrainStopDetection_RF(mSelectedTrainFeatureData, mLabel, sTrainedRF_Model_File,nTreeNum);

    disp('Training [Random Forest] for Stop Detection.....Done!!');

end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% here Below, Test
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('*************************************************');

disp('Start Stop Detection Test with [Random Forest].....');

sArrTestDataFiles = [
    'E:\SensorMatching\Data\SchoolShuttle\20150924\Evening1_full_good\hand_Uniqued_TmCrt_SegMF_N.csv              '; ...
    'E:\SensorMatching\Data\SchoolShuttle\20150924\Evening1_full_good\pantpocket_Uniqued_TmCrt_SegMF_N.csv        '; ...
    'E:\SensorMatching\Data\SchoolShuttle\20150924\Evening1_full_good\Ref_Uniqued_TmCrt_SegMF_N.csv               '; ...

    'E:\SensorMatching\Data\SchoolShuttle\20150924\Green1_full_good\hand_Uniqued_TmCrt_SegMF_N.csv                '; ...
    'E:\SensorMatching\Data\SchoolShuttle\20150924\Green1_full_good\pantpocket_Uniqued_TmCrt_SegMF_N.csv          '; ...
    'E:\SensorMatching\Data\SchoolShuttle\20150924\Green1_full_good\Ref_Uniqued_TmCrt_SegMF_N.csv                 '; ...

    'E:\SensorMatching\Data\SchoolShuttle\20150925_morning\Blue2_full_good\hand_Uniqued_TmCrt_SegMF_N.csv         '; ...
    'E:\SensorMatching\Data\SchoolShuttle\20150925_morning\Blue2_full_good\pantpocket_Uniqued_TmCrt_SegMF_N.csv   '; ...
    'E:\SensorMatching\Data\SchoolShuttle\20150925_morning\Blue2_full_good\Ref_Uniqued_TmCrt_SegMF_N.csv          '; ...

    'E:\SensorMatching\Data\SchoolShuttle\20150925_morning\North2_full_good\hand_Uniqued_TmCrt_SegMF_N.csv        '; ...
    'E:\SensorMatching\Data\SchoolShuttle\20150925_morning\North2_full_good\pantpocket_Uniqued_TmCrt_SegMF_N.csv  '; ...
    'E:\SensorMatching\Data\SchoolShuttle\20150925_morning\North2_full_good\Ref_Uniqued_TmCrt_SegMF_N.csv         '; ...

    'E:\SensorMatching\Data\SchoolShuttle\20150928_withXiang\Red1_full_good\hand_Uniqued_TmCrt_SegMF_N.csv        '; ...
    'E:\SensorMatching\Data\SchoolShuttle\20150928_withXiang\Red1_full_good\pantpocket_Uniqued_TmCrt_SegMF_N.csv  '; ...
    'E:\SensorMatching\Data\SchoolShuttle\20150928_withXiang\Red1_full_good\Ref_Uniqued_TmCrt_SegMF_N.csv         '; ...

    'E:\SensorMatching\Data\SchoolShuttle\20150929_withXiang\Red1_full_good\hand_Uniqued_TmCrt_SegMF_N.csv        '; ...
    'E:\SensorMatching\Data\SchoolShuttle\20150929_withXiang\Red1_full_good\pantpocket_Uniqued_TmCrt_SegMF_N.csv  '; ...
    'E:\SensorMatching\Data\SchoolShuttle\20150929_withXiang\Red1_full_good\Ref_Uniqued_TmCrt_SegMF_N.csv         '; ...
];

cellTestDataFiles = cellstr(sArrTestDataFiles);

mTestData = [];

for i = 1:length(cellTestDataFiles)
    if nPosition ~= 0
        if nPosition == 4
            mCheckHand = [];
            mCheckPocket = [];
            mCheckHand = strfind(lower(cellTestDataFiles{i}), lower(sHand));
            mCheckPocket = strfind(lower(cellTestDataFiles{i}), lower(sPocket));
            if length(mCheckHand) == 0 && length(mCheckPocket) == 0
                continue;
            end
        else
            mCheck = [];
            mCheck = strfind(lower(cellTestDataFiles{i}), lower(sFolder));
            if length(mCheck) == 0
                continue;
            end
        end
    end
    
    mSingleFileTestData = load(cellTestDataFiles{i});
    mTestData = [mTestData; mSingleFileTestData];
end


sTrainedRF_Model_File = sTrainedRF_Model_Prefix;
for i = 1:length(mSelectedFeatures)
    sTrainedRF_Model_File = [sTrainedRF_Model_File '_' num2str(mSelectedFeatures(i))];
end

sTrainedRF_Model_File = [sTrainedRF_Model_File '.mat'];

mSelectedTestFeatureData = mTestData(:,mSelectedFeatures);
mGrondTruthLabel = mTestData(:, nIdxLabel);

RFmodel = load(sTrainedRF_Model_File);
SBM_StopDetection_RF = RFmodel.SBM_StopDetection_RF;

mStrPredictedLabel = SBM_StopDetection_RF.predict(mSelectedTestFeatureData);   %Predicted Label is String, need to convert to integer

mPredictedLabel = [];
for i = 1:length(mStrPredictedLabel)
    mPredictedLabel(i) = str2num(mStrPredictedLabel{i});
end

% Now Check Accuracy
[nTotalTestCaseCnt ~] = size(mSelectedTestFeatureData);

nTotalTestCaseCnt

nCorrectCaseCnt = 0;
for i = 1:nTotalTestCaseCnt
    if mGrondTruthLabel(i) == mPredictedLabel(i)
        nCorrectCaseCnt = nCorrectCaseCnt + 1;
    end
end

fAccuracy = nCorrectCaseCnt*100.0/nTotalTestCaseCnt;

fprintf('Stop Detection Accuracy: %2.3f %%\n', fAccuracy);


disp('>>>>>>>>>>>>>>DONE<<<<<<<<<<<<<<');

fprintf('\nFinish Time: %s\n', datestr(clock, 'yyyy-mm-dd HH:MM:SS'));

f = fAccuracy;

return;
