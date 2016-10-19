function f=Sky_CommuDelay()
% This function measure and show the transmission delay for different
% transmission range and packet size
%

mTransRange = [60 80 100 120 150 200];
mPacketSize = [5 10 15 20 25 30 35 40 45];

nRangeCount = length(mTransRange);
nSizeCount = length(mPacketSize);

%In each inputfile, the records are stored in the order of 
% transmission range + packet size
%Each record contains:
%   Trans range, Packet size, Modulation scheme, Avg trans time, Std trans
%   time, Max trans time, Min trans time
%
%sInputFile = 'E:\\USC_Project\\SkyEye\\Simulation\\Sim_output_PBC_1.0_0.5\\Straight\\Straight_TransTimeEval_RcvTimeCnst\\Straight_TransTimeEval_RcvTimeCnst_Overall.csv';
sInputFile = 'E:\\USC_Project\\SkyEye\\Simulation\\Sim_output_PBC_1.0_0.5\\Dense40_20\\Dense_40_20_TransTimeEval_RecvTimeCnst\\Dense_40_20_TransTimeEval_RcvTimeCnst_Overall.csv';

mResultTime = [];
mResultTimeStd = [];

mTransTime = load(sInputFile);

for i=1:nRangeCount
    for j=1:nSizeCount
        mResultTime(i,j) = mTransTime((i-1)*nSizeCount+j,4)*1000.0;  % Convert to ms
        mResultTimeStd(i,j) = mTransTime((i-1)*nSizeCount+j,5)*1000.0;  % Convert to ms
    end
end

XTickTxt = {'60m'; '80m'; '100m'; '120m'; '150m'; '200m'};
bwlegend = {'5KB'; '10KB';'15KB'; '20KB'; '25KB'; '30KB'; '35KB'; '40KB'; '45KB'};

%barweb(barvalues, errors, width, groupnames, bw_title, bw_xlabel, bw_ylabel, bw_colormap, gridstatus, bw_legend, error_sides, legend_type)
%barweb(mResultTime, mResultTimeStd, [], XTickTxt, 'Communication Delay (Dense Mode, Data Rate: 6 Mbps)', 'Transmission Range', 'Delay (ms)', [], 'y', bwlegend, 2, 'plot');
%return;

figure('numbertitle', 'off', 'name', 'Communication Delay');
%bar(mResultTime);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Here below could plot bar with standard deviation

width=1;
barHandle = bar(mResultTime, width,'edgecolor','k', 'linewidth', 2);
hold on;

for i = 1:9
    x =get(get(barHandle(i),'children'), 'xdata');
    x = mean(x([1 3],:));
    errorbar(x, mResultTime(:,i), mResultTimeStd(:,i), 'k', 'linestyle', 'none', 'linewidth', 2); %
    %ymax = max([ymax; barvalues(:,i)+errors(:,i)]);
end

%errorbar(mTransRange, mResultTime,mResultTimeStd,'Marker','none','LineStyle','none'); %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

XTickTxt = {'60m'; '80m'; '100m'; '120m'; '150m'; '200m'};
set(gca, 'FontSize', 14)
set(gca, 'XTickLabel', XTickTxt);
title(gca, 'Communication Delay (Dense Mode, Data Rate: 6 Mbps)');
legend('5KB', '10KB','15KB', '20KB', '25KB', '30KB', '35KB', '40KB', '45KB');
xlabel('Transmission Range', 'FontSize', 18);
ylabel('Delay (ms)', 'FontSize', 18);
%set(gca,'ygrid','on');

return;


