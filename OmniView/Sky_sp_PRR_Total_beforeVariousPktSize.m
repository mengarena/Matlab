function f = Sky_sp_PRR_Total(bDense)
% This function measure Packet Receiver Rate for all the trace event
% The processed two categories of files: Neighbor List and Receiver List
%
% The Neighbor List contains the one-hop neighbor list (corresponding to
% the transmission range) of sender at each timestamp
%
% The Receiver List contains the receiver list (which actually receives the
% packet sent by the sender at that timestamp)
%
% Result is saved into a csv file, each line contains:
%       Trans range, packet size, Modulation scheme, PRR
%

fprintf('Start Time: %s\n', datestr(clock, 'yyyy-mm-dd HH:MM:SS'));

mTransRange = [60 80 100];  % Meter
mImgSize = [10 12 14 16 18];  % KB
mSmallPktSize = [512 1024 2048];  %B

%bDense = 1;

nFixedImgCnt = 0;   % Count of image is not fixed
fRcvTimeGap = 0.5;

nRangeCount = length(mTransRange);
nImgSizeCount = length(mImgSize);
nSmallPktSizeCount = length(mSmallPktSize);

format long;

if bDense == 0
    %%%% Sparse Mode
    sNeighFilePre = 'C:\\cygwin\\home\\ar\\ns-allinone-2.34\\ns-2.34\\Sparse_sp_NeighborList_Trans\\aligned\\Sparse_Neighbor';
    %sNeighFilePre = 'C:\\cygwin\\home\\ar\\ns-allinone-2.34\\ns-2.34\\Sparse_sp_NeighborList_NoTrans\\aligned\\Sparse_Neighbor';
    sReceiverFilePre = 'C:\\cygwin\\home\\ar\\ns-allinone-2.34\\ns-2.34\\Sparse_sp_ReceiverList_TmCnst\\aligned\\Sparse_Receiver';

else
    %%%% Dense Mode
    sNeighFilePre = 'C:\\cygwin\\home\\ar\\ns-allinone-2.34\\ns-2.34\\Dense_sp_NeighborList_Trans\\aligned\\Dense_Neighbor';
    %sNeighFilePre = 'C:\\cygwin\\home\\ar\\ns-allinone-2.34\\ns-2.34\\Dense_sp_NeighborList_NoTrans\\aligned\\Dense_Neighbor';
    sReceiverFilePre = 'C:\\cygwin\\home\\ar\\ns-allinone-2.34\\ns-2.34\\Dense_sp_ReceiverList_TmCnst\\aligned\\Dense_Receiver';
end

mPRR = [];  % nRangeCount X nSizeCount

for i=1:nRangeCount
    mPRR{i} = [];
    
    nRange = mTransRange(1,i);
    
    for j=1:nImgSizeCount
        nImgSize = mImgSize(1,j);
        
        for k=1:nSmallPktSizeCount
            nSmallPktSize = mSmallPktSize(1,k);
            nSmallPktCnt = nImgSize*1024/nSmallPktSize;

            sNeighFile = sprintf('%s_%s_%s_%s_%s.csv', sNeighFilePre, num2str(nRange), num2str(nSmallPktSize), num2str(nSmallPktCnt), num2str(nFixedImgCnt));    % Neigh file name
            sReceiverFile = sprintf('%s_%s_%s_%s_%s.csv', sReceiverFilePre, num2str(nRange), num2str(nSmallPktSize), num2str(nSmallPktCnt), num2str(nFixedImgCnt));    % Receiver file name

            mNeigh = load(sNeighFile);
            mReceiver = load(sReceiverFile);

            fPRR = Sky_PRR(mNeigh, mReceiver);

            mPRR{i}(j,k) = fPRR * 100;
            
        end
    end
end


if bDense == 1
    figure('numbertitle', 'off', 'name', 'Packet Reception Rate (Dense, Non-Fixed Image Count, Time Constraint, Trans)');
else
    figure('numbertitle', 'off', 'name', 'Packet Reception Rate (Sparse, Non-Fixed Image Count, Time Constraint, Trans)');
end

for i=1:nRangeCount
    subplot(1,3,i);
    bar(mPRR{i});
    
    XTickTxt = {'10'; '12'; '14'; '16'; '18'};

    set(gca, 'FontSize', 20)
    set(gca, 'FontName','Times New Roman');
    set(gca, 'XTickLabel', XTickTxt);
    set(gca,'YTick',0:5:100);
    
    if i == 2
        if bDense == 0
            title(gca, 'Packet Reception Rate (Sparse Mode, Data Rate: 6 Mbps)');
        else
            title(gca, 'Packet Reception Rate (Dense Mode, Data Rate: 6 Mbps)');        
        end

        legend('512B','1024B','2048B');
    end
    
    xlabelStr = strcat('Range:', num2str(mTransRange(1,i)), '(m) Image Size(KB)');
    xlabel(xlabelStr, 'FontSize', 24);
    ylabel('Packet Reception Rate (%)', 'FontSize', 24);
    set(gca,'ygrid','on');
    ylim([0 100]);
end

fprintf('End Time: %s\n', datestr(clock, 'yyyy-mm-dd HH:MM:SS'));

f=0;

return;
