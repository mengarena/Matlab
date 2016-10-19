function f = VT_PRR_Total(nHighWay, bDense, fEndTime)
% This function measure Packet Receiver Rate for all the trace event
% The processed two categories of files: Neighbor List and Receiver List
%
% The Neighbor List contains the one-hop neighbor list (corresponding to
% the transmission range) of sender at each timestamp
%
% The Receiver List contains the receiver list (which actually receives the
% packet sent by the sender at that timestamp)
%
% Parameter:
%   bDense:  1, Dense mode;  0, Sparse mode
%   fEndTime: Only calculate to the sending event before this time. (Because the trace is
%   terminated at the end, so some transmission is terminated, should
%   should be excluded from the statistics.)
%   
% Result is saved into a csv file, each line contains:
%       Trans range, packet size, Modulation scheme, PRR
%

fprintf('Start Time: %s\n', datestr(clock, 'yyyy-mm-dd HH:MM:SS'));

if nHighWay == 1
    mTransRange = [60 80 100];  % Meter
else
    mTransRange = [40 60 80];  % Meter    
end
%mImgSize = [10 12 14 16 18];  % KB
%mImgSize = [1 2 4 6 8 10 12 14];  % KB

mImgSize = [10 12 14 16 18];  % KB

%mSmallPktSize = [512 1024 2048];  %B
%mSmallPktSize = [1024 2048];  %B
mSmallPktSize = [1024];  %B

%bDense = 1;

nFixedImgCnt = 0;   % Count of image is not fixed

nRangeCount = length(mTransRange);
nImgSizeCount = length(mImgSize);
nSmallPktSizeCount = length(mSmallPktSize);

%nHighWay = 1;   % = 0, city

format long;

if nHighWay == 1
    sPlace = 'E:\\VT_Highway_Output\\Meng_NonFixedImgCnt\\';
else
    sPlace = 'E:\\VT_City_Output\\Meng_NonFixedImgCnt\\';
end

if bDense == 0
    %%%% Sparse Mode
    sNeighFilePre = 'Sparse_sp_NeighborList_Trans\\aligned\\Sparse_Neighbor';
    %sNeighFilePre = 'Sparse_sp_NeighborList_NoTrans\\aligned\\Sparse_Neighbor';
    sReceiverFilePre = 'Sparse_sp_ReceiverList_TmCnst\\aligned\\Sparse_Receiver';
    
    sPRR_TotalFile = 'PRR_Data\\Sparse_PRR.csv';

    %%[Begin] New added here
    sTargetListPre = 'Sparse_sp_TargetList\\Sparse_Target';
    %%[End]

else
    %%%% Dense Mode
    sNeighFilePre = 'Dense_sp_NeighborList_Trans\\aligned\\Dense_Neighbor';
    %sNeighFilePre = 'Dense_sp_NeighborList_NoTrans\\aligned\\Dense_Neighbor';
    sReceiverFilePre = 'Dense_sp_ReceiverList_TmCnst\\aligned\\Dense_Receiver';
  
    %%[Begin] New added here
    sTargetListPre = 'Dense_sp_TargetList\\Dense_Target';
    %%[End]
  
    sPRR_TotalFile = 'PRR_Data\\Dense_PRR.csv';
      
end


sPRRFile = sprintf('%s%s', sPlace, sPRR_TotalFile);    % Neigh file name

fid_result = fopen(sPRRFile,'w');

mImgMsgPRR = [];  % nRangeCount X nSizeCount
mMapMsgPRR = [];  % nRangeCount X nSizeCount

for i=1:nRangeCount
%    mImgMsgPRR{i} = [];
%    mMapMsgPRR{i} = [];
%    mImgMsgPRR = [];
%    mMapMsgPRR = [];
    
    nRange = mTransRange(1,i);
    
    for j=1:nImgSizeCount
        nImgSize = mImgSize(1,j);
        
      %  for k=1:nSmallPktSizeCount
%            nSmallPktSize = mSmallPktSize(1,k);
            nSmallPktSize = mSmallPktSize(1,1);

            nSmallPktCnt = nImgSize*1024/nSmallPktSize;

            sNeighFile = sprintf('%s%s_%s_%s_%s_%s.csv', sPlace, sNeighFilePre, num2str(nRange), num2str(nSmallPktSize), num2str(nSmallPktCnt), num2str(nFixedImgCnt));    % Neigh file name
            sReceiverFile = sprintf('%s%s_%s_%s_%s_%s.csv', sPlace, sReceiverFilePre, num2str(nRange), num2str(nSmallPktSize), num2str(nSmallPktCnt), num2str(nFixedImgCnt));    % Receiver file name

            %%[Begin] New added here
            sFileNameTargetList = sprintf('%s%s_%s_%s_%s_%s.csv', sPlace, sTargetListPre, num2str(nRange), num2str(nSmallPktSize), num2str(nSmallPktCnt),num2str(nFixedImgCnt));
            mTargetList = load(sFileNameTargetList);
            %%[End]

            mNeigh = load(sNeighFile);
            mReceiver = load(sReceiverFile);

%Original            mPRR = VT_PRR(mNeigh, mReceiver, fEndTime)
            mPRR = VT_PRR_fromTargetList(mTargetList, mReceiver, fEndTime)

            if mPRR == 0
%                mImgMsgPRR{i}(j,k) = 0;
%                mMapMsgPRR{i}(j,k) = 0;
                mImgMsgPRR(i,j) = 0;
                mMapMsgPRR(i,j) = 0;

            else
%                mImgMsgPRR{i}(j,k) = mPRR(1,1) * 100;
%                mMapMsgPRR{i}(j,k) = mPRR(1,2) * 100;
                mImgMsgPRR(i,j) = mPRR(1,1) * 100;
                mMapMsgPRR(i,j) = mPRR(1,2) * 100;

            end
            
            fprintf(fid_result,'%d,%d,%f,%f\n',nRange, nImgSize, mImgMsgPRR(i,j), mMapMsgPRR(i,j));

     %   end
    end
end

fclose(fid_result);

return;



% Plot for Image Message Reception Rate
if bDense == 1
    figure('numbertitle', 'off', 'name', 'Image Message Reception Rate (Dense, Non-Fixed Image Count, Time Constraint, Trans)');
else
    figure('numbertitle', 'off', 'name', 'Image Message Reception Rate (Sparse, Non-Fixed Image Count, Time Constraint, Trans)');
end

%for i=1:nRangeCount
%    subplot(1,3,i);
%    bar(mImgMsgPRR{i});
    bar(mImgMsgPRR);
    
%    XTickTxt = {'10'; '12'; '14'; '16'; '18'};
%    XTickTxt = {'10'; '12'; '14'};
    XTickTxt = {'60'; '80'; '100'};

    set(gca, 'FontSize', 20)
    set(gca, 'FontName','Times New Roman');
    set(gca, 'XTickLabel', XTickTxt);
    set(gca,'YTick',0:5:100);
    
    %if i == 2
        if bDense == 0
%            title(gca, 'Image Message Reception Rate (Sparse Mode, Data Rate: 6 Mbps)');
            title(gca, 'Image Message Reception Rate (Sparse Mode)');

        else
%            title(gca, 'Image Message Reception Rate (Dense Mode, Data Rate: 6 Mbps)');        
            title(gca, 'Image Message Reception Rate (Dense Mode)');        

        end

%        legend('512B','1024B','2048B');
%        legend('1024B','2048B');

    %end
    legend('10 KB','12 KB', '14 KB', '16 KB', '18 KB');
%    legend('1 KB','2 KB', '4 KB', '6 KB', '8 KB');
    
   % xlabelStr = strcat('Range:', num2str(mTransRange(1,i)), '(m) Image Size(KB)');
%    xlabelStr = strcat('Image Size(KB)', '[Range:', num2str(mTransRange(1,i)), 'm]');
    xlabelStr = 'Transmission Range (m)';

    xlabel(xlabelStr, 'FontSize', 24);
    ylabel('Reception Rate (%)', 'FontSize', 24);
    set(gca,'ygrid','on');
    ylim([0 100]);
%end



% Plot for Map Message Reception Rate
if bDense == 1
    figure('numbertitle', 'off', 'name', 'Map Message Reception Rate (Dense, Non-Fixed Image Count, Time Constraint, Trans)');
else
    figure('numbertitle', 'off', 'name', 'Map Message Reception Rate (Sparse, Non-Fixed Image Count, Time Constraint, Trans)');
end

%for i=1:nRangeCount
%    subplot(1,3,i);
%    bar(mMapMsgPRR{i});
    bar(mMapMsgPRR);
    
%    XTickTxt = {'10'; '12'; '14'; '16'; '18'};
%    XTickTxt = {'10'; '12'; '14'};
    XTickTxt = {'60'; '80'; '100'};

    set(gca, 'FontSize', 20)
    set(gca, 'FontName','Times New Roman');
    set(gca, 'XTickLabel', XTickTxt);
    set(gca,'YTick',0:5:100);
    
%    if i == 2
        if bDense == 0
%            title(gca, 'Map Message Reception Rate (Sparse Mode, Data Rate: 6 Mbps)');
            title(gca, 'Map Message Reception Rate (Sparse Mode)');

        else
%            title(gca, 'Map Message Reception Rate (Dense Mode, Data Rate: 6 Mbps)');        
            title(gca, 'Map Message Reception Rate (Dense Mode)');        

        end

%        legend('512B','1024B','2048B');
%        legend('1024B','2048B');
%    end
    legend('10 KB','12 KB', '14 KB', '16 KB', '18 KB');
%    legend('1 KB','2 KB', '4 KB', '6 KB', '8 KB');
    
%    xlabelStr = strcat('Image Size(KB)', '[Range:', num2str(mTransRange(1,i)), 'm]');
    xlabelStr = 'Transmission Range (m)';
    
    xlabel(xlabelStr, 'FontSize', 24);
    ylabel('Reception Rate (%)', 'FontSize', 24);
    set(gca,'ygrid','on');
    ylim([0 100]);
%end


fprintf('End Time: %s\n', datestr(clock, 'yyyy-mm-dd HH:MM:SS'));

f=0;

return;
