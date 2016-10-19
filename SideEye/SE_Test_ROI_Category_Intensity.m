function f = SE_Test_ROI_Category_Intensity(matE, matS, matR_10, matR_20, matR_30, matR_40, matR_50, matR_60, matR_70, matR_80, matR_90, matR_100, matR_Rest, WinTitle, thrsd)
% Measure the percentage in each category by the threshold to check % of
% correctly detected for Intensity w/wo Warping
% matE: variance of Empty road (without shadow)
% matS: variance of Empty road (with shadow)
% matR_x0: variance of road with vehicle which occupies x percent of the
% ROI
% matR_Rest: variance of the road with vehicle, where the head of the
% vehicle can't be seen (has cross the end line of the ROI), only the tail
% of the vehicle can be seen
% The threshold a meets the following conditions:
%                   1) Let as many as values in matE, matS < thrsd
%                   2) Let as many as values in other mat > thrsd
%
%


detectedRate = [];

% Combine matE and matS together
matES = [];  % Store the combined matrix

[r c] = size(matE);
detectedNum = 0;
for i=1:r
    if (matE(i, 1) <= thrsd)
        detectedNum = detectedNum + 1;
    end
    matES(i,1) = matE(i, 1);
end

detectedRate(1,1) = detectedNum*100/r;

[r1 c1] = size(matS);
detectedNum = 0;
for i=1:r1
    if (matS(i,1) <= thrsd)
        detectedNum = detectedNum + 1;
    end
    matES(i+r,1) = matS(i,1);
end

detectedRate(2,1) = detectedNum*100/r1;

totalES = r + r1;

%maxES = max(matES);
%minES = min(matES);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Combine vehicle related mat together
startIdx = 0;
matV = [];  % Store the combined matrix

% for matR_10
[r c] = size(matR_10);
detectedNum = 0;
for i=1:r
    if (matR_10(i, 1) >= thrsd)
        detectedNum = detectedNum + 1;
    end
    
    matV(i,1) = matR_10(i, 1);
end

detectedRate(3,1) = detectedNum*100/r;

startIdx = r;

% for matR_20
[r c] = size(matR_20);
detectedNum = 0;
for i=1:r
    if (matR_20(i, 1) >= thrsd)
        detectedNum = detectedNum + 1;
    end
    
    matV(i+startIdx,1) = matR_20(i, 1);
end

detectedRate(4,1) = detectedNum*100/r;

startIdx = startIdx + r;

% for matR_30
[r c] = size(matR_30);
detectedNum = 0;
for i=1:r
    if (matR_30(i, 1) >= thrsd)
        detectedNum = detectedNum + 1;
    end
    
    matV(i+startIdx,1) = matR_30(i, 1);
end

detectedRate(5,1) = detectedNum*100/r;

startIdx = startIdx + r;

% for matR_40
[r c] = size(matR_40);
detectedNum = 0;
for i=1:r
    if (matR_40(i, 1) >= thrsd)
        detectedNum = detectedNum + 1;
    end    
    
    matV(i+startIdx,1) = matR_40(i, 1);
end

detectedRate(6,1) = detectedNum*100/r;

startIdx = startIdx + r;

% for matR_50
[r c] = size(matR_50);
detectedNum = 0;
for i=1:r
    if (matR_50(i, 1) >= thrsd)
        detectedNum = detectedNum + 1;
    end    
    
    matV(i+startIdx,1) = matR_50(i, 1);
end

detectedRate(7,1) = detectedNum*100/r;

startIdx = startIdx + r;

% for matR_60
[r c] = size(matR_60);
detectedNum = 0;
for i=1:r
    if (matR_60(i, 1) >= thrsd)
        detectedNum = detectedNum + 1;
    end    
    
    matV(i+startIdx,1) = matR_60(i, 1);
end

detectedRate(8,1) = detectedNum*100/r;

startIdx = startIdx + r;

% for matR_70
[r c] = size(matR_70);
detectedNum = 0;
for i=1:r
    if (matR_70(i, 1) >= thrsd)
        detectedNum = detectedNum + 1;
    end    
    
    matV(i+startIdx,1) = matR_70(i, 1);
end

detectedRate(9,1) = detectedNum*100/r;

startIdx = startIdx + r;

% for matR_80
[r c] = size(matR_80);
detectedNum = 0;
for i=1:r
    if (matR_80(i, 1) >= thrsd)
        detectedNum = detectedNum + 1;
    end    
    
    matV(i+startIdx,1) = matR_80(i, 1);
end

detectedRate(10,1) = detectedNum*100/r;

startIdx = startIdx + r;

% for matR_90
[r c] = size(matR_90);
detectedNum = 0;
for i=1:r
    if (matR_90(i, 1) >= thrsd)
        detectedNum = detectedNum + 1;
    end    
    
    matV(i+startIdx,1) = matR_90(i, 1);
end

detectedRate(11,1) = detectedNum*100/r;

startIdx = startIdx + r;

% for matR_100
[r c] = size(matR_100);
detectedNum = 0;
for i=1:r
    if (matR_100(i, 1) >= thrsd)
        detectedNum = detectedNum + 1;
    end    
    
    matV(i+startIdx,1) = matR_100(i, 1);
end

detectedRate(12,1) = detectedNum*100/r;

startIdx = startIdx + r;

% for matR_Rest
[r c] = size(matR_Rest);
detectedNum = 0;
for i=1:r
    if (matR_Rest(i, 1) >= thrsd)
        detectedNum = detectedNum + 1;
    end    
    
    matV(i+startIdx,1) = matR_Rest(i, 1);
end

detectedRate(13,1) = detectedNum*100/r;

startIdx = startIdx + r;

totalV = startIdx;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

statES = [];  % This matrix stores the threshold, number of value < threshold from Empty road (with/without shadow)
statV = []; % This matrix stores the threshold, number of value > threshold from Road with Vehicle

thresEvalMat = [];   % This matrix stores the threshold and the value of accES*accV/(accES+accV), the max value corresponds to the best threshold

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

Accu = (posNumES + posNumV)/(totalES + totalV);  % Accuracy

Pmacro = (Pe+Pv)/2;  % Macro-average Precision
Rmacro = (Re+Rv)/2;  % Macro-average Recall
Fmacro = (Fe+Fv)/2;  % Macro-average F-measure


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plot 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
XTickTxt = {'Empty'; 'Shadow'; '10%'; '20%'; '30%'; '40%'; '50%'; '60%'; '70%'; '80%'; '90%'; '100%'; 'Rest'};
figure('numbertitle', 'off', 'name', WinTitle);
%plot(thresEvalMat(:,1), thresEvalMat(:,5), 'LineWidth', 2);
bar(detectedRate(:,1));
set(gca, 'FontSize', 14)
set(gca, 'XTickLabel', XTickTxt);
xlabel('Category of ROI', 'FontSize', 18);
ylabel('% of Detection', 'FontSize', 18);

f = [Accu Pmacro Rmacro Fmacro];

return;

