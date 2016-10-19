function f = Test_SBM_GetRefFeature(sUniquedTmCrtTrace, sTraceInfoG, fPCAStat)
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

fprintf('Start Time: %s\n', datestr(clock, 'yyyy-mm-dd HH:MM:SS'));

format long;

fprintf('Start Time [Calculate Reference Trace Feature]: %s\n', datestr(clock, 'yyyy-mm-dd HH:MM:SS'));

sMsg = ['Calculate Feature for:  ' sUniquedTmCrtTrace];
disp(sMsg);

%sFeatureSubFolder = 'Feature';
sFeatureSubFolder = 'FeaturePCA';

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
sBasicFeatureFilePostFix = 'SegBF';

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
disp('Extract Detailed Features (Property of Segment)....');
sDetailedFeatureFilePostFix = 'SegDF';
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
    
    mRemainedSegMotion = [];
    bPreviousStop = 0;
    nTotalMotionRecord = 0;
    
    % Select moving sensor data from _TmCrt.csv and merge them into
    % mRemainedSegMotion, adjust timestamp when merging
    for j = nBeginLine:nEndLine
        fGpsSpeed = mUniquedTmCrtTrace(j, nIdxGpsSpeed);
        
        if fGpsSpeed == 0  % stopped
            bPreviousStop = 1;
            
        else  % moving            
            nTotalMotionRecord = nTotalMotionRecord + 1;

            mRemainedSegMotion = [mRemainedSegMotion; mUniquedTmCrtTrace(j,:)];
            
            if nTotalMotionRecord > 1   
                fTimeGap = mUniquedTmCrtTrace(j,1) - mUniquedTmCrtTrace(j-1,1);
                if fTimeGap == 0 && mUniquedTmCrtTrace(j,nIdxDataType) == mRemainedSegMotion(nTotalMotionRecord-1,nIdxDataType)   % Need to adjust timestamp
                    fSensorTimeGap = SBM_GetSensorTimeGap(mUniquedTmCrtTrace(j,nIdxDataType));
                    mRemainedSegMotion(nTotalMotionRecord,1) = mRemainedSegMotion(nTotalMotionRecord-1,1) + fSensorTimeGap;
                else
                    mRemainedSegMotion(nTotalMotionRecord,1) = mRemainedSegMotion(nTotalMotionRecord-1,1) + fTimeGap;
                end
            end
            
            bPreviousStop = 0;
        end
    end
    
    disp('Preprocessing...');
    
    % After merging, preprocessing sensor
    mCellRemainedSegMotionFiltered = SBM_PreprocessSensors(mRemainedSegMotion, nIdxDataType);
    
    mFilteredLinearAccl = mCellRemainedSegMotionFiltered{1};
    mFilteredGyro = mCellRemainedSegMotionFiltered{2};
    mFilteredBaro = mCellRemainedSegMotionFiltered{3};
    
    % Replace back, i.e. replace the raw LinearAccl, Gyro, Baro with the
    % filtered values
    mRemainedSegMotionReplaced = mRemainedSegMotion;
   
% % %     % <== New add Begin 20160422
% % %     mRawSensorTrace = mRemainedSegMotion;
% % %     % <== New add End 20160422
    
    mRemainedSegMotionReplaced((mRemainedSegMotionReplaced(:,nIdxDataType) == 2),:) = mFilteredLinearAccl;
    mRemainedSegMotionReplaced((mRemainedSegMotionReplaced(:,nIdxDataType) == 3),:) = mFilteredGyro;
    mRemainedSegMotionReplaced((mRemainedSegMotionReplaced(:,nIdxDataType) == 7),:) = mFilteredBaro;
    
    fLastMoment = mRemainedSegMotionReplaced(nTotalMotionRecord,1);
    
    % Window sensor data and calculate features
    fWinBeginTm = mRemainedSegMotionReplaced(1,1);
    fWinEndTm = fWinBeginTm + fWindowSize;
    nWinBeginLine = 1;
    
    disp('Extract Motion Features...');
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
        
        % Get raw sensor data  <== New add Begin 20160422
% % %         mWinSensorRaw = mRawSensorTrace(nWinBeginLine:nWinEndLine, :);
% % %         mWinLinearAcclRaw = mWinSensorRaw((mWinSensorRaw(:,nIdxDataType) == 2),:);
% % %         mWinGyroRaw = mWinSensorRaw((mWinSensorRaw(:,nIdxDataType) == 3),:);
% % %     
% % %         % Features from PCAed raw sensor data
% % %         mWinLinearAcclFeaturePCA = SBM_GetWinLinearAcclFeaturePCA(mWinLinearAcclRaw, nIdxDataType, fPCAStat, 1);
% % %         mWinGyroFeaturePCA = SBM_GetWinGyroFeaturePCA(mWinGyroRaw, nIdxDataType, fPCAStat, 1);
% % %         
% % %         mWinLinearAcclFeaturePCA2 = SBM_GetWinLinearAcclFeaturePCA(mWinLinearAcclRaw, nIdxDataType, fPCAStat, 2);
% % %         mWinGyroFeaturePCA2 = SBM_GetWinGyroFeaturePCA(mWinGyroRaw, nIdxDataType, fPCAStat, 2);        
        % <== New add End 20160422
        
        
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
% % %             fMagMeanLinearAcclPCA = mWinLinearAcclFeaturePCA(1);
% % %             fMagMedianLinearAcclPCA = mWinLinearAcclFeaturePCA(2);
% % %             fMagVarLinearAcclPCA = mWinLinearAcclFeaturePCA(3);
% % %             fMagStdLinearAcclPCA = mWinLinearAcclFeaturePCA(4);
% % %             fMagRangeLinearAcclPCA = mWinLinearAcclFeaturePCA(5);
% % %             fMagMCRLinearAcclPCA = mWinLinearAcclFeaturePCA(6);
% % %             fMagMADLinearAcclPCA = mWinLinearAcclFeaturePCA(7);
% % %             fMagSkewLinearAcclPCA = mWinLinearAcclFeaturePCA(8);
% % %             fMagRMSLinearAcclPCA = mWinLinearAcclFeaturePCA(9);
% % %             fMagSMALinearAcclPCA = mWinLinearAcclFeaturePCA(10);
% % % 
% % %             fFreqMaxAmpLinearAcclPCA = mWinLinearAcclFeaturePCA(11);
% % %             fFreqBucketEnergy5LinearAcclPCA = mWinLinearAcclFeaturePCA(12);
% % %             fFreqBucketRMS5LinearAcclPCA = mWinLinearAcclFeaturePCA(13);
% % %             fFreqMeanBucketAmp5LinearAcclPCA = mWinLinearAcclFeaturePCA(14);
% % %             fFreqBucketEnergy10LinearAcclPCA = mWinLinearAcclFeaturePCA(15);
% % %             fFreqBucketRMS10LinearAcclPCA = mWinLinearAcclFeaturePCA(16);
% % %             fFreqMeanBucketAmp10LinearAcclPCA = mWinLinearAcclFeaturePCA(17);
% % %             fFreqBucketEnergy20LinearAcclPCA = mWinLinearAcclFeaturePCA(18);
% % %             fFreqBucketRMS20LinearAcclPCA = mWinLinearAcclFeaturePCA(19);
% % %             fFreqMeanBucketAmp20LinearAcclPCA = mWinLinearAcclFeaturePCA(20);
% % % 
% % %             fMagMaxLinearAcclPCA = mWinLinearAcclFeaturePCA(21);
% % %             fMagMinLinearAcclPCA = mWinLinearAcclFeaturePCA(22);
% % %             f3AxisAADLinearAcclPCA = mWinLinearAcclFeaturePCA(23);
% % %             %fMagKurtLinearAcclPCA = mWinLinearAcclFeaturePCA(24);
% % %             %fMagCFLinearAcclPCA = mWinLinearAcclFeaturePCA(25);
% % %             fMagCorrLinearAcclPCA = mWinLinearAcclFeaturePCA(24);
% % %             fMagPowerLinearAcclPCA = mWinLinearAcclFeaturePCA(25);
% % %             fMagLogEnergyLinearAcclPCA = mWinLinearAcclFeaturePCA(26);
% % % 
% % %             fMagMeanGyroPCA = mWinGyroFeaturePCA(1);
% % %             fMagMedianGyroPCA = mWinGyroFeaturePCA(2);
% % %             fMagVarGyroPCA = mWinGyroFeaturePCA(3);
% % %             fMagStdGyroPCA = mWinGyroFeaturePCA(4);
% % %             fMagRangeGyroPCA = mWinGyroFeaturePCA(5);
% % %             fMagMCRGyroPCA = mWinGyroFeaturePCA(6);
% % %             fMagMADGyroPCA = mWinGyroFeaturePCA(7);
% % %             fMagSkewGyroPCA = mWinGyroFeaturePCA(8);
% % %             fMagRMSGyroPCA = mWinGyroFeaturePCA(9);
% % %             fMagSMAGyroPCA = mWinGyroFeaturePCA(10);
% % % 
% % %             fFreqMaxAmpGyroPCA = mWinGyroFeaturePCA(11);
% % %             fFreqBucketEnergy5GyroPCA = mWinGyroFeaturePCA(12);
% % %             fFreqBucketRMS5GyroPCA = mWinGyroFeaturePCA(13);
% % %             fFreqMeanBucketAmp5GyroPCA = mWinGyroFeaturePCA(14);
% % %             fFreqBucketEnergy10GyroPCA = mWinGyroFeaturePCA(15);
% % %             fFreqBucketRMS10GyroPCA = mWinGyroFeaturePCA(16);
% % %             fFreqMeanBucketAmp10GyroPCA = mWinGyroFeaturePCA(17);
% % %             fFreqBucketEnergy20GyroPCA = mWinGyroFeaturePCA(18);
% % %             fFreqBucketRMS20GyroPCA = mWinGyroFeaturePCA(19);
% % %             fFreqMeanBucketAmp20GyroPCA = mWinGyroFeaturePCA(20);
% % % 
% % %             fMagMaxGyroPCA = mWinGyroFeaturePCA(21);
% % %             fMagMinGyroPCA = mWinGyroFeaturePCA(22);
% % %             f3AxisAADGyroPCA = mWinGyroFeaturePCA(23);
% % %             %fMagKurtGyroPCA = mWinGyroFeaturePCA(24);
% % %             %fMagCFGyroPCA = mWinGyroFeaturePCA(25);
% % %             fMagCorrGyroPCA = mWinGyroFeaturePCA(24);
% % %             fMagPowerGyroPCA = mWinGyroFeaturePCA(25);
% % %             fMagLogEnergyGyroPCA = mWinGyroFeaturePCA(26);
% % %             % PCA <== New add End 20160422  %%%%%%%%%%%%%%%%%%%%%
% % %             
% % %             % PCA <== New add Begin 20160429 %%%%%%%%%%%%%%%%%%%
% % %             fMagMeanLinearAcclPCA2 = mWinLinearAcclFeaturePCA2(1);
% % %             fMagMedianLinearAcclPCA2 = mWinLinearAcclFeaturePCA2(2);
% % %             fMagVarLinearAcclPCA2 = mWinLinearAcclFeaturePCA2(3);
% % %             fMagStdLinearAcclPCA2 = mWinLinearAcclFeaturePCA2(4);
% % %             fMagRangeLinearAcclPCA2 = mWinLinearAcclFeaturePCA2(5);
% % %             fMagMCRLinearAcclPCA2 = mWinLinearAcclFeaturePCA2(6);
% % %             fMagMADLinearAcclPCA2 = mWinLinearAcclFeaturePCA2(7);
% % %             fMagSkewLinearAcclPCA2 = mWinLinearAcclFeaturePCA2(8);
% % %             fMagRMSLinearAcclPCA2 = mWinLinearAcclFeaturePCA2(9);
% % %             fMagSMALinearAcclPCA2 = mWinLinearAcclFeaturePCA2(10);
% % % 
% % %             fFreqMaxAmpLinearAcclPCA2 = mWinLinearAcclFeaturePCA2(11);
% % %             fFreqBucketEnergy5LinearAcclPCA2 = mWinLinearAcclFeaturePCA2(12);
% % %             fFreqBucketRMS5LinearAcclPCA2 = mWinLinearAcclFeaturePCA2(13);
% % %             fFreqMeanBucketAmp5LinearAcclPCA2 = mWinLinearAcclFeaturePCA2(14);
% % %             fFreqBucketEnergy10LinearAcclPCA2 = mWinLinearAcclFeaturePCA2(15);
% % %             fFreqBucketRMS10LinearAcclPCA2 = mWinLinearAcclFeaturePCA2(16);
% % %             fFreqMeanBucketAmp10LinearAcclPCA2 = mWinLinearAcclFeaturePCA2(17);
% % %             fFreqBucketEnergy20LinearAcclPCA2 = mWinLinearAcclFeaturePCA2(18);
% % %             fFreqBucketRMS20LinearAcclPCA2 = mWinLinearAcclFeaturePCA2(19);
% % %             fFreqMeanBucketAmp20LinearAcclPCA2 = mWinLinearAcclFeaturePCA2(20);
% % % 
% % %             fMagMaxLinearAcclPCA2 = mWinLinearAcclFeaturePCA2(21);
% % %             fMagMinLinearAcclPCA2 = mWinLinearAcclFeaturePCA2(22);
% % %             f3AxisAADLinearAcclPCA2 = mWinLinearAcclFeaturePCA2(23);
% % %             %fMagKurtLinearAcclPCA2 = mWinLinearAcclFeaturePCA2(24);
% % %             %fMagCFLinearAcclPCA2 = mWinLinearAcclFeaturePCA2(25);
% % %             fMagCorrLinearAcclPCA2 = mWinLinearAcclFeaturePCA2(24);
% % %             fMagPowerLinearAcclPCA2 = mWinLinearAcclFeaturePCA2(25);
% % %             fMagLogEnergyLinearAcclPCA2 = mWinLinearAcclFeaturePCA2(26);
% % % 
% % %             fMagMeanGyroPCA2 = mWinGyroFeaturePCA2(1);
% % %             fMagMedianGyroPCA2 = mWinGyroFeaturePCA2(2);
% % %             fMagVarGyroPCA2 = mWinGyroFeaturePCA2(3);
% % %             fMagStdGyroPCA2 = mWinGyroFeaturePCA2(4);
% % %             fMagRangeGyroPCA2 = mWinGyroFeaturePCA2(5);
% % %             fMagMCRGyroPCA2 = mWinGyroFeaturePCA2(6);
% % %             fMagMADGyroPCA2 = mWinGyroFeaturePCA2(7);
% % %             fMagSkewGyroPCA2 = mWinGyroFeaturePCA2(8);
% % %             fMagRMSGyroPCA2 = mWinGyroFeaturePCA2(9);
% % %             fMagSMAGyroPCA2 = mWinGyroFeaturePCA2(10);
% % % 
% % %             fFreqMaxAmpGyroPCA2 = mWinGyroFeaturePCA2(11);
% % %             fFreqBucketEnergy5GyroPCA2 = mWinGyroFeaturePCA2(12);
% % %             fFreqBucketRMS5GyroPCA2 = mWinGyroFeaturePCA2(13);
% % %             fFreqMeanBucketAmp5GyroPCA2 = mWinGyroFeaturePCA2(14);
% % %             fFreqBucketEnergy10GyroPCA2 = mWinGyroFeaturePCA2(15);
% % %             fFreqBucketRMS10GyroPCA2 = mWinGyroFeaturePCA2(16);
% % %             fFreqMeanBucketAmp10GyroPCA2 = mWinGyroFeaturePCA2(17);
% % %             fFreqBucketEnergy20GyroPCA2 = mWinGyroFeaturePCA2(18);
% % %             fFreqBucketRMS20GyroPCA2 = mWinGyroFeaturePCA2(19);
% % %             fFreqMeanBucketAmp20GyroPCA2 = mWinGyroFeaturePCA2(20);
% % % 
% % %             fMagMaxGyroPCA2 = mWinGyroFeaturePCA2(21);
% % %             fMagMinGyroPCA2 = mWinGyroFeaturePCA2(22);
% % %             f3AxisAADGyroPCA2 = mWinGyroFeaturePCA2(23);
% % %             %fMagKurtGyroPCA2 = mWinGyroFeaturePCA2(24);
% % %             %fMagCFGyroPCA2 = mWinGyroFeaturePCA2(25);
% % %             fMagCorrGyroPCA2 = mWinGyroFeaturePCA2(24);
% % %             fMagPowerGyroPCA2 = mWinGyroFeaturePCA2(25);
% % %             fMagLogEnergyGyroPCA2 = mWinGyroFeaturePCA2(26);            
            % PCA <== New add End 20160429  %%%%%%%%%%%%%%%%%%%%%
            
            % No Ground Truth, only features for Moving
%            fprintf(fidWriteDF, '%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,  %4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,  %4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,   %4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,   %4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,   %4.8f,%4.8f,%4.8f,%4.8f,%4.8f,   %4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,  %4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,    %4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,   %4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f\n', ...
            fprintf(fidWriteDF, ...
                    ['%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,  ', ...
                     '%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,  ', ...
                     '%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,   ', ...
                     '%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,   ', ...
                     '%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,   ', ...
                     '%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,   ', ...
                     '\n'], ...
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
                    fMagMaxBaro, fMagMinBaro, fMagCorrBaro, fMagPowerBaro, fMagLogEnergyBaro);
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
    
end  % for i = 1:nSegment

fprintf('\nFinish Time [Calculate Feature]: %s\n', datestr(clock, 'yyyy-mm-dd HH:MM:SS'));

fprintf('\nFinish Time: %s\n', datestr(clock, 'yyyy-mm-dd HH:MM:SS'));

return;

