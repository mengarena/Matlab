function f = Sky_sp_PermEval_sub(mTrace, bDense, nRange, nImgSize, nSmallPktSize, fRcvTimeGap)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function evaluate the performance of the trace based on the trace
% matrix.
% 1) At this moment, it calcuates the time delay for the image receiving.
% 2) Also calculate the receiver list for each image sending event
% In the receiver list file (.csv), the following information is contained:
% HostNodeID, Timestamp, Receiver1, Receiver2....
%
% The receivers in the final receiver list are the nodes which receives all
% the small packets of an image, called common receivers
%
% Delay is also caculated based on the common receivers. For each
% sender-receiver pair, the delay the time between the moment the first packet sent
% out and the time when the last packet is received by a receiver
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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

nFixedImgCnt = 0;

mImgTranstime = [];  % Store Image transmission time
nImgIndex = 0;       % Image index

nSmallPktCount = nImgSize/nSmallPktSize;   % How many small packets each image has

[nRow nCol] = size(mTrace);

format long;

if fRcvTimeGap >= 999.0    % WITHOUT time constraint
    % File stores the receiver list
    if bDense == 1
        sOutputFilePre = 'C:\\cygwin\\home\\ar\\ns-allinone-2.34\\ns-2.34\\Dense_sp_ReceiverList_NoTmCnst\\Dense_Receiver';
    else
        sOutputFilePre = 'C:\\cygwin\\home\\ar\\ns-allinone-2.34\\ns-2.34\\Sparse_sp_ReceiverList_NoTmCnst\\Sparse_Receiver';        
    end
else
    if bDense == 1
        sOutputFilePre = 'C:\\cygwin\\home\\ar\\ns-allinone-2.34\\ns-2.34\\Dense_sp_ReceiverList_TmCnst\\Dense_Receiver';
    else
        sOutputFilePre = 'C:\\cygwin\\home\\ar\\ns-allinone-2.34\\ns-2.34\\Sparse_sp_ReceiverList_TmCnst\\Sparse_Receiver';        
    end
end

sOutputFile = sprintf('%s_%s_%s_%s_%s.csv', sOutputFilePre, num2str(nRange), num2str(nSmallPktSize), num2str(nSmallPktCount), num2str(nFixedImgCnt));

fid_result = fopen(sOutputFile,'w');

nSmallPktIndex = 0;
fFirstSmallPktTimestamp = 0.0;
nFirstSmallPktId = -1;
nCurrentSenderNodeId = -1;

for i=1:nRow
    nEventTypeS = mTrace(i, 1);
    fTimestampS = mTrace(i, 2);   % Sender time
    nNodeIdS = mTrace(i, 3);
    nPacketIdS = mTrace(i, 4);
    nSourceIdS = mTrace(i, 5);
    
    if nEventTypeS == 1    % Send event
        
        nSmallPktIndex = nSmallPktIndex + 1;  % Xth small packet of an image

        if nSmallPktIndex == 1   % Only do this for the first small packet of an image
            fFirstSmallPktTimestamp = fTimestampS;
            nFirstSmallPktId = nPacketIdS;
            nCurrentSenderNodeId = nNodeIdS;
            fprintf(fid_result,'%d,%.9f,', nNodeIdS, fTimestampS);   % Sender Host ID, Timestamp
        end
    
        rcvMatArr{nSmallPktIndex} = [];    % Store receiver list for the Xth small packet of an image
        
        nReceiverCnt = 0;
        
        % This 'for' is used to search the receiver for this send event
        for j=i+1:nRow
            nEventTypeT = mTrace(j, 1);
            if nEventTypeT == 1   % Not the receiving event, just ignore
                continue;
            end

            fTimestampT = mTrace(j, 2);   % Receiving time
            %fTransTime = fTimestampT - fTimestampS;
            fTransTime = fTimestampT - fFirstSmallPktTimestamp;
            
            if fTransTime > fRcvTimeGap   % Packet received within time gap
                % All the time of the record are sorted in asc order, if
                % current is bigger than the time gap, all latter will even
                % big, no need to continue
                break;
            end
               
            nNodeIdT = mTrace(j, 3);
            nPacketIdT = mTrace(j, 4);
            nSourceIdT = mTrace(j, 5);
           
            if nEventTypeT == 0 && nPacketIdS == nPacketIdT && nNodeIdS == nSourceIdT  % A Receiver
                
                %nIndex = nIndex + 1;
                %mTranstime(nIndex, 1) = fTransTime;
                
                %fprintf(fid_result,'%d,',nNodeIdT);   % Receiver Node ID
                nReceiverCnt = nReceiverCnt + 1;
                rcvMatArr{nSmallPktIndex}(1, nReceiverCnt) = nNodeIdT;
            end
        end   %for
        
        %fprintf(fid_result,'\n');
    
    end  % for 'if nEventTypeS == 1'  
   
    if nSmallPktIndex == nSmallPktCount   % The receiver searching for an image's sending is complete
        % Here below, 1) get the common receiver list for all the small
        % packets of the same image
        % rcvCommon stores the common receiver list
        rcvCommon = rcvMatArr{1};
        
        for k=2:nSmallPktCount
            rcvCommon = intersect(rcvCommon, rcvMatArr{k});
        end
        
        [rRcv cRcv] = size(rcvCommon);
        
        % Save the common receiver list into the receiver list file
        for m=1:cRcv
            fprintf(fid_result,'%d,',rcvCommon(1,m));   % Receiver Node ID
        end
        
        fprintf(fid_result,'\n');

        % Here below calculate the delay for the common receivers
        if cRcv >= 1   % Common receiver exists, i.e. some node receives all the small packets of an image
            % Calculate the delay between sender-receiver pairs (searching
            % the time when the last packet is received at a receiver, then
            % get the time between the first packet is sent out and the
            % time the last small packet of an image is received by a
            % receiver
            nLastPktId = nFirstSmallPktId + nSmallPktCount -1;
            
            for s=1:cRcv
                for ss=i+1:nRow       
                   if mTrace(ss,1) == 0 && mTrace(ss,3) == rcvCommon(1,s) && mTrace(ss,4) == nLastPktId && mTrace(ss,5) == nCurrentSenderNodeId 
                      nImgIndex = nImgIndex + 1;
                      mImgTranstime(nImgIndex,1) = mTrace(ss,2) - fFirstSmallPktTimestamp;  % Delay of an image
                      break;
                   end
                end
            end
        end
        
        % Reset
        nSmallPktIndex = 0;
        fFirstSmallPktTimestamp = 0.0;
        nFirstSmallPktId = -1;
        nCurrentSenderNodeId = -1;
        rcvCommon = [];
        for t=1:nSmallPktCount
            rcvMatArr{t} = [];
        end
    end
    
end   % for i=1:nRow

fclose(fid_result);

avgTransTime = mean(mTranstime);
stdTransTime = std(mTranstime);
maxTransTime = max(mTranstime);
minTransTime = min(mTranstime);

f = [avgTransTime stdTransTime maxTransTime minTransTime];

return;