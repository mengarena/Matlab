function f=Sky_sp_CalNetworkLoad(mProcessedTrace, fEndTime, fTailHeadDist, transRange)
% This function is used to calculate the network workload
%
% mProcessedTrace is the processed trace
% fDist is the total distance
% transRange is the transmission range
%
% Networkload = Bytes/Time/(Space/TransRange)
%

format long;

[nRow nCol] = size(mProcessedTrace);

%fTotalTime = mProcessedTrace(nRow, 2) - mProcessedTrace(1, 2);   % Total time

fTotalTime = fEndTime - 185.0;  % Seconds

fLoad = 0.0;
fTotalLoad = 0.0;

for i=1:nRow
    if mProcessedTrace(i,2) > fEndTime
        break;
    end
    
    if mProcessedTrace(i,1) == 1  % Sending event
        fTotalLoad = fTotalLoad + mProcessedTrace(i,5)*1.0/1024;   % Unit is KB
    end
end


fLoad = fTotalLoad/fTotalTime;
fLoad = fLoad/(fTailHeadDist/transRange);   % Unit is KB/s

f = fLoad;

return;
