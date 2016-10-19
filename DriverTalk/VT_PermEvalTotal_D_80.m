function f = VT_PermEvalTotal_D_80(nHighWay, mImgSize)
% This function measure all the transmission time (average, standard
% deviation, max, min;
% It also get statistics about the list of receivers for each send event
%
% The result is saved as csv files
%
% fRcvTimeGap: Receive time constraint, if 1000.0, then no time constraint
%
% Transmission Range: 60, 80, 100, 120, 150, 200
% Packet Size: 5, 10, 15, 20, 25, 30, 35, 40, 45
% Modulation Scheme: 1 (6 Mbps)
%
%

fprintf('Start Time: %s\n', datestr(clock, 'yyyy-mm-dd HH:MM:SS'));

%mTransRange = [60 80 100];  % Meter
mTransRange = [80];  % Meter
%mImgSize = [10 12 14 16 18];  % KB
%mSmallPktSize = [512 1024 2048];  %B
mSmallPktSize = [1024];  %B

bDense = 1;

nFixedImgCnt = 0;   % Count of image is not fixed

fMapMsgRcvTimeGap = 0.4;   % Life time of Map message 
fImgMsgRcvTimeGap = 2.0;   % Life time of Image message (Ask for ID by Img)

nRangeCount = length(mTransRange);
nImgSizeCount = length(mImgSize);
nSmallPktSizeCount = length(mSmallPktSize);


%nHighWay = 1;   % = 0, city

format long;

%fRcvTimeGap = 1000.0;    % 1000.0 is big enough as packet receiving during for WITHOUT constraint

if nHighWay == 1
    sPlace = 'E:\\VT_Highway_Output\\Meng_NonFixedImgCnt\\';
    fEndTime = 2000.0;  % Sending event after this time is not calculated
else
    sPlace = 'E:\\VT_City_Output\\Meng_NonFixedImgCnt\\';
    fEndTime = 1010.0;  % Sending event after this time is not calculated
end

if bDense == 1
    if fImgMsgRcvTimeGap >= 999.0   % No receive time constraint
        sOutputFilePre = 'TimeEval\\Dense_sp_TransTimeEval_NoRcvTimeCnst';
    else
        sOutputFilePre = 'TimeEval\\Dense_sp_TransTimeEval_RcvTimeCnst';
    end

    if nHighWay == 1
        sFilePathPre = 'Dense_sp_Trace\\VT_Highway_Dense';
    else
        sFilePathPre = 'Dense_sp_Trace\\VT_City_Dense';        
    end
    
    %%[Begin] New added here
    sTargetListPre = 'Dense_sp_TargetList\\Dense_Target';
    %%[End]
    
else
    if fImgMsgRcvTimeGap >= 999.0   % No receive time constraint
        sOutputFilePre = 'TimeEval\\Sparse_sp_TransTimeEval_NoRcvTimeCnst';
    else
        sOutputFilePre = 'TimeEval\\Sparse_sp_TransTimeEval_RcvTimeCnst';
    end

    if nHighWay == 1
        sFilePathPre = 'Sparse_sp_Trace\\VT_Highway_Sparse';
    else
        sFilePathPre = 'Sparse_sp_Trace\\VT_City_Sparse';
    end
    
    %%[Begin] New added here
    sTargetListPre = 'Sparse_sp_TargetList\\Sparse_Target';
    %%[End]
end

for i=1:nRangeCount
    nRange = mTransRange(1,i);

%%%    sOutputFile = sprintf('%s%s_%s_%s.csv', sPlace, sOutputFilePre, num2str(nRange), num2str(nFixedImgCnt));   % Transmission Time file

%%%    fid_result = fopen(sOutputFile,'w');
    
    %fprintf(fid_result, '#Trans range, Image size, Small Packet Size, Image transmission time (Average, Std, Max, Min), Map message transmission time (Average, Std, Max, Min)\n');
    
    for j=1:nImgSizeCount
        nImgSize = mImgSize(1,j);

        sOutputFile = sprintf('%s%s_%s_%s_%s.csv', sPlace, sOutputFilePre, num2str(nRange), num2str(nImgSize), num2str(nFixedImgCnt));   % Transmission Time file

        fid_result = fopen(sOutputFile,'w');
                
        for k=1:nSmallPktSizeCount
            nSmallPktSize = mSmallPktSize(1,k);
            nSmallPktCnt = nImgSize*1024/nSmallPktSize;
             % This is the pre-processed ns trace result
            sFileName = sprintf('%s%s_%s_%s_%s_%s.csv', sPlace, sFilePathPre, num2str(nRange), num2str(nSmallPktSize), num2str(nSmallPktCnt),num2str(nFixedImgCnt));
            disp('*****************************************************');
            fprintf('Processing: %s\n', sFileName);
        
            mResult = [];
            mTrace = load(sFileName);

            %%[Begin] New added here
            sFileNameTargetList = sprintf('%s%s_%s_%s_%s_%s.csv', sPlace, sTargetListPre, num2str(nRange), num2str(nSmallPktSize), num2str(nSmallPktCnt),num2str(nFixedImgCnt));
            mTargetList = load(sFileNameTargetList);
            %%[End]
            
            % Call VT_PermEval_sub to produce the receiver list file
            % and the transmission time for Image and Map message
% Original            mResult = VT_PermEval_sub(nHighWay, mTrace,  bDense, nRange, nImgSize, nSmallPktSize, fImgMsgRcvTimeGap, fMapMsgRcvTimeGap, nFixedImgCnt, fEndTime);   
            mResult = VT_PermEval_sub(nHighWay, mTrace, mTargetList, bDense,  nRange, nImgSize, nSmallPktSize, fImgMsgRcvTimeGap, fMapMsgRcvTimeGap, nFixedImgCnt, fEndTime);   
            
            % Write transmission time file 
            % Image transmission time (Average, Std, Max, Min) and
            % Map message transmission time (Average, Std, Max, Min) 
            fprintf(fid_result,'%d,%d,%d,%f,%f,%f,%f,%f,%f,%f,%f\n',nRange, nImgSize, nSmallPktSize, mResult(1,1), mResult(1,2), mResult(1,3), mResult(1,4), mResult(1,5), mResult(1,6), mResult(1,7), mResult(1,8));
            fprintf('Average Img Transmission Time: %f\n', mResult(1,1));
            fprintf('Std Img Transmission Time: %f\n', mResult(1,2));
            fprintf('Max Img Transmission Time: %f\n', mResult(1,3));
            fprintf('Min Img Transmission Time: %f\n', mResult(1,4));
            fprintf('Average Map Msg Transmission Time: %f\n', mResult(1,5));
            fprintf('Std Map Msg Transmission Time: %f\n', mResult(1,6));
            fprintf('Max Map Msg Transmission Time: %f\n', mResult(1,7));
            fprintf('Min Map Msg Transmission Time: %f\n', mResult(1,8));
        end
        
        fclose(fid_result);
        
    end  % for j=1:nImgSizeCount
    
%%%    fclose(fid_result);
    
end   % for i=1:nRangeCount 

disp('***********Processing is done!******************');

fprintf('Finish Time: %s\n', datestr(clock, 'yyyy-mm-dd HH:MM:SS'));

return;
