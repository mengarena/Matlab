function f=VT_GenerateTargetList(nHighWay, bDense)
% This function generate target list for each sender event based on the
% neighbor list file
% It calculate the sending event (i.e which vehicles the ego-vehicle is
% talking to based on the consecutive sending image number.), which decides
% how many target the ego-vehicle is talking to. (for example, talking to
% the vehicle on the left lane ahead, or on the same lane ahead, or
% everyone, or all vehicles behind)
% Then it correspondingly randomly select the nodes from the neighbor list as its target of talking

% The output:
% senderID, timestamp, #image, #target, target list
%
% The generated file has 60 fields, from 5th field, is the target list (appended with -1s at the end of each line).
%
%

if nHighWay == 1
    mTransRange = [60 80 100];  % Meter
else
    mTransRange = [40 60 80];  % Meter    
end
%mImgSize = [10 12 14 16 18];  % KB
%mImgSize = [1 2 4 6 8 10 12 14];  % KB

mImgSize = [10 12 14 16 18];  % KB

%mSmallPktSize = [512 1024 2048];  %B
%mSmallPktSize = [1024 2048];  %B
mSmallPktSize = [1024];  %B

%bDense = 1;

nFixedImgCnt = 0;   % Count of image is not fixed

nRangeCount = length(mTransRange);
nImgSizeCount = length(mImgSize);
nSmallPktSizeCount = length(mSmallPktSize);

%nHighWay = 1;   % = 0, city

format long;

if nHighWay == 1
    sPlace = 'E:\\VT_Highway_Output\\Meng_NonFixedImgCnt\\';
else
    sPlace = 'E:\\VT_City_Output\\Meng_NonFixedImgCnt\\';
end

if bDense == 0
    %%%% Sparse Mode
    sNeighFilePre = 'Sparse_sp_NeighborList_Trans\\aligned\\Sparse_Neighbor';
    
    sTargetListFilePre = 'Sparse_sp_TargetList\\Sparse_Target';


else
    %%%% Dense Mode
    sNeighFilePre = 'Dense_sp_NeighborList_Trans\\aligned\\Dense_Neighbor';
    
    sTargetListFilePre = 'Dense_sp_TargetList\\Dense_Target';
end


for i=1:nRangeCount
    
    nRange = mTransRange(1,i);
    
    for j=1:nImgSizeCount
        nImgSize = mImgSize(1,j);
        
        for k=1:nSmallPktSizeCount
            nSmallPktSize = mSmallPktSize(1,k);
            nSmallPktCnt = nImgSize*1024/nSmallPktSize;  % Each image has this many small packets

            % Aligned Neighbor list file and Receiver list file
            sNeighFile = sprintf('%s%s_%s_%s_%s_%s.csv', sPlace, sNeighFilePre, num2str(nRange), num2str(nSmallPktSize), num2str(nSmallPktCnt), num2str(nFixedImgCnt));
            sTargetFile = sprintf('%s%s_%s_%s_%s_%s.csv', sPlace, sTargetListFilePre, num2str(nRange), num2str(nSmallPktSize), num2str(nSmallPktCnt), num2str(nFixedImgCnt));

            mTrace = load(sNeighFile);

            VT_CalculateEventImageCount_sub(mTrace, sTargetFile);
        end
    end
end

return;

