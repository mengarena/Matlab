function f = SS_GetSingleFileEvaluationResult(sEvaluationResultFile)
% In the file, each line:
%   Evaluation Result, Matching score, Recognized Place Name, Ground Truth Name, <MAC, RSS>....
%
fidRead = fopen(sEvaluationResultFile);

matPlaceRegResult = [];

nIdx = 0;

while 1
    sLine = fgetl(fidRead);
    if ~ischar(sLine)
        break;
    end
           
    EvalFields = SS_SplitString(sLine, ',');
    
    nIdx = nIdx + 1;
    
    matPlaceRegResult(nIdx, 1) = str2num(EvalFields{1});  % Evaluttion Result
    matPlaceRegResult(nIdx, 2) = str2num(EvalFields{2});  % Matching score
    
end

fclose(fidRead);

f = matPlaceRegResult;

return;

