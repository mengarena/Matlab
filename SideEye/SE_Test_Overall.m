function f = SE_Test_Overall()
% Overall test
% Get Accuracy, Macro-average Precision, Recall, F-Measure
%
%

matAccu = [];
matMacroPrecision = [];
matMacroRecall = [];
matMacroFmeasure = [];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
thrsd = 35.1845;  % Threshold for Simple Intensity scheme

SI_empty = evalin('base', 'SI_empty');
SI_emptyshadow = evalin('base', 'SI_emptyshadow');
SI_10p = evalin('base', 'SI_10p');
SI_20p = evalin('base', 'SI_20p');
SI_30p = evalin('base', 'SI_30p');
SI_40p = evalin('base', 'SI_40p');
SI_50p = evalin('base', 'SI_50p');
SI_60p = evalin('base', 'SI_60p');
SI_70p = evalin('base', 'SI_70p');
SI_80p = evalin('base', 'SI_80p');
SI_90p = evalin('base', 'SI_90p');
SI_100p = evalin('base', 'SI_100p');
SI_rest = evalin('base', 'SI_rest');

SI_Overall = SE_Test_ROI_Category_Intensity(SI_empty, SI_emptyshadow, SI_10p, SI_20p, SI_30p, SI_40p, SI_50p, SI_60p, SI_70p, SI_80p, SI_90p, SI_100p, SI_rest, 'Rate of Detection on Each Category of ROI (Simple Intensity)', thrsd);

matAccu(1,1) = SI_Overall(1,1);
matMacroPrecision(1,1) = SI_Overall(1,2);
matMacroRecall(1,1) = SI_Overall(1,3);
matMacroFmeasure(1,1) = SI_Overall(1,4);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

thrsd = 46.1391;  % Threshold for WARP scheme

WARP_empty = evalin('base', 'WARP_empty');
WARP_emptyshadow = evalin('base', 'WARP_emptyshadow');
WARP_10p = evalin('base', 'WARP_10p');
WARP_20p = evalin('base', 'WARP_20p');
WARP_30p = evalin('base', 'WARP_30p');
WARP_40p = evalin('base', 'WARP_40p');
WARP_50p = evalin('base', 'WARP_50p');
WARP_60p = evalin('base', 'WARP_60p');
WARP_70p = evalin('base', 'WARP_70p');
WARP_80p = evalin('base', 'WARP_80p');
WARP_90p = evalin('base', 'WARP_90p');
WARP_100p = evalin('base', 'WARP_100p');
WARP_rest = evalin('base', 'WARP_rest');

WARP_Overall = SE_Test_ROI_Category_Intensity(WARP_empty, WARP_emptyshadow, WARP_10p, WARP_20p, WARP_30p, WARP_40p, WARP_50p, WARP_60p, WARP_70p, WARP_80p, WARP_90p, WARP_100p, WARP_rest, 'Rate of Detection on Each Category of ROI (Warping)', thrsd);

matAccu(1,2) = WARP_Overall(1,1);
matMacroPrecision(1,2) = WARP_Overall(1,2);
matMacroRecall(1,2) = WARP_Overall(1,3);
matMacroFmeasure(1,2) = WARP_Overall(1,4);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

thrsd = 0.19845;  % Threshold for CHAM scheme

CHAM_empty = evalin('base', 'CHAM_empty');
CHAM_emptyshadow = evalin('base', 'CHAM_emptyshadow');
CHAM_10p = evalin('base', 'CHAM_10p');
CHAM_20p = evalin('base', 'CHAM_20p');
CHAM_30p = evalin('base', 'CHAM_30p');
CHAM_40p = evalin('base', 'CHAM_40p');
CHAM_50p = evalin('base', 'CHAM_50p');
CHAM_60p = evalin('base', 'CHAM_60p');
CHAM_70p = evalin('base', 'CHAM_70p');
CHAM_80p = evalin('base', 'CHAM_80p');
CHAM_90p = evalin('base', 'CHAM_90p');
CHAM_100p = evalin('base', 'CHAM_100p');
CHAM_rest = evalin('base', 'CHAM_rest');

CHAM_Overall = SE_Test_ROI_Category_Cham(CHAM_empty, CHAM_emptyshadow, CHAM_10p, CHAM_20p, CHAM_30p, CHAM_40p, CHAM_50p, CHAM_60p, CHAM_70p, CHAM_80p, CHAM_90p, CHAM_100p, CHAM_rest, 'Rate of Detection on Each Category of ROI (Chamfer Matching)', thrsd);

matAccu(1,3) = CHAM_Overall(1,1);
matMacroPrecision(1,3) = CHAM_Overall(1,2);
matMacroRecall(1,3) = CHAM_Overall(1,3);
matMacroFmeasure(1,3) = CHAM_Overall(1,4);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% For Hybrid Scheme
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
matHybrid = evalin('base', 'Hybrid1');

Hybrid_Overall = SE_Test_ROI_Category_Hybrid(matHybrid);

matAccu(1,4) = Hybrid_Overall(1,1);
matMacroPrecision(1,4) = Hybrid_Overall(1,2);
matMacroRecall(1,4) = Hybrid_Overall(1,3);
matMacroFmeasure(1,4) = Hybrid_Overall(1,4);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plot Accuracy
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
XTickTxt = {'Intensity Variation'; 'Warping'; 'Chamfer Matching'; 'Hybrid'};
figure(1);
figure('numbertitle', 'off', 'name', 'Accuracy');
%plot(thresEvalMat(:,1), thresEvalMat(:,5), 'LineWidth', 2);
bar(matAccu(1,:));
set(gca, 'FontSize', 14)
set(gca, 'XTickLabel', XTickTxt);
xlabel('Scheme', 'FontSize', 18);
ylabel('Accuracy', 'FontSize', 18);
set(gca, 'Ylim', [0 1]);

yAxis = get(gca,'Ylim');
hold on
for i=1:4
    text(i, matAccu(1,i)+(yAxis(2)-yAxis(1))/100*3, num2str(matAccu(1,i)));
end
hold off


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plot Macro-average Precision
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(2);
figure('numbertitle', 'off', 'name', 'Macro-average Precision');
%plot(thresEvalMat(:,1), thresEvalMat(:,5), 'LineWidth', 2);
bar(matMacroPrecision(1,:));
set(gca, 'FontSize', 14)
set(gca, 'XTickLabel', XTickTxt);
xlabel('Scheme', 'FontSize', 18);
ylabel('Macro-average Precision', 'FontSize', 18);
set(gca, 'Ylim', [0 1]);

yAxis = get(gca,'Ylim');
hold on
for i=1:4
    text(i, matMacroPrecision(1,i)+(yAxis(2)-yAxis(1))/100*3, num2str(matMacroPrecision(1,i)));
end
hold off

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plot Macro-average Recall
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%XTickTxt = {'Intensity'; 'Warp'; 'Chamfer Matching'};
figure(3);
figure('numbertitle', 'off', 'name', 'Macro-average Recall');
%plot(thresEvalMat(:,1), thresEvalMat(:,5), 'LineWidth', 2);
bar(matMacroRecall(1,:));
set(gca, 'FontSize', 14)
set(gca, 'XTickLabel', XTickTxt);
xlabel('Scheme', 'FontSize', 18);
ylabel('Macro-average Recall', 'FontSize', 18);
set(gca, 'Ylim', [0 1]);

yAxis = get(gca,'Ylim');
hold on
for i=1:4
    text(i, matMacroRecall(1,i)+(yAxis(2)-yAxis(1))/100*3, num2str(matMacroRecall(1,i)));
end
hold off

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plot Macro-average F-measure
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%XTickTxt = {'Intensity'; 'Warp'; 'Chamfer Matching'};
figure(4);
figure('numbertitle', 'off', 'name', 'Macro-average F-measure');
%plot(thresEvalMat(:,1), thresEvalMat(:,5), 'LineWidth', 2);
bar(matMacroFmeasure(1,:));
set(gca, 'FontSize', 14)
set(gca, 'XTickLabel', XTickTxt);
xlabel('Scheme', 'FontSize', 18);
ylabel('Macro-average F-measure', 'FontSize', 18);
set(gca, 'Ylim', [0 1]);

yAxis = get(gca,'Ylim');
hold on
for i=1:4
    text(i, matMacroFmeasure(1,i)+(yAxis(2)-yAxis(1))/100*3, num2str(matMacroFmeasure(1,i)));
end
hold off


matAccu
matMacroPrecision
matMacroRecall
matMacroFmeasure

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plot all together
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

overallMacro = [];
% overallMacro(1,1) = matMacroPrecision(1,1);
% overallMacro(1,2) = matMacroPrecision(1,2);
% overallMacro(1,3) = matMacroPrecision(1,3);
% 
% overallMacro(2,1) = matMacroRecall(1,1);
% overallMacro(2,2) = matMacroRecall(1,2);
% overallMacro(2,3) = matMacroRecall(1,3);
% 
% overallMacro(3,1) = matMacroFmeasure(1,1);
% overallMacro(3,2) = matMacroFmeasure(1,2);
% overallMacro(3,3) = matMacroFmeasure(1,3);
% 
overallMacro(1,1) = SI_Overall(1,1);
overallMacro(1,2) = SI_Overall(1,2);
overallMacro(1,3) = SI_Overall(1,3);
overallMacro(1,4) = SI_Overall(1,4);

overallMacro(2,1) = WARP_Overall(1,1);
overallMacro(2,2) = WARP_Overall(1,2);
overallMacro(2,3) = WARP_Overall(1,3);
overallMacro(2,4) = WARP_Overall(1,4);

overallMacro(3,1) = CHAM_Overall(1,1);
overallMacro(3,2) = CHAM_Overall(1,2);
overallMacro(3,3) = CHAM_Overall(1,3);
overallMacro(3,4) = CHAM_Overall(1,4);

overallMacro(4,1) = Hybrid_Overall(1,1);
overallMacro(4,2) = Hybrid_Overall(1,2);
overallMacro(4,3) = Hybrid_Overall(1,3);
overallMacro(4,4) = Hybrid_Overall(1,4);

figure(5);
figure('numbertitle', 'off', 'name', 'Overall Evalution (Macro-average)');
%plot(thresEvalMat(:,1), thresEvalMat(:,5), 'LineWidth', 2);
bar(overallMacro);
set(gca, 'FontSize', 14)
set(gca, 'XTickLabel', XTickTxt);
legend('Accuracy', 'Precision','Recall', 'F-measure');
xlabel('Scheme', 'FontSize', 18);
ylabel('Overall Measurement', 'FontSize', 18);
set(gca, 'Ylim', [0 1]);

f = 0;

return;
