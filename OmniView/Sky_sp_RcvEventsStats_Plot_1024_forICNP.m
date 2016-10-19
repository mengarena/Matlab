function f=Sky_sp_RcvEventsStats_Plot_1024_forICNP()
% This function measure and show the Image Message Reception Frequency for
% 60m and 10/12/14 KBs with both Sparse and Dense in one figure.
%

fprintf('Start Time: %s\n', datestr(clock, 'yyyy-mm-dd HH:MM:SS'));

mTransRange = [60];  % Meter
%mImgSize = [10 12 14 16 18];  % KB
mImgSize = [10 12 14];  % KB

%mSmallPktSize = [512 1024 2048];  %B
%mSmallPktSize = [1024 2048];  %B
mSmallPktSize = [1024];  %B

nFixedImgCnt = 0;   % Count of image is not fixed

nRangeCount = length(mTransRange);
nImgSizeCount = length(mImgSize);
nSmallPktSizeCount = length(mSmallPktSize);

format long;

mRcvEventTimes = [];
mRcvEventTimesStd = [];


sInputFileSparse = 'E:\\USC_Project\\SkyEye\\ForICNP2014_Paper\\HotMobile_Version\\Sparse_sp_RcvEventStats\\Sparse_RcvEventStats_Merged.csv';
mRcvEventStats = load(sInputFileSparse);

for i=1:nImgSizeCount
    mRcvEventTimes(1,i) = mRcvEventStats(i,4);
    mRcvEventTimesStd(1,i) = mRcvEventStats(i,5);
end

sInputFileSparse = 'E:\\USC_Project\\SkyEye\\ForICNP2014_Paper\\HotMobile_Version\\Dense_sp_RcvEventStats\\Dense_RcvEventStats_Merged.csv';
mRcvEventStats = load(sInputFileSparse);

for i=1:nImgSizeCount
    mRcvEventTimes(2,i) = mRcvEventStats(i,4);
    mRcvEventTimesStd(2,i) = mRcvEventStats(i,5);
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Here below could plot time bar for Image Message Reception Frequency with standard deviation

XTickTxt = {'Sparse'; 'Dense'};

width=1;

figure('numbertitle', 'off', 'name', 'Identify Message Reception Frequency (Non-Fixed Image Count, Time Constraint, Trans)');

set(0, 'DefaultAxesFontName', 'Times New Roman');
set(0, 'DefaultTextFontName', 'Times New Roman');

yMax = 0;
yMaxTmp = 0;

for i=1:nRangeCount
    for j=1:nImgSizeCount
        yMaxTmp = mRcvEventTimes(i,j) + mRcvEventTimesStd(i,j);

        if yMaxTmp > yMax
            yMax = yMaxTmp;
        end
    end
end

yMax = yMax + 2;
yMax = yMax - mod(yMax, 2);

yMax = 5;

barHandle = bar(mRcvEventTimes, width,'edgecolor','k', 'linewidth', 2);

hold on;

tmp = [];
for ii=1:nRangeCount
    for j = 1:nImgSizeCount
        tmp(ii,j) = 0;
    end
end

for j = 1:nImgSizeCount
    x = get(get(barHandle(j),'children'), 'xdata');

    x = mean(x([1 3],:));
%        errorbar(x, mRcvEventTimes{i}(:,j), mRcvEventTimesStd{i}(:,j), 'k', 'linestyle', 'none', 'linewidth', 2); %
%        errorbar(x, mRcvEventTimes{i}(:,j), tmp(:,j), mRcvEventTimesStd{i}(:,j), 'k', 'linestyle', 'none', 'linewidth', 2); %
    errorbar(x, mRcvEventTimes(:,j), mRcvEventTimesStd(:,j), mRcvEventTimesStd(:,j), 'k', 'linestyle', 'none', 'linewidth', 2); %

end
    
set(gca, 'FontSize', 24);
set(gca, 'XTickLabel', XTickTxt);

title(gca, 'Identify Message Reception Frequency', 'FontSize', 24);

legend('10 KB','12 KB', '14 KB', 'Orientation', 'horizontal');

xlabelStr = 'Traffic Density';
xlabel(xlabelStr, 'FontSize', 24);    
ylabel('#Identify Message Per Second', 'FontSize', 24);
set(gca,'ygrid','on');
ylim([0 yMax]);
set(gca, 'YTick', 0:0.5:yMax);

f=0;

return;


