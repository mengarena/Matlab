function f = SE_GetThreshold_forCham(matE, matS, matR_10, matR_20, matR_30, matR_40, matR_50, matR_60, matR_70, matR_80, matR_90, matR_100, matR_Rest)
% Get the threshold a
% matE: variance of Empty road (without shadow)
% matS: variance of Empty road (with shadow)
% matR_x0: variance of road with vehicle which occupies x percent of the
% ROI
% matR_Rest: variance of the road with vehicle, where the head of the
% vehicle can't be seen (has cross the end line of the ROI), only the tail
% of the vehicle can be seen
% The threshold a meets the following conditions:
%                   1) Let as many as values in matE, matS < a
%                   2) Let as many as values in other mat > a
%
%

% Combine matE and matS together
matES = [];  % Store the combined matrix

[r c] = size(matE);
for i=1:r
    matES(i,1) = matE(i, 1);
end

[r1 c1] = size(matS);
for i=1:r1
    matES(i+r,1) = matS(i,1);
end

totalES = r + r1;

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

for i = 1:levels
    thrsd = totalMin + stepsize*i;
    
    % Calculate how many values in matES is < thrsd
    posNumES = 0;
    for j = 1:totalES
        if (matES(j,1) >= thrsd) 
            posNumES = posNumES + 1; 
        end
    end

    accES = posNumES/totalES;
    
    statES(i,1) = thrsd;
    statES(i,2) = posNumES;
    statES(i,3) = totalES - posNumES;
    statES(i,4) = accES;
    
    % Calulate how many values in matV is > thrsd
    posNumV = 0;
    for k = 1:totalV
        if (matV(k,1) <= thrsd)
            posNumV = posNumV + 1;
        end
    end

    accV = posNumV/totalV;
    
    statV(i,1) = thrsd;
    statV(i,2) = posNumV;
    statV(i,3) = totalV - posNumV;
    statV(i,4) = accV;
    
    thresEvalMat(i,1) = thrsd;
    thresEvalMat(i,2) = accES*accV/(accES + accV)

end

[thresEval, rowIdx] = max(thresEvalMat(:,2));

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

f = bestThreshold;

return;

