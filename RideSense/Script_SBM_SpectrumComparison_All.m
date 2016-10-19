% Script_SBM_SpectrumComparison_All

sParentFolder = 'E:\SensorMatching\Data\SchoolShuttle\20150925_morning\Blue3_full_good';

sResultPostFix = 'Uniqued_TmCrt.csv';

sRefTraceFile = '';
sHandTraceFile = '';
sPantTraceFile = '';

Files = dir(sParentFolder);

% Find Ref
for i=3:length(Files)        
    sFullFolderPathFile = [sParentFolder '\' Files(i).name];

    mCheckPreFixRef = strfind(lower(Files(i).name), lower('Ref'));
    mCheckPreFixHand = strfind(lower(Files(i).name), lower('hand'));
    mCheckPreFixPant = strfind(lower(Files(i).name), lower('pocket'));
    
    mCheckPostFix = strfind(lower(Files(i).name), lower(sResultPostFix));
    if length(mCheckPreFixRef) == 1 && length(mCheckPostFix) == 1
        sRefTraceFile = sFullFolderPathFile
    elseif length(mCheckPreFixHand) == 1 && length(mCheckPostFix) == 1
        sHandTraceFile = sFullFolderPathFile
    elseif length(mCheckPreFixPant) == 1 && length(mCheckPostFix) == 1
        sPantTraceFile = sFullFolderPathFile
    end
end

if length(sRefTraceFile) == 0 | length(sHandTraceFile) == 0 | length(sPantTraceFile) == 0
    disp('Cannot find Ref or Hand or Pant trace file!');
    return;
end

disp('Processing and Plotting ...');

nCompareSize = 20;
nFrameCnt = 5;

%%% Linear Accl
nSensorType = 2;   % 2--Linear Accl;  3--Gyro;  7--Baro
nFilterFactor = 100; 

nFigBaseNo = 0;

sRefTitle = 'Ref-Seat[LinAccl]';
sHandTitle = 'Hand[LinAccl]';
sPantTitle = 'Pantpocket[LinAccl]';

%SBM_SpectrumComparison_AllPosition(sRefTraceFile, sRefTitle, sHandTraceFile, sHandTitle, sPantTraceFile, sPantTitle, nSensorType, nCompareSize, nFrameCnt, nFilterFactor, nFigBaseNo);
SBM_SpectrumComparison_AllPosition_Time(sRefTraceFile, sRefTitle, sHandTraceFile, sHandTitle, sPantTraceFile, sPantTitle, nSensorType, nCompareSize, nFrameCnt, nFilterFactor, nFigBaseNo);

%%% Gyro
nSensorType = 3;   % 2--Linear Accl;  3--Gyro;  7--Baro
nFilterFactor = 100; 

nFigBaseNo = 10;

sRefTitle = 'Ref-Seat[Gyro]';
sHandTitle = 'Hand[Gyro]';
sPantTitle = 'Pantpocket[Gyro]';

%SBM_SpectrumComparison_AllPosition(sRefTraceFile, sRefTitle, sHandTraceFile, sHandTitle, sPantTraceFile, sPantTitle, nSensorType, nCompareSize, nFrameCnt, nFilterFactor, nFigBaseNo);
SBM_SpectrumComparison_AllPosition_Time(sRefTraceFile, sRefTitle, sHandTraceFile, sHandTitle, sPantTraceFile, sPantTitle, nSensorType, nCompareSize, nFrameCnt, nFilterFactor, nFigBaseNo);


%%% Baro
nSensorType = 7;   % 2--Linear Accl;  3--Gyro;  7--Baro
nFilterFactor = 15; 

nFigBaseNo = 20;

sRefTitle = 'Ref-Seat[Baro]';
sHandTitle = 'Hand[Baro]';
sPantTitle = 'Pantpocket[Baro]';

%SBM_SpectrumComparison_AllPosition(sRefTraceFile, sRefTitle, sHandTraceFile, sHandTitle, sPantTraceFile, sPantTitle, nSensorType, nCompareSize, nFrameCnt, nFilterFactor, nFigBaseNo);
SBM_SpectrumComparison_AllPosition_Time(sRefTraceFile, sRefTitle, sHandTraceFile, sHandTitle, sPantTraceFile, sPantTitle, nSensorType, nCompareSize, nFrameCnt, nFilterFactor, nFigBaseNo);

