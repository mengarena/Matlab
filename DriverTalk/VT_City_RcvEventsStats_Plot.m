function f=VT_City_RcvEventsStats_Plot()
% This function measure and show the transmission delay for different
% transmission range and packet size
%
bDense = 0;
fprintf('Start Time: %s\n', datestr(clock, 'yyyy-mm-dd HH:MM:SS'));

mTransRange = [40 60 80];  % Meter
%mImgSize = [10 12 14 16 18];  % KB
mImgSize = [10 12 14];  % KB
%mImgSize = [10 14 18];  % KB

%mSmallPktSize = [512 1024 2048];  %B
%mSmallPktSize = [1024 2048];  %B
mSmallPktSize = [1024];  %B

nFixedImgCnt = 0;   % Count of image is not fixed

nRangeCount = length(mTransRange);
nImgSizeCount = length(mImgSize);
nSmallPktSizeCount = length(mSmallPktSize);

format long;

%sPlace = 'E:\\VT_City_Output\\Meng_NonFixedImgCnt\\';
sPlace = 'E:\\VT_City1200_Output_753\\Meng_NonFixedImgCnt\\';

if bDense == 0
    sInputFilePre = 'Sparse_sp_RcvEventStats\\Sparse_RcvEventStats';
else
    sInputFilePre = 'Dense_sp_RcvEventStats\\Dense_RcvEventStats';    
end

mRcvEventTimes = [];
mRcvEventTimesStd = [];

for i=1:nRangeCount
    
    nRange = mTransRange(1,i);
    
    for j=1:nImgSizeCount
        nImgSize = mImgSize(1,j);

        sInputFile = sprintf('%s%s_%s_%s_%s.csv', sPlace, sInputFilePre, num2str(nRange), num2str(nImgSize), num2str(nFixedImgCnt));    % Receive event statistics file

        mRcvEventStats = load(sInputFile);

        mRcvEventTimes(i,j) = mRcvEventStats(1,4);
        mRcvEventTimesStd(i,j) = mRcvEventStats(1,5);
            
    end
            
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Here below could plot time bar for Image Message Reception Frequency with standard deviation

XTickTxt = {'40'; '60'; '80'};

width=1;

if bDense == 0
    figure('numbertitle', 'off', 'name', 'Message Reception Frequency (Sparse, Non-Fixed Image Count, Time Constraint, Trans)');
else
    figure('numbertitle', 'off', 'name', 'Message Reception Frequency (Dense, Non-Fixed Image Count, Time Constraint, Trans)');    
end

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

yMax = 3.0;

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
    
set(gca, 'XTickLabel', XTickTxt, 'FontName','Times New Roman', 'FontSize', 24);

if bDense == 0
    title(gca, 'Message Reception Frequency (City)', 'FontName','Times New Roman', 'FontSize', 26);
else
    title(gca, 'Message Reception Frequency (City)', 'FontName','Times New Roman', 'FontSize', 26);            
end

legend('10 KB','12 KB', '14 KB', 'Orientation', 'horizontal');
%legend('10 KB','14 KB', '18 KB', 'Orientation', 'horizontal');

xlabelStr = 'Transmission Range (m)';
xlabel(xlabelStr, 'FontName','Times New Roman', 'FontSize', 26);    
ylabel('#Message Per Second', 'FontName','Times New Roman', 'FontSize', 26);
set(gca,'ygrid','on');
ylim([0 yMax]);
set(gca, 'YTick', 0:0.5:yMax);

f=0;

return;


