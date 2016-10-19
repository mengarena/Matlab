function f = Sky_sp_PermEval_D_sub(mTrace, nRange, nImgSize, nSmallPktSize, fRcvTimeGap)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function evaluate the performance of the trace based on the trace
% matrix.
% 1) At this moment, it calcuates the time delay for the packet receiving.
% 2) Also statistics the receiver list for each sender at each moment
% In the receiver list file (.csv), the following information is contained:
% HostNodeID, Timestamp, Receiver1, Receiver2....
%
% Parameter:
%   mTrace: The trace matrix; which has been processed
%           The mTraces looks like:
%                   1,185.000174539,90,0,90
%   nRange: Transmission range
%   nImgSize:   Image Size
%   nSmallPktSize: Small Packet size
%   fRcvTimeGap: Only the receiver receives this packet within tht time gap,
%   it will be considered as correctly received
%
%   From 'nImgSize' and 'nSmallPktSize', calculate how many packets each image has.
%   The sending from the 1st small packet and the last small packet of one
%   image is counted as the sending of one image.
%
%   A: [How to calculate Delay of each image ?]
%   Q: When one node sending out a group of small packets (belonging to the same image), 
%      at each receiver, 
%      the time between the first packet is sent out at the sender and the last packet is received at this receiver,
%      is counted as the transmission time of the image between this sender
%      and this receiver; 
%      All this kind of transmission time is recorded into an array, which
%      will later be processed to get the mean transmission time and
%      variance.
%      [*] The receiver here must receive all the small packets of an
%      image.
%
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

nSmallPktCount = nImgSize/nSmallPktSize;   % How many small packets each image has

[nRow nCol] = size(mTrace);

format long;


if fRcvTimeGap >= 999.0    % WITHOUT time constraint
    sOutputFilePre = 'E:\\SkyEye_Backup20130801\\Simulation\\Sim_output\\Dense_sp_ReceiverList_NoTmCnst\\Dense_Receiver';
else
    sOutputFilePre = 'E:\\SkyEye_Backup20130801\\Simulation\\Sim_output\\Dense_sp_ReceiverList_TmCnst\\Dense_Receiver';
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