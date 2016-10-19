function f = VT_PRR_fromTargetList(mTargetList, mReceiverList, fEndTime)
% This function measure the Packet Receive Rate
%
% mNeighList: This is the matrix of neighbor list (i.e. the list of the node who should receive the packet) for the senders
% mReceiverList: This is the node list who actually receives the packet
% fEndTime: Only calculate the sending event before this time.
%
% Neighbor node ID starts from 3rd column in mNeighList
% Receiver node ID starts from 4th column in the mReceiverList
% 
% Result: A mean number of the Packet Receive Rate
%

format long;

[nTargetRow nTargetCol] = size(mTargetList);
[nReceiverRow nReceiverCol] = size(mReceiverList);

nTotalTargetRow = sum(mTargetList(:,3));

nMyCnt = min(nTotalTargetRow, nReceiverRow);


nTargetRowIdx = 1;

curTargetSender = mTargetList(nTargetRowIdx, 1);
curTargetSenderTime = mTargetList(nTargetRowIdx, 2);
curTargetImgCount = mTargetList(nTargetRowIdx, 3);
curTargetCount = mTargetList(nTargetRowIdx, 4);



nMapMsgSize = 512;  % Map message size

mImgMsgPRR = [];
mMapMsgPRR = [];

nImgMsgCount = 0;
nMapMsgCount = 0;

%for i=1:nNeighRow
for i=1:nMyCnt
    
    if curTargetSenderTime > fEndTime
        break;
    end

    hostReceiver = mReceiverList(i, 1);
%    tmReceiver = mReceiverList(i, 2);
    tmReceiver = mReceiverList(i, 3);
    
    nPacketSize = mReceiverList(i,2);
        
    if curTargetSender == hostReceiver && curTargetSenderTime == tmReceiver
        
        nReceiverCnt = 0;
        
        % Calculate #Valid receivers (i.e. the receiver should occur in the
        % neighbors list)
%        for k=3:nReceiverCol
        for k=4:nReceiverCol
            if mReceiverList(i,k) ~= -1
                for p=1:curTargetCount
                    if mReceiverList(i,k) == mTargetList(nTargetRowIdx, p+4)
                        % Only the node exists in the neighbor list, it is
                        % considered valid for PRR calculation
                        nReceiverCnt = nReceiverCnt + 1;
                    end
                end
            end
        end
        
        if nPacketSize == nMapMsgSize    % For Map message transmission
          %  nMapMsgCount = nMapMsgCount + 1;

          %  if nNeighCnt == 0
          %      mMapMsgPRR(nMapMsgCount,1)=0;
          %  else
          %      mMapMsgPRR(nMapMsgCount,1)=1.0*nReceiverCnt/nNeighCnt;            
          %  end        
        else   % For Image transmission
            if curTargetCount == 0
                % Not counted in
            else
                nImgMsgCount = nImgMsgCount + 1;
                mImgMsgPRR(nImgMsgCount,1)=1.0*nReceiverCnt/curTargetCount;            
            end
        end
        
    end
    
    curTargetImgCount = curTargetImgCount - 1;
    if curTargetImgCount == 0
        nTargetRowIdx = nTargetRowIdx + 1;
        curTargetSender = mTargetList(nTargetRowIdx, 1);
        curTargetSenderTime = mTargetList(nTargetRowIdx, 2);
        curTargetImgCount = mTargetList(nTargetRowIdx, 3);
        curTargetCount = mTargetList(nTargetRowIdx, 4);
    end
    
end

if nMapMsgCount > 0
    avgMapMsgPRR = mean(mMapMsgPRR);
else
    avgMapMsgPRR = 0;
end

if nImgMsgCount > 0
    avgImgMsgPRR = mean(mImgMsgPRR);
else
    avgImgMsgPRR = 0;
end

f = [avgImgMsgPRR avgMapMsgPRR]

return;
