function f=Sky_AverageNodeNumber_Total_Receiver()
% This function calcuate the overall number of receiver
%

mTransRange = [60 80 100 120 150 200];
mPacketSize = [5 10 15 20 25 30 35 40 45];

nRangeCount = length(mTransRange);
nSizeCount = length(mPacketSize);

mAvgNodeNum = [];   % Row is trans range; Col is packet size

%sInputFilePre = 'E:\\USC_Project\\SkyEye\\Simulation\\Sim_output\\Straight\\Straight_ReceiverList_TmCnst\\aligned\\Straight_Receiver';
sInputFilePre = 'E:\\USC_Project\\SkyEye\\Simulation\\Sim_output\\Dense40_20\\Dense_40_20_ReceiverList_TmCnst\\aligned\\Dense_Receiver';

for i=1:nRangeCount
    nRange = mTransRange(1,i);
    
    for j=1:nSizeCount
        nSize = mPacketSize(1,j);

        sInputFile = sprintf('%s_%s_%s_1_sub.csv', sInputFilePre, num2str(nRange), num2str(nSize));    % Input file name
        
        mNodeList = load(sInputFile);
        
        fAvgNodeNum = Sky_AverageNodeNumber(mNodeList);
        
        mAvgNodeNum(i,j) = fAvgNodeNum;
    end
end
        
%figure(1);
figure('numbertitle', 'off', 'name', 'Average # Receivers');
bar(mAvgNodeNum);
XTickTxt = {'60m'; '80m'; '100m'; '120m'; '150m'; '200m'};
set(gca, 'FontSize', 14)
set(gca, 'XTickLabel', XTickTxt);
title(gca, 'Number of Receivers (Dense Mode, Packet lifetime=0.5s)');
legend('5KB', '10KB','15KB', '20KB', '25KB', '30KB', '35KB', '40KB', '45KB');
xlabel('Transmission Range', 'FontSize', 18);
ylabel('Number of Receivers', 'FontSize', 18);

return;


