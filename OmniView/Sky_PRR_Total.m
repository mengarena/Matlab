function f = Sky_PRR_Total()
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

nModulScheme = 1;

%mTransRange = [60 80 100 120 150 200];
%mPacketSize = [5 10 15 20 25 30 35 40 45];
mTransRange = [60 80 100];
mPacketSize = [10 15];

nRangeCount = length(mTransRange);
nSizeCount = length(mPacketSize);

format long;

%%%% Sparse Mode (Straight)
sNeighFilePre = 'E:\\USC_Project\\SkyEye\\Simulation\\Sim_output_PBC_1.0_0.5\\Straight\\Straight_NeighborList_Trans\\aligned\\Straigh_Neighbor';
%sNeighFilePre = 'E:\\USC_Project\\SkyEye\\Simulation\\Sim_output_PBC_1.0_0.5\\Straight\\Straight_NeighborList_NoTrans\\aligned\\Straigh_Neighbor';
sReceiverFilePre = 'E:\\USC_Project\\SkyEye\\Simulation\\Sim_output_PBC_1.0_0.5\\Straight\\Straight_ReceiverList_TmCnst\\aligned\\Straight_Receiver';


%%%% Dense Mode (Dense_40_20)
%sNeighFilePre = 'E:\\USC_Project\\SkyEye\\Simulation\\Sim_output_PBC_1.0_0.5\\Dense40_20\\Dense_40_20_NeighborList_Trans\\aligned\\Dense_Neighbor';
%sNeighFilePre = 'E:\\USC_Project\\SkyEye\\Simulation\\Sim_output_PBC_1.0_0.5\\Dense40_20\\Dense_40_20_NeighborList_NoTrans\\aligned\\Dense_Neighbor';
%sReceiverFilePre = 'E:\\USC_Project\\SkyEye\\Simulation\\Sim_output_PBC_1.0_0.5\\Dense40_20\\Dense_40_20_ReceiverList_TmCnst\\aligned\\Dense_Receiver';

mPRR = [];  % nRangeCount X nSizeCount

for i=1:nRangeCount
    nRange = mTransRange(1,i);
    
    for j=1:nSizeCount
        nSize = mPacketSize(1,j);

        sNeighFile = sprintf('%s_%s_%s_1.csv', sNeighFilePre, num2str(nRange), num2str(nSize));    % Neigh file name
        sReceiverFile = sprintf('%s_%s_%s_1_sub.csv', sReceiverFilePre, num2str(nRange), num2str(nSize));    % Receiver file name
        
        mNeigh = load(sNeighFile);
        mReceiver = load(sReceiverFile);
        
        fPRR = Sky_PRR(mNeigh, mReceiver);
        
        mPRR(i,j) = fPRR * 100;
        
    end
end

figure('numbertitle', 'off', 'name', 'Packet Reception Rate (NeighWithNoTrans-ReceiverWithTimeConstraint)');
bar(mPRR);
%XTickTxt = {'60m'; '80m'; '100m'; '120m'; '150m'; '200m'};
XTickTxt = {'60m'; '80m'; '100m'};

set(gca, 'FontSize', 20)
set(gca, 'FontName','Times New Roman');
set(gca, 'XTickLabel', XTickTxt);
title(gca, 'Packet Reception Rate (Sparse Mode, Data Rate: 6 Mbps)');
%legend('5KB', '10KB','15KB', '20KB', '25KB', '30KB', '35KB', '40KB', '45KB');
legend('10KB','15KB');
xlabel('Transmission Range', 'FontSize', 24);
ylabel('Packet Reception Rate (%)', 'FontSize', 24);
set(gca,'ygrid','on');

f=0;

return;
