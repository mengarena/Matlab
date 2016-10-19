function f=VT_Highway_CommuDelay_Plot(bDense)
% This function measure and show the transmission delay for different
% transmission range and packet size
%

fprintf('Start Time: %s\n', datestr(clock, 'yyyy-mm-dd HH:MM:SS'));

mTransRange = [60 80 100];  % Meter
mImgSize = [10 12 14];  % KB
%mImgSize = [10 14 18];  % KB

%mImgSize = [1 2 4 6 8 10 12 14];  % KB

%mSmallPktSize = [512 1024 2048];  %B
%mSmallPktSize = [1024 2048];  %B
mSmallPktSize = [1024];  %B

%bDense = 1;

nFixedImgCnt = 0;   % Count of image is not fixed
%fRcvTimeGap = 0.5;

nRangeCount = length(mTransRange);
nImgSizeCount = length(mImgSize);
nSmallPktSizeCount = length(mSmallPktSize);

format long;

sPlace = 'E:\\VT_Highway_Output\\Meng_NonFixedImgCnt\\';

if bDense == 0
    sInputFilePre = 'TimeEval\\Sparse_sp_TransTimeEval_RcvTimeCnst';
else
    sInputFilePre = 'TimeEval\\Dense_sp_TransTimeEval_RcvTimeCnst';    
end

mResultTimeImg = [];
mResultTimeImgStd = [];

for i=1:nRangeCount
%    mResultTime{i} = [];
%    mResultTimeStd{i} = [];
    
    nRange = mTransRange(1,i);
    
    for j=1:nImgSizeCount
        nImgSize = mImgSize(1,j);

        sInputFile = sprintf('%s%s_%s_%s_%s.csv', sPlace, sInputFilePre, num2str(nRange), num2str(nImgSize), num2str(nFixedImgCnt));    % Delay time file

%        mTransTime{i} = load(sInputFile);
        mTransTime = load(sInputFile);

    %    for k=1:nSmallPktSizeCount
%             mResultTimeImg{i}(j,k) = mTransTime{i}((j-1)*nSmallPktSizeCount+k,4)*1000.0;  % Convert to ms
%             mResultTimeImgStd{i}(j,k) = mTransTime{i}((j-1)*nSmallPktSizeCount+k,5)*1000.0;  % Convert to ms
%             mResultTimeMap{i}(j,k) = mTransTime{i}((j-1)*nSmallPktSizeCount+k,8)*1000.0;  % Convert to ms
%             mResultTimeMapStd{i}(j,k) = mTransTime{i}((j-1)*nSmallPktSizeCount+k,9)*1000.0;  % Convert to ms
%             mResultTimeImg{i}(j,k) = mTransTime{i}(k,4)*1000.0;  % Convert to ms
%             mResultTimeImgStd{i}(j,k) = mTransTime{i}(k,5)*1000.0;  % Convert to ms
%             mResultTimeMap{i}(j,k) = mTransTime{i}(k,8)*1000.0;  % Convert to ms
%             mResultTimeMapStd{i}(j,k) = mTransTime{i}(k,9)*1000.0;  % Convert to ms
            mResultTimeImg(i,j) = mTransTime(1,4)*1000.0;  % Convert to ms
            mResultTimeImgStd(i,j) = mTransTime(1,5)*1000.0;  % Convert to ms

            
   %     end
    end
        
    
end

%XTickTxt = {'10'; '12'; '14'; '16'; '18'};
XTickTxt = {'60'; '80'; '100'};

%barweb(barvalues, errors, width, groupnames, bw_title, bw_xlabel, bw_ylabel, bw_colormap, gridstatus, bw_legend, error_sides, legend_type)
%barweb(mResultTime, mResultTimeStd, [], XTickTxt, 'Communication Delay (Dense Mode, Data Rate: 6 Mbps)', 'Transmission Range', 'Delay (ms)', [], 'y', bwlegend, 2, 'plot');
%return;

width=1;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Here below could plot time bar for Img Reception with standard deviation

if bDense == 0
    figure('numbertitle', 'off', 'name', 'Message Communication Latency (Sparse, Non-Fixed Image Count, Time Constraint, Trans)','units','normalized','outerposition',[0 0 1 1]);
else
    figure('numbertitle', 'off', 'name', 'Message Communication Latency (Dense, Non-Fixed Image Count, Time Constraint, Trans)','units','normalized','outerposition',[0 0 1 1]);    
end
%bar(mResultTime);

yMax = 0;
yMaxTmp = 0;

for i=1:nRangeCount
    for j=1:nImgSizeCount
      %  for k = 1:nSmallPktSizeCount
            yMaxTmp = mResultTimeImg(i,j) + mResultTimeImgStd(i,j);
            
            if yMaxTmp > yMax
                yMax = yMaxTmp;
            end
      %  end
    end
end

yMax = yMax + 10;
yMax = yMax - mod(yMax, 10);

%for i=1:nRangeCount
%    subplot(1,3,i);
%    barHandle = bar(mResultTimeImg{i}, width,'edgecolor','k', 'linewidth', 2);
    barHandle = bar(mResultTimeImg, width,'edgecolor','k', 'linewidth', 2);

    hold on;
    
    tmp = [];
    for ii=1:nRangeCount
        for j = 1:nImgSizeCount
            tmp(ii,j) = 0;
        end
    end
    
    for j = 1:nImgSizeCount
        x = get(get(barHandle(j),'children'), 'xdata');
%        x = get(get(barHandle(1),'children'), 'xdata');

        x = mean(x([1 3],:));
%        errorbar(x, mResultTimeImg{i}(:,j), mResultTimeImgStd{i}(:,j), 'k', 'linestyle', 'none', 'linewidth', 2); %
%        errorbar(x, mResultTimeImg{i}(:,j), tmp(:,j), mResultTimeImgStd{i}(:,j), 'k', 'linestyle', 'none', 'linewidth', 2); %
        errorbar(x, mResultTimeImg(:,j), tmp(:,j), mResultTimeImgStd(:,j), 'k', 'linestyle', 'none', 'linewidth', 2); %

        %ymax = max([ymax; barvalues(:,i)+errors(:,i)]);
    end
  
    
%    if i == 2
        if bDense == 0
            title(gca, 'Latency of Message Communication (Highway, Sparse Mode)', 'FontName','Times New Roman', 'FontSize', 26);
        else
            title(gca, 'Latency of Message Communication (Highway, Dense Mode)', 'FontName','Times New Roman', 'FontSize', 26);            
        end

%        legend('512B','1024B','2048B');

    set(gca, 'XTickLabel', XTickTxt, 'FontName','Times New Roman', 'FontSize', 24);
    
%    end
%    legend('1 KB','2 KB', '4 KB', '6 KB', '8 KB', '10 KB', '12 KB', '14 KB', 'Orientation', 'horizontal');
    legend('10 KB', '12 KB', '14 KB', 'Orientation', 'horizontal');
%    legend('10 KB', '14 KB', '18 KB', 'Orientation', 'horizontal');

%    xlabelStr = strcat('Image Size(KB)', '[Range:', num2str(mTransRange(1,i)), 'm]');
    xlabelStr = 'Transmission Range (m)';
    xlabel(xlabelStr, 'FontName','Times New Roman', 'FontSize', 26);    
    ylabel('Latency (ms)', 'FontName', 'Times New Roman', 'FontSize', 26);
    set(gca,'ygrid','on');
%    ylim([0 yMax]);

    ylim([0 100]);
    set(gca,'YTick',0:10:100);

%end

%legend('1024B','2048B');



f=0;

return;


