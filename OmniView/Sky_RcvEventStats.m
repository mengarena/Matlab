function f=Sky_RcvEventStats(mProcessedTrace)
% This function calculate the statistics of the number of receiving event of each node 
%
% Parameter:
% mProcessedTrace is the processed trace file, each line contains:
% Send/Receive, timestamp, node ID, packet ID, source address
%

format long;

[rowNum colNum] = size(mProcessedTrace);

totalTime = mProcessedTrace(rowNum, 2) - mProcessedTrace(1, 2);

nodeCnt = max(mProcessedTrace(:,3))+1;  % nodeID start from 0

mNodeRcvEventCnt = [];
mRcvEventTimesInS = [];
for j=1:nodeCnt
    mNodeRcvEventCnt(1, j) = 0;
    mRcvEventTimesInS(1, j) = 0.0;
end

for i=1:rowNum
    if mProcessedTrace(i,1) == 0 % Receiving event
        nIndex = mProcessedTrace(i,3)+1;
        mNodeRcvEventCnt(1, nIndex) = mNodeRcvEventCnt(1, nIndex) + 1;
    end
end

for k=1:nodeCnt
    mRcvEventTimesInS(1, k) = mNodeRcvEventCnt(1, k)*1.0/totalTime;
end
