function f = SBM_GetPassengerFeatureS(sUniquedTmCrtTrace, sTraceInfoG, nIdxDataType)
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Different from SBM_GetPassengerFeature:
% This function process features segment by segment
% but the moment when the vehicle is stopped (not station) is also used to
% extract features
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The features are processed segment by segment
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fprintf('Start Time: %s\n', datestr(clock, 'yyyy-mm-dd HH:MM:SS'));

format long;

fprintf('Start Time [Calculate Passenger Trace Feature]: %s\n', datestr(clock, 'yyyy-mm-dd HH:MM:SS'));

sMsg = ['Calculate Feature for:  ' sUniquedTmCrtTrace];
disp(sMsg);

sFeatureSubFolder = 'Feature';

%%%%%%%%%%%%%%Set Information for Stop Detection%%%%%%%%%%%%%%%%%%%%%%
sRFModelFilePrefix = 'E:\SensorMatching\Data\SchoolShuttle\TrainedModel\RF\Normal\Passenger\50tree\StopDetection_RF';

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

nTypeStation = 0;
nTypeSegment = 1;

% Each trace starts with Station, ends with Station
mStation = mTraceInfoG((mTraceInfoG(:,1) == nTypeStation), :);
mSegment = mTraceInfoG((mTraceInfoG(:,1) == nTypeSegment), :);

[nSegmentCnt ~] = size(mSegment);

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
sBasicFeatureFilePostFix = 'SegBFs';
sDetailedFeatureFilePostFix = 'SegDFs';

fWindowSize = 1.0;  % seconds
fWindowStep = fWindowSize*0.5;  % If Non-overlapping, set this to fWindowSize

nContinuousStopCntThreshold = 3;   % If the prediction model shows this number of continuous stops, we could conclude this is a real stop, so can estimate the UnitAccl

mCellSegBasicFeature = [];
mCellUnitAcclInfo = []; 
mCellCellTurnGyroRows = [];

for i = 1:nSegmentCnt
    nBeginLine = mSegment(i, 2);  % Begin Line of current segment
    nEndLine = mSegment(i, 3);    % End Line of current segment
    
    % Get all the turn information of the segment, 
    % For each turn:  Begin Line (in original trace), End Line, Direction (1--Left, -1--Right, 0--No Turn), Turn Degree, GPS Lat, GPS Long 
    mTurnInfoGyroRow = SBM_GetPassengerTurnInfo(mUniquedTmCrtTrace,nBeginLine,nEndLine,nIdxDataType);
    
    mTurns = mTurnInfoGyroRow{1};  % The turn direction is not decided
    mCellTurnGyroRows = mTurnInfoGyroRow{2};   % Gyro rows for these turns, it is a cell
    
    [nTurnCnt ~] = size(mTurns);
    % For Stop/Moving, there is no GPS information, must use Stop Detection to decide   % 1:  Stop, 0: Non-Stop
    
    %
    % Set Result File Pathname for Detailed here
    %
    [pathstr, filename, ext] = fileparts(sUniquedTmCrtTrace);
    sResultSegDFFile = [pathstr '\' sFeatureSubFolder '\' filename '_' sDetailedFeatureFilePostFix '_' num2str(i) '.csv'];
    fidWriteDF = fopen(sResultSegDFFile, 'w');
    
    % Preprocessing sensor
    mCellSegMotionFiltered = SBM_PreprocessSensors(mUniquedTmCrtTrace(nBeginLine:nEndLine,:), nIdxDataType);
    
    mFilteredAccl = SBM_PreprocessSingleSensor(mUniquedTmCrtTrace(nBeginLine:nEndLine,:), nIdxDataType, nDataTypeAccl, 200);
    
    mFilteredLinearAccl = mCellSegMotionFiltered{1};
    mFilteredGyro = mCellSegMotionFiltered{2};
    mFilteredBaro = mCellSegMotionFiltered{3};
    
    % Replace back, i.e. replace the raw LinearAccl, Gyro, Baro with the
    % filtered values
    mSegMotionReplaced = mUniquedTmCrtTrace(nBeginLine:nEndLine,:);  %% 1st Line --- nBeginLine;   last line --- nEndLine
    mSegMotionReplaced((mSegMotionReplaced(:,nIdxDataType) == 1),:) = mFilteredAccl;
    mSegMotionReplaced((mSegMotionReplaced(:,nIdxDataType) == 2),:) = mFilteredLinearAccl;
    mSegMotionReplaced((mSegMotionReplaced(:,nIdxDataType) == 3),:) = mFilteredGyro;
    mSegMotionReplaced((mSegMotionReplaced(:,nIdxDataType) == 7),:) = mFilteredBaro;
    
    [nTotalSegRecord ~] = size(mSegMotionReplaced);
    fLastMoment = mSegMotionReplaced(nTotalSegRecord,1);
    
    mSegBasicFeature = [];
    nBasicFeatureCnt = 0;

    mMergedTurn = [];
    if nTurnCnt > 0
        for k = 1:nTurnCnt
            mMergedTurn(k) = 0;
        end
    end
    
    nContinuousStopCnt = 0;
    mUnitAcclInfo = [];
    nUnitAcclInfoCnt = 0;
    % True line No. in mUniquedTmCrtTrace = x + nBeginLine - 1;

    % Window sensor data and calculate features
    fWinBeginTm = mSegMotionReplaced(1,1);
    fWinEndTm = fWinBeginTm + fWindowSize;
    nWinBeginLine = 1;

    while fWinEndTm <= fLastMoment 
        nWinEndLine = SBM_GetLineNoWithinTime(mSegMotionReplaced, nWinBeginLine, fWinEndTm);
        if nWinEndLine == -1
            break;
        end
                
        [nInTurn nTurnIdx] = SBM_CheckInTurn(mTurns, nWinBeginLine + nBeginLine -1, nWinEndLine + nBeginLine -1);
        
        if nInTurn == 1  % Within a Turn
            nContinuousStopCnt = 0;
            if mMergedTurn(nTurnIdx) == 0
                nBasicFeatureCnt = nBasicFeatureCnt + 1;
                mSegBasicFeature(nBasicFeatureCnt, 1) = 2;    % Turn
                mSegBasicFeature(nBasicFeatureCnt, 2) = mTurns(nTurnIdx, 3);   % Turn Direction (Direction is uncertain at this moment, decide later)
                mSegBasicFeature(nBasicFeatureCnt, 3) = mTurns(nTurnIdx, 1);   % Turn Begin Line 
                mSegBasicFeature(nBasicFeatureCnt, 4) = mTurns(nTurnIdx, 2);   % Turn End Line (in Original trace)
                mSegBasicFeature(nBasicFeatureCnt, 5) = mTurns(nTurnIdx, 5);   % Turn GPS Lat 
                mSegBasicFeature(nBasicFeatureCnt, 6) = mTurns(nTurnIdx, 6);   % Turn GPS Long 

                mMergedTurn(nTurnIdx) = 1;
            end
        end

        % Process sensor data within a window and extract features
        mWinSensor = mSegMotionReplaced(nWinBeginLine:nWinEndLine, :);
        mWinLinearAccl = mWinSensor((mWinSensor(:,nIdxDataType) == 2),:);
        mWinGyro = mWinSensor((mWinSensor(:,nIdxDataType) == 3),:);
        mWinBaro = mWinSensor((mWinSensor(:,nIdxDataType) == 7),:);
        
        mWinLinearAcclFeature = SBM_GetWinLinearAcclFeature(mWinLinearAccl, nIdxDataType);
        mWinGyroFeature = SBM_GetWinGyroFeature(mWinGyro, nIdxDataType);
        mWinBaroFeature = SBM_GetWinBaroFeature(mWinBaro, nIdxDataType);
        
        mFeatures = [mWinLinearAcclFeature mWinGyroFeature mWinBaroFeature];
        mSelectedTestFeatureData = mFeatures(mSelectedFeatures);
        mStrPredictedLabel = SBM_StopDetection_RF.predict(mSelectedTestFeatureData);   %Predicted Label is String, need to convert to integer, 1:  Stop, 0: Non-Stop
        nPredicatedLabel = str2num(mStrPredictedLabel{1});
        
        %fprintf('Predicated #Label: %d\n', length(mStrPredictedLabel));   % Should only has one item
 
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Save the detailed motion feature anyway, even the vehicle in
        % non-moving moment
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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

            % No Ground Truth, only features for Moving
            fprintf(fidWriteDF, '%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,  %4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,  %4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f\n', ...
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
                    fMagMeanBaro,      fMagMedianBaro,      fMagVarBaro,      fMagStdBaro,      fMagRangeBaro,      fMagMCRBaro,      fMagMADBaro,      fMagSkewBaro,      fMagRMSBaro,      fMagSMABaro);

        end
        
        
        if nPredicatedLabel == 0  % Non-stop (Moving)
            nContinuousStopCnt = 0;
            
            if nInTurn == 0
                nBasicFeatureCnt = nBasicFeatureCnt + 1;
                mSegBasicFeature(nBasicFeatureCnt, 1) = 1;    % Moving
                mSegBasicFeature(nBasicFeatureCnt, 2) = mSegMotionReplaced(nWinEndLine,1) - mSegMotionReplaced(nWinBeginLine,1);   % Duration 
                mSegBasicFeature(nBasicFeatureCnt, 3) = nWinBeginLine + nBeginLine -1;    % Begin Line 
                mSegBasicFeature(nBasicFeatureCnt, 4) = nWinEndLine + nBeginLine -1;      % End Line 
                mSegBasicFeature(nBasicFeatureCnt, 5) = mean(mSegMotionReplaced(nWinBeginLine:nWinEndLine,nIdxDataType+4));     % GPS Lat
                mSegBasicFeature(nBasicFeatureCnt, 6) = mean(mSegMotionReplaced(nWinBeginLine:nWinEndLine,nIdxDataType+5));     % GPS Long
            end
            
%             % Save the detailed motion feature
%             if length(mWinLinearAcclFeature) > 0 && length(mWinGyroFeature) > 0 && length(mWinBaroFeature) > 0
%                 fMagMeanLinearAccl = mWinLinearAcclFeature(1);
%                 fMagMedianLinearAccl = mWinLinearAcclFeature(2);
%                 fMagVarLinearAccl = mWinLinearAcclFeature(3);
%                 fMagStdLinearAccl = mWinLinearAcclFeature(4);
%                 fMagRangeLinearAccl = mWinLinearAcclFeature(5);
%                 fMagMCRLinearAccl = mWinLinearAcclFeature(6);
%                 fMagMADLinearAccl = mWinLinearAcclFeature(7);
%                 fMagSkewLinearAccl = mWinLinearAcclFeature(8);
%                 fMagRMSLinearAccl = mWinLinearAcclFeature(9);
%                 fMagSMALinearAccl = mWinLinearAcclFeature(10);
% 
%                 fFreqMaxAmpLinearAccl = mWinLinearAcclFeature(11);
%                 fFreqBucketEnergy5LinearAccl = mWinLinearAcclFeature(12);
%                 fFreqBucketRMS5LinearAccl = mWinLinearAcclFeature(13);
%                 fFreqMeanBucketAmp5LinearAccl = mWinLinearAcclFeature(14);
%                 fFreqBucketEnergy10LinearAccl = mWinLinearAcclFeature(15);
%                 fFreqBucketRMS10LinearAccl = mWinLinearAcclFeature(16);
%                 fFreqMeanBucketAmp10LinearAccl = mWinLinearAcclFeature(17);
%                 fFreqBucketEnergy20LinearAccl = mWinLinearAcclFeature(18);
%                 fFreqBucketRMS20LinearAccl = mWinLinearAcclFeature(19);
%                 fFreqMeanBucketAmp20LinearAccl = mWinLinearAcclFeature(20);
% 
%                 fMagMeanGyro = mWinGyroFeature(1);
%                 fMagMedianGyro = mWinGyroFeature(2);
%                 fMagVarGyro = mWinGyroFeature(3);
%                 fMagStdGyro = mWinGyroFeature(4);
%                 fMagRangeGyro = mWinGyroFeature(5);
%                 fMagMCRGyro = mWinGyroFeature(6);
%                 fMagMADGyro = mWinGyroFeature(7);
%                 fMagSkewGyro = mWinGyroFeature(8);
%                 fMagRMSGyro = mWinGyroFeature(9);
%                 fMagSMAGyro = mWinGyroFeature(10);
% 
%                 fFreqMaxAmpGyro = mWinGyroFeature(11);
%                 fFreqBucketEnergy5Gyro = mWinGyroFeature(12);
%                 fFreqBucketRMS5Gyro = mWinGyroFeature(13);
%                 fFreqMeanBucketAmp5Gyro = mWinGyroFeature(14);
%                 fFreqBucketEnergy10Gyro = mWinGyroFeature(15);
%                 fFreqBucketRMS10Gyro = mWinGyroFeature(16);
%                 fFreqMeanBucketAmp10Gyro = mWinGyroFeature(17);
%                 fFreqBucketEnergy20Gyro = mWinGyroFeature(18);
%                 fFreqBucketRMS20Gyro = mWinGyroFeature(19);
%                 fFreqMeanBucketAmp20Gyro = mWinGyroFeature(20);
% 
%                 fMagMeanBaro = mWinBaroFeature(1);
%                 fMagMedianBaro = mWinBaroFeature(2);
%                 fMagVarBaro = mWinBaroFeature(3);            
%                 fMagStdBaro = mWinBaroFeature(4);
%                 fMagRangeBaro = mWinBaroFeature(5);
%                 fMagMCRBaro = mWinBaroFeature(6);
%                 fMagMADBaro = mWinBaroFeature(7);
%                 fMagSkewBaro = mWinBaroFeature(8);
%                 fMagRMSBaro = mWinBaroFeature(9);
%                 fMagSMABaro = mWinBaroFeature(10);  
% 
%                 % No Ground Truth, only features for Moving
%                 fprintf(fidWriteDF, '%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,  %4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,  %4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f\n', ...
%                         fMagMeanLinearAccl,fMagMedianLinearAccl,fMagVarLinearAccl,fMagStdLinearAccl,fMagRangeLinearAccl,fMagMCRLinearAccl,fMagMADLinearAccl,fMagSkewLinearAccl,fMagRMSLinearAccl,fMagSMALinearAccl, ...
%                         fFreqMaxAmpLinearAccl, ...
%                         fFreqBucketEnergy5LinearAccl, fFreqBucketRMS5LinearAccl, fFreqMeanBucketAmp5LinearAccl, ...
%                         fFreqBucketEnergy10LinearAccl,fFreqBucketRMS10LinearAccl,fFreqMeanBucketAmp10LinearAccl, ...
%                         fFreqBucketEnergy20LinearAccl,fFreqBucketRMS20LinearAccl,fFreqMeanBucketAmp20LinearAccl, ...
%                         fMagMeanGyro,      fMagMedianGyro,      fMagVarGyro,      fMagStdGyro,      fMagRangeGyro,      fMagMCRGyro,      fMagMADGyro,      fMagSkewGyro,      fMagRMSGyro,      fMagSMAGyro, ...
%                         fFreqMaxAmpGyro, ...
%                         fFreqBucketEnergy5Gyro, fFreqBucketRMS5Gyro, fFreqMeanBucketAmp5Gyro, ...
%                         fFreqBucketEnergy10Gyro,fFreqBucketRMS10Gyro,fFreqMeanBucketAmp10Gyro, ...
%                         fFreqBucketEnergy20Gyro,fFreqBucketRMS20Gyro,fFreqMeanBucketAmp20Gyro, ...                    
%                         fMagMeanBaro,      fMagMedianBaro,      fMagVarBaro,      fMagStdBaro,      fMagRangeBaro,      fMagMCRBaro,      fMagMADBaro,      fMagSkewBaro,      fMagRMSBaro,      fMagSMABaro);
%              
%             end
            
        else   % Stop
            
            if nInTurn == 0
                nBasicFeatureCnt = nBasicFeatureCnt + 1;
                mSegBasicFeature(nBasicFeatureCnt, 1) = 0;    % Stop
                mSegBasicFeature(nBasicFeatureCnt, 2) = mSegMotionReplaced(nWinEndLine,1) - mSegMotionReplaced(nWinBeginLine,1);   % Duration 
                mSegBasicFeature(nBasicFeatureCnt, 3) = nWinBeginLine + nBeginLine -1;    % Begin Line in the original trace
                mSegBasicFeature(nBasicFeatureCnt, 4) = nWinEndLine + nBeginLine -1;      % End Line in the original trace
                mSegBasicFeature(nBasicFeatureCnt, 5) = mean(mSegMotionReplaced(nWinBeginLine:nWinEndLine,nIdxDataType+4));     % GPS Lat
                mSegBasicFeature(nBasicFeatureCnt, 6) = mean(mSegMotionReplaced(nWinBeginLine:nWinEndLine,nIdxDataType+5));     % GPS Long
                
                nContinuousStopCnt = nContinuousStopCnt + 1;
                
                % Decide the static status and select the Unit Accl for
                % rotation
                if nContinuousStopCnt >= nContinuousStopCntThreshold
                    nRealBeginLine = nWinBeginLine + nBeginLine -1;
                    nRealEndLine = nWinEndLine + nBeginLine -1;
                     
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

                        mUnitAccl = mUniquedTmCrtTrace(nAcclLineNo, nIdxDataType+1:nIdxDataType+3)/sqrt(power(mUniquedTmCrtTrace(nAcclLineNo, nIdxDataType+1),2) + power(mUniquedTmCrtTrace(nAcclLineNo, nIdxDataType+2),2) + power(mUniquedTmCrtTrace(nAcclLineNo, nIdxDataType+3),2));
                        %mUnitAccl = mSegMotionReplaced(nAcclLineNo, nIdxDataType+1:nIdxDataType+3)/sqrt(power(mSegMotionReplaced(nAcclLineNo, nIdxDataType+1),2) + power(mSegMotionReplaced(nAcclLineNo, nIdxDataType+2),2) + power(mSegMotionReplaced(nAcclLineNo, nIdxDataType+3),2));

                        mUnitAcclInfo(nUnitAcclInfoCnt, 3) = mUnitAccl(1);
                        mUnitAcclInfo(nUnitAcclInfoCnt, 4) = mUnitAccl(2);
                        mUnitAcclInfo(nUnitAcclInfoCnt, 5) = mUnitAccl(3);
                        
                        nContinuousStopCnt = 0;
                    end
                end
            end
        end     % Stop or not
        
        % Move Window
        fWinBeginTm = fWinBeginTm + fWindowStep;
        
        if fWinBeginTm >= fLastMoment
            break;
        end
        
        nWinBeginLine = SBM_GetLineNoBeyondTime(mSegMotionReplaced, nWinBeginLine, fWinBeginTm);
        if nWinBeginLine == -1
            break;
        end
        
        fWinEndTm = fWinBeginTm + fWindowSize; 
    end 
    
    fclose(fidWriteDF);
    
    mCellSegBasicFeature{i} = mSegBasicFeature;
    mCellUnitAcclInfo{i} = mUnitAcclInfo;
    mCellCellTurnGyroRows{i} = mCellTurnGyroRows;
        
end   % for i = 1:nSegmentCnt


% Process Basic Feature and save into file
for i = 1:nSegmentCnt
    %
    % Set Result File Pathname for Basic Feature here
    %
    [pathstr, filename, ext] = fileparts(sUniquedTmCrtTrace);
    sResultSegBFFile = [pathstr '\' sFeatureSubFolder '\' filename '_' sBasicFeatureFilePostFix '_' num2str(i) '.csv'];
    fidWriteBF = fopen(sResultSegBFFile, 'w');
    
    mSegBasicFeature = mCellSegBasicFeature{i};
    mCellTurnGyroRows = mCellCellTurnGyroRows{i};
    
    % Decide Turn Direction in mSegBasicFeature
    mSegBasicFeature = SBM_DecideTurnDirection(mSegBasicFeature, mCellUnitAcclInfo, i, mCellTurnGyroRows, nIdxDataType); 
    
    % Merge and combine Stop/Moving/Turn to form basic features
    mResultBasicFeature = SBM_ExtractPassengerBasicFeature(mUniquedTmCrtTrace, mSegBasicFeature, nIdxDataType);
    
    [nResultBasicFeatureCnt ~] = size(mResultBasicFeature);
    
    % Write into Segment Basic Feature File: Type (0-stop; 1-moving; 2-
    % turn), duration, original begin line, original end line
    for k = 1:nResultBasicFeatureCnt
        fprintf(fidWriteBF, '%d,%f,%d,%d,%5.8f,%5.8f\n', mResultBasicFeature(k, 1),mResultBasicFeature(k, 2),mResultBasicFeature(k, 3),mResultBasicFeature(k, 4),mResultBasicFeature(k, 5),mResultBasicFeature(k, 6));
    end
    
    fclose(fidWriteBF);

end


fprintf('\nFinish Time [Calculate Feature]: %s\n', datestr(clock, 'yyyy-mm-dd HH:MM:SS'));

fprintf('\nFinish Time: %s\n', datestr(clock, 'yyyy-mm-dd HH:MM:SS'));

return;

