function f = SBM_GetWinBaroFeature(mWinBaro, nIdxDataType)
% This function calculate the Baro feature within a window
%

format long;

mResultFeature = [];

[nRow ~] = size(mWinBaro);
if nRow == 0
    f = mResultFeature;
    return;
end

mBaro = mWinBaro(:,nIdxDataType+1);

fMagMean = mean(mBaro);
fMagMedian = median(mBaro);
fMagVar = var(mBaro);
fMagStd = std(mBaro);
fMagRange = max(mBaro) - min(mBaro);
fMagMCR = ZCR(mBaro-fMagMean);             % Mean Crossing Rate
fMagMAD = sum(abs(mBaro-fMagMean))/nRow;   % Mean Absolute Deviation
fMagSkew = skewness(mBaro);
fMagRMS = sqrt(sum(power(mBaro,2))/nRow);  % Root Mean Square
fMagSMA = sum(abs(mBaro))/nRow;          % Normalized Signal Magnitude Area 

% Added on 2016/03/18
fMagMax = max(mBaro);
fMagMin = min(mBaro);
%fMagKurt = kurtosis(mBaro);
%fMagCF = fMagMax/fMagRMS;  % Crest Factor
fMagCorr = fMagStd/fMagMean;  % Coffefficients of variation
fMagPower = sum(power(mBaro, 2));
fMagLogEnergy = sum(log(power(mBaro, 2)));

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

% Added on 2016/03/18
mFeature(11) = fMagMax;
mFeature(12) = fMagMin;
%mFeature(13) = fMagKurt;
%mFeature(14) = fMagCF;
mFeature(13) = fMagCorr;
mFeature(14) = fMagPower;
mFeature(15) = fMagLogEnergy;


f = mFeature;

return;

