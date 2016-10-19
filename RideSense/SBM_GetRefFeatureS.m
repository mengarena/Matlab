function f = SBM_GetRefFeatureS(sUniquedTmCrtTrace, sTraceInfoG)
% This function is used to get the Basic Features of the Reference Trace 
% It also get detailed features (from accl, gyro, baro) of each segments
% 
% @sUniquedTmCrtTrace:  The uniqued and timestamp corrected sensor trace
% file
% @sTraceInfoG:  The general information file which tells information about the segment and
% station of the trace (For all traces: Pantpocket, Ref, Hand, these
% general information are generated.)
%
% Basic Feature (for each segment)
% 1) A series of data, describe stops (NOT station)/moving/turns
%    Stop: 0 (type), duration
%    Moving: 1 (type), duration
%    Turn:  2 (type), direction (1--left, -1--right, 0--Uncertain, 9--No Turn)
%       -- Window size for Turn:  6 seconds, Window Step:  2  (Refer to past
%       project) Overlapping Window
%       
%  For Reference trace, the stop (not station) is decided by GPS speed = 0
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Different from SBM_GetRefFeature:
%% This function includes the stops (not station) also as detailed features
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fprintf('Start Time: %s\n', datestr(clock, 'yyyy-mm-dd HH:MM:SS'));

format long;

fprintf('Start Time [Calculate Reference Trace Feature]: %s\n', datestr(clock, 'yyyy-mm-dd HH:MM:SS'));

sMsg = ['Calculate Feature for:  ' sUniquedTmCrtTrace];
disp(sMsg);

sFeatureSubFolder = 'Feature';
nIdxDataType = 2;   % Index of Data type in _TmCrt file (for reference and pocket phone, if hand phone, should +1)
nIdxGpsSpeed = 9;   % Index of GPS speed in _TmCrt file (for reference and pocket phone; if hand phone, should +1)

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
disp('Extract Basic Features (Property of Segment)....');
sBasicFeatureFilePostFix = 'SegBFs';   

for i = 1:nSegmentCnt
    fprintf('Segment [%d]...\n', i);
    nBeginLine = mSegment(i, 2);  % Begin Line of current segment in Original trace
    nEndLine = mSegment(i, 3);    % End Line of current segment in Original trace

    %
    % Set Result File Pathname here
    %
    [pathstr, filename, ext] = fileparts(sUniquedTmCrtTrace);
    sResultSegBFFile = [pathstr '\' sFeatureSubFolder '\' filename '_' sBasicFeatureFilePostFix '_' num2str(i) '.csv'];
    fidWriteBF = fopen(sResultSegBFFile, 'w');
    
    disp('Getting Turn Information...');
    % Get all the turn information of the segment, 
    % For each turn:  Begin Line, End Line, Direction (1--Left, -1--Right, 0--Uncertain, 9--No turn), Turn Degree, GPS Lat, GPS Long 
    mTurns = SBM_GetTurnInfo(mUniquedTmCrtTrace,nBeginLine,nEndLine,nIdxDataType)
    
    nPreviousStatus = -1;   %  0-stop, 1-moving, 2-turn
    
    mSegBasicFeature = [];
    nBasicFeatureCnt = 0;
    
    nMotionUnitStartLine = 0;
    
    disp('Extract Stop/Moving Information...');
    
    nSegLine = nBeginLine;
    while nSegLine <= nEndLine
        % Check every line's GPS speed and whether this line is within
        % Turns     
        
        %fprintf('============[Current Line: %d / %d]\n', nSegLine, nEndLine);
        [bIsTurn nTurnIdx] = SBM_CheckIsTurn(mTurns, nSegLine);

        if bIsTurn == 1   % It is a Turn
            % First summarize previous motion Unit
            if nPreviousStatus == 0 || nPreviousStatus == 1  % Previous status: stop or moving
                nBasicFeatureCnt = nBasicFeatureCnt + 1;
                mSegBasicFeature(nBasicFeatureCnt, 1) = nPreviousStatus;
                mSegBasicFeature(nBasicFeatureCnt, 2) = mUniquedTmCrtTrace(nSegLine-1,1) - mUniquedTmCrtTrace(nMotionUnitStartLine,1);  % Duration
                mSegBasicFeature(nBasicFeatureCnt, 3) = nMotionUnitStartLine;  % Start line
                mSegBasicFeature(nBasicFeatureCnt, 4) = nSegLine-1;  % End line
                mSegBasicFeature(nBasicFeatureCnt, 5) = mean(mUniquedTmCrtTrace(nMotionUnitStartLine:nSegLine-1,nIdxDataType+4));  % mean GPS Lat
                mSegBasicFeature(nBasicFeatureCnt, 6) = mean(mUniquedTmCrtTrace(nMotionUnitStartLine:nSegLine-1,nIdxDataType+5));  % mean GPS Long
            end
            
            %disp('In Turn....');
            nBasicFeatureCnt = nBasicFeatureCnt + 1;
            mSegBasicFeature(nBasicFeatureCnt, 1) = 2;  % Type = turn
            
            nTurnBeginLine = mTurns(nTurnIdx, 1);
            nTurnEndLine = mTurns(nTurnIdx, 2);

            mSegBasicFeature(nBasicFeatureCnt, 2) = mTurns(nTurnIdx, 3);   % ******Turn Direction** 
            mSegBasicFeature(nBasicFeatureCnt, 3) = nTurnBeginLine;        % Turn Begin Line 
            mSegBasicFeature(nBasicFeatureCnt, 4) = nTurnEndLine;          % Turn End Line 
            mSegBasicFeature(nBasicFeatureCnt, 5) = mTurns(nTurnIdx, 5);   % Turn GPS Lat 
            mSegBasicFeature(nBasicFeatureCnt, 6) = mTurns(nTurnIdx, 6);   % Turn GPS Long 

            %mSegBasicFeature(nBasicFeatureCnt, 3) = mUniquedTmCrtTrace(nTurnEndLine,1) - mUniquedTmCrtTrace(nTurnBeginLine,1);  % Turn Duration
            
            nPreviousStatus = 2;  % Turn
            
            nSegLine = nTurnEndLine + 1;

            nMotionUnitStartLine = 0;
            continue;
        else  % Stop or Moving
            %disp('Here');
            fGpsSpeed = mUniquedTmCrtTrace(nSegLine, nIdxGpsSpeed);  % For Reference trace, use GPS speed to decide the bus is moving or stopped; for other traces (i.e. Pantpocket and Hand)
            
            if fGpsSpeed == 0  % Stop
                %disp('In Stop...');
                if nPreviousStatus == 1  % Previous is moving
                    % First summarize previous motion Unit
                    nBasicFeatureCnt = nBasicFeatureCnt + 1;
                    mSegBasicFeature(nBasicFeatureCnt, 1) = 1;  % Moving
                    mSegBasicFeature(nBasicFeatureCnt, 2) = mUniquedTmCrtTrace(nSegLine-1,1) - mUniquedTmCrtTrace(nMotionUnitStartLine,1);  % Duration
                    mSegBasicFeature(nBasicFeatureCnt, 3) = nMotionUnitStartLine;  % Start line
                    mSegBasicFeature(nBasicFeatureCnt, 4) = nSegLine-1;  % End line
                    mSegBasicFeature(nBasicFeatureCnt, 5) = mean(mUniquedTmCrtTrace(nMotionUnitStartLine:nSegLine-1,nIdxDataType+4));  % mean GPS Lat
                    mSegBasicFeature(nBasicFeatureCnt, 6) = mean(mUniquedTmCrtTrace(nMotionUnitStartLine:nSegLine-1,nIdxDataType+5));  % mean GPS Long
                    
                    nMotionUnitStartLine = nSegLine;
                    
                elseif nPreviousStatus == 2
                    nMotionUnitStartLine = nSegLine;
                elseif nPreviousStatus == 0  % Stop
                    if nSegLine == nEndLine  % Already last line
                        nBasicFeatureCnt = nBasicFeatureCnt + 1;
                        mSegBasicFeature(nBasicFeatureCnt, 1) = 0;   % Stop
                        mSegBasicFeature(nBasicFeatureCnt, 2) = mUniquedTmCrtTrace(nSegLine,1) - mUniquedTmCrtTrace(nMotionUnitStartLine,1);  % Duration
                        mSegBasicFeature(nBasicFeatureCnt, 3) = nMotionUnitStartLine;  % Start line
                        mSegBasicFeature(nBasicFeatureCnt, 4) = nSegLine;              % End line 
                        mSegBasicFeature(nBasicFeatureCnt, 5) = mean(mUniquedTmCrtTrace(nMotionUnitStartLine:nSegLine,nIdxDataType+4));  % mean GPS Lat 
                        mSegBasicFeature(nBasicFeatureCnt, 6) = mean(mUniquedTmCrtTrace(nMotionUnitStartLine:nSegLine,nIdxDataType+5));  % mean GPS Long
                        
                        break;
                    end
                else
                    nMotionUnitStartLine = nSegLine;
                end
                
                nPreviousStatus = 0;  % Stop
            else  % fGpsSpeed > 0
                %disp('In Move...');
                if nPreviousStatus == 0
                    % First summary previous motion Unit
                    nBasicFeatureCnt = nBasicFeatureCnt + 1;
                    mSegBasicFeature(nBasicFeatureCnt, 1) = 0;   % Stop
                    mSegBasicFeature(nBasicFeatureCnt, 2) = mUniquedTmCrtTrace(nSegLine-1,1) - mUniquedTmCrtTrace(nMotionUnitStartLine,1);  % Duration
                    mSegBasicFeature(nBasicFeatureCnt, 3) = nMotionUnitStartLine;  % Start line
                    mSegBasicFeature(nBasicFeatureCnt, 4) = nSegLine-1;            % End line
                    mSegBasicFeature(nBasicFeatureCnt, 5) = mean(mUniquedTmCrtTrace(nMotionUnitStartLine:nSegLine-1,nIdxDataType+4));  % mean GPS Lat 
                    mSegBasicFeature(nBasicFeatureCnt, 6) = mean(mUniquedTmCrtTrace(nMotionUnitStartLine:nSegLine-1,nIdxDataType+5));  % mean GPS Long
                                         
                    nMotionUnitStartLine = nSegLine;
                elseif nPreviousStatus == 2
                    nMotionUnitStartLine = nSegLine;
                elseif nPreviousStatus == 1
                    if nSegLine == nEndLine  % Already last line
                        nBasicFeatureCnt = nBasicFeatureCnt + 1;
                        mSegBasicFeature(nBasicFeatureCnt, 1) = 1;  % Moving
                        mSegBasicFeature(nBasicFeatureCnt, 2) = mUniquedTmCrtTrace(nSegLine,1) - mUniquedTmCrtTrace(nMotionUnitStartLine,1);  % Duration
                        mSegBasicFeature(nBasicFeatureCnt, 3) = nMotionUnitStartLine;  % Start line
                        mSegBasicFeature(nBasicFeatureCnt, 4) = nSegLine;              % End line
                        mSegBasicFeature(nBasicFeatureCnt, 5) = mean(mUniquedTmCrtTrace(nMotionUnitStartLine:nSegLine,nIdxDataType+4));  % mean GPS Lat 
                        mSegBasicFeature(nBasicFeatureCnt, 6) = mean(mUniquedTmCrtTrace(nMotionUnitStartLine:nSegLine,nIdxDataType+5));  % mean GPS Long
                        
                        break;
                    end
                else
                    nMotionUnitStartLine = nSegLine;
                end
                
                nPreviousStatus = 1;  % Moving
            end
            
            nSegLine = nSegLine + 1;
            %fprintf('Processing.....................Line [%d / %d]\n', nSegLine, nEndLine);
        end

    end  %  while nSegLine <= nEndLine
    
    %
    % Before writing into file, filter out the Stop/Moving which has too
    % small duration, (and merge after removing small unit)
    %
    % To DO here
    disp('Remove Basic Features which has too small duration...');
    mSegBasicFeatureFiltered = SBM_FilterBasicFeature(mSegBasicFeature, mUniquedTmCrtTrace, nIdxDataType);
    
    [nFilteredBasicFeatureCnt ~] = size(mSegBasicFeatureFiltered);
    % Write into Segment Basic Feature File
    for k = 1:nFilteredBasicFeatureCnt
        fprintf(fidWriteBF, '%d,%f,%d,%d,%5.8f,%5.8f\n', mSegBasicFeatureFiltered(k, 1),mSegBasicFeatureFiltered(k, 2),mSegBasicFeatureFiltered(k, 3),mSegBasicFeatureFiltered(k, 4),mSegBasicFeatureFiltered(k, 5),mSegBasicFeatureFiltered(k, 6));
    end
    
    fclose(fidWriteBF);
    
end   % for i = 1:nSegmentCnt


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Detailed Features
%
% Detailed Features are calculated segment by segment
% The stops within a segment are removed, the remained motion data are
% merged
%
% The detailed feature for each segment is stored in a separate file
% The resulting file will be _TmCrt_SegDF_1.csv, _TmCrt_SegDF_2.csv
% (DF--Detailed Feature)
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('Extract Detailed Features (Property of Segment/Station)....');
sDetailedFeatureFilePostFix = 'SegDFs';   % Extract features even when #the car stops# ==> Extract feature for the whole segment 

sDetailedFeatureFileStationPostFix = 'StationDFs';   % Extract features for stations

fWindowSize = 1.0;  % seconds
fWindowStep = fWindowSize*0.5;  % If Non-overlapping, set this to fWindowSize

% One segment one detailed feature file
% The stopping moment within the segment is eliminated for extracting
% detailed features
for i = 1:nSegmentCnt
    nBeginLine = mSegment(i, 2);  % Begin Line of the segment
    nEndLine = mSegment(i, 3);    % End Line of the segment
    
    %
    % Set Result File Pathname here
    %
    
    [pathstr, filename, ext] = fileparts(sUniquedTmCrtTrace);
    sResultSegDFFile = [pathstr '\' sFeatureSubFolder '\' filename '_' sDetailedFeatureFilePostFix '_' num2str(i) '.csv'];
    fidWriteDF = fopen(sResultSegDFFile, 'w');

    % Corresponding station information
    nStationBeginLine = 0;
    nStationEndLine = 0;
    sResultStationDFFile = '';
    fidWriteStationDF = 0;
   
    if i ~= nSegmentCnt
        nStationBeginLine = mStation(i+1,2);
        nStationEndLine = mStation(i+1,3);
        sResultStationDFFile = [pathstr '\' sFeatureSubFolder '\' filename '_' sDetailedFeatureFileStationPostFix '_' num2str(i) '.csv'];
        fidWriteStationDF = fopen(sResultStationDFFile, 'w');
    end
    
    % bPreviousStop = 0;

    mRemainedSegMotion = [];
    nTotalMotionRecord = 0;

    mRemainedStationMotion = [];
    nTotalStationMotionRecord = 0;
   
    % Select moving sensor data from _TmCrt.csv and merge them into
    % mRemainedSegMotion, adjust timestamp when merging
%     for j = nBeginLine:nEndLine
%         fGpsSpeed = mUniquedTmCrtTrace(j, nIdxGpsSpeed);
%         
%         if fGpsSpeed == 0  % stopped
%             bPreviousStop = 1;
%             
%         else  % moving            
%             nTotalMotionRecord = nTotalMotionRecord + 1;
% 
%             mRemainedSegMotion = [mRemainedSegMotion; mUniquedTmCrtTrace(j,:)];
%             
%             if nTotalMotionRecord > 1   
%                 fTimeGap = mUniquedTmCrtTrace(j,1) - mUniquedTmCrtTrace(j-1,1);
%                 if fTimeGap == 0 && mUniquedTmCrtTrace(j,nIdxDataType) == mRemainedSegMotion(nTotalMotionRecord-1,nIdxDataType)   % Need to adjust timestamp
%                     fSensorTimeGap = SBM_GetSensorTimeGap(mUniquedTmCrtTrace(j,nIdxDataType));
%                     mRemainedSegMotion(nTotalMotionRecord,1) = mRemainedSegMotion(nTotalMotionRecord-1,1) + fSensorTimeGap;
%                 else
%                     mRemainedSegMotion(nTotalMotionRecord,1) = mRemainedSegMotion(nTotalMotionRecord-1,1) + fTimeGap;
%                 end
%             end
%             
%             bPreviousStop = 0;
%         end
%     end
    
    %%
    
    mRemainedSegMotion = mUniquedTmCrtTrace(nBeginLine:nEndLine, :);
    nTotalMotionRecord = nEndLine - nBeginLine + 1;
    
    % The station features are the features of the station following the
    % corresponding segment
    if i ~= nSegmentCnt
        nStationBeginLine = SBM_GetLineNoBeyondTime(mUniquedTmCrtTrace, nBeginLine, mUniquedTmCrtTrace(nEndLine, 1) - fWindowStep);  % Adjust the Begin/End line of station to make the whole features continue
        nStationEndLine = SBM_GetLineNoWithinTime(mUniquedTmCrtTrace, nStationEndLine, mUniquedTmCrtTrace(nStationEndLine, 1) + fWindowStep);
        
        mRemainedStationMotion = mUniquedTmCrtTrace(nStationBeginLine:nStationEndLine, :);
        nTotalStationMotionRecord = nStationEndLine - nStationBeginLine + 1;        
    end
    %%
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%% Processing Segments
    disp('Preprocessing...Segment...');
    
    % After merging, preprocessing sensor
    mCellRemainedSegMotionFiltered = SBM_PreprocessSensors(mRemainedSegMotion, nIdxDataType);
    
    mFilteredLinearAccl = mCellRemainedSegMotionFiltered{1};
    mFilteredGyro = mCellRemainedSegMotionFiltered{2};
    mFilteredBaro = mCellRemainedSegMotionFiltered{3};
    
    % Replace back, i.e. replace the raw LinearAccl, Gyro, Baro with the
    % filtered values
    mRemainedSegMotionReplaced = mRemainedSegMotion;
    mRemainedSegMotionReplaced((mRemainedSegMotionReplaced(:,nIdxDataType) == 2),:) = mFilteredLinearAccl;
    mRemainedSegMotionReplaced((mRemainedSegMotionReplaced(:,nIdxDataType) == 3),:) = mFilteredGyro;
    mRemainedSegMotionReplaced((mRemainedSegMotionReplaced(:,nIdxDataType) == 7),:) = mFilteredBaro;
    
    fLastMoment = mRemainedSegMotionReplaced(nTotalMotionRecord,1);
    
    % Window sensor data and calculate features
    fWinBeginTm = mRemainedSegMotionReplaced(1,1);
    fWinEndTm = fWinBeginTm + fWindowSize;
    nWinBeginLine = 1;
    
    disp('Extract Segment Detailed Features...');
    while fWinEndTm <= fLastMoment 
        nWinEndLine = SBM_GetLineNoWithinTime(mRemainedSegMotionReplaced, nWinBeginLine, fWinEndTm);
        if nWinEndLine == -1
            break;
        end
        
        % Process sensor data within a window and extract features
        mWinSensor = mRemainedSegMotionReplaced(nWinBeginLine:nWinEndLine, :);
        mWinLinearAccl = mWinSensor((mWinSensor(:,nIdxDataType) == 2),:);
        mWinGyro = mWinSensor((mWinSensor(:,nIdxDataType) == 3),:);
        mWinBaro = mWinSensor((mWinSensor(:,nIdxDataType) == 7),:);
        
        mWinLinearAcclFeature = SBM_GetWinLinearAcclFeature(mWinLinearAccl, nIdxDataType);
        mWinGyroFeature = SBM_GetWinGyroFeature(mWinGyro, nIdxDataType);
        mWinBaroFeature = SBM_GetWinBaroFeature(mWinBaro, nIdxDataType);
        
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
        
        
        % Move Window
        fWinBeginTm = fWinBeginTm + fWindowStep;
        
        if fWinBeginTm >= fLastMoment
            break;
        end
        
        nWinBeginLine = SBM_GetLineNoBeyondTime(mRemainedSegMotionReplaced, nWinBeginLine, fWinBeginTm);
        if nWinBeginLine == -1
            break;
        end
        
        fWinEndTm = fWinBeginTm + fWindowSize; 
    end 
    
    fclose(fidWriteDF);
    
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%% Processing Station %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if i ~= nSegmentCnt
        disp('Preprocessing...Station...');

        % After merging, preprocessing sensor
        mCellRemainedStationMotionFiltered = SBM_PreprocessSensors(mRemainedStationMotion, nIdxDataType);

        mFilteredStationLinearAccl = mCellRemainedStationMotionFiltered{1};
        mFilteredStationGyro = mCellRemainedStationMotionFiltered{2};
        mFilteredStationBaro = mCellRemainedStationMotionFiltered{3};

        % Replace back, i.e. replace the raw LinearAccl, Gyro, Baro with the
        % filtered values
        mRemainedStationMotionReplaced = mRemainedStationMotion;
        mRemainedStationMotionReplaced((mRemainedStationMotionReplaced(:,nIdxDataType) == 2),:) = mFilteredStationLinearAccl;
        mRemainedStationMotionReplaced((mRemainedStationMotionReplaced(:,nIdxDataType) == 3),:) = mFilteredStationGyro;
        mRemainedStationMotionReplaced((mRemainedStationMotionReplaced(:,nIdxDataType) == 7),:) = mFilteredStationBaro;

        fLastStationMoment = mRemainedStationMotionReplaced(nTotalStationMotionRecord,1);

        % Window sensor data and calculate features
        fStationWinBeginTm = mRemainedStationMotionReplaced(1,1);
        fStationWinEndTm = fStationWinBeginTm + fWindowSize;
        nStationWinBeginLine = 1;

        disp('Extract Station Detailed Features...');
        while fStationWinEndTm <= fLastStationMoment 
            nStationWinEndLine = SBM_GetLineNoWithinTime(mRemainedStationMotionReplaced, nStationWinBeginLine, fStationWinEndTm);
            if nStationWinEndLine == -1
                break;
            end

            % Process sensor data within a window and extract features
            mStationWinSensor = mRemainedStationMotionReplaced(nStationWinBeginLine:nStationWinEndLine, :);
            mStationWinLinearAccl = mStationWinSensor((mStationWinSensor(:,nIdxDataType) == 2),:);
            mStationWinGyro = mStationWinSensor((mStationWinSensor(:,nIdxDataType) == 3),:);
            mStationWinBaro = mStationWinSensor((mStationWinSensor(:,nIdxDataType) == 7),:);

            mStationWinLinearAcclFeature = SBM_GetWinLinearAcclFeature(mStationWinLinearAccl, nIdxDataType);
            mStationWinGyroFeature = SBM_GetWinGyroFeature(mStationWinGyro, nIdxDataType);
            mStationWinBaroFeature = SBM_GetWinBaroFeature(mStationWinBaro, nIdxDataType);

            if length(mStationWinLinearAcclFeature) > 0 && length(mStationWinGyroFeature) > 0 && length(mStationWinBaroFeature) > 0
                fStationMagMeanLinearAccl = mStationWinLinearAcclFeature(1);
                fStationMagMedianLinearAccl = mStationWinLinearAcclFeature(2);
                fStationMagVarLinearAccl = mStationWinLinearAcclFeature(3);
                fStationMagStdLinearAccl = mStationWinLinearAcclFeature(4);
                fStationMagRangeLinearAccl = mStationWinLinearAcclFeature(5);
                fStationMagMCRLinearAccl = mStationWinLinearAcclFeature(6);
                fStationMagMADLinearAccl = mStationWinLinearAcclFeature(7);
                fStationMagSkewLinearAccl = mStationWinLinearAcclFeature(8);
                fStationMagRMSLinearAccl = mStationWinLinearAcclFeature(9);
                fStationMagSMALinearAccl = mStationWinLinearAcclFeature(10);

                fStationFreqMaxAmpLinearAccl = mStationWinLinearAcclFeature(11);
                fStationFreqBucketEnergy5LinearAccl = mStationWinLinearAcclFeature(12);
                fStationFreqBucketRMS5LinearAccl = mStationWinLinearAcclFeature(13);
                fStationFreqMeanBucketAmp5LinearAccl = mStationWinLinearAcclFeature(14);
                fStationFreqBucketEnergy10LinearAccl = mStationWinLinearAcclFeature(15);
                fStationFreqBucketRMS10LinearAccl = mStationWinLinearAcclFeature(16);
                fStationFreqMeanBucketAmp10LinearAccl = mStationWinLinearAcclFeature(17);
                fStationFreqBucketEnergy20LinearAccl = mStationWinLinearAcclFeature(18);
                fStationFreqBucketRMS20LinearAccl = mStationWinLinearAcclFeature(19);
                fStationFreqMeanBucketAmp20LinearAccl = mStationWinLinearAcclFeature(20);

                fStationMagMeanGyro = mStationWinGyroFeature(1);
                fStationMagMedianGyro = mStationWinGyroFeature(2);
                fStationMagVarGyro = mStationWinGyroFeature(3);
                fStationMagStdGyro = mStationWinGyroFeature(4);
                fStationMagRangeGyro = mStationWinGyroFeature(5);
                fStationMagMCRGyro = mStationWinGyroFeature(6);
                fStationMagMADGyro = mStationWinGyroFeature(7);
                fStationMagSkewGyro = mStationWinGyroFeature(8);
                fStationMagRMSGyro = mStationWinGyroFeature(9);
                fStationMagSMAGyro = mStationWinGyroFeature(10);

                fStationFreqMaxAmpGyro = mStationWinGyroFeature(11);
                fStationFreqBucketEnergy5Gyro = mStationWinGyroFeature(12);
                fStationFreqBucketRMS5Gyro = mStationWinGyroFeature(13);
                fStationFreqMeanBucketAmp5Gyro = mStationWinGyroFeature(14);
                fStationFreqBucketEnergy10Gyro = mStationWinGyroFeature(15);
                fStationFreqBucketRMS10Gyro = mStationWinGyroFeature(16);
                fStationFreqMeanBucketAmp10Gyro = mStationWinGyroFeature(17);
                fStationFreqBucketEnergy20Gyro = mStationWinGyroFeature(18);
                fStationFreqBucketRMS20Gyro = mStationWinGyroFeature(19);
                fStationFreqMeanBucketAmp20Gyro = mStationWinGyroFeature(20);

                fStationMagMeanBaro = mStationWinBaroFeature(1);
                fStationMagMedianBaro = mStationWinBaroFeature(2);
                fStationMagVarBaro = mStationWinBaroFeature(3);            
                fStationMagStdBaro = mStationWinBaroFeature(4);
                fStationMagRangeBaro = mStationWinBaroFeature(5);
                fStationMagMCRBaro = mStationWinBaroFeature(6);
                fStationMagMADBaro = mStationWinBaroFeature(7);
                fStationMagSkewBaro = mStationWinBaroFeature(8);
                fStationMagRMSBaro = mStationWinBaroFeature(9);
                fStationMagSMABaro = mStationWinBaroFeature(10);  

                % No Ground Truth, only features for Moving
                fprintf(fidWriteStationDF, '%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,  %4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,  %4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f\n', ...
                        fStationMagMeanLinearAccl,fStationMagMedianLinearAccl,fStationMagVarLinearAccl,fStationMagStdLinearAccl,fStationMagRangeLinearAccl,fStationMagMCRLinearAccl,fStationMagMADLinearAccl,fStationMagSkewLinearAccl,fStationMagRMSLinearAccl,fStationMagSMALinearAccl, ...
                        fStationFreqMaxAmpLinearAccl, ...
                        fStationFreqBucketEnergy5LinearAccl, fStationFreqBucketRMS5LinearAccl, fStationFreqMeanBucketAmp5LinearAccl, ...
                        fStationFreqBucketEnergy10LinearAccl,fStationFreqBucketRMS10LinearAccl,fStationFreqMeanBucketAmp10LinearAccl, ...
                        fStationFreqBucketEnergy20LinearAccl,fStationFreqBucketRMS20LinearAccl,fStationFreqMeanBucketAmp20LinearAccl, ...
                        fStationMagMeanGyro,      fStationMagMedianGyro,      fStationMagVarGyro,      fStationMagStdGyro,      fStationMagRangeGyro,      fStationMagMCRGyro,      fStationMagMADGyro,      fStationMagSkewGyro,      fStationMagRMSGyro,      fStationMagSMAGyro, ...
                        fStationFreqMaxAmpGyro, ...
                        fStationFreqBucketEnergy5Gyro, fStationFreqBucketRMS5Gyro, fStationFreqMeanBucketAmp5Gyro, ...
                        fStationFreqBucketEnergy10Gyro,fStationFreqBucketRMS10Gyro,fStationFreqMeanBucketAmp10Gyro, ...
                        fStationFreqBucketEnergy20Gyro,fStationFreqBucketRMS20Gyro,fStationFreqMeanBucketAmp20Gyro, ...                    
                        fStationMagMeanBaro,      fStationMagMedianBaro,      fStationMagVarBaro,      fStationMagStdBaro,      fStationMagRangeBaro,      fStationMagMCRBaro,      fStationMagMADBaro,      fStationMagSkewBaro,      fStationMagRMSBaro,      fStationMagSMABaro);

            end

            % Move Window
            fStationWinBeginTm = fStationWinBeginTm + fWindowStep;

            if fStationWinBeginTm >= fLastStationMoment
                break;
            end

            nStationWinBeginLine = SBM_GetLineNoBeyondTime(mRemainedStationMotionReplaced, nStationWinBeginLine, fStationWinBeginTm);
            if nStationWinBeginLine == -1
                break;
            end

            fStationWinEndTm = fStationWinBeginTm + fWindowSize; 
        end 

        fclose(fidWriteStationDF);
    
    end   % if i ~= nSegmentCnt
    
end  % for i = 1:nSegment

fprintf('\nFinish Time [Calculate Feature]: %s\n', datestr(clock, 'yyyy-mm-dd HH:MM:SS'));

fprintf('\nFinish Time: %s\n', datestr(clock, 'yyyy-mm-dd HH:MM:SS'));

return;

