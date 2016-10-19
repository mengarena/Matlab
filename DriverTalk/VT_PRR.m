function f = VT_PRR(mNeighList, mReceiverList, fEndTime)
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

[nNeighRow nNeighCol] = size(mNeighList);
[nReceiverRow nReceiverCol] = size(mReceiverList);

%if nNeighRow ~= nReceiverRow
%    f = 0;
%    return;
%end

nMyCnt = min(nNeighRow, nReceiverRow);

%fTmLast = mNeighList(nNeighRow, 2);   % The timestamp of the last trace record

%fLastValidTm = floor(fTmLast)*1.0 - fTimeIgnored;   % Last record in this time to be calculated

nMapMsgSize = 512;  % Map message size

mImgMsgPRR = [];
mMapMsgPRR = [];

nImgMsgCount = 0;
nMapMsgCount = 0;

%for i=1:nNeighRow
for i=1:nMyCnt

    hostNeigh = mNeighList(i, 1);
    tmNeigh = mNeighList(i, 2);
    
    if tmNeigh > fEndTime
        break;
    end

    hostReceiver = mReceiverList(i, 1);
%    tmReceiver = mReceiverList(i, 2);
    tmReceiver = mReceiverList(i, 3);
    
    nPacketSize = mReceiverList(i,2);
        
    if hostNeigh == hostReceiver && tmNeigh == tmReceiver
        nNeighCnt = 0;
        
        % Calculate #neighbors
        for j=3:nNeighCol
            if mNeighList(i, j) ~= -1
                nNeighCnt = nNeighCnt + 1;
            end
        end
        
        nReceiverCnt = 0;
        
        % Calculate #Valid receivers (i.e. the receiver should occur in the
        % neighbors list)
%        for k=3:nReceiverCol
        for k=4:nReceiverCol
            if mReceiverList(i,k) ~= -1
                for p=3:3+nNeighCnt-1
                    if mReceiverList(i,k) == mNeighList(i, p)
                        % Only the node exists in the neighbor list, it is
                        % considered valid for PRR calculation
                        nReceiverCnt = nReceiverCnt + 1;
                    end
                end
            end
        end
        
        if nPacketSize == nMapMsgSize    % For Map message transmission
            nMapMsgCount = nMapMsgCount + 1;

            if nNeighCnt == 0
                mMapMsgPRR(nMapMsgCount,1)=0;
            else
                mMapMsgPRR(nMapMsgCount,1)=1.0*nReceiverCnt/nNeighCnt;            
            end        
        else   % For Image transmission
            nImgMsgCount = nImgMsgCount + 1;

            if nNeighCnt == 0
                mImgMsgPRR(nImgMsgCount,1)=0;
            else
                mImgMsgPRR(nImgMsgCount,1)=1.0*nReceiverCnt/nNeighCnt;            
            end
        end
        
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
