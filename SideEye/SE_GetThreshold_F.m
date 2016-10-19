function f = SE_GetThreshold_F(matE, matR_10, matR_20, matR_30, matR_40, matR_50, matR_60, matR_70, matR_80, matR_90, matR_100, matR_Rest, WinTitle, xLabelTxt)
% Get the threshold a
% matE: variance of Empty road (without shadow)
% matR_x0: variance of road with vehicle which occupies x percent of the
% ROI
% matR_Rest: variance of the road with vehicle, where the head of the
% vehicle can't be seen (has cross the end line of the ROI), only the tail
% of the vehicle can be seen
% The threshold a meets the following conditions:
%                   1) Let as many as values in matE < a
%                   2) Let as many as values in other mat > a
%
% Use Macro-average F measure to determine the threshold
% The best threshold gets the max Macro-average F measure
%

% Combine matE and matS together
matES = [];  % Store the combined matrix

[r c] = size(matE);
for i=1:r
    matES(i,1) = matE(i, 1);
end

totalES = r;

maxES = max(matES);
minES = min(matES);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Combine vehicle related mat together
startIdx = 0;
matV = [];  % Store the combined matrix

% for matR_10
[r c] = size(matR_10);
for i=1:r
    matV(i,1) = matR_10(i, 1);
end

startIdx = r;

% for matR_20
[r c] = size(matR_20);
for i=1:r
    matV(i+startIdx,1) = matR_20(i, 1);
end

startIdx = startIdx + r;

% for matR_30
[r c] = size(matR_30);
for i=1:r
    matV(i+startIdx,1) = matR_30(i, 1);
end

startIdx = startIdx + r;

% for matR_40
[r c] = size(matR_40);
for i=1:r
    matV(i+startIdx,1) = matR_40(i, 1);
end

startIdx = startIdx + r;

% for matR_50
[r c] = size(matR_50);
for i=1:r
    matV(i+startIdx,1) = matR_50(i, 1);
end

startIdx = startIdx + r;

% for matR_60
[r c] = size(matR_60);
for i=1:r
    matV(i+startIdx,1) = matR_60(i, 1);
end

startIdx = startIdx + r;

% for matR_70
[r c] = size(matR_70);
for i=1:r
    matV(i+startIdx,1) = matR_70(i, 1);
end

startIdx = startIdx + r;

% for matR_80
[r c] = size(matR_80);
for i=1:r
    matV(i+startIdx,1) = matR_80(i, 1);
end

startIdx = startIdx + r;

% for matR_90
[r c] = size(matR_90);
for i=1:r
    matV(i+startIdx,1) = matR_90(i, 1);
end

startIdx = startIdx + r;

% for matR_100
[r c] = size(matR_100);
for i=1:r
    matV(i+startIdx,1) = matR_100(i, 1);
end

startIdx = startIdx + r;

% for matR_Rest
[r c] = size(matR_Rest);
for i=1:r
    matV(i+startIdx,1) = matR_Rest(i, 1);
end

startIdx = startIdx + r;

totalV = startIdx;

maxV = max(matV);
minV = min(matV);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
totalMax = max(maxES, maxV);
totalMin = min(minES, minV);

levels = 1000;
stepsize = (totalMax - totalMin)/levels;

statES = [];  % This matrix stores the threshold, number of value < threshold from Empty road (with/without shadow)
statV = []; % This matrix stores the threshold, number of value > threshold from Road with Vehicle

thresEvalMat = [];   % This matrix stores the threshold and the value of accES*accV/(accES+accV), the max value corresponds to the best threshold

thrsd = 0;

for i = 1:levels-1
    thrsd = totalMin + stepsize*i;
    
    % Calculate how many values in matES is < thrsd
    posNumES = 0;
    for j = 1:totalES
        if (matES(j,1) <= thrsd) 
            posNumES = posNumES + 1; 
        end
    end

    accES = posNumES/totalES; % Actually is recall
    
    statES(i,1) = thrsd;
    statES(i,2) = posNumES;
    statES(i,3) = totalES - posNumES;
    statES(i,4) = accES;
    
    % Calulate how many values in matV is > thrsd
    posNumV = 0;
    for k = 1:totalV
        if (matV(k,1) >= thrsd)
            posNumV = posNumV + 1;
        end
    end

    accV = posNumV/totalV; % Actually is recall
    
    statV(i,1) = thrsd;
    statV(i,2) = posNumV;
    statV(i,3) = totalV - posNumV;
    statV(i,4) = accV;
    
    thresEvalMat(i,1) = thrsd;
    thresEvalMat(i,2) = accES*accV/(accES + accV);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Calculate the F-measure for empty road and vehicle %%
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
    
    Fmacro = (Fe+Fv)/2;  % Macro-average F-measure
    
    thresEvalMat(i,3) = Fe;
    thresEvalMat(i,4) = Fv;
    thresEvalMat(i,5) = Fmacro;
end

%[thresEval, rowIdx] = max(thresEvalMat(:,2));  % Old version no F-measure
[thresEval, rowIdx] = max(thresEvalMat(:,5 ));

bestThreshold = thresEvalMat(rowIdx, 1);

disp('--------------------------------------');
disp(['Total Empty=',num2str(totalES)]);
disp(['Total Vehicle=',num2str(totalV)]);
disp(['Correctly Detected Empty=',num2str(statES(rowIdx,2))]);
disp(['Correctly Detected Vehicle=',num2str(statV(rowIdx,2))]);
disp(['min=',num2str(totalMin)]);
disp(['max=',num2str(totalMax)]);
disp(['step size=', num2str(stepsize)]);
disp(['Best Threshold=', num2str(bestThreshold)]);
disp(['Rate for Empty=', num2str(statES(rowIdx,4))]);
disp(['Rate for Vehicle=', num2str(statV(rowIdx,4))]);
disp('--------------------------------------');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plot 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure('numbertitle', 'off', 'name', WinTitle);
plot(thresEvalMat(:,1), thresEvalMat(:,5), 'LineWidth', 2);
ax1 = gca;
hx1 = get(ax1,'Xlabel');
hy1 = get(ax1,'Ylabel');
%set(hx1,'String','Threshold');
%set(hy1,'String','Macro-average F-Measure');
set(gca, 'FontSize', 14)
xlabel(xLabelTxt, 'FontSize', 18);
ylabel('Macro-average F-Measure', 'FontSize', 18);
set(gca, 'Ylim', [0 1]);

% Mark peak
[ymax, k] = max(thresEvalMat(:,5));

yAxis = get(gca,'ylim');

hold on
plot(thresEvalMat(k,1), thresEvalMat(k,5), '*r', 'LineWidth', 4);
%peakTxt = strcat('( ', num2str(thresEvalMat(k,1)) , ' , ' , num2str(thresEvalMat(k,5)) , ' )')
peakTxt = strcat('Threshold = ', num2str(thresEvalMat(k,1)));
text(thresEvalMat(k,1), thresEvalMat(k,5)+(yAxis(2)-yAxis(1))/100*3, peakTxt);
hold off

f = bestThreshold;

return;

