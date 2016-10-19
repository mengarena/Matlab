function f = SBM_GetWinLinearAcclFeaturePCA(mWinLinearAcclRaw, nIdxDataType, fPCAStat, pcaCompIdx)
% This function calculate the Linear Accl feature within a window
% 
% Different from [SBM_GetWinLinearAcclFeature], this function applys PCA on
% the RAW sensor data and then extract the features
%

format long;

mResultFeature = [];

mWinLinearAccl = mWinLinearAcclRaw;

[nRow ~] = size(mWinLinearAccl);
if nRow == 0
    f = mResultFeature;
    return;
end

% Further correct timestamp, in case two neighboring records have same
% timestamps
fMinTimeGap = 0.00033;
fPreviousRawTm = 0;

for i = 2:nRow
    if mWinLinearAccl(i,1) == mWinLinearAccl(i-1,1) || mWinLinearAccl(i,1) == fPreviousRawTm
        fPreviousRawTm = mWinLinearAccl(i,1);
        mWinLinearAccl(i,1) = mWinLinearAccl(i-1,1) + fMinTimeGap;
    end
end

mWinPureLinearAccl = mWinLinearAccl(:,nIdxDataType+1:nIdxDataType+3);

[coeff, score, latent, ts, explained] = pca(mWinPureLinearAccl);

fprintf(fPCAStat, '1, %f, %f, %f, %f, %f, %f,\n', explained(1), explained(2), explained(3), latent(1), latent(2), latent(3));

mPcaComp = score(:, pcaCompIdx);   

mMagnitude = mPcaComp;

% Get magnitude
%mMagnitude = sqrt(sum(power(mWinLinearAccl(:,nIdxDataType+1:nIdxDataType+3),2),2));

% Time domain feature
fMagMean = mean(mMagnitude);
fMagMedian = median(mMagnitude);
fMagVar = var(mMagnitude);
fMagStd = std(mMagnitude);
fMagRange = max(mMagnitude) - min(mMagnitude);
fMagMCR = ZCR(mMagnitude-fMagMean);             % Mean Crossing Rate
fMagMAD = sum(abs(mMagnitude-fMagMean))/nRow;   % Mean Absolute Deviation
fMagSkew = skewness(mMagnitude);
fMagRMS = sqrt(sum(power(mMagnitude,2))/nRow);  % Root Mean Square
fMagSMA = (sum(abs(mWinLinearAccl(:,nIdxDataType+1))) + sum(abs(mWinLinearAccl(:,nIdxDataType+2))) + sum(abs(mWinLinearAccl(:,nIdxDataType+3))))/nRow;   % Normalized Signal Magnitude Area 

% Added on 2016/03/18
fMagMax = max(mMagnitude);
fMagMin = min(mMagnitude);

fMeanX = mean(mWinLinearAccl(:,nIdxDataType+1));
fMeanY = mean(mWinLinearAccl(:,nIdxDataType+2));
fMeanZ = mean(mWinLinearAccl(:,nIdxDataType+3));
f3AxisAAD = mean(abs(mWinLinearAccl(:,nIdxDataType+1)-fMeanX) + abs(mWinLinearAccl(:,nIdxDataType+2)-fMeanY) + abs(mWinLinearAccl(:,nIdxDataType+3)-fMeanZ));   % Average Absolute Difference

% fMagKurt = kurtosis(mMagnitude);
% fMagCF = fMagMax/fMagRMS;  % Crest Factor
fMagCorr = fMagStd/fMagMean;  % Coffefficients of variation
fMagPower = sum(power(mMagnitude, 2));
fMagLogEnergy = sum(log(power(mMagnitude, 2)));



% Frequency domain feature
nSampleCnt = 256;

% Sample's interval might not be fixed, here interpolate and resample the sample
fInterval = (mWinLinearAccl(nRow,1) - mWinLinearAccl(1,1))/(nSampleCnt-1);
xx = mWinLinearAccl(1,1):fInterval:mWinLinearAccl(nRow,1);
yy = spline(mWinLinearAccl(:,1),mMagnitude,xx); 

InterpTrace = [];
InterpTrace(:,1) = xx;
InterpTrace(:,2) = yy;

mSpec = SBM_SegSpectrum(InterpTrace, 2);
mFreq = mSpec{1};     
mAmp = mSpec{2};   

fFreqMaxAmp = max(mAmp);

% 0~5 Hz
fBucketFreq5 = 5;   % 5 Hz
nBucketIdx5 = max(find(mFreq<=fBucketFreq5));
mBucketAmp5 = mAmp(1:nBucketIdx5);
fFreqBucketEnergy5 = sum(power(mBucketAmp5,2));

fFreqBucketRMS5 = sqrt(fFreqBucketEnergy5/length(mBucketAmp5));

fFreqMeanBucketAmp5 = mean(mBucketAmp5);

% 0~10 Hz
fBucketFreq10 = 10;   % 10 Hz
nBucketIdx10 = max(find(mFreq<=fBucketFreq10));
mBucketAmp10 = mAmp(1:nBucketIdx10);
fFreqBucketEnergy10 = sum(power(mBucketAmp10,2));

fFreqBucketRMS10 = sqrt(fFreqBucketEnergy10/length(mBucketAmp10));

fFreqMeanBucketAmp10 = mean(mBucketAmp10);

% 0~20 Hz
fBucketFreq20 = 20;   % 20 Hz
nBucketIdx20 = max(find(mFreq<=fBucketFreq20));
mBucketAmp20 = mAmp(1:nBucketIdx20);
fFreqBucketEnergy20 = sum(power(mBucketAmp20,2));

fFreqBucketRMS20 = sqrt(fFreqBucketEnergy20/length(mBucketAmp20));

fFreqMeanBucketAmp20 = mean(mBucketAmp20);


mFeature = [];
mFeature(1) = fMagMean;
mFeature(2) = fMagMedian;
mFeature(3) = fMagVar;
mFeature(4) = fMagStd;
mFeature(5) = fMagRange;
mFeature(6) = fMagMCR;
mFeature(7) = fMagMAD;
mFeature(8) = fMagSkew;
mFeature(9) = fMagRMS;
mFeature(10) = fMagSMA;

mFeature(11) = fFreqMaxAmp;
mFeature(12) = fFreqBucketEnergy5;
mFeature(13) = fFreqBucketRMS5;
mFeature(14) = fFreqMeanBucketAmp5;
mFeature(15) = fFreqBucketEnergy10;
mFeature(16) = fFreqBucketRMS10;
mFeature(17) = fFreqMeanBucketAmp10;
mFeature(18) = fFreqBucketEnergy20;
mFeature(19) = fFreqBucketRMS20;
mFeature(20) = fFreqMeanBucketAmp20;

% Added on 2016/03/18
mFeature(21) = fMagMax;
mFeature(22) = fMagMin;
mFeature(23) = f3AxisAAD;
%mFeature(24) = fMagKurt;
%mFeature(25) = fMagCF;
mFeature(24) = fMagCorr;
mFeature(25) = fMagPower;
mFeature(26) = fMagLogEnergy;



f = mFeature;

return;

