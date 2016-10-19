function f = SBM_ProcessRawTrace_RefPhone(sRefRawTraceFile, sResultPostFix, bWithLabel)
%
% sRefRawTraceFile contain Label field
%
% In this function, process the raw Reference trace
% Do following:
% 0) Find the synchronized line
% a) Remove the trace by the last "start" of the initial group of "start"s.
% b) Remove the trace after the first "stop" of the last group of "stop"s.
% c) Change absolute timestamp to relative time (i.e. 12.232 (unit:s))
% d) Initial time starts from the first record
% e) After processing, label is removed.
% f) After processing, each line only contains information for one
% sensor + GPS fields, so each line will be:
% time, datatype, sensor_x, sensor_y, sensor_z, GPS (lat, long, altitude,
% speed, bearing)
% If sensor only has one dimension, other two fields filled with 9999;
% If GPS field is empty, filled with 9999
%
% After processing, the Reference trace contains only the Bus trace (between "start" and "stop"--- the "start", "stop" parts are excluded)
% (the sensor data related to user walk, getting on-off all are eliminated.)
% It only contains a little hand motion due to operate to swtich the label
% "null-start-null" and "null-stop-null"
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

[pathstr, filename, ext] = fileparts(sRefRawTraceFile);
sResultFile = [pathstr '\' filename '_' sResultPostFix '.csv'];

bFindStart = 0;

sLabelStart = 'start';
sLabelStop = 'stop'; 


%%%%%%%%%%% Search Synchronized Line%%%%%%%%%%%%%%%%%%%
fTimeFromAppOn = 90;  % seconds
[fMaxLinearAcclMag nSynchronizeLine] = SBM_SearchInitialSynchronizeLine(sRefRawTraceFile, fTimeFromAppOn, bWithLabel, sLabelStart);

fMaxLinearAcclMag
nSynchronizeLine
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fInitTime = 0;
nTotalLine = 0;

fidRead = fopen(sRefRawTraceFile);
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
    
    if bWithLabel == 1
        sTmpLabel = strtrim(C{nIdxLabel});

        if bFindStart == 0 
            if strcmpi(sTmpLabel,sLabelStart) == 0 
                continue;
            else
                bFindStart = 1;
                continue;
            end
        else
            if strcmpi(sTmpLabel,sLabelStart) == 1   % Until the end of "Start"
                continue;
            end
        end

        if strcmpi(sTmpLabel,sLabelStop) == 1
            break;
        end        
    end
    
    nDataType = str2num(C{nIdxDataType});
    
    nIndexIndex = find(mDataType == nDataType);
        
    nSensorIdx = mIdx(nIndexIndex);
    nSensorFieldNum = mFieldNum(nIndexIndex);
    
    fTime = CalculateTimeInS(fInitTime, str2num(C{1}));
    
    sNewLine = sprintf('%4.5f,%s', fTime, C{nIdxDataType});
    
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




