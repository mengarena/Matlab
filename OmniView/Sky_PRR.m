function f = Sky_PRR(mNeighList, mReceiverList)
% This function measure the Packet Receive Rate
%
% mNeighList: This is the matrix of neighbor list (i.e. the list of the node who should receive the packet) for the senders
% mReceiverList: This is the node list who actually receives the packet
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

mPRR = [];

nCount = 0;

for i=1:nNeighRow
    hostNeigh = mNeighList(i, 1);
    tmNeigh = mNeighList(i, 2);

    hostReceiver = mReceiverList(i, 1);
    tmReceiver = mReceiverList(i, 2);
        
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
        for k=3:nReceiverCol
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
        
        nCount = nCount + 1;
        
        if nNeighCnt == 0
            mPRR(nCount,1)=0;
        else
            mPRR(nCount,1)=1.0*nReceiverCnt/nNeighCnt;            
        end
        
    end
    
end

if nCount > 0
    avgPRR = mean(mPRR);
else
    avgPRR = 0;
end

f = avgPRR;

return;
