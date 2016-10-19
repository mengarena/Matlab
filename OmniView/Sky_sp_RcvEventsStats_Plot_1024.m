function f=Sky_sp_RcvEventsStats_Plot_1024(bDense)
% This function measure and show the transmission delay for different
% transmission range and packet size
%

fprintf('Start Time: %s\n', datestr(clock, 'yyyy-mm-dd HH:MM:SS'));

mTransRange = [60 80 100];  % Meter
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

sPlace = 'E:\\SkyEye_sp_Output\\Meng_NonFixedImgCnt\\';

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

XTickTxt = {'60'; '80'; '100'};

width=1;

if bDense == 0
    figure('numbertitle', 'off', 'name', 'Image Message Reception Frequency (Sparse, Non-Fixed Image Count, Time Constraint, Trans)');
else
    figure('numbertitle', 'off', 'name', 'Image Message Reception Frequency (Dense, Non-Fixed Image Count, Time Constraint, Trans)');    
end

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

yMax = yMax + 3;
yMax = yMax - mod(yMax, 3);

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
    
set(gca, 'FontName', 'Times New Roman', 'FontSize', 24)
set(gca, 'XTickLabel', XTickTxt);

if bDense == 0
    title(gca, 'Image Message Reception Frequency (Sparse Mode)', 'FontName', 'Times New Roman', 'FontSize', 24);
else
    title(gca, 'Image Message Reception Frequency (Dense Mode)', 'FontName', 'Times New Roman', 'FontSize', 24);            
end

legend('10 KB','12 KB', '14 KB');

xlabelStr = 'Transmission Range (m)';
xlabel(xlabelStr, 'FontSize', 24);    
ylabel('Delay (ms)', 'FontSize', 24);
set(gca,'ygrid','on');
ylim([0 yMax]);



f=0;

return;


