function f=VT_City_PRR_Total_Plot()
% Packet Reception Rate data has been produced.
% This function is only used for plotting graph.
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

%bDense = 1;

nFixedImgCnt = 0;   % Count of image is not fixed

nRangeCount = length(mTransRange);
nImgSizeCount = length(mImgSize);
nSmallPktSizeCount = length(mSmallPktSize);

format long;

%sPlace = 'E:\\VT_City_Output\\Meng_NonFixedImgCnt\\';
%sPlace = 'E:\\VT_City1200_Output_751\\Meng_NonFixedImgCnt\\';
sPlace = 'E:\\VT_City1200_Output_753\\Meng_NonFixedImgCnt\\';




if bDense == 0
    %%%% Sparse Mode
    sPRR_TotalFile = 'PRR_Data\\Sparse_PRR.csv';

else
    %%%% Dense Mode
    sPRR_TotalFile = 'PRR_Data\\Dense_PRR.csv';
end

sPRRFile = sprintf('%s%s', sPlace, sPRR_TotalFile);    % Neigh file name

mPRRS = load(sPRRFile);

[nTotalRow nTotalCol] = size(mPRRS);

mMsgPRRS = [];  % nRangeCount X nSizeCount

nIndex = 0;

for i=1:nRangeCount    
    nRange = mTransRange(1,i);
    
    for j=1:nImgSizeCount
        nImgSize = mImgSize(1,j);
        
         for k=1:nTotalRow
             if mPRRS(k,1) == nRange && mPRRS(k,2) == nImgSize
                mMsgPRRS(i,j) = mPRRS(k,3);
             end
         end
    end
end




width = 1;


screenSize = get(0, 'ScreenSize');


bDense = 0;
%subplot(1,2,2);
if bDense == 1
    h1=figure('numbertitle', 'off', 'name', 'City Message Reception Rate (Dense, Non-Fixed Image Count, Time Constraint, Trans)');
else
    h1=figure('numbertitle', 'off', 'name', 'City Message Reception Rate (Sparse, Non-Fixed Image Count, Time Constraint, Trans)');
end

% Plot for Map Message Reception Rate

%for i=1:nRangeCount
%    subplot(1,3,i);
%    bar(mMapMsgPRR{i});
    bar(mMsgPRRS, width);
    
%    XTickTxt = {'10'; '12'; '14'; '16'; '18'};
%    XTickTxt = {'10'; '12'; '14'};
    XTickTxt = {'40'; '60'; '80'};
    
%    if i == 2
        if bDense == 0
%            title(gca, 'Map Message Reception Rate (Sparse Mode, Data Rate: 6 Mbps)');
            title(gca, 'Message Reception Rate (City)', 'FontName','Times New Roman', 'FontSize', 26);

        else
%            title(gca, 'Map Message Reception Rate (Dense Mode, Data Rate: 6 Mbps)');        
            title(gca, 'Message Reception Rate (Highway, Dense Mode)', 'FontName','Times New Roman', 'FontSize', 26);        

        end

    set(gca, 'FontSize', 24)
    set(gca, 'XTickLabel', XTickTxt, 'FontName','Times New Roman', 'FontSize', 24);
    set(gca,'YTick',0:5:100);
    
%        legend('512B','1024B','2048B');
%        legend('1024B','2048B');
%    end
    legend('10 KB','12 KB', '14 KB', 'Orientation', 'horizontal');
%    legend('10 KB','14 KB', '18 KB', 'Orientation', 'horizontal');

    %  legend('1 KB','2 KB', '4 KB', '6 KB', '8 KB', '10 KB', '12 KB', '14 KB','Orientation', 'horizontal');
    
%    xlabelStr = strcat('Image Size(KB)', '[Range:', num2str(mTransRange(1,i)), 'm]');
    xlabelStr = 'Transmission Range (m)';
    
    xlabel(xlabelStr, 'FontName','Times New Roman','FontSize', 26);
    ylabel('Reception Rate (%)','FontName','Times New Roman', 'FontSize', 26);
    set(gca,'ygrid','on');
    ylim([0 100]);
%end


% set(gcf, 'NextPlot', 'add');
% axes;
% h=title('Message Reception Rate','FontName','Times New Roman', 'FontSize', 24);
% set(gca, 'Visible', 'off');
% set(h, 'Visible', 'on');

fprintf('End Time: %s\n', datestr(clock, 'yyyy-mm-dd HH:MM:SS'));

f=0;

return;

    
      
      
      