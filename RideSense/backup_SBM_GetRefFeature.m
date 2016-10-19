function f = backup_SBM_GetRefFeature(sUniquedTmCrtTrace, sTraceInfoG)
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
%    Turn:  2 (type), direction (1--left, -1--right, 0--No Turn)
%       -- Window size:  6 seconds, Window Step:  2  (Refer to past
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

        if bIsTurn == 1
            % First summarize previous motion Unit
            if nPreviousStatus == 0 || nPreviousStatus == 1
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
            
            if nTotalMotionRecord > 1   % Adjust timestamp
                fTimeGap = mUniquedTmCrtTrace(j,1) - mUniquedTmCrtTrace(j-1,1);
                if fTimeGap == 0 && mUniquedTmCrtTrace(j,nIdxDataType) == mRemainedSegMotion(nTotalMotionRecord-1,nIdxDataType)
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
            
            % No Ground Truth, only features for Moving
            fprintf(fidWriteDF, '%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,  %4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,  %4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f\n', ...
                    fMagMeanLinearAccl,fMagStdLinearAccl,fMagRangeLinearAccl,fMagMCRLinearAccl,fMagMADLinearAccl,fMagSkewLinearAccl,fMagRMSLinearAccl,fMagSMALinearAccl, ...
                    fMagMeanGyro,      fMagStdGyro,      fMagRangeGyro,      fMagMCRGyro,      fMagMADGyro,      fMagSkewGyro,      fMagRMSGyro,      fMagSMAGyro, ...
                    fMagMeanBaro,      fMagStdBaro,      fMagRangeBaro,      fMagMCRBaro,      fMagMADBaro,      fMagSkewBaro,      fMagRMSBaro,      fMagSMABaro);
            
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

