function f=Sky_sp_CalNetworkLoad_Total_1024(bDense, fEndTime)
% This function is used to calculate the network workload
%
% bDense = 1: Dense mode
% 
% Networkload = Bytes/Time/(Space/TransRange)
%

fprintf('Start Time: %s\n', datestr(clock, 'yyyy-mm-dd HH:MM:SS'))

format long;

mTransRange = [60 80 100];  % Meter
mImgSize = [10 12 14 16 18];  % KB
%mSmallPktSize = [512 1024 2048];  %B
mSmallPktSize = [1024];  %B

nFixedImgCnt = 0;   % Count of image is not fixed

nRangeCount = length(mTransRange);
nImgSizeCount = length(mImgSize);
nSmallPktSizeCount = length(mSmallPktSize);

sPlace = 'E:\\SkyEye_sp_Output\\Meng_NonFixedImgCnt\\';

if bDense == 1
    fTailHeadDist = 3127.0;   % Unit: m
    
    sFilePathPre = 'Dense_sp_Trace\\SkyEye_Dense';
    
    sOutputFilePre = 'NetLoad\\Dense_sp_NetworkLoad';

else
    fTailHeadDist = 5499.84;  % Unit: m
    
    sFilePathPre = 'Sparse_sp_Trace\\SkyEye_Sparse';
    
    sOutputFilePre = 'NetLoad\\Sparse_sp_NetworkLoad';

end


mNetworkRoad = [];

for i=1:nRangeCount
    nRange = mTransRange(1,i);

    sOutputFile = sprintf('%%ss_%s_%s.csv', sPlace, sOutputFilePre, num2str(nRange), num2str(nFixedImgCnt));   % Transmission Time file

    fid_result = fopen(sOutputFile,'w');
    
    for j=1:nImgSizeCount
        nImgSize = mImgSize(1,j);
        
        nSmallPktSize = mSmallPktSize(1,1);
        nSmallPktCnt = nImgSize*1024/nSmallPktSize;
         % This is the pre-processed ns trace result
        sFileName = sprintf('%s%s_%s_%s_%s_%s.csv', sPlace, sFilePathPre, num2str(nRange), num2str(nSmallPktSize), num2str(nSmallPktCnt),num2str(nFixedImgCnt));
        disp('*****************************************************');
        fprintf('Processing: %s\n', sFileName);

        mTrace = load(sFileName);

        mNetworkRoad(i,j) = Sky_sp_CalNetworkLoad(mTrace, fEndTime, fTailHeadDist, nRange);

        fprintf(fid_result,'%d,%d,%d,%f\n',nRange, nImgSize, nSmallPktSize, mNetworkRoad(i,j));
            
    end
    
    fclose(fid_result);
    
end




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Here below could plot time bar for Network Load

XTickTxt = {'60'; '80'; '100'};

width=1;

if bDense == 0
    figure('numbertitle', 'off', 'name', 'Network Load (Sparse, Non-Fixed Image Count, Time Constraint, Trans)');
else
    figure('numbertitle', 'off', 'name', 'Network Load (Dense, Non-Fixed Image Count, Time Constraint, Trans)');    
end

yMax = 0;
yMaxTmp = 0;

for i=1:nRangeCount
    for j=1:nImgSizeCount
        yMaxTmp = mNetworkRoad(i,j);

        if yMaxTmp > yMax
            yMax = yMaxTmp;
        end
    end
end

yMax = yMax + 10;
yMax = yMax - mod(yMax, 10);

barHandle = bar(mNetworkRoad, width,'edgecolor','k', 'linewidth', 2);

hold on;
    
set(gca, 'FontSize', 20)
set(gca, 'XTickLabel', XTickTxt);

if bDense == 0
    title(gca, 'Network Load (Sparse Mode)');
else
    title(gca, 'Network Load (Dense Mode)');            
end

legend('10 KB','12 KB', '14 KB');

xlabelStr = 'Transmission Range (m)'
xlabel(xlabelStr, 'FontSize', 24);    
ylabel('Delay (ms)', 'FontSize', 24);
set(gca,'ygrid','on');
ylim([0 yMax]);


fprintf('End Time: %s\n', datestr(clock, 'yyyy-mm-dd HH:MM:SS'));

f=0;

return;
