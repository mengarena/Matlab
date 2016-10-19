function f=VT_RcvEventStats(mAlignedRcvList, totalTime, nodeCnt)
% This function calculate the statistics of the number of receiving event of each node 
%
% Parameter:
% mAlignedRcvList is the aligned Receiver List file, each line contains:
% Send/Receive, packet size, timestamp, node ID, packet ID, source address
%

format long;

nMapMsgSize = 512;  % Map message size

[rowNum colNum] = size(mAlignedRcvList);

%totalTime = mProcessedTrace(rowNum, 2) - mProcessedTrace(1, 2);

%nodeCnt = max(mProcessedTrace(:,3))+1;  % nodeID start from 0

mNodeRcvEventCnt = [];  % Store #receive event for each node 
mRcvEventTimesInS = []; % Average #receive event/s

for j=1:nodeCnt
    mNodeRcvEventCnt(1, j) = 0;
    mRcvEventTimesInS(1, j) = 0.0;
end

for i=1:rowNum
    nPacketSize = mAlignedRcvList(i,2);
    if nPacketSize ~= nMapMsgSize  % Only calculate for Image Reception event
        for j=4:colNum   % Receiver Node ID
            if mAlignedRcvList(i,j) == -1
                break;
            else
                nodeID = mAlignedRcvList(i,j);
                nIdx = nodeID + 1;  % nodeID starts from 0; Index starts from 1
                mNodeRcvEventCnt(1, nIdx) = mNodeRcvEventCnt(1, nIdx) + 1; 
            end
        end
    end
end


for k=1:nodeCnt
    mRcvEventTimesInS(1, k) = mNodeRcvEventCnt(1, k)*1.0/totalTime;
end

f = mRcvEventTimesInS;

return;
