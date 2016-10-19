function f=Sky_sp_RcvEventStats_Total_80(bDense, fEndTime, mImgSize)
% This function calculate the average #receive event for every node/s in
% each trace
% It also calculate the receving time of each image event
%
% Parameter:
%   bDense:  1, Dense mode;  0, Sparse mode
%   fTimeIgnored: The time from the last to ignored. (Because the trace is
%   terminated at the end, so some transmission is terminated, should
%   should be excluded from the statistics.)
%

fprintf('Start Time: %s\n', datestr(clock, 'yyyy-mm-dd HH:MM:SS'));

%mTransRange = [60 80 100];  % Meter
mTransRange = [80];  % Meter

%mImgSize = [10 12 14 16 18];  % KB
%mSmallPktSize = [512 1024 2048];  %B
mSmallPktSize = [1024];  %B

%bDense = 1;

nFixedImgCnt = 0;   % Count of image is not fixed

nRangeCount = length(mTransRange);
nImgSizeCount = length(mImgSize);
nSmallPktSizeCount = length(mSmallPktSize);

format long;

nMapMsgSize = 512;  % Map message size

sPlace = 'F:\\SkyEye_sp_Output\\Meng_NonFixedImgCnt\\';

if bDense == 0
    %%%% Sparse Mode
%    sNeighFilePre = 'Sparse_sp_NeighborList_Trans\\aligned\\Sparse_Neighbor';
    %sNeighFilePre = 'Sparse_sp_NeighborList_NoTrans\\aligned\\Sparse_Neighbor';
    sReceiverFilePre = 'Sparse_sp_ReceiverList_TmCnst\\aligned\\Sparse_Receiver';
    
    sProcessedTraceFilePre = 'Sparse_sp_Trace\\SkyEye_Sparse';
    
    sRcvEventStatsFilePre = 'Sparse_sp_RcvEventStats\\Sparse_RcvEventStats';

else
    %%%% Dense Mode
%    sNeighFilePre = 'Dense_sp_NeighborList_Trans\\aligned\\Dense_Neighbor';
    %sNeighFilePre = 'Dense_sp_NeighborList_NoTrans\\aligned\\Dense_Neighbor';
    sReceiverFilePre = 'Dense_sp_ReceiverList_TmCnst\\aligned\\Dense_Receiver';

    sProcessedTraceFilePre = 'Dense_sp_Trace\\SkyEye_Dense';

    sRcvEventStatsFilePre = 'Dense_sp_RcvEventStats\\Dense_RcvEventStats';

end


fTotalTime = fEndTime - 290.0;   % Total time

rcvTimeMatArr = [];

for i=1:nRangeCount
    
    nRange = mTransRange(1,i);
    
    for j=1:nImgSizeCount
        nImgSize = mImgSize(1,j);

        sOutputFile = sprintf('%s%s_%s_%s_%s.csv', sPlace, sRcvEventStatsFilePre, num2str(nRange), num2str(nImgSize), num2str(nFixedImgCnt));   % Output file
    
        fid_result = fopen(sOutputFile,'w');
        
        for k=1:nSmallPktSizeCount
            nSmallPktSize = mSmallPktSize(1,k);
            nSmallPktCnt = nImgSize*1024/nSmallPktSize;  % Each image has this many small packets

            % Aligned Neighbor list file and Receiver list file
            %sNeighFile = sprintf('%s%s_%s_%s_%s_%s.csv', sPlace, sNeighFilePre, num2str(nRange), num2str(nSmallPktSize), num2str(nSmallPktCnt), num2str(nFixedImgCnt));
            sReceiverFile = sprintf('%s%s_%s_%s_%s_%s.csv', sPlace, sReceiverFilePre, num2str(nRange), num2str(nSmallPktSize), num2str(nSmallPktCnt), num2str(nFixedImgCnt));

            %mNeigh = load(sNeighFile);
            mReceiver = load(sReceiverFile);
                        
            %[rowNum colNum] = size(mNeigh);
            
            %fTmLast = mNeigh(rowNum, 2);   % The timestamp of the last trace record

            %fLastValidTm = floor(fTmLast)*1.0 - fTimeIgnored;   % Last record in this time to be calculated
            
            %fTotalTime = fLastValidTm - mNeigh(1, 2);
            %%%fTotalTime = mNeigh(rowNum, 2) - mNeigh(1, 2);

%            nodeCnt = max(mNeigh(:,3))+1  % nodeID start from 0
            
       %%% Here below commented out, because these information could be obtained in the processing below it     
            % Calculate Average #receive event/s
       %%%     mRcvEventTimesInS = Sky_sp_RcvEventStats(mReceiver, fTotalTime, nodeCnt);

       %%%     avgRcvEventTimesInS = mean(mRcvEventTimesInS);
       %%%     stdRcvEventTimesInS = std(mRcvEventTimesInS);
       %%%     maxRcvEventTimesInS = max(mRcvEventTimesInS);
       %%%     minRcvEventTimesIns = min(mRcvEventTimesInS);
            
            
            % Here below get the receiving time for each receiver for each
            % image receiving event
            sProcessedTraceFile = sprintf('%s%s_%s_%s_%s_%s.csv', sPlace, sProcessedTraceFilePre, num2str(nRange), num2str(nSmallPktSize), num2str(nSmallPktCnt), num2str(nFixedImgCnt));
            
            mTrace = load(sProcessedTraceFile);
            
            [rowTrace colTrace] = size(mTrace);
            [rowRcvList colRcvList] = size(mReceiver);

            nodeCnt = max(mTrace(:,3))+1;  % nodeID start from 0

            rcvTimeMatArr = [];   % Record valid receiving time of image for each receiver (receiver node ID + 1 is the index)
            rcvTimeMatCnt = [];   % Record how many valid receiving event of image for each receiver (receiver node ID + 1 is the index)
            
            for m=1:nodeCnt
                rcvTimeMatArr{m} = [];  
                rcvTimeMatCnt(1,m) = 0;
            end
            
            % Here pay attention: node ID is started from 0, but the index
            % of Matrix is started from 1
            % Here below: Search through the receiver list file, for each sending
            % event: For each of its valid receiver, search through the
            % processed trace file to get the timestamp of receiving for
            % the last small packet of image
            for s=1:rowRcvList
                
                disp(strcat(num2str(s), '/', num2str(rowRcvList)));
                sndNodeID = mReceiver(s, 1);
                nMsgSize = mReceiver(s, 2);
                tmSnd = mReceiver(s, 3);
                
                if tmSnd > fEndTime
                    break;
                end
                
                if nMsgSize ~= nMapMsgSize  % Only calculate for Image Message Receiving Event
                    for ss=4:colRcvList
                        rcvNodeID = mReceiver(s, ss);
                        if rcvNodeID == -1
                            break;
                        else
                            % First, Look for the packet Id of the last small packet
                            % of an image
                            lastSmallPktId = -1;
                            nStartPos = -1;
                            for t=1:rowTrace
                                if mTrace(t,2) < tmSnd 
                                    continue;
                                end
                                
                                if mTrace(t,1) == 1 && mTrace(t,2) == tmSnd && mTrace(t,3) == sndNodeID
                                    lastSmallPktId = mTrace(t,4) + nSmallPktCnt - 1;  % Last small packet ID of an image
                                    nStartPos = t;
                                    break;
                                end
                            end
                            
                            if lastSmallPktId ~= -1
                                % Look for the receiving time of the last
                                % small packet of an image
                                for tt=nStartPos+1:rowTrace
                                    if mTrace(tt,1) == 0 && mTrace(tt,3) == rcvNodeID && mTrace(tt,4) == lastSmallPktId && mTrace(tt,6) == sndNodeID
                                        nIdx = rcvNodeID + 1;  % Node ID starts from 0; Index starts from 1
                                        rcvTimeMatCnt(1, nIdx) = rcvTimeMatCnt(1, nIdx) + 1;  % Increase image receving event number for this receiver
                                        rcvTimeMatArr{nIdx}(1, rcvTimeMatCnt(1, nIdx)) = mTrace(tt,2);  % Receiving time
                                    end
                                end
                            end
                            
                        end
                    end
                end  % if nMsgSize ~= nMapMsgSize
            end % for s=1:rowRcvList
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%% Now statistics of the result for current    
            %%%%%% trace/neigh list/receiver list file
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%% First: Average, Std, Max, Min Number of image receiving
            %%% event of each node
            mRcvEventTimesInS = []; % Average #receive event/s

            for p=1:nodeCnt
                mRcvEventTimesInS(1, p) = rcvTimeMatCnt(1, p)*1.0/fTotalTime;
            end

            avgRcvEventTimesInS = mean(mRcvEventTimesInS);
            stdRcvEventTimesInS = std(mRcvEventTimesInS);
            maxRcvEventTimesInS = max(mRcvEventTimesInS);
            minRcvEventTimesIns = min(mRcvEventTimesInS);
            
            %%% Second: Find out the maximum number of image receiving
            %%% event happens on one receiver node during an one-second
            %%% time range
            nMaxImgRcvCnt = 0;  % In an one-second time range, the maximum image receiving event occurs on one node
            
            fTimeRange = 1.0;  % This is for calculate how many image receiving events happen in one second
            
            for q=1:nodeCnt
                tmpMat = rcvTimeMatArr{q};  % The image receiving time array for one receiver node
                
                for qq=1:rcvTimeMatCnt(1,q)
                    baseRcvTime = tmpMat(1, qq);
                    tmpCntInTmRange = 0;
                    for qqq=qq+1:rcvTimeMatCnt(1,q)
                        if abs(tmpMat(1,qqq) - baseRcvTime) <= fTimeRange
                            tmpCntInTmRange = tmpCntInTmRange + 1;
                        else
                            break;
                        end
                    end
                    
                    if tmpCntInTmRange > nMaxImgRcvCnt
                        nMaxImgRcvCnt = tmpCntInTmRange;
                    end
                    
                end
                
            end
            
            %%%% Now write the Avg, Std, Max, Min Image Receiving event
            %%%% every second and the Max Image Receiving event on one node
            %%%% into file
            fprintf(fid_result,'%d,%d,%d,%f,%f,%f,%f,%d\n',nRange, nImgSize, nSmallPktSize, avgRcvEventTimesInS, stdRcvEventTimesInS, maxRcvEventTimesInS, minRcvEventTimesIns, nMaxImgRcvCnt);

        end  % for k=1:nSmallPktSizeCount

        fclose(fid_result);
        
    end  % for j=1:nImgSizeCount


end  % for i=1:nRangeCount


disp('***********Processing is done!******************');

fprintf('Finish Time: %s\n', datestr(clock, 'yyyy-mm-dd HH:MM:SS'));

f=0;

return;

