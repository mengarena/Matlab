function f = SBM_PreprocessSingleSensor(mRawSensors, nIdxDataType, nDataType, nSampleRate)
% This function is used to preprocess the raw sensors
% It does filtering 
%
% Currently, it filters LinearAccl, Gyro, Baro
%

format long;

nFilterPeriod = round(nSampleRate/2);
mSingleSensor = mRawSensors((mRawSensors(:,nIdxDataType) == nDataType),:); 
mSingleSensorFiltered = mSingleSensor;

mSingleSensorFiltered(:,nIdxDataType+1) = EMA(mSingleSensor(:,nIdxDataType+1), nFilterPeriod);  

if nIdxDataType == 1 || nIdxDataType == 2 || nIdxDataType == 3 || nIdxDataType == 4 || nIdxDataType == 5 || nIdxDataType == 12 
    mSingleSensorFiltered(:,nIdxDataType+2) = EMA(mSingleSensor(:,nIdxDataType+2), nFilterPeriod);   
    mSingleSensorFiltered(:,nIdxDataType+3) = EMA(mSingleSensor(:,nIdxDataType+3), nFilterPeriod);   
end


f = mSingleSensorFiltered;

return;
