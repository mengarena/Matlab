function f=Sky_sp_GenNeighbor_TclScript()
% This function is used to generate the Tcl Script for getting the neighbor
% nodes for each sender node at each timestamp
%
%

fprintf('Start Time: %s\n', datestr(clock, 'yyyy-mm-dd HH:MM:SS'));

mTransRange = [60 80 100];  % Meter
mImgSize = [10 12 14 16 18];  % KB
mSmallPktSize = [512 1024 2048];  %B

nRangeCount = length(mTransRange);
nImgSizeCount = length(mImgSize);
nSmallPktSizeCount = length(mSmallPktSize);

nFixedImgCnt = 0;   % Count of image is not fixed

format long;

%sOutputFilePre = 'C:\\cygwin\\home\\ar\\ns-allinone-2.34\\ns-2.34\\Sparse_sp_GetNeighborTclScript\\Sparse_GetNeigh';
%sFilePath = 'C:\\cygwin\\home\\ar\\ns-allinone-2.34\\ns-2.34\\Sparse_sp_Trace\\SkyEye_Sparse';

sOutputFilePre = 'C:\\cygwin\\home\\ar\\ns-allinone-2.34\\ns-2.34\\Dense_sp_GetNeighborTclScript\\Dense_GetNeigh';
sFilePath = 'C:\\cygwin\\home\\ar\\ns-allinone-2.34\\ns-2.34\\Dense_sp_Trace\\SkyEye_Dense';

for i=1:nRangeCount

    nRange = mTransRange(1,i);

    for j=1:nImgSizeCount
        
        for k=1:nSmallPktSizeCount
            
            nSmallPktSize = mSmallPktSize(1,k);
            
            nSmallPktCnt = mImgSize(1,j)*1024/nSmallPktSize;  % Number of small packet
            
            sFileName = sprintf('%s_%s_%s_%s_%s.csv', sFilePath, num2str(nRange), num2str(nSmallPktSize), num2str(nSmallPktCnt), num2str(nFixedImgCnt)); % Pre-processed trace file
            disp('*****************************************************');
            fprintf('Processing: %s\n', sFileName);

            sOutputFile = sprintf('%s_%s_%s_%s_%s.tcl', sOutputFilePre, num2str(nRange), num2str(nSmallPktSize), num2str(nSmallPktCnt), num2str(nFixedImgCnt));
            fprintf('Output Tcl script: %s\n', sOutputFile);
            fid_result = fopen(sOutputFile,'w');

            mTrace = load(sFileName);
            [nRow nCol] = size(mTrace);

            nTmpCount = 0;
            
            for m=1:nRow
                nEventType = mTrace(m,1);
                
                if nEventType == 0
                    nTmpCount = 0;                    
                    continue;
                end
                
                if nEventType == 1    % Sender
                    if nTmpCount == 0   % First small packet of an image
                        fTimestamp = mTrace(m,2);
                        nHostNodeId = mTrace(m,3);
                        fprintf(fid_result,'$ns_ at %.9f "get_neighborlist %d %.9f"\n',fTimestamp, nHostNodeId, fTimestamp);
                    end

                    nTmpCount = nTmpCount + 1;
                    
                    if nTmpCount == nSmallPktCnt
                        nTmpCount = 0;
                    end
                    
                end
            end

            fclose(fid_result);
            
        end
    end
end
    

disp('***********All scripts are generated!******************');

fprintf('Finish Time: %s\n', datestr(clock, 'yyyy-mm-dd HH:MM:SS'));

return;
