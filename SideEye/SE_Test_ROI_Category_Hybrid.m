function f = SE_Test_ROI_Category_Hybrid(matHybrid)
% Show Detection Rate for each category of ROI for Hybrid Scheme
%
% In matHybrid, the 1st column is the total frames of each category
% the 2nd column is the number of frames correctly detected.
%

[r c] = size(matHybrid);

matDetectionRate = [];

for i=1:r
    matDetectionRate(i,1) = matHybrid(i,2)*100/matHybrid(i,1);
end

posNumES = 0;
totalES = 0;
posNumV = 0;
totalV = 0;

for i=1:2    % Empty & Shadow
    posNumES = posNumES + matHybrid(i,2);
    totalES = totalES + matHybrid(i,1);
end

for i=3:r    % Vehicle
    posNumV = posNumV + matHybrid(i,2); 
    totalV = totalV + matHybrid(i,1);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calculate the Accuracy, Precision, Recall, F-measure 
% for empty road and vehicle %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
TPe = posNumES;
FPe = totalV - posNumV;
FNe = totalES - posNumES;
TNe = posNumV;

TPv = posNumV;
FPv = totalES - posNumES;
FNv = totalV - posNumV;
TNv = posNumES;

Pe = TPe/(TPe + FPe);   % Precision for empty road
Re = TPe/(TPe + FNe);   % Recall for empty road

Pv = TPv/(TPv + FPv);   % Precision for vehicle
Rv = TPv/(TPv + FNv);   % Recall for vehicle

if (Pe+Re == 0)
    Fe = 0;
else
    Fe = 2*Pe*Re/(Pe+Re);  %F-Measure for empty road
end

if (Pv+Rv == 0)
    Fv = 0;
else
    Fv = 2*Pv*Rv/(Pv+Rv);  %F-Measure for vehicle
end

Accu = (posNumES + posNumV)/(totalES + totalV);  % Accuracy

Pmacro = (Pe+Pv)/2;  % Macro-average Precision
Rmacro = (Re+Rv)/2;  % Macro-average Recall
Fmacro = (Fe+Fv)/2;  % Macro-average F-measure


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plot Detection Rate of Each Category
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
XTickTxt = {'Empty'; 'Shadow'; '10%'; '20%'; '30%'; '40%'; '50%'; '60%'; '70%'; '80%'; '90%'; '100%'; 'Rest'};
figure('numbertitle', 'off', 'name', 'Rate of Detection on Each Category of ROI (Hybrid)');
%plot(thresEvalMat(:,1), thresEvalMat(:,5), 'LineWidth', 2);
bar(matDetectionRate(:,1));
set(gca, 'FontSize', 14)
set(gca, 'XTickLabel', XTickTxt);
xlabel('Category of ROI', 'FontSize', 18);
ylabel('% of Detection (Hybrid)', 'FontSize', 18);

f = [Accu Pmacro Rmacro Fmacro];

return;
