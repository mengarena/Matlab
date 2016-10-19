function f = SBM_AnalyzeFreq()

format long;

%sTrace = 'E:\SensorMatching\Data\SchoolShuttle\20150924\Evening2_full_good\hand_Uniqued_TmCrt.csv';
%sTraceInfo = 'E:\SensorMatching\Data\SchoolShuttle\20150924\Evening2_full_good\hand_Uniqued_TmCrt_InfoG.csv';

sTrace = 'E:\SensorMatching\Data\SchoolShuttle\20150925_morning\Blue2_full_good\pantpocket_Uniqued_TmCrt.csv';
sTraceInfo = 'E:\SensorMatching\Data\SchoolShuttle\20150925_morning\Blue2_full_good\pantpocket_Uniqued_TmCrt_InfoG.csv';

%%%%%%% Setting BEGIN %%%%%%%
nDataTypeIdx = 2;    % If the trace contains start/stop information(in 2nd field), this is set to 3
                           % In trace collected by the hand phone, this should be set to 3;
                           % In other traces (pantpocket, Ref(seat)), it should be set to 2

%%%%%
nSensorType = 2;  % Linear Accl
%nSensorType = 3;  % Gyroscope
%nSensorType = 5;  % Magnitude
%nSensorType = 7;  % Barometer

sTitle = 'Linear Accl';
%sTitle = 'Gyro';
%sTitle = 'Magnitude';
%sTitle = 'Baro';

nFilterFactor = 200;

%%%%%%% Setting END %%%%%%%

mTrace = load(sTrace);
mTraceInfo = load(sTraceInfo);

mMoveInfo = mTraceInfo(mTraceInfo(:,1) == 1,:);
nMoveStartLine = mMoveInfo(3,2);
nMoveEndLine = mMoveInfo(3,3);

mStopInfo = mTraceInfo(mTraceInfo(:,1) == 0,:);  % Station information in _Uniqued_TmCrt
mStopStartLine = mStopInfo(3,2);
mStopEndLine = mStopInfo(3,3);

mMoveTrace = mTrace(nMoveStartLine:nMoveEndLine,:);

mStopTrace = mTrace(mStopStartLine:mStopEndLine,:);

mMoveTraceSensor = mMoveTrace(mMoveTrace(:,nDataTypeIdx) == nSensorType,:);
[nMoveLineCnt ~] = size(mMoveTraceSensor)

mStopTraceSensor = mStopTrace(mStopTrace(:,nDataTypeIdx) == nSensorType,:);
[nStopLineCnt ~] = size(mStopTraceSensor)

mMyMove = [];

for i = 100:299
    mMyMove(i-100+1,1) = mMoveTraceSensor(i,1);  % Timestamp
    if nSensorType ~= 7
        mMyMove(i-100+1,2) = sqrt(power(mMoveTraceSensor(i,nDataTypeIdx+1),2) + power(mMoveTraceSensor(i,nDataTypeIdx+2),2) + power(mMoveTraceSensor(i,nDataTypeIdx+3),2)); % Magnitude
    else   % Barometer
        mMyMove(i-100+1,2) = mMoveTraceSensor(i,nDataTypeIdx+1);
    end
end    

fIntervalMove = (mMyMove(200,1) - mMyMove(1,1))/255;  % To make 256 samples
xxMove = mMyMove(1,1):fIntervalMove:mMyMove(200,1);  % 256 timestamps
mMyMove
yyMove = spline(mMyMove(:,1),mMyMove(:,2),xxMove); % Interpolate the samples
length(yyMove)
InterMove = [];
InterMove(:,1) = xxMove;
InterMove(:,2) = yyMove;

mMoveSpec = SBM_SegSpectrum(InterMove, 2);
freqMove = mMoveSpec{1};     
ampMove = mMoveSpec{2};   

mMyStop = [];

for i = 100:299
    mMyStop(i-100+1,1) = mStopTraceSensor(i,1);
    if nSensorType ~= 7
        mMyStop(i-100+1,2) = sqrt(power(mStopTraceSensor(i,nDataTypeIdx+1),2) + power(mStopTraceSensor(i,nDataTypeIdx+2),2) + power(mStopTraceSensor(i,nDataTypeIdx+3),2));
    else   % Barometer
        mMyStop(i-100+1,2) = mStopTraceSensor(i,nDataTypeIdx+1);
    end
end

fIntervalStop = (mMyStop(200,1) - mMyStop(1,1))/255;
xxStop = mMyStop(1,1):fIntervalStop:mMyStop(200,1);
mMyStop
yyStop = spline(mMyStop(:,1),mMyStop(:,2),xxStop); 
InterStop = [];
InterStop(:,1) = xxStop;
InterStop(:,2) = yyStop;

mStopSpec = SBM_SegSpectrum(InterStop, 2);
freqStop = mStopSpec{1};     
ampStop = mStopSpec{2};
function f = SBM_CorrectTimeStamp_Total()
% This function process the _Uniqued.csv under each folder
% To correct the timestamp for each record
%

sArr_ParentFolders = [ ...
      'E:\SensorMatching\Data\SchoolShuttle\20150924\Evening1_full_good                         '; ...
      'E:\SensorMatching\Data\SchoolShuttle\20150924\Evening2_full_good                         '; ...
      'E:\SensorMatching\Data\SchoolShuttle\20150924\Evening3_full_good                         '; ...
      'E:\SensorMatching\Data\SchoolShuttle\20150924\Green1_full_good                           '; ...
      'E:\SensorMatching\Data\SchoolShuttle\20150924\Yellow1_full_good                          '; ...
      'E:\SensorMatching\Data\SchoolShuttle\20150924\Yellow2_half_good                          '; ...

     'E:\SensorMatching\Data\SchoolShuttle\20150925_morning\Blue1_full_good                    '; ...
     'E:\SensorMatching\Data\SchoolShuttle\20150925_morning\Blue2_full_good                    '; ...
     'E:\SensorMatching\Data\SchoolShuttle\20150925_morning\Blue3_full_good                    '; ...
      
      'E:\SensorMatching\Data\SchoolShuttle\20150925_morning\North1_full_good                   '; ...
      'E:\SensorMatching\Data\SchoolShuttle\20150925_morning\North2_full_good                   '; ...
      'E:\SensorMatching\Data\SchoolShuttle\20150925_morning\North3_full_good                   '; ...
      'E:\SensorMatching\Data\SchoolShuttle\20150925_morning\Yellow_half_good                   '; ...
      'E:\SensorMatching\Data\SchoolShuttle\20150928_withPhani\Green1_full_goodQ                '; ...
      'E:\SensorMatching\Data\SchoolShuttle\20150928_withPhani\Green2_full_goodQ                '; ...
      'E:\SensorMatching\Data\SchoolShuttle\20150928_withPhani\Red1_abnormal_almostgood         '; ...
      'E:\SensorMatching\Data\SchoolShuttle\20150928_withPhani\Red2_full_good                   '; ...
      'E:\SensorMatching\Data\SchoolShuttle\20150928_withPhani\Yellow1_full_goodQ               '; ...
      'E:\SensorMatching\Data\SchoolShuttle\20150928_withXiang\Green1_half_good                 '; ...
      'E:\SensorMatching\Data\SchoolShuttle\20150928_withXiang\Red1_full_good                   '; ...
      'E:\SensorMatching\Data\SchoolShuttle\20150929_withXiang\Yellow1_full_good                '; ...
      'E:\SensorMatching\Data\SchoolShuttle\20150929_withXiang\Green1_half_almostgood           '; ...
      'E:\SensorMatching\Data\SchoolShuttle\20150929_withXiang\Red1_full_good                   '; ...
     'E:\SensorMatching\Data\SchoolShuttle\20150925_afternoon\Green3_full_AlmostGood           '; ...
     'E:\SensorMatching\Data\SchoolShuttle\20150925_afternoon\Green1_half_Bad                  '; ...
     'E:\SensorMatching\Data\SchoolShuttle\20150925_afternoon\Green2_full_Bad                  '; ...
     'E:\SensorMatching\Data\SchoolShuttle\20150925_afternoon\Red_half_Bad                     '; ...
];

cellParentFolders = cellstr(sArr_ParentFolders);

% to find Ref_xxxxx_Uniqued.csv, hand_xxxx_Uniqued.csv,
% pocket_xxx_Uniqued.csv

sPreFixRef = 'Ref';    
sPreFixHand = 'hand';  
sPreFixPocket = 'pocket';  

sPostFix = '_Uniqued.csv';

sResultPostFix = 'TmCrt';

for k=1:length(cellParentFolders)
    sParentFolder = cellParentFolders{k} ; 

    bFindRef = 0;
    bFindHand = 0;
    bFindPocket = 0;

    sMsg = ['Processing...' sParentFolder];
    disp(sMsg);
    
    Files = dir(sParentFolder);

    for i=3:length(Files)        
        sFullFolderPathFile = [sParentFolder '\' Files(i).name];
        
        mCheckPreFixRef = strfind(lower(Files(i).name), lower(sPreFixRef));
        mCheckPreFixHand = strfind(lower(Files(i).name), lower(sPreFixHand));
        mCheckPreFixPocket = strfind(lower(Files(i).name), lower(sPreFixPocket));
        
        mCheckPostFix = strfind(lower(Files(i).name), lower(sPostFix));
        
        if length(mCheckPreFixRef) == 1 && length(mCheckPostFix) == 1
            SBM_CorrectTimeStamp(sFullFolderPathFile, sResultPostFix, 0);
            bFindRef = 1;
        end
        
        if length(mCheckPreFixHand) == 1 && length(mCheckPostFix) == 1
            SBM_CorrectTimeStamp(sFullFolderPathFile, sResultPostFix, 1);
            bFindHand = 1;
        end

        if length(mCheckPreFixPocket) == 1 && length(mCheckPostFix) == 1
            SBM_CorrectTimeStamp(sFullFolderPathFile, sResultPostFix, 0);
            bFindPocket = 1;
        end
        
        if bFindRef == 1 && bFindHand == 1 && bFindPocket == 1
            break;
        end
    end

end


return;

figure(1);
subplot(2,1,1);
plot(freqMove, ampMove);
title(['Move ' sTitle]);
xlabel('Frequency');
ylabel('Amplitude');

subplot(2,1,2);
plot(freqStop, ampStop);
title(['Stop ' sTitle]);
xlabel('Frequency');
ylabel('Amplitude');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Above is raw data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Below is filtered data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

mMyMoveFiltered = [];

mMyMoveFiltered = mMyMove;
mMyMoveFiltered(:,2) = EMA(mMyMove(:,2), nFilterFactor);  % 100

fIntervalMoveFiltered = (mMyMoveFiltered(200,1) - mMyMoveFiltered(1,1))/255;
xxMoveFiltered = mMyMoveFiltered(1,1):fIntervalMoveFiltered:mMyMoveFiltered(200,1);
yyMoveFiltered = spline(mMyMoveFiltered(:,1),mMyMoveFiltered(:,2),xxMoveFiltered); 
length(yyMoveFiltered)
InterMoveFiltered = [];
InterMoveFiltered(:,1) = xxMoveFiltered;
InterMoveFiltered(:,2) = yyMoveFiltered;

mMoveFilteredSpec = SBM_SegSpectrum(InterMoveFiltered, 2);
freqMoveFiltered = mMoveFilteredSpec{1};     
ampMoveFiltered = mMoveFilteredSpec{2};   


mMyStopFiltered = [];

mMyStopFiltered = mMyStop;
mMyStopFiltered(:,2) = EMA(mMyStop(:,2), nFilterFactor);   % 100

fIntervalStopFiltered = (mMyStopFiltered(200,1) - mMyStopFiltered(1,1))/255;
xxStopFiltered = mMyStopFiltered(1,1):fIntervalStopFiltered:mMyStopFiltered(200,1);
yyStopFiltered = spline(mMyStopFiltered(:,1),mMyStopFiltered(:,2),xxStopFiltered); 
length(yyStopFiltered)
InterStopFiltered = [];
InterStopFiltered(:,1) = xxStopFiltered;
InterStopFiltered(:,2) = yyStopFiltered;


mStopFilteredSpec = SBM_SegSpectrum(InterStopFiltered, 2);
freqStopFiltered = mStopFilteredSpec{1};     
ampStopFiltered = mStopFilteredSpec{2};   


figure(2);
subplot(2,1,1);
plot(freqMoveFiltered, ampMoveFiltered);
title(['Move (Filtered) ' sTitle]);
xlabel('Frequency');
ylabel('Amplitude');

subplot(2,1,2);
plot(freqStopFiltered, ampStopFiltered);
title(['Stop (Filtered) ' sTitle]);
xlabel('Frequency');
ylabel('Amplitude');

return;
