function f = SBM_PreprocessSensors(mRawSensors, nIdxDataType)
% This function is used to preprocess the raw sensors
% It does filtering 
%
% Currently, it filters LinearAccl, Gyro, Baro
%

% Filter period for Sensors:  LinearAccl:  100 (/200), Gyro: 100 (/200),
% Baro 15 (/30)
% Less filter: 20, 20, 3
% More filter: 200, 200, 30

format long;

nLinearAcclFilterPeriod = 100;
nGyroFilterPeriod = 100;
nBaroFilterPeriod = 15;

mCellFiltered = [];

% Filter LinearAccl
mLinearAcclRaw = mRawSensors((mRawSensors(:,nIdxDataType) == 2),:); 

if length(mLinearAcclRaw) == 0
    f = mCellFiltered;
    return;
end

mLinearAcclFiltered = mLinearAcclRaw;
mLinearAcclFiltered(:,nIdxDataType+1) = EMA(mLinearAcclRaw(:,nIdxDataType+1), nLinearAcclFilterPeriod);   % Sample rate = 200
mLinearAcclFiltered(:,nIdxDataType+2) = EMA(mLinearAcclRaw(:,nIdxDataType+2), nLinearAcclFilterPeriod);   % Sample rate = 200
mLinearAcclFiltered(:,nIdxDataType+3) = EMA(mLinearAcclRaw(:,nIdxDataType+3), nLinearAcclFilterPeriod);   % Sample rate = 200

% Filter Gyro
mGyroRaw = mRawSensors((mRawSensors(:,nIdxDataType) == 3),:); 

if length(mGyroRaw) == 0
    f = mCellFiltered;
    return;
end

mGyroFiltered = mGyroRaw;
mGyroFiltered(:,nIdxDataType+1) = EMA(mGyroRaw(:,nIdxDataType+1), nGyroFilterPeriod);   % Sample rate = 200
mGyroFiltered(:,nIdxDataType+2) = EMA(mGyroRaw(:,nIdxDataType+2), nGyroFilterPeriod);   % Sample rate = 200
mGyroFiltered(:,nIdxDataType+3) = EMA(mGyroRaw(:,nIdxDataType+3), nGyroFilterPeriod);   % Sample rate = 200

% Filter Baro
mBaroRaw = mRawSensors((mRawSensors(:,nIdxDataType) == 7),:);

if length(mBaroRaw) == 0
    f = mCellFiltered;
    return;
end

mBaroFiltered = mBaroRaw;
mBaroFiltered(:,nIdxDataType+1) = EMA(mBaroRaw(:,nIdxDataType+1), nBaroFilterPeriod);   % Sample rate = 30

mCellFiltered{1} = mLinearAcclFiltered;
mCellFiltered{2} = mGyroFiltered;
mCellFiltered{3} = mBaroFiltered;

f = mCellFiltered;

return;

