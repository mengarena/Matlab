function f = Sky_PermEval_S_sub(mTrace, nRange, nPacketSize, fRcvTimeGap)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function evaluate the performance of the trace based on the trace
% matrix.
% At this moment, it calcuates the time delay for the packet receiving.
%
% Also statistics the receiver list for each sender at each moment
% In the receiver list file (.csv), the following information is contained:
% HostNodeID, Timestamp, Receiver1, Receiver2....
%
% Parameter:
%   mTrace: The trace matrix; which has been processed
%           The mTraces looks like:
%                   1,185.000174539,90,0,90
%   nRange: Transmission range
%   nPacketSize: Packet size
%   nTransSpeed: Transmission speed
%   fRcvTimeGap: Only the receiver receives this packet within tht time gap,
%   it will be considered as correctly received
%
% The fields are:
%   1st:    Event type (1---send;  0---receive)
%   2nd:    Timestamp
%   3rd:    Node ID
%   4th:    Packet ID
%   5th:    Sender address
%
% Return:
%   Average/Std/Max/Min transmission time
%
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

mTranstime = [];
nIndex = 0;

[nRow nCol] = size(mTrace);

format long;

if fRcvTimeGap >= 999.0    % WITHOUT time constraint
    sOutputFilePre = 'E:\\SkyEye_Backup20130801\\Simulation\\Sim_output\\Straight_ReceiverList_NoTmCnst\\Straight_Receiver';
else
    sOutputFilePre = 'E:\\SkyEye_Backup20130801\\Simulation\\Sim_output\\Straight_ReceiverList_TmCnst\\Straight_Receiver';
end

sOutputFile = sprintf('%s_%s_%s_1_sub.csv', sOutputFilePre, num2str(nRange), num2str(nPacketSize));

fid_result = fopen(sOutputFile,'w');

for i=1:nRow
    nEventTypeS = mTrace(i, 1);
    fTimestampS = mTrace(i, 2);   % Sender time
    nNodeIdS = mTrace(i, 3);
    nPacketIdS = mTrace(i, 4);
    nSourceIdS = mTrace(i, 5);
    
    if nEventTypeS == 1    % Send
        
        fprintf(fid_result,'%d,%.9f,', nNodeIdS, fTimestampS);   % Host ID, Timestamp

        for j=i+1:nRow
            fTimestampT = mTrace(j, 2);   % Receiver time
            fTransTime = fTimestampT - fTimestampS;
            
            if fTransTime > fRcvTimeGap   % Packet received within time gap
                % All the time of the record are sorted in asc order, if
                % current is bigger than the time gap, all latter will even
                % big, no need to continue
                break;
            end

            nEventTypeT = mTrace(j, 1);
            nNodeIdT = mTrace(j, 3);
            nPacketIdT = mTrace(j, 4);
            nSourceIdT = mTrace(j, 5);
           
            if nEventTypeT == 0 && nPacketIdS == nPacketIdT && nNodeIdS == nSourceIdT
                
                nIndex = nIndex + 1;
                mTranstime(nIndex, 1) = fTransTime;
                
               % if fTransTime <= fRcvTimeGap   % Packet received within time gap
                fprintf(fid_result,'%d,',nNodeIdT);   % Receiver Node ID
               % end
            end
        end   %for
        
        fprintf(fid_result,'\n');
    
    end
   
end

fclose(fid_result);

avgTransTime = mean(mTranstime);
stdTransTime = std(mTranstime);
maxTransTime = max(mTranstime);
minTransTime = min(mTranstime);

f = [avgTransTime stdTransTime maxTransTime minTransTime];

return;