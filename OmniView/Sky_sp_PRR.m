function f = Sky_sp_PRR(mNeighList, mReceiverList)
% This function measure the Packet Receive Rate
%
% mNeighList: This is the matrix of neighbor list (i.e. the list of the node who should receive the packet) for the senders
% mReceiverList: This is the node list who actually receives the packet
%
% Neighbor node ID starts from 3rd column in mNeighList
% Receiver node ID starts from 4th column in the mReceiverList
% 
% Result: A mean number of the Packet Receive Rate
%

format long;

[nNeighRow nNeighCol] = size(mNeighList);
[nReceiverRow nReceiverCol] = size(mReceiverList);

if nNeighRow ~= nReceiverRow
    f = 0;
    return;
end

nMapMsgSize = 256;  % Map message size

mImgPRR = [];
mMapMsgPRR = [];

nImgCount = 0;
nMapMsgCount = 0;

for i=1:nNeighRow
    hostNeigh = mNeighList(i, 1);
    tmNeigh = mNeighList(i, 2);

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
            nImgCount = nImgCount + 1;

            if nNeighCnt == 0
                mImgPRR(nImgCount,1)=0;
            else
                mImgPRR(nImgCount,1)=1.0*nReceiverCnt/nNeighCnt;            
            end
        end
        
    end
    
end

if nMapMsgCount > 0
    avgMapMsgPRR = mean(mMapMsgPRR);
else
    avgMapMsgPRR = 0;
end

if nImgCount > 0
    avgImgPRR = mean(mImgPRR);
else
    avgImgPRR = 0;
end

f = [avgImgPRR avgMapMsgPRR];

return;
