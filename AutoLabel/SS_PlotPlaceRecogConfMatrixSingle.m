function f = SS_PlotPlaceRecogConfMatrixSingle(sFile, sTitle)
% In this plotting, if the cell value is 0.0,  it will show it as 0.000. (This is the difference from SS_PlotPlaceRecogConfMatrix)
%

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

% Normalized over column (i.e. it tells for a store, finally, it is recognized as what store)
matRecogResultNorm = [];

% % Normalized over row
% for i=1:nRow
%     fMax = max(matRecogResult(i,:));
%     mRow = [];
%     
%     if fMax == 0
%         mRow = zeros(1, nCol);
%     else
%         for j=1:nCol
%             mRow(j) = matRecogResult(i,j)/fMax;
%         end
%     end
%     
%     matRecogResultNorm = [matRecogResultNorm; mRow];
% end

for i=1:nCol
    fMax = max(matRecogResult(:,i))
    mCol = [];
    
    if fMax == 0
        mCol = zeros(1,nRow);
    else
        for j=1:nRow
            mCol(j) = matRecogResult(j,i)/fMax;
        end

    end
        
    matRecogResultNorm = [matRecogResultNorm mCol'];
end


xTicks = GroundTruthPlaceNames;
yTicks = CandidatePlaceNames;

xLabels = 'Stores';
yLabels = 'Store Webs';
%figure(1);

SS_PlotConfusionSingle(matRecogResult, xLabels, xTicks, yLabels, yTicks, sTitle, 1);
SS_PlotConfusionSingle(matRecogResultNorm, xLabels, xTicks, yLabels, yTicks, sTitle, 2);

hold on;

return;
