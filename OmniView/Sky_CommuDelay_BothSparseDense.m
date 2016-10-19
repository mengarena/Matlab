function f=Sky_CommuDelay_BothSparseDense()
% This function measure and show the transmission delay for different
% transmission range and packet size
%

mTransRange = [60 80 100];
mPacketSize = [10 15];

nRangeCount = length(mTransRange);
nSizeCount = length(mPacketSize);

%In each inputfile, the records are stored in the order of 
% transmission range + packet size
%Each record contains:
%   Trans range, Packet size, Modulation scheme, Avg trans time, Std trans
%   time, Max trans time, Min trans time
%
sInputFile1 = 'E:\\USC_Project\\SkyEye\\Simulation\\Sim_output_PBC_1.0_0.5\\Straight\\Straight_TransTimeEval_RcvTimeCnst\\Straight_TransTimeEval_RcvTimeCnst_Overall.csv';
%sInputFile = 'E:\\USC_Project\\SkyEye\\Simulation\\Sim_output_PBC_1.0_0.5\\Dense40_20\\Dense_40_20_TransTimeEval_RecvTimeCnst\\Dense_40_20_TransTimeEval_RcvTimeCnst_Overall.csv';

mResultTime1 = [];
mResultTimeStd1 = [];

mTransTime1 = load(sInputFile1);

for i=1:nRangeCount
    for j=1:nSizeCount
        mResultTime1(i,j) = mTransTime1((i-1)*nSizeCount+j,4)*1000.0;  % Convert to ms
        mResultTimeStd1(i,j) = mTransTime1((i-1)*nSizeCount+j,5)*1000.0  % Convert to ms
    end
end

%XTickTxt = {'60m'; '80m'; '100m'; '120m'; '150m'; '200m'};
%bwlegend = {'5KB'; '10KB';'15KB'; '20KB'; '25KB'; '30KB'; '35KB'; '40KB'; '45KB'};
XTickTxt = {'60m'; '80m'; '100m'};
bwlegend = {'10KB';'15KB'};

%barweb(barvalues, errors, width, groupnames, bw_title, bw_xlabel, bw_ylabel, bw_colormap, gridstatus, bw_legend, error_sides, legend_type)
%barweb(mResultTime, mResultTimeStd, [], XTickTxt, 'Communication Delay (Dense Mode, Data Rate: 6 Mbps)', 'Transmission Range', 'Delay (ms)', [], 'y', bwlegend, 2, 'plot');
%return;

figure('numbertitle', 'off', 'name', 'Communication Delay');
%bar(mResultTime);
subplot(1,2,1);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Here below could plot bar with standard deviation

width=1;
barHandle1 = bar(mResultTime1, width,'edgecolor','k', 'linewidth', 2);
hold on;

for i = 1:2
    x1 = get(get(barHandle1(i),'children'), 'xdata');
    x1 = mean(x1([1 3],:));
    errorbar(x1, mResultTime1(:,i), mResultTimeStd1(:,i), 'k', 'linestyle', 'none', 'linewidth', 2); %
    %ymax = max([ymax; barvalues(:,i)+errors(:,i)]);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%XTickTxt = {'60m'; '80m'; '100m'; '120m'; '150m'; '200m'};
XTickTxt = {'60m'; '80m'; '100m'};
set(gca, 'FontSize', 20)
set(gca, 'XTickLabel', XTickTxt);
title(gca, 'Communication Delay (Sparse Mode)');
%legend('5KB', '10KB','15KB', '20KB', '25KB', '30KB', '35KB', '40KB', '45KB');
legend('10KB','15KB');
xlabel('Transmission Range', 'FontSize', 24);
ylabel('Delay (ms)', 'FontSize', 24);
set(gca,'ygrid','on');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%sInputFile2 = 'E:\\USC_Project\\SkyEye\\Simulation\\Sim_output_PBC_1.0_0.5\\Straight\\Straight_TransTimeEval_RcvTimeCnst\\Straight_TransTimeEval_RcvTimeCnst_Overall.csv';
sInputFile2 = 'E:\\USC_Project\\SkyEye\\Simulation\\Sim_output_PBC_1.0_0.5\\Dense40_20\\Dense_40_20_TransTimeEval_RecvTimeCnst\\Dense_40_20_TransTimeEval_RcvTimeCnst_Overall.csv';

mResultTime2 = [];
mResultTimeStd2 = [];

mTransTime2 = load(sInputFile2);

for i=1:nRangeCount
    for j=1:nSizeCount
        mResultTime2(i,j) = mTransTime2((i-1)*nSizeCount+j,4)*1000.0;  % Convert to ms
        mResultTimeStd2(i,j) = mTransTime2((i-1)*nSizeCount+j,5)*1000.0  % Convert to ms
    end
end

%bar(mResultTime);
subplot(1,2,2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Here below could plot bar with standard deviation

barHandle2 = bar(mResultTime2, width, 'edgecolor','k', 'linewidth', 2);
hold on;

for i = 1:2
    x2 = get(get(barHandle2(i),'children'), 'xdata');
    x2 = mean(x2([1 3],:));
    errorbar(x2, mResultTime2(:,i), mResultTimeStd2(:,i), 'k', 'linestyle', 'none', 'linewidth', 2); %
    %ymax = max([ymax; barvalues(:,i)+errors(:,i)]);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

set(gca, 'FontSize', 20)
set(gca, 'XTickLabel', XTickTxt);
title(gca, 'Communication Delay (Dense Mode)');
%legend('10KB','15KB');
xlabel('Transmission Range', 'FontSize', 24);
ylabel('Delay (ms)', 'FontSize', 24);
set(gca,'YaxisLocation','right');
set(gca,'ygrid','on');

return;


