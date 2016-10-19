% This script is used to correct Timestamp for _Uniqued.csv files, which
% produces _Uniqued_TmCrt.csv
%
% And then derive the general information from _Uniqued_TmCrt.csv to get _InfoG.csv files
%

disp('Process Raw Sensor File to Unique ...');
disp('This step generate _Uniqued.csv');
SBM_ProcessRawTrace_Total(1);
SBM_ProcessRawTrace_Total(2);
SBM_ProcessRawTrace_Total(3);


disp('Correcting Timestamp ...');
disp('This step generate _Uniqued_TmCrt.csv');
% Correct Timestamp
SBM_CorrectTimeStamp_Total();

% disp('Deriving General Information ...');
% disp('This step generate _Uniqued_TmCrt_InfoG.csv');
% % Derive General Information
% SBM_GetTraceInfo_General_Total();

disp('>>>>>>>>>>>>>>DONE<<<<<<<<<<<<<<');
