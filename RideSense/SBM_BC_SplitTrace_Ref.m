function f = SBM_BC_SplitTrace_Ref(sRawSensorFile)
% Fields in sRawSensorFile:
% Time(1), SensorType(2), x(3), y(4), z(5), GPS Lat(6), GPS Long(7), GPS Alt(8), GPS Speed(9), GPS Bearing(10)
%

format long;

fSegmentLen = 300.0;     % seconds, each segment should at least has this length
fEndTime = 2908.0;   

fStopDuration = 10.0;   % Must stop at least 10 seconds   

% Use Gps Speed to detect stops

mSensor = load(sRawSensorFile);

[nRowCnt ~] = size(mSensor);

sSegFolder = 'Seg';
sResultPostFix = 'Seg';

nSegStartRowIdx = 1;

while mSensor(nSegStartRowIdx, 9) == 0.0 && nSegStartRowIdx < nRowCnt
    nSegStartRowIdx = nSegStartRowIdx + 1;
end

nSegEndRowIdx = nSegStartRowIdx + 1;

% Find all the stops (the stop should have duration at least fStopDuration

nCandidateStopBeginRowIdx = -1;
nCandidateStopEndRowIdx = -1;

mStops = [];
nStopCnt = 0;

while mSensor(nSegEndRowIdx, 1) <= fEndTime
    
    if mSensor(nSegEndRowIdx, 9) == 0.0
        if nCandidateStopBeginRowIdx == -1
            nCandidateStopBeginRowIdx = nSegEndRowIdx;
        end
        
        nCandidateStopEndRowIdx  =  nSegEndRowIdx;
    else
        if nCandidateStopBeginRowIdx ~= -1 && mSensor(nCandidateStopEndRowIdx, 1) - mSensor(nCandidateStopBeginRowIdx, 1) >= fStopDuration
            nStopCnt = nStopCnt + 1;
            mStops(nStopCnt, 1) = nCandidateStopBeginRowIdx;
            mStops(nStopCnt, 2) = nCandidateStopEndRowIdx;
            mStops(nStopCnt, 3) = mSensor(nCandidateStopBeginRowIdx, 1);
            mStops(nStopCnt, 4) = mSensor(nCandidateStopEndRowIdx, 1);
        end
    
        nCandidateStopBeginRowIdx = -1;
        nCandidateStopEndRowIdx = -1;
    end
    
    nSegEndRowIdx = nSegEndRowIdx + 1;
end

if nCandidateStopBeginRowIdx ~= -1 && mSensor(nCandidateStopEndRowIdx, 1) - mSensor(nCandidateStopBeginRowIdx, 1) >= fStopDuration
    nStopCnt = nStopCnt + 1;
    mStops(nStopCnt, 1) = nCandidateStopBeginRowIdx;
    mStops(nStopCnt, 2) = nCandidateStopEndRowIdx;
    mStops(nStopCnt, 3) = mSensor(nCandidateStopBeginRowIdx, 1);
    mStops(nStopCnt, 4) = mSensor(nCandidateStopEndRowIdx, 1);    
end


% Split the raw trace into segments
[pathstr, filename, ext] = fileparts(sRawSensorFile);

nStopIdx = 1;
nSegIdx = 1;

while nStopIdx <= nStopCnt
    if mSensor(mStops(nStopIdx, 1), 1) - mSensor(nSegStartRowIdx,1) >= fSegmentLen
        sResultSegFile = [pathstr '\' sSegFolder '\' filename '_' sResultPostFix '_' num2str(nSegIdx) '.csv'];
        fidWrite = fopen(sResultSegFile, 'w');
        
        for i = nSegStartRowIdx:mStops(nStopIdx, 1)-1
            fprintf(fidWrite, '%4.5f,%d,%5.12f,%5.12f,%5.12f,%5.8f,%5.8f,%5.4f,%3.4f,%3.4f\n', mSensor(i,1), mSensor(i,2), mSensor(i,3), mSensor(i,4), mSensor(i,5), ...
                                                                                          mSensor(i,6), mSensor(i,7), mSensor(i,8), mSensor(i,9), mSensor(i,10));            
        end
        
        fclose(fidWrite);
        
        nSegIdx = nSegIdx + 1;
                
        nSegStartRowIdx = mStops(nStopIdx, 2) + 1;
    end
    
    nStopIdx = nStopIdx + 1;
end

if mSensor(nSegEndRowIdx, 1) - mSensor(nSegStartRowIdx, 1) >= 10.0   % Last segment
    sResultSegFile = [pathstr '\' sSegFolder '\' filename '_' sResultPostFix '_' num2str(nSegIdx) '.csv'];
    fidWrite = fopen(sResultSegFile, 'w');

    for i = nSegStartRowIdx:nSegEndRowIdx
        fprintf(fidWrite, '%4.5f,%d,%5.12f,%5.12f,%5.12f,%5.8f,%5.8f,%5.4f,%3.4f,%3.4f\n', mSensor(i,1), mSensor(i,2), mSensor(i,3), mSensor(i,4), mSensor(i,5), ...
                                                                                      mSensor(i,6), mSensor(i,7), mSensor(i,8), mSensor(i,9), mSensor(i,10));            
    end

    fclose(fidWrite);    
end

nSegIdx

return;

% nTmpStopBeginRowIdx = -1;
% nTmpStopEndRowIdx = -1;
% 
% nCandidateStopBeginRowIdx = -1;
% nCandidateStopEndRowIdx = -1;
% 
% while mSensor(nSegEndRowIdx, 1) <= fEndTime
% 
%     while nSegEndRowIdx <= nRowCnt && mSensor(nSegEndRowIdx, 1) <= fEndTime && mSensor(nSegEndRowIdx, 1) - mSensor(nSegStartRowIdx, 1) <= fSegmentLen
%         if mSensor(nSegEndRowIdx, 9) > 0.0
%             if nTmpStopBeginRowIdx ~= -1 && mSensor(nTmpStopEndRowIdx, 1) - mSensor(nTmpStopBeginRowIdx, 1) >= fStopDuration
%                 nCandidateStopBeginRowIdx = nTmpStopBeginRowIdx;
%                 nCandidateStopEndRowIdx = nTmpStopEndRowIdx;
%             end
% 
%             nTmpStopBeginRowIdx = -1;
%             nTmpStopEndRowIdx = -1;
%         else
%             if nTmpStopBeginRowIdx == -1
%                 nTmpStopBeginRowIdx = nSegEndRowIdx;
%             end
% 
%             nTmpEndRowIdx = nSegEndRowIdx;
%         end
% 
%         nSegEndRowIdx = nSegEndRowIdx + 1;
%     end
% 
%     sResultSegFile = [pathstr '\' filename '_' sResultPostFix '_' num2str(nSegIdx) '.csv'];
%     fidWrite = fopen(sResultSegFile, 'w');
%     
%     for i = nSegStartRowIdx:nCandidateStopBeginRowIdx
%         fprintf(fidWrite, '%4.5f,%d,%5.12f,%5.12f,%5.12f,%5.8f,%5.8f,%5.4f,%3.4f,%3.4f\n', mSensor(i,1), mSensor(i,2), mSensor(i,3), mSensor(i,4), mSensor(i,5), ...
%                                                                                          mSensor(i,6), mSensor(i,7), mSensor(i,8), mSensor(i,9), mSensor(i,10));   
%     end
%     
%     fclose(fidWrite);
% 
%     nSegIdx = nSegIdx + 1;
%     
%     nSegStartRowIdx = nCandidateStopEndRowIdx + 1;
%     nSegEndRowIdx = nSegStartRowIdx + 1;
% end
    
    