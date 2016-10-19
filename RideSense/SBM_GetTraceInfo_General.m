function f = SBM_GetTraceInfo_General(sUniquedRefTrace, sUniquedHandTrace, sUniquedPocketTrace, sResultPostFix)
%
% Before this function could be called, the _Uniqued_TmCrt.csv file must be
% existing through calling SBM_ProcessRefRawTrace_Total.m
%
% In sUniquedRefTrace, no label field, it has:  
% time,datatype, sensor_x, sensor_y, sensor_z, GPS lat, GPS long, GPS alt,
% GPS speed, GPS bearing
%
% sUniquedHandTrace provides ground truth for stations. 
% In HandTrace, Label field exist, -1 (null), 0 (stop), 1 (running)
% Each line:
% time, Label, datatype, sensor_x, sensor_y, sensor_z, GPS lat, GPS long, GPS alt,
% GPS speed, GPS bearing
%
% sUniquedPocketTrace has no label field,
% Each line:
% time, datatype, sensor_x, sensor_y, sensor_z, GPS lat, GPS long, GPS alt,
% GPS speed, GPS bearing
%
% This function is used get the general trace information 
% The general information tells the segment/stop's start/end line in the _Uniqued_TmCrt.csv Ref Trace. 
%
% The result file is _Uniqued_TmCrt_InfoG.csv
% In the result file, each line: 
% Type (0=station; 1=segment), LineNo_begin, LineNo_end, time duration, meanBaro, GPS_begin (lat, long, alt), GPS_end (lat, long, alt)   (for station GPS_begin =
% GPS_end)
%
% If it is not meaningful to set LineNo_Begin/End,Duration for the station, e.g. first or last station, last station, set relative field value to -1; 
%
% The station and segment information is alternative. looks like
%    station (where gets on)
%    segment
%    station
%    segment
%    ...
%    ...
%    segment
%    station (where gets off)
% 
fprintf('Start Time: %s\n', datestr(clock, 'yyyy-mm-dd HH:MM:SS'));

format long;

[pathstr, filename, ext] = fileparts(sUniquedRefTrace);
sResultFileRef = [pathstr '\' filename '_' sResultPostFix '.csv'];
fidWriteRef = fopen(sResultFileRef, 'w');

[pathstr, filename, ext] = fileparts(sUniquedHandTrace);
sResultFileHand = [pathstr '\' filename '_' sResultPostFix '.csv'];
fidWriteHand = fopen(sResultFileHand, 'w');

[pathstr, filename, ext] = fileparts(sUniquedPocketTrace);
sResultFilePocket = [pathstr '\' filename '_' sResultPostFix '.csv'];
fidWritePocket = fopen(sResultFilePocket, 'w');

mUniquedRefTrace = load(sUniquedRefTrace);
[nRefRow ~] = size(mUniquedRefTrace);

mUniquedHandTrace = load(sUniquedHandTrace);
[nHandRow ~] = size(mUniquedHandTrace);

mUniquedPocketTrace = load(sUniquedPocketTrace);
[nPocketRow ~] = size(mUniquedPocketTrace);

nTypeStation = 0;
nTypeSegment = 1;

% Processing the station where the passenger gets on (or say where the
% Reference trace starts)
fRefStartTime = mUniquedRefTrace(1,1);

nHandLineNo = 1;
nHandFirstStationBeginLineNo = 0;
nHandFirstStationEndLineNo = 0;

for i = 1:nHandRow
    if mUniquedHandTrace(i, 2) == -1 % null
        continue;
    elseif mUniquedHandTrace(i, 2) == 0 % station
        if nHandFirstStationBeginLineNo == 0
            nHandFirstStationBeginLineNo = i;
        end
        nHandFirstStationEndLineNo = i;
        continue;
    else  % running
        nHandLineNo = i;
        break;
    end
end

if nHandFirstStationBeginLineNo == 0
    nHandFirstStationBeginLineNo = 1;
    nHandFirstStationEndLineNo = SBM_GetLineNoByTime(mUniquedHandTrace, mUniquedHandTrace(nHandFirstStationBeginLineNo,1) + 2);
end

fHandBeginTm = mUniquedHandTrace(nHandLineNo, 1);

if fHandBeginTm > fRefStartTime
    nRefFirstStationEndLineNo = SBM_GetLineNoByTime(mUniquedRefTrace, fHandBeginTm);
    nRefFirstStationEndLineNoBaro = nRefFirstStationEndLineNo;
else
    nRefFirstStationEndLineNo = 1;
    nRefFirstStationEndLineNoBaro = SBM_GetLineNoByTime(mUniquedRefTrace, fRefStartTime + 2);  % Only for calculating mean baro
end

fMeanBaroRef = SBM_GetMeanBaro(mUniquedRefTrace, 2, 1, nRefFirstStationEndLineNoBaro);
[fMeanGpsLatRef, fMeanGpsLngRef, fMeanGpsAltRef] = SBM_GetMeanGps(mUniquedRefTrace, 2, 1, nRefFirstStationEndLineNo);
fprintf(fidWriteRef, '%d,-1,%d,-1,%f,%f,%f,%f,%f,%f,%f\n',nTypeStation,nRefFirstStationEndLineNo,fMeanBaroRef, ...
                                                          fMeanGpsLatRef, fMeanGpsLngRef, fMeanGpsAltRef, fMeanGpsLatRef, fMeanGpsLngRef, fMeanGpsAltRef);


fMeanBaroHand = SBM_GetMeanBaro(mUniquedHandTrace, 3, nHandFirstStationBeginLineNo, nHandFirstStationEndLineNo);
[fMeanGpsLatHand, fMeanGpsLngHand, fMeanGpsAltHand] = SBM_GetMeanGps(mUniquedHandTrace, 3, nHandFirstStationBeginLineNo, nHandFirstStationEndLineNo);
fprintf(fidWriteHand, '%d,-1,%d,-1,%f,%f,%f,%f,%f,%f,%f\n',nTypeStation,nHandFirstStationEndLineNo,fMeanBaroHand, ...
                                                          fMeanGpsLatHand, fMeanGpsLngHand, fMeanGpsAltHand, fMeanGpsLatHand, fMeanGpsLngHand, fMeanGpsAltHand);
                                                      
nPocketFirstStationBeginLineNo = SBM_GetLineNoByTime(mUniquedPocketTrace, mUniquedHandTrace(nHandFirstStationBeginLineNo,1));
nPocketFirstStationEndLineNo = SBM_GetLineNoByTime(mUniquedPocketTrace, mUniquedHandTrace(nHandFirstStationEndLineNo,1));

fMeanBaroPocket = SBM_GetMeanBaro(mUniquedPocketTrace, 2, nPocketFirstStationBeginLineNo, nPocketFirstStationEndLineNo);
[fMeanGpsLatPocket, fMeanGpsLngPocket, fMeanGpsAltPocket] = SBM_GetMeanGps(mUniquedPocketTrace, 2, nPocketFirstStationBeginLineNo, nPocketFirstStationEndLineNo);
fprintf(fidWritePocket, '%d,-1,%d,-1,%f,%f,%f,%f,%f,%f,%f\n',nTypeStation,nPocketFirstStationEndLineNo,fMeanBaroPocket, ...
                                                          fMeanGpsLatPocket, fMeanGpsLngPocket, fMeanGpsAltPocket, fMeanGpsLatPocket, fMeanGpsLngPocket, fMeanGpsAltPocket);
                                                      
                                                      
bFirstLineOfUnit = 0;
nHandUnitFirstLine = 0;
nHandUnitLastLine = 0;
nPreviousLabel = 0;

while nHandLineNo <= nHandRow
    nLabel = mUniquedHandTrace(nHandLineNo, 2);

    if bFirstLineOfUnit == 0
        nHandUnitFirstLine = nHandLineNo;
        bFirstLineOfUnit = 1;
        nPreviousLabel = nLabel;
        nHandLineNo = nHandLineNo + 1;
        continue;
    end
    
    if nLabel == nPreviousLabel
        nHandUnitLastLine = nHandLineNo;
    else
        % One Unit ends
        % Find the First/Last lines of the Unit in Ref and Pantpocket
        % traces according to the Hand trace
        nRefUnitFirstLine = SBM_GetLineNoByTime(mUniquedRefTrace, mUniquedHandTrace(nHandUnitFirstLine,1));
        nRefUnitLastLine = SBM_GetLineNoByTime(mUniquedRefTrace, mUniquedHandTrace(nHandUnitLastLine,1));

        nPocketUnitFirstLine = SBM_GetLineNoByTime(mUniquedPocketTrace, mUniquedHandTrace(nHandUnitFirstLine,1));
        nPocketUnitLastLine = SBM_GetLineNoByTime(mUniquedPocketTrace, mUniquedHandTrace(nHandUnitLastLine,1));
        
        fMeanBaroRef = SBM_GetMeanBaro(mUniquedRefTrace, 2, nRefUnitFirstLine, nRefUnitLastLine);
        fMeanBaroHand = SBM_GetMeanBaro(mUniquedHandTrace, 3, nHandUnitFirstLine, nHandUnitLastLine);
        fMeanBaroPocket = SBM_GetMeanBaro(mUniquedPocketTrace, 2, nPocketUnitFirstLine, nPocketUnitLastLine);

        fDuration = mUniquedHandTrace(nHandUnitLastLine,1) - mUniquedHandTrace(nHandUnitFirstLine,1);
        
        if nPreviousLabel == nTypeSegment
            fprintf(fidWriteRef, '%d,%d,%d,%f,%f,%f,%f,%f,%f,%f,%f\n',nTypeSegment,nRefUnitFirstLine, nRefUnitLastLine,fDuration, fMeanBaroRef, ...
                                                                   mUniquedRefTrace(nRefUnitFirstLine,6), mUniquedRefTrace(nRefUnitFirstLine,7), mUniquedRefTrace(nRefUnitFirstLine,8), ...
                                                                   mUniquedRefTrace(nRefUnitLastLine,6), mUniquedRefTrace(nRefUnitLastLine,7), mUniquedRefTrace(nRefUnitLastLine,8)); 
                                                               
            fprintf(fidWriteHand, '%d,%d,%d,%f,%f,%f,%f,%f,%f,%f,%f\n',nTypeSegment,nHandUnitFirstLine, nHandUnitLastLine,fDuration, fMeanBaroHand, ...
                                                                   mUniquedHandTrace(nHandUnitFirstLine,7), mUniquedHandTrace(nHandUnitFirstLine,8), mUniquedHandTrace(nHandUnitFirstLine,9), ...
                                                                   mUniquedHandTrace(nHandUnitLastLine,7), mUniquedHandTrace(nHandUnitLastLine,8), mUniquedHandTrace(nHandUnitLastLine,9));   
                                                               
            fprintf(fidWritePocket, '%d,%d,%d,%f,%f,%f,%f,%f,%f,%f,%f\n',nTypeSegment,nPocketUnitFirstLine, nPocketUnitLastLine,fDuration, fMeanBaroPocket, ...
                                                                   mUniquedPocketTrace(nPocketUnitFirstLine,6), mUniquedPocketTrace(nPocketUnitFirstLine,7), mUniquedPocketTrace(nPocketUnitFirstLine,8), ...
                                                                   mUniquedPocketTrace(nPocketUnitLastLine,6), mUniquedPocketTrace(nPocketUnitLastLine,7), mUniquedPocketTrace(nPocketUnitLastLine,8));            

        elseif nPreviousLabel == nTypeStation
            [fMeanGpsLatRef, fMeanGpsLngRef, fMeanGpsAltRef] = SBM_GetMeanGps(mUniquedRefTrace, 2, nRefUnitFirstLine, nRefUnitLastLine);
            [fMeanGpsLatHand, fMeanGpsLngHand, fMeanGpsAltHand] = SBM_GetMeanGps(mUniquedHandTrace, 3, nHandUnitFirstLine, nHandUnitLastLine);
            [fMeanGpsLatPocket, fMeanGpsLngPocket, fMeanGpsAltPocket] = SBM_GetMeanGps(mUniquedPocketTrace, 2, nPocketUnitFirstLine, nPocketUnitLastLine);
            
            if nLabel == -1  % null,it means this is the last station, i.e. the station where passenger gets off
                fprintf(fidWriteRef, '%d,%d,-1,-1,%f,%f,%f,%f,%f,%f,%f\n',nTypeStation,nRefUnitFirstLine, fMeanBaroRef, ...
                                                                          fMeanGpsLatRef, fMeanGpsLngRef, fMeanGpsAltRef,fMeanGpsLatRef, fMeanGpsLngRef, fMeanGpsAltRef);
                                                                      
                fprintf(fidWriteHand, '%d,%d,-1,-1,%f,%f,%f,%f,%f,%f,%f\n',nTypeStation,nHandUnitFirstLine, fMeanBaroHand, ...
                                                                          fMeanGpsLatHand, fMeanGpsLngHand, fMeanGpsAltHand,fMeanGpsLatHand, fMeanGpsLngHand, fMeanGpsAltHand);
                                                                      
                fprintf(fidWritePocket, '%d,%d,-1,-1,%f,%f,%f,%f,%f,%f,%f\n',nTypeStation,nPocketUnitFirstLine, fMeanBaroPocket, ...
                                                                          fMeanGpsLatPocket, fMeanGpsLngPocket, fMeanGpsAltPocket,fMeanGpsLatPocket, fMeanGpsLngPocket, fMeanGpsAltPocket);

            else
                fprintf(fidWriteRef, '%d,%d,%d,%f,%f,%f,%f,%f,%f,%f,%f\n',nTypeStation,nRefUnitFirstLine, nRefUnitLastLine,fDuration, fMeanBaroRef, ...
                                                                          fMeanGpsLatRef, fMeanGpsLngRef, fMeanGpsAltRef,fMeanGpsLatRef, fMeanGpsLngRef, fMeanGpsAltRef);
                                                                      
                fprintf(fidWriteHand, '%d,%d,%d,%f,%f,%f,%f,%f,%f,%f,%f\n',nTypeStation,nHandUnitFirstLine, nHandUnitLastLine,fDuration, fMeanBaroHand, ...
                                                                          fMeanGpsLatHand, fMeanGpsLngHand, fMeanGpsAltHand,fMeanGpsLatHand, fMeanGpsLngHand, fMeanGpsAltHand);
                                                                      
                fprintf(fidWritePocket, '%d,%d,%d,%f,%f,%f,%f,%f,%f,%f,%f\n',nTypeStation,nPocketUnitFirstLine, nPocketUnitLastLine,fDuration, fMeanBaroPocket, ...
                                                                          fMeanGpsLatPocket, fMeanGpsLngPocket, fMeanGpsAltPocket,fMeanGpsLatPocket, fMeanGpsLngPocket, fMeanGpsAltPocket);
                                                                      
            end
        end
           
        if nLabel == -1  % null means the last station
            break;
        end
        
        nHandUnitFirstLine = nHandLineNo;
        nPreviousLabel = nLabel;
    end
    
    nHandLineNo = nHandLineNo + 1;
    
end

fclose(fidWritePocket);
fclose(fidWriteHand);
fclose(fidWriteRef);

fprintf('\nFinish Time: %s\n', datestr(clock, 'yyyy-mm-dd HH:MM:SS'));

return;

