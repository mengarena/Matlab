function f = Bak_SBM_BC_SplitTrace_Psg(sRawRefFile, nSegCnt, sRawPsgFile)
% Time(1), SensorType(2), x(3), y(4), z(5), GPS Lat(6), GPS Long(7), GPS Alt(8), GPS Speed(9), GPS Bearing(10)

format long;

sSegFolder = 'Seg';
sResultPostFix = 'Seg';

fGpsThreshold = 25.0;

mPsgTrace = load(sRawPsgFile);

[nPsgRowCnt ~] = size(mPsgTrace);

nPsgSegStartRowIdx = 1;

while mPsgTrace(nPsgSegStartRowIdx, 9) == 0.0 && nPsgSegStartRowIdx < nPsgRowCnt
    nPsgSegStartRowIdx = nPsgSegStartRowIdx + 1;
end

[pathstr, filename, ext] = fileparts(sRawRefFile);

[pathstrPsg, filenamePsg, extPsg] = fileparts(sRawPsgFile);

for nSegIdx=1:nSegCnt
    sRefSegFile = [pathstr '\' sSegFolder '\' filename '_' sResultPostFix '_' num2str(nSegIdx) '.csv'];
    mRefSeg = load(sRefSegFile);
    [nRefSegRowCnt ~] = size(mRefSeg);
    
    fSegStartGpsLat = mRefSeg(1, 6);
    fSegStartGpsLong = mRefSeg(1, 7);
    
    fSegEndGpsLat = mRefSeg(nRefSegRowCnt, 6);
    fSegEndGpsLong = mRefSeg(nRefSegRowCnt, 7);
    
    nPsgSegStartRow = -1;
    nPsgSegEndRow = -1;
    
    fStartDist = 9999999.0;
    
    % Find start line of Psg Segment
    for i = nPsgSegStartRowIdx:nPsgRowCnt
        fDist = ZD_CalculateDistanceByGPS(fSegStartGpsLat, fSegStartGpsLong, mPsgTrace(i, 6), mPsgTrace(i, 7));
        if fDist < fStartDist
            fStartDist = fDist;
            nPsgSegStartRow = i;
        end
    end
    
    % Find end line of Psg Segment
    if nPsgSegStartRow == -1
        break;
    end
   
    fEndDist = 9999999.0;
    
    for i = nPsgSegStartRow+1:nPsgRowCnt
        fDist = ZD_CalculateDistanceByGPS(fSegEndGpsLat, fSegEndGpsLong, mPsgTrace(i, 6), mPsgTrace(i, 7));
        if fDist < fEndDist
            fEndDist = fDist;
            nPsgSegEndRow = i;
        end        
    end
    
    if nPsgSegEndRow ~= -1
        
        fprintf('Seg: %d,  SegStartDist = %f,  SegEndDist = %f\n', nSegIdx, fStartDist, fEndDist);
        
        sPsgSegFile = [pathstrPsg '\' sSegFolder '\' filenamePsg '_' sResultPostFix '_' num2str(nSegIdx) '.csv'];
        fidWrite = fopen(sPsgSegFile, 'w');
        
        for i = nPsgSegStartRow:nPsgSegEndRow
            fprintf(fidWrite, '%4.5f,%d,%5.12f,%5.12f,%5.12f,%5.8f,%5.8f,%5.4f,%3.4f,%3.4f\n', mPsgTrace(i,1), mPsgTrace(i,2), mPsgTrace(i,3), mPsgTrace(i,4), mPsgTrace(i,5), ...
                                                                                          mPsgTrace(i,6), mPsgTrace(i,7), mPsgTrace(i,8), mPsgTrace(i,9), mPsgTrace(i,10));            
        end
        
        fclose(fidWrite);
                
        nPsgSegStartRowIdx = nPsgSegEndRow+1;
    else
        break;
    end
end


return;
