%function f = SBM_BC_SplitTrace_Psg(sRawRefFile, nSegCnt, sRawPsgFile)
function f = SBM_BC_SplitTrace_Psg()

% Time(1), SensorType(2), x(3), y(4), z(5), GPS Lat(6), GPS Long(7), GPS Alt(8), GPS Speed(9), GPS Bearing(10)

format long;

nSegCnt = 7;
sRawRefFile = 'E:\SensorMatching\Data\Bus_Car\Ref_Uniqued_TmCrt.csv';
sRawPsgFile = 'E:\SensorMatching\Data\Bus_Car\Seat_Car_Uniqued_TmCrt.csv';

sSegFolder = 'Seg';
sResultPostFix = 'Seg';

[pathstr, filename, ext] = fileparts(sRawRefFile);

[pathstrPsg, filenamePsg, extPsg] = fileparts(sRawPsgFile);


mPsgTrace = load(sRawPsgFile);

[nPsgRowCnt ~] = size(mPsgTrace);

nPsgSegStartRowIdx = 1;

while mPsgTrace(nPsgSegStartRowIdx, 9) == 0.0 && nPsgSegStartRowIdx < nPsgRowCnt
    nPsgSegStartRowIdx = nPsgSegStartRowIdx + 1;
end

fPsgStartTm = mPsgTrace(nPsgSegStartRowIdx, 1);

sRefSegFile = [pathstr '\' sSegFolder '\' filename '_' sResultPostFix '_' num2str(1) '.csv'];
mRefSeg = load(sRefSegFile);

fRefStartTm = mRefSeg(1,1);

fPsgRefGap = fPsgStartTm - fRefStartTm


nPsgSegStartRowIdx = 1;

for nSegIdx=1:nSegCnt
    sRefSegFile = [pathstr '\' sSegFolder '\' filename '_' sResultPostFix '_' num2str(nSegIdx) '.csv'];
    mRefSeg = load(sRefSegFile);
    [nRefSegRowCnt ~] = size(mRefSeg);

    fRefStartTm = mRefSeg(1, 1);
    fRefEndTm = mRefSeg(nRefSegRowCnt, 1);
    
    fPsgStartTm = fRefStartTm + fPsgRefGap;
    fPsgEndTm = fRefEndTm + fPsgRefGap;

    
    nPsgSegStartRow = -1;
    nPsgSegEndRow = -1;
    
    fStartTmGap = 9999.0;
    
    % Find start line of Psg Segment
    for i = nPsgSegStartRowIdx:nPsgRowCnt
        fTmGap = abs(mPsgTrace(i, 1) - fPsgStartTm);
        if fStartTmGap >= fTmGap
            fStartTmGap = fTmGap;
            nPsgSegStartRow = i;
        else
            break;
        end
    end
       
 
    
    fEndTmGap = 9999.0;
    
    for i = nPsgSegStartRow+1:nPsgRowCnt
        fTmGap = abs(mPsgTrace(i, 1) - fPsgEndTm);
        if fEndTmGap >= fTmGap
            fEndTmGap = fTmGap;
            nPsgSegEndRow = i;
        else
            break;
        end
    end
    
       
    sPsgSegFile = [pathstrPsg '\' sSegFolder '\' filenamePsg '_' sResultPostFix '_' num2str(nSegIdx) '.csv'];
    fidWrite = fopen(sPsgSegFile, 'w');

    for i = nPsgSegStartRow:nPsgSegEndRow
        fprintf(fidWrite, '%4.5f,%d,%5.12f,%5.12f,%5.12f,%5.8f,%5.8f,%5.4f,%3.4f,%3.4f\n', mPsgTrace(i,1), mPsgTrace(i,2), mPsgTrace(i,3), mPsgTrace(i,4), mPsgTrace(i,5), ...
                                                                                      mPsgTrace(i,6), mPsgTrace(i,7), mPsgTrace(i,8), mPsgTrace(i,9), mPsgTrace(i,10));            
    end

    fclose(fidWrite);

    nPsgSegStartRowIdx = nPsgSegEndRow+1;
end


return;
