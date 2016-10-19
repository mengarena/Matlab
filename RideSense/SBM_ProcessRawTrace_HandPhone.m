function f = SBM_ProcessRawTrace_HandPhone(sRawTraceFile, sResultPostFix, bWithLabel)
%
% sRawTraceFile contains Label field
%
% In this function, process the raw Reference trace
% Do following:
% 0) Find the synchronized line
% a) Change absolute timestamp to relative time (i.e. 12.232 (unit:s))
% b) Initial time starts from the first record
% c) After processing, label is converted.
%   1) Convert "null" label to -1.
%   2) Convert "stop" label to 0.
%   3) Convert "running" label to 1
% d) After processing, each line only contains information for one
% sensor + GPS fields, so each line will be:
% time, Label, datatype, sensor_x, sensor_y, sensor_z, GPS (lat, long, altitude,
% speed, bearing)
% If sensor only has one dimension, other two fields filled with 9999;
% If GPS field is empty, filled with 9999
% 
fprintf('Start Time: %s\n', datestr(clock, 'yyyy-mm-dd HH:MM:SS'));

format long;

nIdxLabel = 2;

if bWithLabel == 0
    nIdxDataType = 2;
else
    nIdxDataType = 3;    
end

% nDataTypeAccl = 1;
% nDataTypeLinearAccl = 2;
% nDataTypeGyro = 3;
% nDataTypeOrient = 4;
% nDataTypeMagnet = 5;
% nDataTypeLight = 6;
% nDataTypeBaro = 7;
% nDataTypeMicro = 8;
% nDataTypeCell = 9;
% nDataTypeGps = 10;
% nDataTypeWiFi = 11;
% nDataTypeGravity = 12;

mDataType = [1 2 3 4 5 6 7 8 9 10 12];  % No WiFi

% Label is not in the data

% nIdxAccl = 3;
% nIdxLinearAccl = 6;
% nIdxGyro = 12;
% nIdxOrient = 15;
% nIdxMagnet = 18;
% nIdxLight = 21;
% nIdxBaro = 22;
% nIdxMicro = 23;
% nIdxCell = 24;
% nIdxGps = 25;
% nIdxWiFi = 32;
% nIdxGravity = 9;

mIdx = [3 6 12 15 18 21 22 23 24 25 9];

if bWithLabel == 1
    mIdx = mIdx + 1;
end

% Field Number
mFieldNum = [3 3 3 3 3 1 1 1 1 7 3];

nDataTypeGps = 10;
if bWithLabel == 1
    nIdxGps = 26;
else
    nIdxGps = 25;
end

nFieldNumGps = 7;

[pathstr, filename, ext] = fileparts(sRawTraceFile);
sResultFile = [pathstr '\' filename '_' sResultPostFix '.csv'];

bFindStart = 0;

sLabelStation = 'stop';
sLabelRunning = 'running'; 
sLabelNull = 'null';


%%%%%%%%%%% Search Synchronized Line%%%%%%%%%%%%%%%%%%%
sLabelStartWith = sLabelStation;
fTimeFromAppOn = 180;  % seconds
[fMaxLinearAcclMag nSynchronizeLine] = SBM_SearchInitialSynchronizeLine(sRawTraceFile, fTimeFromAppOn, bWithLabel, sLabelStartWith);

fMaxLinearAcclMag
nSynchronizeLine
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fInitTime = 0;
nTotalLine = 0;

fidRead = fopen(sRawTraceFile);
fidWrite = fopen(sResultFile, 'w');

while 1
    sLine = fgetl(fidRead);
    if ~ischar(sLine)
        break;
    end
    
    nTotalLine = nTotalLine + 1;
    C = SplitStringX(sLine, ',');

    if nTotalLine < nSynchronizeLine
        continue;
    elseif nTotalLine == nSynchronizeLine
        fInitTime = str2num(C{1});
    end
    
    nLabel = -1;   % "null"
    
    if bWithLabel == 1
        sTmpLabel = strtrim(C{nIdxLabel});

        if strcmpi(sTmpLabel,sLabelStation) == 1  % "stop" --> 0
            nLabel = 0;
        elseif strcmpi(sTmpLabel,sLabelRunning) == 1  % "running" --> 1
            nLabel = 1;
        end 
    end
    
    nDataType = str2num(C{nIdxDataType});
    
    nIndexIndex = find(mDataType == nDataType);
        
    nSensorIdx = mIdx(nIndexIndex);
    nSensorFieldNum = mFieldNum(nIndexIndex);
    
    fTime = CalculateTimeInS(fInitTime, str2num(C{1}));
    
    sNewLine = sprintf('%4.5f,%d, %s', fTime, nLabel, C{nIdxDataType});   % Time, Label, DataType
    
    % Process sensor part
    if nDataType ~= nDataTypeGps
        for i=1:nSensorFieldNum
            sNewLine = sprintf('%s,%s', sNewLine, C{nSensorIdx+i-1});
        end

        if nSensorFieldNum ~= 3
            for j = 1:2
                sNewLine = sprintf('%s,%d', sNewLine, 9999);
            end
        end
    else
        for j = 1:3
            sNewLine = sprintf('%s,%d', sNewLine, 9999);
        end
    end
    
    % Append GPS part
    % GPS Lat,Long,Alt
    for k = 1:3
        if length(strtrim(C{nIdxGps+k-1})) ~= 0
            sNewLine = sprintf('%s,%s', sNewLine, C{nIdxGps+k-1});
        else
            sNewLine = sprintf('%s,%d', sNewLine, 9999);
        end
    end
    
    % GPS Declination/Inclination are not included in the result file
    % GPS Speed, Bearing
    for k = 6:7
        if length(strtrim(C{nIdxGps+k-1})) ~= 0
            sNewLine = sprintf('%s,%s', sNewLine, C{nIdxGps+k-1});
        else
            sNewLine = sprintf('%s,%d', sNewLine, 9999);
        end
    end
    
    fprintf(fidWrite, '%s\n', sNewLine);
end

fclose(fidWrite);
fclose(fidRead);

fprintf('\nFinish Time: %s\n', datestr(clock, 'yyyy-mm-dd HH:MM:SS'));

return;
