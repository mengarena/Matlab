function f=Sky_sp_CalNetworkLoad_Total(bDense)
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
mSmallPktSize = [512 1024 2048];  %B

%bDense = 1;

nFixedImgCnt = 0;   % Count of image is not fixed

nRangeCount = length(mTransRange);
nImgSizeCount = length(mImgSize);
nSmallPktSizeCount = length(mSmallPktSize);

sPlace = 'C:\\cygwin\\home\\ar\\ns-allinone-2.34\\ns-2.34\\';

if bDense == 1
    fDist = 3127.0;   % Unit: m
    
    sFilePathPre = 'Dense_sp_Trace\\SkyEye_Dense';
    
    sOutputFilePre = 'NetLoad\\Dense_sp_NetworkLoad';

else
    fDist = 5499.84;  % Unit: m
    
    sFilePathPre = 'Sparse_sp_Trace\\SkyEye_Sparse';
    
    sOutputFilePre = 'NetLoad\\Sparse_sp_NetworkLoad';

end

for i=1:nRangeCount
    nRange = mTransRange(1,i);

    sOutputFile = sprintf('%%ss_%s_%s.csv', sPlace, sOutputFilePre, num2str(nRange), num2str(nFixedImgCnt));   % Transmission Time file

    fid_result = fopen(sOutputFile,'w');
    
    for j=1:nImgSizeCount
        nImgSize = mImgSize(1,j);
        
        for k=1:nSmallPktSizeCount
            nSmallPktSize = mSmallPktSize(1,k);
            nSmallPktCnt = nImgSize*1024/nSmallPktSize;
             % This is the pre-processed ns trace result
            sFileName = sprintf('%s%s_%s_%s_%s_%s.csv', sPlace, sFilePathPre, num2str(nRange), num2str(nSmallPktSize), num2str(nSmallPktCnt),num2str(nFixedImgCnt));
            disp('*****************************************************');
            fprintf('Processing: %s\n', sFileName);
        
            mTrace = load(sFileName);

            fLoad = Sky_sp_CalNetworkLoad(mTrace, fDist, nRange);
            
            fprintf(fid_result,'%d,%d,%d,%f\n',nRange, nImgSize, nSmallPktSize, fLoad);
            
        end
    end
    
    fclose(fid_result);
    
end


fprintf('End Time: %s\n', datestr(clock, 'yyyy-mm-dd HH:MM:SS'));

f=0;

return;
