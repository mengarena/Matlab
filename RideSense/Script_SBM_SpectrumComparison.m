% Script_SBM_SpectrumComparison

sRefTraceFile = 'E:\SensorMatching\Data\SchoolShuttle\ForSpectrumAnalysis\seat-shuttle_ARVGONB_Uniqued_TmCrt.csv';

sQueryTraceFile = 'E:\SensorMatching\Data\SchoolShuttle\ForSpectrumAnalysis\hand-shuttle_ARVGONB_Uniqued_TmCrt.csv';

%function f = SBM_SpectrumComparison(sRefTraceFile, sQueryTraceFile, nSensorType, fTimeOffset, nCompareSize, nFrameCnt)

nSensorType = 7;
fTimeOffset = 20;
nCompareSize = 10;
nFrameCnt = 5;
nFilterFactor = 30;

SBM_SpectrumComparison(sRefTraceFile, 'Seat-Baro', sQueryTraceFile, 'Hand-Baro', nSensorType, fTimeOffset, nCompareSize, nFrameCnt, nFilterFactor);
