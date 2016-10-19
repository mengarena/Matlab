function f = SBM_SegSpectrum(mData, nIndex)
% In mData,  1st Field:  timestamps;   2nd~ Field:   Data

format long;

[N  nCol] = size(mData);

fTimeDuration = mData(N, 1) - mData(1, 1);
dt = fTimeDuration/N;       % Sample Interval
fs = round(N/fTimeDuration+0.5);   % Sample Frequency

n = round(N/2);

t = mData(:, 1)';
mDataSingleRaw = mData(:, nIndex)';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fMean = mean(mDataSingleRaw);
mDataSingle = mDataSingleRaw - fMean;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

mDataSingleSpectrum = fft(mDataSingle);
 
amp_specRaw = abs(mDataSingleSpectrum)/n;

amp_spec = amp_specRaw(1:n);

freq = (0:n-1)*fs/N;

f = {freq amp_spec};

return;
