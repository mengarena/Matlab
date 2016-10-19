function f=Sky_AverageNodeNumber_Total_Neigh()
% This function calcuate the overall number of neighbors
%

mTransRange = [60 80 100 120 150 200];
mPacketSize = [5 10 15 20 25 30 35 40 45];

nRangeCount = length(mTransRange);
nSizeCount = length(mPacketSize);

mAvgNodeNum = [];   % Row is trans range; Col is packet size

%sInputFilePre = 'E:\\USC_Project\\SkyEye\\Simulation\\Sim_output\\Straight\\Straight_NeighborList_Trans\\aligned\\Straigh_Neighbor';
%sInputFilePre = 'E:\\USC_Project\\SkyEye\\Simulation\\Sim_output\\Straight\\Straight_NeighborList_NoTrans\\aligned\\Straigh_Neighbor';
%sInputFilePre = 'E:\\USC_Project\\SkyEye\\Simulation\\Sim_output\\Dense40_20\\Dense_40_20_NeighborList_Trans\\aligned\\Dense_Neighbor';
sInputFilePre = 'E:\\USC_Project\\SkyEye\\Simulation\\Sim_output\\Dense40_20\\Dense_40_20_NeighborList_NoTrans\\aligned\\Dense_Neighbor';

for i=1:nRangeCount
    nRange = mTransRange(1,i);
    
    for j=1:nSizeCount
        nSize = mPacketSize(1,j);

        sInputFile = sprintf('%s_%s_%s_1.csv', sInputFilePre, num2str(nRange), num2str(nSize));    % Input file name
        
        mNodeList = load(sInputFile);
        
        fAvgNodeNum = Sky_AverageNodeNumber(mNodeList);
        
        mAvgNodeNum(i,j) = fAvgNodeNum;
    end
end
        
%figure(1);
figure('numbertitle', 'off', 'name', 'Average # Neighbors');
bar(mAvgNodeNum);
XTickTxt = {'60m'; '80m'; '100m'; '120m'; '150m'; '200m'};
set(gca, 'FontSize', 14)
set(gca, 'XTickLabel', XTickTxt);
title(gca, 'Number of Neighbors (Dense Mode, No Trans)');
legend('5KB', '10KB','15KB', '20KB', '25KB', '30KB', '35KB', '40KB', '45KB');
xlabel('Transmission Range', 'FontSize', 18);
ylabel('Number of Neighbors', 'FontSize', 18);

return;


