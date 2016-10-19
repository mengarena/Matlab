function f = SBM_SampleRate(sFile, nSensorTypeIdx, nSensorType)

mTrace = load(sFile);

fTime = mTrace(end,1) - mTrace(1,1);
nCount = sum(mTrace(:,nSensorTypeIdx) == nSensorType);

fSampleRate = nCount/fTime;

fprintf('Sample Rate = %f Hz\n', fSampleRate);

return;
