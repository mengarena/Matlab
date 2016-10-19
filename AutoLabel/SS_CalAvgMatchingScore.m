function f = SS_CalAvgMatchingScore(sFile)

format long;

fidRead = fopen(sFile);

matRecogResult = [];

nGroundTruthLine = 0; 
nCandidateLine = 0;

while 1
    sLine = fgetl(fidRead);
    if ~ischar(sLine)
        break;
    end
           
    if nGroundTruthLine == 0
        % Save Ground Truth names here
        GroundTruthPlaceNames = SS_SplitString(sLine, ',');
        nGroundTruthLine = 1;
        continue;
    end  
    
    if nCandidateLine == 0
        % Save Candidate place names here
        CandidatePlaceNames = SS_SplitString(sLine, ',');
        nCandidateLine = 1;
        continue;
    end
    
    % Process matching score lines and save in matRecogResult
    mRow = SS_SplitStringNum(sLine, ',');
    
    matRecogResult = [matRecogResult, mRow'];
   
end

fclose(fidRead);

[nRow nCol] = size(matRecogResult)

fTotalScore = 0;

for i=1:nRow
    fTotalScore = fTotalScore + matRecogResult(i,i);
end

fAvg = fTotalScore/nRow


return;
