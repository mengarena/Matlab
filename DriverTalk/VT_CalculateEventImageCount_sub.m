function f=VT_CalculateEventImageCount_sub(mTrace, sTargetListFile)
% The output:
% senderID, timestamp, #image, #target, target list
%

fid_result = fopen(sTargetListFile,'w');

format long;

[nRow nCol] = size(mTrace);

preSender = mTrace(1,1);
preTime = mTrace(1,2);
nPreRowIdx = 1;
nImageCount = 1;

for i=2:nRow
    curSender = mTrace(i,1);
    curTime = mTrace(i,2);
    
    if curSender ~= preSender || curTime ~= preTime
        nTmpNeighCount = 0;
        for j=3:nCol
            if mTrace(nPreRowIdx,j) ~= -1
                nTmpNeighCount = nTmpNeighCount + 1;
            end
        end
       
        if nImageCount == 1
            nTargetCnt = 1;  
        elseif nImageCount == 2
            nTargetCnt = 1; 
        elseif nImageCount == 3
             fTmp = rand;
             if fTmp >= 0.66
                 nTargetCnt = 3;  % =3
             else
                 nTargetCnt = 2;  % 2
             end 
        elseif nImageCount == 4
            nTargetCnt = nTmpNeighCount;  % Means all
        end
        
        if nImageCount ~= 4
            if nTmpNeighCount < nTargetCnt
                nTargetCnt = nTmpNeighCount;
            end
        end
        
        fprintf(fid_result,'%d,%.9f,%d,%d',preSender, preTime, nImageCount, nTargetCnt); 
        
        if nTargetCnt == 0  % 0 target
            for k=5:60
                fprintf(fid_result,',%d',-1); 
            end
        elseif nTargetCnt == nTmpNeighCount
            for k=1:nTmpNeighCount
                fprintf(fid_result,',%d',mTrace(nPreRowIdx,k+2));
            end
            for k=5+nTmpNeighCount:60
                 fprintf(fid_result,',%d',-1);
            end
        else
            mRetIdx = VT_getRandomIdx(nTmpNeighCount, nTargetCnt);
            for m=1:nTargetCnt
                fprintf( fid_result,',%d',mTrace( nPreRowIdx, mRetIdx(1,m)+2 )  );
            end
            for k=5+nTargetCnt:60
                 fprintf(fid_result,',%d',-1);
            end            
        end
            
        fprintf(fid_result,'\n');    
        
        preSender = curSender;
        preTime = curTime;
        nPreRowIdx = i;
        nImageCount = 1;
    else
        nImageCount = nImageCount + 1;
    end
        
end

%%% [Begin] Process the last sending event

nTmpNeighCount = 0;
for j=3:nCol
    if mTrace(nPreRowIdx,j) ~= -1
        nTmpNeighCount = nTmpNeighCount + 1;
    end
end

if nImageCount == 1
    nTargetCnt = 1;  
elseif nImageCount == 2
    nTargetCnt = 1; 
elseif nImageCount == 3
     fTmp = rand;
     if fTmp >= 0.66
         nTargetCnt = 3;  % =3
     else
         nTargetCnt = 2;  % 2
     end 
elseif nImageCount == 4
    nTargetCnt = nTmpNeighCount;  % Means all
end

if nImageCount ~= 4
    if nTmpNeighCount < nTargetCnt
        nTargetCnt = nTmpNeighCount;
    end
end

fprintf(fid_result,'%d,%.9f,%d,%d',preSender, preTime, nImageCount, nTargetCnt); 

if nTargetCnt == 0  % 0 target
    for k=5:60
        fprintf(fid_result,',%d',-1); 
    end
elseif nTargetCnt == nTmpNeighCount
    for k=1:nTmpNeighCount
        fprintf(fid_result,',%d',mTrace(nPreRowIdx,k+2));
    end
    for k=5+nTmpNeighCount:60
         fprintf(fid_result,',%d',-1);
    end
else
    mRetIdx = VT_getRandomIdx(nTmpNeighCount, nTargetCnt);
    for m=1:nTargetCnt
        fprintf(fid_result,',%d',mTrace(nPreRowIdx,mRetIdx(1,m)+2));
    end
    for k=5+nTargetCnt:60
         fprintf(fid_result,',%d',-1);
    end            
end

fprintf(fid_result,'\n');    


%%% [End]
        
fclose(fid_result);

f = 0;

return;

