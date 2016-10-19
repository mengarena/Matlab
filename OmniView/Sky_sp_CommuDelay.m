function f=Sky_sp_CommuDelay(bDense)
% This function measure and show the transmission delay for different
% transmission range and packet size
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
    sInputFilePre = 'C:\\cygwin\\home\\ar\\ns-allinone-2.34\\ns-2.34\\TimeEval\\Sparse_sp_TransTimeEval_RcvTimeCnst';
else
    sInputFilePre = 'C:\\cygwin\\home\\ar\\ns-allinone-2.34\\ns-2.34\\TimeEval\\Dense_sp_TransTimeEval_RcvTimeCnst';    
end

mResultTime = [];
mResultTimeStd = [];

for i=1:nRangeCount
    mResultTime{i} = [];
    mResultTimeStd{i} = [];
    
    nRange = mTransRange(1,i);
    
    sInputFile = sprintf('%s_%s_%s.csv', sInputFilePre, num2str(nRange), num2str(nFixedImgCnt));    % Delay time file
    mTransTime{i} = load(sInputFile);
    for j=1:nImgSizeCount
        for k=1:nSmallPktSizeCount
            mResultTime{i}(j,k) = mTransTime{i}((j-1)*nSmallPktSizeCount+k,4)*1000.0;  % Convert to ms
            mResultTimeStd{i}(j,k) = mTransTime{i}((j-1)*nSmallPktSizeCount+k,5)*1000.0;  % Convert to ms
        end
    end
    
end

XTickTxt = {'10'; '12'; '14'; '16'; '18'};
%barweb(barvalues, errors, width, groupnames, bw_title, bw_xlabel, bw_ylabel, bw_colormap, gridstatus, bw_legend, error_sides, legend_type)
%barweb(mResultTime, mResultTimeStd, [], XTickTxt, 'Communication Delay (Dense Mode, Data Rate: 6 Mbps)', 'Transmission Range', 'Delay (ms)', [], 'y', bwlegend, 2, 'plot');
%return;

if bDense == 0
    figure('numbertitle', 'off', 'name', 'Communication Delay (Sparse, Non-Fixed Image Count, Time Constraint, Trans)');
else
    figure('numbertitle', 'off', 'name', 'Communication Delay (Dense, Non-Fixed Image Count, Time Constraint, Trans)');    
end
%bar(mResultTime);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Here below could plot bar with standard deviation
width=1;

for i=1:nRangeCount
    subplot(1,3,i);
    barHandle = bar(mResultTime{i}, width,'edgecolor','k', 'linewidth', 2);
    hold on;
    
    for j = 1:3
        x = get(get(barHandle(j),'children'), 'xdata');
        x = mean(x([1 3],:));
        errorbar(x, mResultTime{i}(:,j), mResultTimeStd{i}(:,j), 'k', 'linestyle', 'none', 'linewidth', 2); %
        %ymax = max([ymax; barvalues(:,i)+errors(:,i)]);
    end
    
    set(gca, 'FontSize', 20)
    set(gca, 'XTickLabel', XTickTxt);
    
    if i == 2
        if bDense == 0
            title(gca, 'Communication Delay (Sparse Mode, Data Rate: 6 Mbps)');
        else
            title(gca, 'Communication Delay (Dense Mode, Data Rate: 6 Mbps)');            
        end

        legend('512B','1024B','2048B');
    end

    xlabelStr = strcat('Range:', num2str(mTransRange(1,i)), '(m) Image Size(KB)');
    xlabel(xlabelStr, 'FontSize', 24);    
    ylabel('Delay (ms)', 'FontSize', 24);
    set(gca,'ygrid','on');
    
end

f=0;

return;


