function f = SBM_GetPassengerFeature_WholeTrace(sUniquedTmCrtTrace, sTraceInfoG, nIdxDataType, fPCAStat)
% This function is used to get the Basic Features of the Passebger Trace 
% It also get detailed features (from accl, gyro, baro) of each segments
% 
% @sUniquedTmCrtTrace:  The uniqued and timestamp corrected sensor trace
% file
% @sTraceInfoG:  The general information file which tells information about the segment and
% station of the trace (For all traces: Pantpocket, Ref, Hand, these
% general information are generated.)
% @nIdxDataType: Field Index of Data Type
%
% Basic Feature (for each segment)
% 1) A series of data, describe stops (NOT station)/moving/turns
%    Stop: 0 (type), duration
%    Moving: 1 (type), duration
%    Turn:  2 (type), direction (1--left, -1--right, 0--No Turn, 9--Uncertain)
%       -- Window size:  6 seconds, Window Step:  2  (Refer to past
%       project) Overlapping Window
%       
%  Do Stop Detection to decide the stops
% 
% 2) Detailed features about each segments's motion, including (the trace
% when bus stopped is removed)
% 
% Overlapping Window
% Window size: 1 seconds, 
% Window Step: 0.5 seconds
%
%   Features:
%    a) 
%
%  Result:
%    File 1:  statistics information about each segment (i.e. stop, moving,
%    turn information)
%       --- File name:  _TmCrt_SegBF_1.csv, _TmCrt_SegBF_2.csv  (BF--Basic
%       Feature)
%    
%    File 2:  
%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% All the features are processed in one file
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fprintf('Start Time: %s\n', datestr(clock, 'yyyy-mm-dd HH:MM:SS'));

format long;

fprintf('Start Time [Calculate Passenger Trace Feature]: %s\n', datestr(clock, 'yyyy-mm-dd HH:MM:SS'));

sMsg = ['Calculate Feature for:  ' sUniquedTmCrtTrace];
disp(sMsg);

%sFeatureSubFolder = 'Feature';
sFeatureSubFolder = 'FeaturePCA';

%%%%%%%%%%%%%%Set Information for Stop Detection%%%%%%%%%%%%%%%%%%%%%%
sRFModelFilePrefix = 'E:\SensorMatching\Data\SchoolShuttle\TrainedModel\RF\Normal\Passenger\50tree\StopDetection_RF';

% Features for stop detection
% Original          [2 3 4 5 12 19 20 21 22 23 24 25 32 39 40 41] 
mSelectedFeatures = [1 2 3 4 11 18 19 20 21 22 23 24 31 38 39 40];  % Index starts from 1

sRF_Model_File = sRFModelFilePrefix;
for i = 1:length(mSelectedFeatures)
    sRF_Model_File = sprintf('%s_%d', sRF_Model_File, mSelectedFeatures(i)+1);
end

sRF_Model_File = [sRF_Model_File '.mat'];

RFmodel = load(sRF_Model_File);
SBM_StopDetection_RF = RFmodel.SBM_StopDetection_RF;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

mUniquedTmCrtTrace = load(sUniquedTmCrtTrace);

mTraceInfoG = load(sTraceInfoG);

[nStationSegCnt ~] = size(mTraceInfoG);

nTraceFirstLine = mTraceInfoG(1,3);
nTraceLastLine = mTraceInfoG(nStationSegCnt,2);

nDataTypeAccl = 1;   % Accl,  NOT linear Accl
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Basic Features
%
% Calculate basic features segment by segment
% Each segment will be a separate file
% It derives Stop, Moving, Turn information, these motion units show in
% order in the result file of each segment
% 
% Basic Features:
% Unit Motion Type (0=Stop, 1=Moving, 2=Turn), Duration, Start Line, End Line 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
sBasicFeatureFilePostFix = 'TraceBF';
sDetailedFeatureFilePostFix = 'TraceDF';

fWindowSize = 1.0;  % seconds
fWindowStep = fWindowSize*0.5;  % If Non-overlapping, set this to fWindowSize

nContinuousStopCntThreshold = 3;   % If the prediction model shows this number of continuous stops, we could conclude this is a real stop, so can estimate the UnitAccl
    
% Get all the turn information of the segment, 
% For each turn:  Begin Line (in original trace), End Line, Direction (1--Left, -1--Right, 0--No Turn), Turn Degree, GPS Lat, GPS Long 
mTurnInfoGyroRow = SBM_GetPassengerTurnInfo(mUniquedTmCrtTrace,nTraceFirstLine,nTraceLastLine,nIdxDataType);

mTurns = mTurnInfoGyroRow{1};  % The turn direction is not decided
mCellTurnGyroRows = mTurnInfoGyroRow{2};   % Gyro rows for these turns, it is a cell
    
[nTurnCnt ~] = size(mTurns);

mMergedTurn = [];
if nTurnCnt > 0
    for k = 1:nTurnCnt
        mMergedTurn(k) = 0;
    end
end

% For Stop/Moving, there is no GPS information, must use Stop Detection to decide   % 1:  Stop, 0: Non-Stop

% Preprocessing sensor (Filtering)
mCellTraceMotionFiltered = SBM_PreprocessSensors(mUniquedTmCrtTrace(nTraceFirstLine:nTraceLastLine,:), nIdxDataType);

mFilteredAccl = SBM_PreprocessSingleSensor(mUniquedTmCrtTrace(nTraceFirstLine:nTraceLastLine,:), nIdxDataType, nDataTypeAccl, 200);

mFilteredLinearAccl = mCellTraceMotionFiltered{1};
mFilteredGyro = mCellTraceMotionFiltered{2};
mFilteredBaro = mCellTraceMotionFiltered{3};
    
% Replace back, i.e. replace the raw LinearAccl, Gyro, Baro with the
% filtered values
mTraceMotionReplaced = mUniquedTmCrtTrace(nTraceFirstLine:nTraceLastLine,:);  %% 1st Line --- nBeginLine;   last line --- nEndLine

% <== New add Begin 20160422
mRawSensorTrace = mUniquedTmCrtTrace(nTraceFirstLine:nTraceLastLine,:);
% <== New add End 20160422

mTraceMotionReplaced((mTraceMotionReplaced(:,nIdxDataType) == 1),:) = mFilteredAccl;
mTraceMotionReplaced((mTraceMotionReplaced(:,nIdxDataType) == 2),:) = mFilteredLinearAccl;
mTraceMotionReplaced((mTraceMotionReplaced(:,nIdxDataType) == 3),:) = mFilteredGyro;
mTraceMotionReplaced((mTraceMotionReplaced(:,nIdxDataType) == 7),:) = mFilteredBaro;

[nTotalTraceRecord ~] = size(mTraceMotionReplaced);
fLastMoment = mTraceMotionReplaced(nTotalTraceRecord,1);
    
mUnitAcclInfo = []; 
nUnitAcclInfoCnt = 0;

mTraceBasicFeature = [];
nBasicFeatureCnt = 0;

nContinuousStopCnt = 0;
% True line No. in mUniquedTmCrtTrace = x + nBeginLine - 1;

%
% Set Result File Pathname for Detailed here
%
[pathstr, filename, ext] = fileparts(sUniquedTmCrtTrace);
sResultDFFile = [pathstr '\' sFeatureSubFolder '\' filename '_' sDetailedFeatureFilePostFix '.csv'];
fidWriteDF = fopen(sResultDFFile, 'w');

% Window sensor data and calculate features
fWinBeginTm = mTraceMotionReplaced(1,1);
fWinEndTm = fWinBeginTm + fWindowSize;
nWinBeginLine = 1;

while fWinEndTm <= fLastMoment 
    nWinEndLine = SBM_GetLineNoWithinTime(mTraceMotionReplaced, nWinBeginLine, fWinEndTm);
    if nWinEndLine == -1
        break;
    end

    [nInTurn nTurnIdx] = SBM_CheckInTurn(mTurns, nWinBeginLine + nTraceFirstLine -1, nWinEndLine + nTraceFirstLine -1);

    if nInTurn == 1  % Within a Turn
        nContinuousStopCnt = 0;
        if mMergedTurn(nTurnIdx) == 0
            nBasicFeatureCnt = nBasicFeatureCnt + 1;
            mTraceBasicFeature(nBasicFeatureCnt, 1) = 2;    % Turn
            mTraceBasicFeature(nBasicFeatureCnt, 2) = mTurns(nTurnIdx, 3);   % Turn Direction (Direction is uncertain at this moment, decide later)
            mTraceBasicFeature(nBasicFeatureCnt, 3) = mTurns(nTurnIdx, 1);   % Turn Begin Line 
            mTraceBasicFeature(nBasicFeatureCnt, 4) = mTurns(nTurnIdx, 2);   % Turn End Line (in Original trace)
            mTraceBasicFeature(nBasicFeatureCnt, 5) = mTurns(nTurnIdx, 5);   % Turn GPS Lat 
            mTraceBasicFeature(nBasicFeatureCnt, 6) = mTurns(nTurnIdx, 6);   % Turn GPS Long 

            mMergedTurn(nTurnIdx) = 1;
        end
    end

    % Process sensor data within a window and extract features
    mWinSensor = mTraceMotionReplaced(nWinBeginLine:nWinEndLine, :);
    mWinLinearAccl = mWinSensor((mWinSensor(:,nIdxDataType) == 2),:);
    mWinGyro = mWinSensor((mWinSensor(:,nIdxDataType) == 3),:);
    mWinBaro = mWinSensor((mWinSensor(:,nIdxDataType) == 7),:);

    % Get raw sensor data  <== New add Begin 20160422
    mWinSensorRaw = mRawSensorTrace(nWinBeginLine:nWinEndLine, :);
    mWinLinearAcclRaw = mWinSensorRaw((mWinSensorRaw(:,nIdxDataType) == 2),:);
    mWinGyroRaw = mWinSensorRaw((mWinSensorRaw(:,nIdxDataType) == 3),:);
    
    % Features from PCAed raw sensor data
    mWinLinearAcclFeaturePCA = SBM_GetWinLinearAcclFeaturePCA(mWinLinearAcclRaw, nIdxDataType, fPCAStat, 1);
    mWinGyroFeaturePCA = SBM_GetWinGyroFeaturePCA(mWinGyroRaw, nIdxDataType, fPCAStat, 1);

    mWinLinearAcclFeaturePCA2 = SBM_GetWinLinearAcclFeaturePCA(mWinLinearAcclRaw, nIdxDataType, fPCAStat, 2);
    mWinGyroFeaturePCA2 = SBM_GetWinGyroFeaturePCA(mWinGyroRaw, nIdxDataType, fPCAStat, 2);
    % <== New add End 20160422
    
    %
    % Features from filtered raw sensor data
    mWinLinearAcclFeature = SBM_GetWinLinearAcclFeature(mWinLinearAccl, nIdxDataType);
    mWinGyroFeature = SBM_GetWinGyroFeature(mWinGyro, nIdxDataType);
    mWinBaroFeature = SBM_GetWinBaroFeature(mWinBaro, nIdxDataType);

    mFeatures = [mWinLinearAcclFeature mWinGyroFeature mWinBaroFeature];
    
    % Change on 20160504 Begin (for adjust feature index for Stop
    % detection)
    % [1 2 3 4 11 18 19 20 21 22 23 24 31 38 39 40]
    mSelectedFeatures = [1 2 3 4 11 18 19 20 27 28 29 30 37 44 45 46];
    % Change on 20160504 End
    
    mSelectedTestFeatureData = mFeatures(mSelectedFeatures);    %%Has Problem here (the index) <----------------20160504 Rufeng Meng
    mStrPredictedLabel = SBM_StopDetection_RF.predict(mSelectedTestFeatureData);   %Predicted Label is String, need to convert to integer, 1:  Stop, 0: Non-Stop
    nPredicatedLabel = str2num(mStrPredictedLabel{1});

    %fprintf('Predicated #Label: %d\n', length(mStrPredictedLabel));   % Should only has one item

    if nPredicatedLabel == 0  % Non-stop (Moving)
        nContinuousStopCnt = 0;

        if nInTurn == 0
            nBasicFeatureCnt = nBasicFeatureCnt + 1;
            mTraceBasicFeature(nBasicFeatureCnt, 1) = 1;    % Moving
            mTraceBasicFeature(nBasicFeatureCnt, 2) = mTraceMotionReplaced(nWinEndLine,1) - mTraceMotionReplaced(nWinBeginLine,1);   % Duration 
            mTraceBasicFeature(nBasicFeatureCnt, 3) = nWinBeginLine + nTraceFirstLine -1;    % Begin Line 
            mTraceBasicFeature(nBasicFeatureCnt, 4) = nWinEndLine + nTraceFirstLine -1;      % End Line 
            mTraceBasicFeature(nBasicFeatureCnt, 5) = mean(mTraceMotionReplaced(nWinBeginLine:nWinEndLine,nIdxDataType+4));     % GPS Lat
            mTraceBasicFeature(nBasicFeatureCnt, 6) = mean(mTraceMotionReplaced(nWinBeginLine:nWinEndLine,nIdxDataType+5));     % GPS Long
        end

        % Save the detailed motion feature
        if length(mWinLinearAcclFeature) > 0 && length(mWinGyroFeature) > 0 && length(mWinBaroFeature) > 0
            fMagMeanLinearAccl = mWinLinearAcclFeature(1);
            fMagMedianLinearAccl = mWinLinearAcclFeature(2);
            fMagVarLinearAccl = mWinLinearAcclFeature(3);
            fMagStdLinearAccl = mWinLinearAcclFeature(4);
            fMagRangeLinearAccl = mWinLinearAcclFeature(5);
            fMagMCRLinearAccl = mWinLinearAcclFeature(6);
            fMagMADLinearAccl = mWinLinearAcclFeature(7);
            fMagSkewLinearAccl = mWinLinearAcclFeature(8);
            fMagRMSLinearAccl = mWinLinearAcclFeature(9);
            fMagSMALinearAccl = mWinLinearAcclFeature(10);

            fFreqMaxAmpLinearAccl = mWinLinearAcclFeature(11);
            fFreqBucketEnergy5LinearAccl = mWinLinearAcclFeature(12);
            fFreqBucketRMS5LinearAccl = mWinLinearAcclFeature(13);
            fFreqMeanBucketAmp5LinearAccl = mWinLinearAcclFeature(14);
            fFreqBucketEnergy10LinearAccl = mWinLinearAcclFeature(15);
            fFreqBucketRMS10LinearAccl = mWinLinearAcclFeature(16);
            fFreqMeanBucketAmp10LinearAccl = mWinLinearAcclFeature(17);
            fFreqBucketEnergy20LinearAccl = mWinLinearAcclFeature(18);
            fFreqBucketRMS20LinearAccl = mWinLinearAcclFeature(19);
            fFreqMeanBucketAmp20LinearAccl = mWinLinearAcclFeature(20);

            fMagMaxLinearAccl = mWinLinearAcclFeature(21);
            fMagMinLinearAccl = mWinLinearAcclFeature(22);
            f3AxisAADLinearAccl = mWinLinearAcclFeature(23);
            %fMagKurtLinearAccl = mWinLinearAcclFeature(24);
            %fMagCFLinearAccl = mWinLinearAcclFeature(25);
            fMagCorrLinearAccl = mWinLinearAcclFeature(24);
            fMagPowerLinearAccl = mWinLinearAcclFeature(25);
            fMagLogEnergyLinearAccl = mWinLinearAcclFeature(26);

            fMagMeanGyro = mWinGyroFeature(1);
            fMagMedianGyro = mWinGyroFeature(2);
            fMagVarGyro = mWinGyroFeature(3);
            fMagStdGyro = mWinGyroFeature(4);
            fMagRangeGyro = mWinGyroFeature(5);
            fMagMCRGyro = mWinGyroFeature(6);
            fMagMADGyro = mWinGyroFeature(7);
            fMagSkewGyro = mWinGyroFeature(8);
            fMagRMSGyro = mWinGyroFeature(9);
            fMagSMAGyro = mWinGyroFeature(10);

            fFreqMaxAmpGyro = mWinGyroFeature(11);
            fFreqBucketEnergy5Gyro = mWinGyroFeature(12);
            fFreqBucketRMS5Gyro = mWinGyroFeature(13);
            fFreqMeanBucketAmp5Gyro = mWinGyroFeature(14);
            fFreqBucketEnergy10Gyro = mWinGyroFeature(15);
            fFreqBucketRMS10Gyro = mWinGyroFeature(16);
            fFreqMeanBucketAmp10Gyro = mWinGyroFeature(17);
            fFreqBucketEnergy20Gyro = mWinGyroFeature(18);
            fFreqBucketRMS20Gyro = mWinGyroFeature(19);
            fFreqMeanBucketAmp20Gyro = mWinGyroFeature(20);

            fMagMaxGyro = mWinGyroFeature(21);
            fMagMinGyro = mWinGyroFeature(22);
            f3AxisAADGyro = mWinGyroFeature(23);
            %fMagKurtGyro = mWinGyroFeature(24);
            %fMagCFGyro = mWinGyroFeature(25);
            fMagCorrGyro = mWinGyroFeature(24);
            fMagPowerGyro = mWinGyroFeature(25);
            fMagLogEnergyGyro = mWinGyroFeature(26);
                        
            fMagMeanBaro = mWinBaroFeature(1);
            fMagMedianBaro = mWinBaroFeature(2);
            fMagVarBaro = mWinBaroFeature(3);            
            fMagStdBaro = mWinBaroFeature(4);
            fMagRangeBaro = mWinBaroFeature(5);
            fMagMCRBaro = mWinBaroFeature(6);
            fMagMADBaro = mWinBaroFeature(7);
            fMagSkewBaro = mWinBaroFeature(8);
            fMagRMSBaro = mWinBaroFeature(9);
            fMagSMABaro = mWinBaroFeature(10); 
            
            fMagMaxBaro = mWinBaroFeature(11);
            fMagMinBaro = mWinBaroFeature(12);
            %fMagKurtBaro = mWinBaroFeature(13);
            %fMagCFBaro = mWinBaroFeature(14);
            fMagCorrBaro = mWinBaroFeature(13);
            fMagPowerBaro = mWinBaroFeature(14);
            fMagLogEnergyBaro = mWinBaroFeature(15);

            % PCA <== New add Begin 20160422 %%%%%%%%%%%%%%%%%%%
            fMagMeanLinearAcclPCA = mWinLinearAcclFeaturePCA(1);
            fMagMedianLinearAcclPCA = mWinLinearAcclFeaturePCA(2);
            fMagVarLinearAcclPCA = mWinLinearAcclFeaturePCA(3);
            fMagStdLinearAcclPCA = mWinLinearAcclFeaturePCA(4);
            fMagRangeLinearAcclPCA = mWinLinearAcclFeaturePCA(5);
            fMagMCRLinearAcclPCA = mWinLinearAcclFeaturePCA(6);
            fMagMADLinearAcclPCA = mWinLinearAcclFeaturePCA(7);
            fMagSkewLinearAcclPCA = mWinLinearAcclFeaturePCA(8);
            fMagRMSLinearAcclPCA = mWinLinearAcclFeaturePCA(9);
            fMagSMALinearAcclPCA = mWinLinearAcclFeaturePCA(10);

            fFreqMaxAmpLinearAcclPCA = mWinLinearAcclFeaturePCA(11);
            fFreqBucketEnergy5LinearAcclPCA = mWinLinearAcclFeaturePCA(12);
            fFreqBucketRMS5LinearAcclPCA = mWinLinearAcclFeaturePCA(13);
            fFreqMeanBucketAmp5LinearAcclPCA = mWinLinearAcclFeaturePCA(14);
            fFreqBucketEnergy10LinearAcclPCA = mWinLinearAcclFeaturePCA(15);
            fFreqBucketRMS10LinearAcclPCA = mWinLinearAcclFeaturePCA(16);
            fFreqMeanBucketAmp10LinearAcclPCA = mWinLinearAcclFeaturePCA(17);
            fFreqBucketEnergy20LinearAcclPCA = mWinLinearAcclFeaturePCA(18);
            fFreqBucketRMS20LinearAcclPCA = mWinLinearAcclFeaturePCA(19);
            fFreqMeanBucketAmp20LinearAcclPCA = mWinLinearAcclFeaturePCA(20);

            fMagMaxLinearAcclPCA = mWinLinearAcclFeaturePCA(21);
            fMagMinLinearAcclPCA = mWinLinearAcclFeaturePCA(22);
            f3AxisAADLinearAcclPCA = mWinLinearAcclFeaturePCA(23);
            %fMagKurtLinearAcclPCA = mWinLinearAcclFeaturePCA(24);
            %fMagCFLinearAcclPCA = mWinLinearAcclFeaturePCA(25);
            fMagCorrLinearAcclPCA = mWinLinearAcclFeaturePCA(24);
            fMagPowerLinearAcclPCA = mWinLinearAcclFeaturePCA(25);
            fMagLogEnergyLinearAcclPCA = mWinLinearAcclFeaturePCA(26);

            fMagMeanGyroPCA = mWinGyroFeaturePCA(1);
            fMagMedianGyroPCA = mWinGyroFeaturePCA(2);
            fMagVarGyroPCA = mWinGyroFeaturePCA(3);
            fMagStdGyroPCA = mWinGyroFeaturePCA(4);
            fMagRangeGyroPCA = mWinGyroFeaturePCA(5);
            fMagMCRGyroPCA = mWinGyroFeaturePCA(6);
            fMagMADGyroPCA = mWinGyroFeaturePCA(7);
            fMagSkewGyroPCA = mWinGyroFeaturePCA(8);
            fMagRMSGyroPCA = mWinGyroFeaturePCA(9);
            fMagSMAGyroPCA = mWinGyroFeaturePCA(10);

            fFreqMaxAmpGyroPCA = mWinGyroFeaturePCA(11);
            fFreqBucketEnergy5GyroPCA = mWinGyroFeaturePCA(12);
            fFreqBucketRMS5GyroPCA = mWinGyroFeaturePCA(13);
            fFreqMeanBucketAmp5GyroPCA = mWinGyroFeaturePCA(14);
            fFreqBucketEnergy10GyroPCA = mWinGyroFeaturePCA(15);
            fFreqBucketRMS10GyroPCA = mWinGyroFeaturePCA(16);
            fFreqMeanBucketAmp10GyroPCA = mWinGyroFeaturePCA(17);
            fFreqBucketEnergy20GyroPCA = mWinGyroFeaturePCA(18);
            fFreqBucketRMS20GyroPCA = mWinGyroFeaturePCA(19);
            fFreqMeanBucketAmp20GyroPCA = mWinGyroFeaturePCA(20);

            fMagMaxGyroPCA = mWinGyroFeaturePCA(21);
            fMagMinGyroPCA = mWinGyroFeaturePCA(22);
            f3AxisAADGyroPCA = mWinGyroFeaturePCA(23);
            %fMagKurtGyroPCA = mWinGyroFeaturePCA(24);
            %fMagCFGyroPCA = mWinGyroFeaturePCA(25);
            fMagCorrGyroPCA = mWinGyroFeaturePCA(24);
            fMagPowerGyroPCA = mWinGyroFeaturePCA(25);
            fMagLogEnergyGyroPCA = mWinGyroFeaturePCA(26);
            % PCA <== New add End 20160422  %%%%%%%%%%%%%%%%%%%%%
            
            
            % PCA <== New add Begin 20160429 %%%%%%%%%%%%%%%%%%%
            fMagMeanLinearAcclPCA2 = mWinLinearAcclFeaturePCA2(1);
            fMagMedianLinearAcclPCA2 = mWinLinearAcclFeaturePCA2(2);
            fMagVarLinearAcclPCA2 = mWinLinearAcclFeaturePCA2(3);
            fMagStdLinearAcclPCA2 = mWinLinearAcclFeaturePCA2(4);
            fMagRangeLinearAcclPCA2 = mWinLinearAcclFeaturePCA2(5);
            fMagMCRLinearAcclPCA2 = mWinLinearAcclFeaturePCA2(6);
            fMagMADLinearAcclPCA2 = mWinLinearAcclFeaturePCA2(7);
            fMagSkewLinearAcclPCA2 = mWinLinearAcclFeaturePCA2(8);
            fMagRMSLinearAcclPCA2 = mWinLinearAcclFeaturePCA2(9);
            fMagSMALinearAcclPCA2 = mWinLinearAcclFeaturePCA2(10);

            fFreqMaxAmpLinearAcclPCA2 = mWinLinearAcclFeaturePCA2(11);
            fFreqBucketEnergy5LinearAcclPCA2 = mWinLinearAcclFeaturePCA2(12);
            fFreqBucketRMS5LinearAcclPCA2 = mWinLinearAcclFeaturePCA2(13);
            fFreqMeanBucketAmp5LinearAcclPCA2 = mWinLinearAcclFeaturePCA2(14);
            fFreqBucketEnergy10LinearAcclPCA2 = mWinLinearAcclFeaturePCA2(15);
            fFreqBucketRMS10LinearAcclPCA2 = mWinLinearAcclFeaturePCA2(16);
            fFreqMeanBucketAmp10LinearAcclPCA2 = mWinLinearAcclFeaturePCA2(17);
            fFreqBucketEnergy20LinearAcclPCA2 = mWinLinearAcclFeaturePCA2(18);
            fFreqBucketRMS20LinearAcclPCA2 = mWinLinearAcclFeaturePCA2(19);
            fFreqMeanBucketAmp20LinearAcclPCA2 = mWinLinearAcclFeaturePCA2(20);

            fMagMaxLinearAcclPCA2 = mWinLinearAcclFeaturePCA2(21);
            fMagMinLinearAcclPCA2 = mWinLinearAcclFeaturePCA2(22);
            f3AxisAADLinearAcclPCA2 = mWinLinearAcclFeaturePCA2(23);
            %fMagKurtLinearAcclPCA2 = mWinLinearAcclFeaturePCA2(24);
            %fMagCFLinearAcclPCA2 = mWinLinearAcclFeaturePCA2(25);
            fMagCorrLinearAcclPCA2 = mWinLinearAcclFeaturePCA2(24);
            fMagPowerLinearAcclPCA2 = mWinLinearAcclFeaturePCA2(25);
            fMagLogEnergyLinearAcclPCA2 = mWinLinearAcclFeaturePCA2(26);

            fMagMeanGyroPCA2 = mWinGyroFeaturePCA2(1);
            fMagMedianGyroPCA2 = mWinGyroFeaturePCA2(2);
            fMagVarGyroPCA2 = mWinGyroFeaturePCA2(3);
            fMagStdGyroPCA2 = mWinGyroFeaturePCA2(4);
            fMagRangeGyroPCA2 = mWinGyroFeaturePCA2(5);
            fMagMCRGyroPCA2 = mWinGyroFeaturePCA2(6);
            fMagMADGyroPCA2 = mWinGyroFeaturePCA2(7);
            fMagSkewGyroPCA2 = mWinGyroFeaturePCA2(8);
            fMagRMSGyroPCA2 = mWinGyroFeaturePCA2(9);
            fMagSMAGyroPCA2 = mWinGyroFeaturePCA2(10);

            fFreqMaxAmpGyroPCA2 = mWinGyroFeaturePCA2(11);
            fFreqBucketEnergy5GyroPCA2 = mWinGyroFeaturePCA2(12);
            fFreqBucketRMS5GyroPCA2 = mWinGyroFeaturePCA2(13);
            fFreqMeanBucketAmp5GyroPCA2 = mWinGyroFeaturePCA2(14);
            fFreqBucketEnergy10GyroPCA2 = mWinGyroFeaturePCA2(15);
            fFreqBucketRMS10GyroPCA2 = mWinGyroFeaturePCA2(16);
            fFreqMeanBucketAmp10GyroPCA2 = mWinGyroFeaturePCA2(17);
            fFreqBucketEnergy20GyroPCA2 = mWinGyroFeaturePCA2(18);
            fFreqBucketRMS20GyroPCA2 = mWinGyroFeaturePCA2(19);
            fFreqMeanBucketAmp20GyroPCA2 = mWinGyroFeaturePCA2(20);

            fMagMaxGyroPCA2 = mWinGyroFeaturePCA2(21);
            fMagMinGyroPCA2 = mWinGyroFeaturePCA2(22);
            f3AxisAADGyroPCA2 = mWinGyroFeaturePCA2(23);
            %fMagKurtGyroPCA2 = mWinGyroFeaturePCA2(24);
            %fMagCFGyroPCA2 = mWinGyroFeaturePCA2(25);
            fMagCorrGyroPCA2 = mWinGyroFeaturePCA2(24);
            fMagPowerGyroPCA2 = mWinGyroFeaturePCA2(25);
            fMagLogEnergyGyroPCA2 = mWinGyroFeaturePCA2(26);
            % PCA <== New add End 20160429  %%%%%%%%%%%%%%%%%%%%%
            
            
           %  fprintf(fidWriteDF, '%d,%d,   %4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,  %4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,  %4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f\n', ...
           
            % No Ground Truth, only features for Moving
            fprintf(fidWriteDF, ...
                    ['%d,%d,   ', ...
                     '%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,  ', ...
                     '%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,  ', ...
                     '%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,   ', ...
                     '%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,   ', ...
                     '%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,   ', ...
                     '%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,   ', ...
                     '%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,  ', ...
                     '%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,  ', ...
                     '%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,   ', ...
                     '%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,   ', ...
                     '%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,  ', ...
                     '%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,  ', ...
                     '%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,   ', ...
                     '%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,   ', ...
                     '\n'], ...
                    nWinBeginLine + nTraceFirstLine -1, nWinEndLine + nTraceFirstLine -1, ...
                    fMagMeanLinearAccl,fMagMedianLinearAccl,fMagVarLinearAccl,fMagStdLinearAccl,fMagRangeLinearAccl,fMagMCRLinearAccl,fMagMADLinearAccl,fMagSkewLinearAccl,fMagRMSLinearAccl,fMagSMALinearAccl, ...
                    fFreqMaxAmpLinearAccl, ...
                    fFreqBucketEnergy5LinearAccl, fFreqBucketRMS5LinearAccl, fFreqMeanBucketAmp5LinearAccl, ...
                    fFreqBucketEnergy10LinearAccl,fFreqBucketRMS10LinearAccl,fFreqMeanBucketAmp10LinearAccl, ...
                    fFreqBucketEnergy20LinearAccl,fFreqBucketRMS20LinearAccl,fFreqMeanBucketAmp20LinearAccl, ...
                    fMagMeanGyro,      fMagMedianGyro,      fMagVarGyro,      fMagStdGyro,      fMagRangeGyro,      fMagMCRGyro,      fMagMADGyro,      fMagSkewGyro,      fMagRMSGyro,      fMagSMAGyro, ...
                    fFreqMaxAmpGyro, ...
                    fFreqBucketEnergy5Gyro, fFreqBucketRMS5Gyro, fFreqMeanBucketAmp5Gyro, ...
                    fFreqBucketEnergy10Gyro,fFreqBucketRMS10Gyro,fFreqMeanBucketAmp10Gyro, ...
                    fFreqBucketEnergy20Gyro,fFreqBucketRMS20Gyro,fFreqMeanBucketAmp20Gyro, ...                    
                    fMagMeanBaro,      fMagMedianBaro,      fMagVarBaro,      fMagStdBaro,      fMagRangeBaro,      fMagMCRBaro,      fMagMADBaro,      fMagSkewBaro,      fMagRMSBaro,      fMagSMABaro, ...
                    fMagMaxLinearAccl, fMagMinLinearAccl, f3AxisAADLinearAccl, fMagCorrLinearAccl,  fMagPowerLinearAccl, fMagLogEnergyLinearAccl, ...
                    fMagMaxGyro, fMagMinGyro, f3AxisAADGyro, fMagCorrGyro, fMagPowerGyro, fMagLogEnergyGyro, ...
                    fMagMaxBaro, fMagMinBaro, fMagCorrBaro, fMagPowerBaro, fMagLogEnergyBaro, ...
                    fMagMeanLinearAcclPCA,fMagMedianLinearAcclPCA,fMagVarLinearAcclPCA,fMagStdLinearAcclPCA,fMagRangeLinearAcclPCA,fMagMCRLinearAcclPCA,fMagMADLinearAcclPCA,fMagSkewLinearAcclPCA,fMagRMSLinearAcclPCA,fMagSMALinearAcclPCA, ...   % PCA <== New add Begin 20160422
                    fFreqMaxAmpLinearAcclPCA, ...
                    fFreqBucketEnergy5LinearAcclPCA, fFreqBucketRMS5LinearAcclPCA, fFreqMeanBucketAmp5LinearAcclPCA, ...
                    fFreqBucketEnergy10LinearAcclPCA,fFreqBucketRMS10LinearAcclPCA,fFreqMeanBucketAmp10LinearAcclPCA, ...
                    fFreqBucketEnergy20LinearAcclPCA,fFreqBucketRMS20LinearAcclPCA,fFreqMeanBucketAmp20LinearAcclPCA, ...
                    fMagMeanGyroPCA,      fMagMedianGyroPCA,      fMagVarGyroPCA,      fMagStdGyroPCA,      fMagRangeGyroPCA,      fMagMCRGyroPCA,      fMagMADGyroPCA,      fMagSkewGyroPCA,      fMagRMSGyroPCA,      fMagSMAGyroPCA, ...
                    fFreqMaxAmpGyroPCA, ...
                    fFreqBucketEnergy5GyroPCA, fFreqBucketRMS5GyroPCA, fFreqMeanBucketAmp5GyroPCA, ...
                    fFreqBucketEnergy10GyroPCA,fFreqBucketRMS10GyroPCA,fFreqMeanBucketAmp10GyroPCA, ...
                    fFreqBucketEnergy20GyroPCA,fFreqBucketRMS20GyroPCA,fFreqMeanBucketAmp20GyroPCA, ...                    
                    fMagMaxLinearAcclPCA, fMagMinLinearAcclPCA, f3AxisAADLinearAcclPCA, fMagCorrLinearAcclPCA,  fMagPowerLinearAcclPCA, fMagLogEnergyLinearAcclPCA, ...
                    fMagMaxGyroPCA, fMagMinGyroPCA, f3AxisAADGyroPCA, fMagCorrGyroPCA, fMagPowerGyroPCA, fMagLogEnergyGyroPCA, ...
                    fMagMeanLinearAcclPCA2,fMagMedianLinearAcclPCA2,fMagVarLinearAcclPCA2,fMagStdLinearAcclPCA2,fMagRangeLinearAcclPCA2,fMagMCRLinearAcclPCA2,fMagMADLinearAcclPCA2,fMagSkewLinearAcclPCA2,fMagRMSLinearAcclPCA2,fMagSMALinearAcclPCA2, ...   % PCA2 <== New add Begin 20160429
                    fFreqMaxAmpLinearAcclPCA2, ...
                    fFreqBucketEnergy5LinearAcclPCA2, fFreqBucketRMS5LinearAcclPCA2, fFreqMeanBucketAmp5LinearAcclPCA2, ...
                    fFreqBucketEnergy10LinearAcclPCA2,fFreqBucketRMS10LinearAcclPCA2,fFreqMeanBucketAmp10LinearAcclPCA2, ...
                    fFreqBucketEnergy20LinearAcclPCA2,fFreqBucketRMS20LinearAcclPCA2,fFreqMeanBucketAmp20LinearAcclPCA2, ...
                    fMagMeanGyroPCA2,      fMagMedianGyroPCA2,      fMagVarGyroPCA2,      fMagStdGyroPCA2,      fMagRangeGyroPCA2,      fMagMCRGyroPCA2,      fMagMADGyroPCA2,      fMagSkewGyroPCA2,      fMagRMSGyroPCA2,      fMagSMAGyroPCA2, ...
                    fFreqMaxAmpGyroPCA2, ...
                    fFreqBucketEnergy5GyroPCA2, fFreqBucketRMS5GyroPCA2, fFreqMeanBucketAmp5GyroPCA2, ...
                    fFreqBucketEnergy10GyroPCA2,fFreqBucketRMS10GyroPCA2,fFreqMeanBucketAmp10GyroPCA2, ...
                    fFreqBucketEnergy20GyroPCA2,fFreqBucketRMS20GyroPCA2,fFreqMeanBucketAmp20GyroPCA2, ...                    
                    fMagMaxLinearAcclPCA2, fMagMinLinearAcclPCA2, f3AxisAADLinearAcclPCA2, fMagCorrLinearAcclPCA2,  fMagPowerLinearAcclPCA2, fMagLogEnergyLinearAcclPCA2, ...
                    fMagMaxGyroPCA2, fMagMinGyroPCA2, f3AxisAADGyroPCA2, fMagCorrGyroPCA2, fMagPowerGyroPCA2, fMagLogEnergyGyroPCA2);
        end
   
    else   % Stop
        
        if nInTurn == 0
            nBasicFeatureCnt = nBasicFeatureCnt + 1;
            mTraceBasicFeature(nBasicFeatureCnt, 1) = 0;    % Stop
            mTraceBasicFeature(nBasicFeatureCnt, 2) = mTraceMotionReplaced(nWinEndLine,1) - mTraceMotionReplaced(nWinBeginLine,1);   % Duration 
            mTraceBasicFeature(nBasicFeatureCnt, 3) = nWinBeginLine + nTraceFirstLine -1;    % Begin Line in the original trace
            mTraceBasicFeature(nBasicFeatureCnt, 4) = nWinEndLine + nTraceFirstLine -1;      % End Line in the original trace
            mTraceBasicFeature(nBasicFeatureCnt, 5) = mean(mTraceMotionReplaced(nWinBeginLine:nWinEndLine,nIdxDataType+4));     % GPS Lat
            mTraceBasicFeature(nBasicFeatureCnt, 6) = mean(mTraceMotionReplaced(nWinBeginLine:nWinEndLine,nIdxDataType+5));     % GPS Long

            nContinuousStopCnt = nContinuousStopCnt + 1;

            % Decide the static status and select the Unit Accl for
            % rotation
            if nContinuousStopCnt >= nContinuousStopCntThreshold
                nRealBeginLine = nWinBeginLine + nTraceFirstLine -1;
                nRealEndLine = nWinEndLine + nTraceFirstLine -1;

                nAcclLineNo = 0;

%                     for m = nWinEndLine:-1:nWinBeginLine
%                         if mSegMotionReplaced(m,nIdxDataType) == nDataTypeAccl   % Accl (NOT linear accl)   % Possible improve, filter Accl field
%                             nAcclLineNo = m;
%                             break;
%                         end
%                     end
                for m = nRealEndLine:-1:nRealBeginLine
                    if mUniquedTmCrtTrace(m,nIdxDataType) == nDataTypeAccl   % Accl (NOT linear accl)   % Possible improve, filter Accl field
                        nAcclLineNo = m;
                        break;
                    end
                end

                if nAcclLineNo > 0
                    nUnitAcclInfoCnt = nUnitAcclInfoCnt + 1;

                    mUnitAcclInfo(nUnitAcclInfoCnt, 1) = nRealBeginLine;
                    mUnitAcclInfo(nUnitAcclInfoCnt, 2) = nRealEndLine;

                    % For deciding phone pose
                    mUnitAccl = mUniquedTmCrtTrace(nAcclLineNo, nIdxDataType+1:nIdxDataType+3)/sqrt(power(mUniquedTmCrtTrace(nAcclLineNo, nIdxDataType+1),2) + power(mUniquedTmCrtTrace(nAcclLineNo, nIdxDataType+2),2) + power(mUniquedTmCrtTrace(nAcclLineNo, nIdxDataType+3),2));
                    %mUnitAccl = mSegMotionReplaced(nAcclLineNo, nIdxDataType+1:nIdxDataType+3)/sqrt(power(mSegMotionReplaced(nAcclLineNo, nIdxDataType+1),2) + power(mSegMotionReplaced(nAcclLineNo, nIdxDataType+2),2) + power(mSegMotionReplaced(nAcclLineNo, nIdxDataType+3),2));

                    mUnitAcclInfo(nUnitAcclInfoCnt, 3) = mUnitAccl(1);
                    mUnitAcclInfo(nUnitAcclInfoCnt, 4) = mUnitAccl(2);
                    mUnitAcclInfo(nUnitAcclInfoCnt, 5) = mUnitAccl(3);

                    nContinuousStopCnt = 0;
                end
            end
        end
    end

    % Move Window
    fWinBeginTm = fWinBeginTm + fWindowStep;

    if fWinBeginTm >= fLastMoment
        break;
    end

    nWinBeginLine = SBM_GetLineNoBeyondTime(mTraceMotionReplaced, nWinBeginLine, fWinBeginTm);
    if nWinBeginLine == -1
        break;
    end

    fWinEndTm = fWinBeginTm + fWindowSize; 
end 

fclose(fidWriteDF);
    
     
%
% Set Result File Pathname for Basic Feature here
%
[pathstr, filename, ext] = fileparts(sUniquedTmCrtTrace);
sResultTraceBFFile = [pathstr '\' sFeatureSubFolder '\' filename '_' sBasicFeatureFilePostFix '.csv'];
fidWriteBF = fopen(sResultTraceBFFile, 'w');

% Decide Turn Direction in mSegBasicFeature
mTraceBasicFeature = SBM_DecideTurnDirection_WholeTrace(mTraceBasicFeature, mUnitAcclInfo, mCellTurnGyroRows, nIdxDataType); 

% Merge and combine Stop/Moving/Turn to form basic features
mResultBasicFeature = SBM_ExtractPassengerBasicFeature(mUniquedTmCrtTrace, mTraceBasicFeature, nIdxDataType);

[nResultBasicFeatureCnt ~] = size(mResultBasicFeature);

% Write into Segment Basic Feature File: Type (0-stop; 1-moving; 2-
% turn), duration/direction, original begin line, original end line, Lat, Lng
for k = 1:nResultBasicFeatureCnt
    fprintf(fidWriteBF, '%d,%f,%d,%d,%5.8f,%5.8f\n', mResultBasicFeature(k, 1),mResultBasicFeature(k, 2),mResultBasicFeature(k, 3),mResultBasicFeature(k, 4),mResultBasicFeature(k, 5),mResultBasicFeature(k, 6));
end

fclose(fidWriteBF);


fprintf('\nFinish Time [Calculate Feature]: %s\n', datestr(clock, 'yyyy-mm-dd HH:MM:SS'));

fprintf('\nFinish Time: %s\n', datestr(clock, 'yyyy-mm-dd HH:MM:SS'));

return;

