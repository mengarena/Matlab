function f = SS_CalMapEvaluationResutl(sParentFolder)
%
% Recognized result:  0 -- Unknown;  1 -- Correct;  2 -- Wrong
%

format long;

RECOGNITION_UNKNOWN = 0;
RECOGNITION_CORRECT = 1;
RECOGNITION_WRONG = 2;

sFileNamePre_InStore = 'EvaluationResult_InStore';
sFileNamePre_OutStore = 'EvaluationResult_OutStore';

mEvalInStore = [];
mEvalOutStore = [];

Files = dir(sParentFolder);

for i=1:length(Files)
    sFileName = Files(i).name
    if  length(strfind(sFileName, sFileNamePre_InStore)) ~= 0
        sFileFullPath = [sParentFolder '\' Files(i).name];
        mTmpEvalInstore = SS_GetSingleFileEvaluationResult(sFileFullPath);
        mEvalInStore = [mEvalInStore; mTmpEvalInstore];
    elseif length(strfind(sFileName, sFileNamePre_OutStore)) ~= 0
        sFileFullPath = [sParentFolder '\' Files(i).name];
        mTmpEvalOutstore = SS_GetSingleFileEvaluationResult(sFileFullPath);
        mEvalOutStore = [mEvalOutStore; mTmpEvalOutstore];    
    end
end

[nTotalNumIn nCol] = size(mEvalInStore);

[nTotalNumOut nCol] = size(mEvalOutStore);

nTotalNumUnknownIn = 0;
nTotalNumCorrectIn = 0;
nTotalNumWrongIn = 0;

nTotalNumUnknownOut = 0;
nTotalNumCorrectOut = 0;
nTotalNumWrongOut = 0;

for i=1:nTotalNumIn
    if mEvalInStore(i,1) == RECOGNITION_UNKNOWN
        nTotalNumUnknownIn = nTotalNumUnknownIn + 1;
    end
    
    if mEvalInStore(i,1) == RECOGNITION_CORRECT
        nTotalNumCorrectIn = nTotalNumCorrectIn + 1;
    end

    if mEvalInStore(i,1) == RECOGNITION_WRONG
        nTotalNumWrongIn = nTotalNumWrongIn + 1;
    end  
end

for i=1:nTotalNumOut
    if mEvalOutStore(i,1) == RECOGNITION_UNKNOWN
        nTotalNumUnknownOut = nTotalNumUnknownOut + 1;
    end
    
    if mEvalOutStore(i,1) == RECOGNITION_CORRECT
        nTotalNumCorrectOut = nTotalNumCorrectOut + 1;
    end

    if mEvalOutStore(i,1) == RECOGNITION_WRONG
        nTotalNumWrongOut = nTotalNumWrongOut + 1;
    end  
end

mTotalResult = [];
mTotalResult(1,1) = nTotalNumCorrectIn*100.0/nTotalNumIn;
mTotalResult(1,2) = nTotalNumWrongIn*100.0/nTotalNumIn;
mTotalResult(1,3) = nTotalNumUnknownIn*100.0/nTotalNumIn;

mTotalResult(2,1) = nTotalNumCorrectOut*100.0/nTotalNumOut;
mTotalResult(2,2) = nTotalNumWrongOut*100.0/nTotalNumOut;
mTotalResult(2,3) = nTotalNumUnknownOut*100.0/nTotalNumOut;

mTotalResult(3,1) = (nTotalNumCorrectOut + nTotalNumCorrectIn)*100.0/(nTotalNumOut + nTotalNumIn);
mTotalResult(3,2) = (nTotalNumWrongOut + nTotalNumWrongIn)*100.0/(nTotalNumOut + nTotalNumIn);
mTotalResult(3,3) = (nTotalNumUnknownOut + nTotalNumUnknownIn)*100.0/(nTotalNumOut + nTotalNumIn);

mTotalResult(1,1)
mTotalResult(2,1)
mTotalResult(3,1)


% Plotting...:
screenSize = get(0, 'ScreenSize');

h1=figure('numbertitle', 'off', 'name', 'Performance of Place Recognition');

bar(mTotalResult, 1,'edgecolor','k', 'linewidth', 2); colormap(gray);

XTickTxt = {'In Store'; 'Out Store'; 'Overall'};

set(gca, 'FontName','Times New Roman');
set(gca, 'FontSize', 36)
        
set(gca, 'FontSize', 36)
set(gca, 'XTickLabel', XTickTxt);
set(gca,'YTick',0:10:100);
    
legend('Correct', 'Wrong', 'Unrecognized');
    
xlabelStr = 'Scenario';

xlabel(xlabelStr, 'FontSize', 50);
ylabel('Recognition Rate (%)', 'FontSize', 50);
set(gca,'ygrid','on');
ylim([0 100]);

set(0, 'DefaultFigurePosition', screenSize);



f = 0;

return;
