function f = SBM_BC_ExtractFeatures(sRawTraceFile, nSegCnt)

format long;

sFeatureFolder = 'FeaturePCA';
sFeaturePostFix = 'SegDF';
sSegFolder = 'Seg';
sResultPostFix = 'Seg';

sTmpFile = 'E:\SensorMatching\Data\Bus_Car\FeaturePCA\tmp.txt';
fPCAStat = fopen(sTmpFile, 'w');

[pathstr, filename, ext] = fileparts(sRawTraceFile);

nIdxDataType = 2;   % Index of Data type in _TmCrt file (for reference and pocket phone, if hand phone, should +1)
nIdxGpsSpeed = 9;   % Index of GPS speed in _TmCrt file (for reference and pocket phone; if hand phone, should +1)
fWindowSize = 1.0;  % seconds
fWindowStep = fWindowSize*0.5;  % If Non-overlapping, set this to fWindowSize

for i = 1:nSegCnt
    fprintf('Processing....Seg [%d]\n', i);
    
    sSegFile = [pathstr '\' sSegFolder '\' filename '_' sResultPostFix '_' num2str(i) '.csv'];

    sSegFeatureFile = [pathstr '\' sFeatureFolder '\' filename '_' sFeaturePostFix '_' num2str(i) '.csv'];
    fidWriteDF = fopen(sSegFeatureFile, 'w');
    
    fprintf('Loading...%s\n', sSegFile);
    mSegTrace = load(sSegFile);

    [nSegRowCnt ~] = size(mSegTrace);
    
    mRemainedSegMotion = [];
    nTotalMotionRecord = 0;
    
    fprintf('Merge Moving Sensor Data...[Total Rows: %d]\n', nSegRowCnt);
    
    % Select moving sensor data from _TmCrt.csv and merge them into
    % mRemainedSegMotion, adjust timestamp when merging
    for j = 1:nSegRowCnt
        fprintf('Row: %d\n', j);
        fGpsSpeed = mSegTrace(j, nIdxGpsSpeed);
        
        if fGpsSpeed == 0.0  % stopped
            
        else  % moving            
            nTotalMotionRecord = nTotalMotionRecord + 1;

            mRemainedSegMotion = [mRemainedSegMotion; mSegTrace(j,:)];
            
            if nTotalMotionRecord > 1   
                fTimeGap = mSegTrace(j,1) - mSegTrace(j-1,1);
                if fTimeGap == 0 && mSegTrace(j,nIdxDataType) == mRemainedSegMotion(nTotalMotionRecord-1,nIdxDataType)   % Need to adjust timestamp
                    fSensorTimeGap = SBM_GetSensorTimeGap(mSegTrace(j,nIdxDataType));
                    mRemainedSegMotion(nTotalMotionRecord,1) = mRemainedSegMotion(nTotalMotionRecord-1,1) + fSensorTimeGap;
                else
                    mRemainedSegMotion(nTotalMotionRecord,1) = mRemainedSegMotion(nTotalMotionRecord-1,1) + fTimeGap;
                end
            end
            
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
   
    % <== New add Begin 20160422
    mRawSensorTrace = mRemainedSegMotion;
    % <== New add End 20160422
    
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
        mWinSensorRaw = mRawSensorTrace(nWinBeginLine:nWinEndLine, :);
        mWinLinearAcclRaw = mWinSensorRaw((mWinSensorRaw(:,nIdxDataType) == 2),:);
        mWinGyroRaw = mWinSensorRaw((mWinSensorRaw(:,nIdxDataType) == 3),:);
    
        % Features from PCAed raw sensor data
        mWinLinearAcclFeaturePCA = SBM_GetWinLinearAcclFeaturePCA(mWinLinearAcclRaw, nIdxDataType, fPCAStat, 1);
        mWinGyroFeaturePCA = SBM_GetWinGyroFeaturePCA(mWinGyroRaw, nIdxDataType, fPCAStat, 1);
        
        mWinLinearAcclFeaturePCA2 = SBM_GetWinLinearAcclFeaturePCA(mWinLinearAcclRaw, nIdxDataType, fPCAStat, 2);
        mWinGyroFeaturePCA2 = SBM_GetWinGyroFeaturePCA(mWinGyroRaw, nIdxDataType, fPCAStat, 2);        
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
            
            % No Ground Truth, only features for Moving
%            fprintf(fidWriteDF, '%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,  %4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,  %4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,   %4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,   %4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,   %4.8f,%4.8f,%4.8f,%4.8f,%4.8f,   %4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,  %4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,    %4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,   %4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f\n', ...
            fprintf(fidWriteDF, ...
                    ['%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,%4.8f,  ', ...
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
    
end

disp('>>>>>>Done<<<<<<');

return;
