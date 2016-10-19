function f = SS_PlotPlaceRecogConfMatrix(sFile)
% In this plotting, if the cell value is 0.0,  it will leave it blank. (This is the difference from SS_PlotPlaceRecogConfMatrixSingle)
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

[nRow nCol] = size(matRecogResult);

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
    fMax = max(matRecogResult(:,i));
    mCol = [];
    
    if fMax == 0
        mCol = zeros(nRow, 1);
    else
        for j=1:nRow
            mCol(j) = matRecogResult(j,i)/fMax;
        end
    end
    
    matRecogResultNorm = [matRecogResultNorm mCol'];
end

[a b] = size(matRecogResultNorm)


xTicks = GroundTruthPlaceNames;
yTicks = CandidatePlaceNames;

xLabels = 'Ground Truth Place';
yLabels = 'Predicted Place';

nFontSizeTitleAxis = 30;
nFontSizeContent = 26;

%subplot(1,2,1);
SS_PlotConfusion(matRecogResult, xLabels, xTicks, yLabels, yTicks, 'Place Recognition Confusion Matrix', 1, nFontSizeTitleAxis, nFontSizeContent);
hold on;

%subplot(1,2,2);
SS_PlotConfusion(matRecogResultNorm, xLabels, xTicks, yLabels, yTicks, 'Place Recognition Confusion Matrix (Normalized)', 2, nFontSizeTitleAxis, nFontSizeContent);

return;
