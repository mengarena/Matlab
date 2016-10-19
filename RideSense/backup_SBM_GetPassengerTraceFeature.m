function f = backup_SBM_GetPassengerTraceFeature(sUniquedTmCrtTrace, sTraceInfoG, nIdxDataType)
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
%    Turn:  2 (type), direction (1--left, -1--right, 0--No Turn)
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

fprintf('Start Time: %s\n', datestr(clock, 'yyyy-mm-dd HH:MM:SS'));

format long;

fprintf('Start Time [Calculate Passenger Trace Feature]: %s\n', datestr(clock, 'yyyy-mm-dd HH:MM:SS'));

sMsg = ['Calculate Feature for:  ' sUniquedTmCrtTrace];
disp(sMsg);

sFeatureSubFolder = 'Feature';

%%%%%%%%%%%%%%Set Information for Stop Detection%%%%%%%%%%%%%%%%%%%%%%
sRFModelFile = 'E:\SensorMatching\Data\SchoolShuttle\TrainedModel\RF\Normal\Passenger\50tree\StopDetection_RF_2_3_4_5_6_7_8_9.mat';

mSelectedFeatures = [1 2 3 4 5 6 7 8];  % Index starts from 1

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
sBasicFeatureFilePostFix = 'SegBF';
sDetailedFeatureFilePostFix = 'SegDF';

fWindowSize = 1.0;  % seconds
fWindowStep = fWindowSize*0.5;  % If Non-overlapping, set this to fWindowSize

for i = 1:nSegmentCnt
    nBeginLine = mSegment(i, 2);  % Begin Line of current segment
    nEndLine = mSegment(i, 3);    % End Line of current segment

    %
    % Set Result File Pathname for Basic Feature here
    %
    [pathstr, filename, ext] = fileparts(sUniquedTmCrtTrace);
    sResultSegBFFile = [pathstr '\' sFeatureSubFolder '\' filename '_' sBasicFeatureFilePostFix '_' num2str(i) '.csv'];
    fidWriteBF = fopen(sResultSegBFFile, 'w');
    
    % Get all the turn information of the segment, 
    % For each turn:  Begin Line, End Line, Direction (1--Left, -1--Right, 0--No Turn), Turn Degree, GPS Lat, GPS Long 
    mTurns = SBM_GetTurnInfo(mUniquedTmCrtTrace,nBeginLine,nEndLine,nIdxDataType);
        
    % For Stop/Moving, there is no GPS information, must use Stop Detection to decide   % 1:  Stop, 0: Non-Stop
    
    %
    % Set Result File Pathname for Detailed here
    %
    [pathstr, filename, ext] = fileparts(sUniquedTmCrtTrace);
    sResultSegDFFile = [pathstr '\' sFeatureSubFolder '\' filename '_' sDetailedFeatureFilePostFix '_' num2str(i) '.csv'];
    fidWriteDF = fopen(sResultSegDFFile, 'w');
    
    
    % Preprocessing sensor
    mCellSegMotionFiltered = SBM_PreprocessSensors(mUniquedTmCrtTrace(nBeginLine:nEndLine,:));
    
    mFilteredLinearAccl = mCellSegMotionFiltered{1};
    mFilteredGyro = mCellSegMotionFiltered{2};
    mFilteredBaro = mCellSegMotionFiltered{3};
    
    % Replace back, i.e. replace the raw LinearAccl, Gyro, Baro with the
    % filtered values
    mSegMotionReplaced = mCellSegMotionFiltered;  %% 1st Line --- nBeginLine;   last line --- nEndLine
    mSegMotionReplaced((mSegMotionReplaced(:,nIdxDataType) == 2),:) = mFilteredLinearAccl;
    mSegMotionReplaced((mSegMotionReplaced(:,nIdxDataType) == 3),:) = mFilteredGyro;
    mSegMotionReplaced((mSegMotionReplaced(:,nIdxDataType) == 7),:) = mFilteredBaro;
    
    [nTotalSegRecord ~] = size(mSegMotionReplaced);
    fLastMoment = mSegMotionReplaced(nTotalSegRecord,1);
    
    % Window sensor data and calculate features
    fWinBeginTm = mSegMotionReplaced(1,1);
    fWinEndTm = fWinBeginTm + fWindowSize;
    nWinBeginLine = 1;
    
    mSegBasicFeature = [];
    nBasicFeatureCnt = 0;

    % True line No. in mUniquedTmCrtTrace = x + nBeginLine - 1;
    
    while fWinEndTm <= fLastMoment 
        nWinEndLine = SBM_GetLineNoWithinTime(mSegMotionReplaced, nWinBeginLine, fWinEndTm);
        if nWinEndLine == -1
            break;
        end
        
        [bIsTurnBegin nTurnIdxBegin] = SBM_CheckIsTurn(mTurns, nWinBeginLine);
        [bIsTurnEnd nTurnIdxEnd] = SBM_CheckIsTurn(mTurns, nWinEndLine);
        
        if bIsTurnBegin == 1 || bIsTurnEnd == 1  % Within a Turn
            nBasicFeatureCnt = nBasicFeatureCnt + 1;
            mSegBasicFeature(nBasicFeatureCnt, 1) = 2;    % Turn
            mSegBasicFeature(nBasicFeatureCnt, 2) = mTurns(nTurnIdxBegin, 3);   % Turn Direction 
            mSegBasicFeature(nBasicFeatureCnt, 3) = mTurns(nTurnIdxBegin, 1);   % Turn Begin Line 
            mSegBasicFeature(nBasicFeatureCnt, 4) = mTurns(nTurnIdxBegin, 2);   % Turn End Line (in Original trace)
%             mSegBasicFeature(nBasicFeatureCnt, 5) = mTurns(nTurnIdxBegin, 5);   % Turn GPS Lat 
%             mSegBasicFeature(nBasicFeatureCnt, 6) = mTurns(nTurnIdxBegin, 6);   % Turn GPS Long 
            
            % Move Window
            %fWinBeginTm = fWinBeginTm + fWindowStep;

            nWinBeginLine = mTurns(nTurnIdxBegin, 2) + 1 - nBeginLine + 1;  % Relative Line in this segment
            
            if nWinBeginLine >= nTotalSegRecord
                break;
            end
            
            fWinBeginTm = mSegMotionReplaced(nWinBeginLine, 1);
            fWinEndTm = fWinBeginTm + fWindowSize;
            
            continue;
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
        
        fprintf('Predicated #Label: %d\n', length(mStrPredictedLabel));   % Should only has one item
        
        if nPredicatedLabel == 0  % Non-stop
            mSegBasicFeature(nBasicFeatureCnt, 1) = 1;    % Moving
            mSegBasicFeature(nBasicFeatureCnt, 2) = mSegMotionReplaced(nWinEndLine,1) - mSegMotionReplaced(nWinBeginLine,1);   % Duration 
            mSegBasicFeature(nBasicFeatureCnt, 3) = nWinBeginLine + nBeginLine -1;    % Begin Line 
            mSegBasicFeature(nBasicFeatureCnt, 4) = nWinEndLine + nBeginLine -1;      % End Line 

            % Save the detailed motion feature
            if length(mWinLinearAcclFeature) > 0 && length(mWinGyroFeature) > 0 && length(mWinBaroFeature) > 0
                fMagMeanLinearAccl = mWinLinearAcclFeature(1);
                fMagStdLinearAccl = mWinLinearAcclFeature(2);
                fMagRangeLinearAccl = mWinLinearAcclFeature(3);
                fMagMCRLinearAccl = mWinLinearAcclFeature(4);
                fMagMADLinearAccl = mWinLinearAcclFeature(5);
                fMagSkewLinearAccl = mWinLinearAcclFeature(6);
                fMagRMSLinearAccl = mWinLinearAcclFeature(7);
                fMagSMALinearAccl = mWinLinearAcclFeature(8);
                fMagMeanGyro = mWinGyroFeature(1);
                fMagStdGyro = mWinGyroFeature(2);
                fMagRangeGyro = mWinGyroFeature(3);
                fMagMCRGyro = mWinGyroFeature(4);
                fMagMADGyro = mWinGyroFeature(5);
                fMagSkewGyro = mWinGyroFeature(6);
                fMagRMSGyro = mWinGyroFeature(7);
                fMagSMAGyro = mWinGyroFeature(8);
                
                fMagMeanBaro = mWinBaroFeature(1);
                fMagStdBaro = mWinBaroFeature(2);
                fMagRangeBaro = mWinBaroFeature(3);
                fMagMCRBaro = mWinBaroFeature(4);
                fMagMADBaro = mWinBaroFeature(5);
                fMagSkewBaro = mWinBaroFeature(6);
                fMagRMSBaro = mWinBaroFeature(7);
                fMagSMABaro = mWinBaroFeature(8);  

                % No Ground Truth, only features for moving
                fprintf(fidWriteDF, '%f,%f,%f,%f,%f,%f,%f,%f,  %f,%f,%f,%f,%f,%f,%f,%f,  %f,%f,%f,%f,%f,%f,%f,%f\n', ...
                        fMagMeanLinearAccl,fMagStdLinearAccl,fMagRangeLinearAccl,fMagMCRLinearAccl,fMagMADLinearAccl,fMagSkewLinearAccl,fMagRMSLinearAccl,fMagSMALinearAccl, ...
                        fMagMeanGyro,      fMagStdGyro,      fMagRangeGyro,      fMagMCRGyro,      fMagMADGyro,      fMagSkewGyro,      fMagRMSGyro,      fMagSMAGyro, ...
                        fMagMeanBaro,      fMagStdBaro,      fMagRangeBaro,      fMagMCRBaro,      fMagMADBaro,      fMagSkewBaro,      fMagRMSBaro,      fMagSMABaro);

            end
        else   % Stop
            mSegBasicFeature(nBasicFeatureCnt, 1) = 0;    % Stop
            mSegBasicFeature(nBasicFeatureCnt, 2) = mSegMotionReplaced(nWinEndLine,1) - mSegMotionReplaced(nWinBeginLine,1);   % Duration 
            mSegBasicFeature(nBasicFeatureCnt, 3) = nWinBeginLine + nBeginLine -1;    % Begin Line in the original trace
            mSegBasicFeature(nBasicFeatureCnt, 4) = nWinEndLine + nBeginLine -1;      % End Line in the original trace
        end
        
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
    
    % From the above code, the basic feature ares are calculated through
    % overlapping windows; each one stop action, was divided into many
    % windows, need to merge them to get macro stops/moving
    % mean GPS Lat, GPS Long need to be added
    mMergedBasicFeature = SBM_MergeFeature(mSegBasicFeature, mUniquedTmCrtTrace, nIdxDataType);
    
    %
    % Before writing into file, filter out the Stop/Moving which has too
    % small duration, (and merge after removing small unit)
    %
    % To DO here
    mSegBasicFeatureFiltered = SBM_FilterBasicFeature(mMergedBasicFeature, mUniquedTmCrtTrace);
    
    [nFilteredBasicFeatureCnt ~] = size(mSegBasicFeatureFiltered);
    % Write into Segment Basic Feature File
    for k = 1:nFilteredBasicFeatureCnt
        fprintf(fidWriteBF, '%d,%f,%d,%d\n', mSegBasicFeatureFiltered(k, 1),mSegBasicFeatureFiltered(k, 2),mSegBasicFeatureFiltered(k, 3),mSegBasicFeatureFiltered(k, 4));
    end
    
    fclose(fidWriteBF);
   
    
end   % for i = 1:nSegmentCnt


fprintf('\nFinish Time [Calculate Feature]: %s\n', datestr(clock, 'yyyy-mm-dd HH:MM:SS'));

fprintf('\nFinish Time: %s\n', datestr(clock, 'yyyy-mm-dd HH:MM:SS'));

return;

