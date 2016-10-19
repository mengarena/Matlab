function f=VT_GenNeighbor_TclScript(nHighWay, nDense)
% This function is used to generate the Tcl Script for getting the neighbor
% nodes for each sender node at each timestamp
%
%
% nDense = 1, Dense mode
% nDense = 0, Sparse mode
%

fprintf('Start Time: %s\n', datestr(clock, 'yyyy-mm-dd HH:MM:SS'));

if nHighWay == 1
    mTransRange = [60 80 100];  % Meter
else 
    mTransRange = [40 60 80];  % Meter
end

mImgSize = [10 12 14 16 18];  % KB
%mImgSize = [10 12 14];  % KB
%mImgSize = [1 2];  % KB

%%%mSmallPktSize = [512 1024 2048];  %B
%mSmallPktSize = [1024 2048];  %B
mSmallPktSize = [1024];  %B

nRangeCount = length(mTransRange);
nImgSizeCount = length(mImgSize);
nSmallPktSizeCount = length(mSmallPktSize);

nFixedImgCnt = 0;   % Count of image is not fixed

nMapMsgSize = 512;  % Size of Map message

format long;

%nHighWay = 0;   % = 0, city


if nHighWay == 1
    sPlace = 'E:\\VT_Highway_Output\\Meng_NonFixedImgCnt\\';
else
    sPlace = 'E:\\VT_City_Output\\Meng_NonFixedImgCnt\\';
end
    
if nDense == 0 
%    sOutputFilePre = 'C:\\cygwin\\home\\ar\\ns-allinone-2.34\\ns-2.34\\Sparse_sp_GetNeighborTclScript\\Sparse_GetNeigh';
%    sFilePath = 'C:\\cygwin\\home\\ar\\ns-allinone-2.34\\ns-2.34\\Sparse_sp_Trace\\SkyEye_Sparse';
    sOutputFilePre = 'Sparse_sp_GetNeighborTclScript\\Sparse_GetNeigh';
    if nHighWay == 1
        sFilePath = 'Sparse_sp_Trace\\VT_Highway_Sparse';
    else
        sFilePath = 'Sparse_sp_Trace\\VT_City_Sparse';
    end
else
%    sOutputFilePre = 'C:\\cygwin\\home\\ar\\ns-allinone-2.34\\ns-2.34\\Dense_sp_GetNeighborTclScript\\Dense_GetNeigh';
%    sFilePath = 'C:\\cygwin\\home\\ar\\ns-allinone-2.34\\ns-2.34\\Dense_sp_Trace\\VT_Dense';
    sOutputFilePre = 'Dense_sp_GetNeighborTclScript\\Dense_GetNeigh';
    
    if nHighWay == 1
        sFilePath = 'Dense_sp_Trace\\VT_Highway_Dense';
    else
        sFilePath = 'Dense_sp_Trace\\VT_City_Dense';        
    end
end

for i=1:nRangeCount

    nRange = mTransRange(1,i);

    for j=1:nImgSizeCount
        
        for k=1:nSmallPktSizeCount
            
            nSmallPktSize = mSmallPktSize(1,k);
            
            nSmallPktCnt = mImgSize(1,j)*1024/nSmallPktSize;  % Number of small packet
            
            sFileName = sprintf('%s%s_%s_%s_%s_%s.csv', sPlace, sFilePath, num2str(nRange), num2str(nSmallPktSize), num2str(nSmallPktCnt), num2str(nFixedImgCnt)); % Pre-processed trace file
            disp('*****************************************************');
            fprintf('Processing: %s\n', sFileName);

            sOutputFile = sprintf('%s%s_%s_%s_%s_%s.tcl', sPlace, sOutputFilePre, num2str(nRange), num2str(nSmallPktSize), num2str(nSmallPktCnt), num2str(nFixedImgCnt));
            fprintf('Output Tcl script: %s\n', sOutputFile);
            fid_result = fopen(sOutputFile,'w');

            mTrace = load(sFileName);
            [nRow nCol] = size(mTrace);

            nTmpCount = 0;
            
            for m=1:nRow
                nEventType = mTrace(m,1);
                
                if nEventType == 0   % Receiver
                    nTmpCount = 0;                    
                    continue;
                end
                
                if nEventType == 1    % Sender
                    
                    if mTrace(m,5) == nMapMsgSize     % It is sending Map message, write everyone into script file
                        fTimestamp = mTrace(m,2);
                        nHostNodeId = mTrace(m,3);
                        fprintf(fid_result,'$ns_ at %.9f "get_neighborlist %d %.9f"\n',fTimestamp, nHostNodeId, fTimestamp);
                        nTmpCount = 0;
                    else   % It is sending Image message (small packet), only write the first corresponding to an image into script file
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
            end

            fclose(fid_result);
            
        end
    end
end
    

disp('***********All scripts are generated!******************');

fprintf('Finish Time: %s\n', datestr(clock, 'yyyy-mm-dd HH:MM:SS'));

return;
