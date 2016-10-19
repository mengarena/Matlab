function f=Sky_ShowPhoneFocalRatio_Together(matRatio, nType)
% In the matRatio, the fields are:
% 1st: Which direction (1=rear, 2=left15,3=left30)
% 2nd: distance (10, 20, 25, 30, 35, 40, 45, 50, 55, 60, 70)

%%% 3~6:  ratio between Galaxy Nexus1 and Galaxy Nexus 2
% 3rd: number of matched points
% 4th: ratio of the two max matched point
% 5th: ratio of the average of all matched points
% 6th: ratio of the euclidian distances in each selected two points in each image

%%% 7~10:  ratio between Galaxy Nexus and Galaxy S4
% 7rd: number of matched points
% 8th: ratio of the two max matched point
% 9th: ratio of the average of all matched points
% 10th: ratio of the euclidian distances in each selected two points in each image

%%% 11~14:  ratio between Galaxy Nexus and iPhone 4S
% 11th: number of matched points
% 12th: ratio of the two max matched point
% 13th: ratio of the average of all matched points
% 14th: ratio of the euclidian distances in each selected two points in each image

% nType = 0:  Max Feature Point ratio
% nType = 1:  Average Feature Point ratio
% nType = 2:  Euclidian ratio
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[nRow nCol] = size(matRatio);

nSetRow = nRow/3;

if nType == 0   %Max
    disp('Max based Ratio');
    nColIdx = 4;
elseif nType == 1   %Average
    disp('Average based Ratio');
    nColIdx = 5;
else   % Euclidian distance
    disp('Euclidian Distance based Ratio');
    nColIdx = 6; 
end
    
% Calculate value range of Y axis
maxY_NN=max(matRatio(:,nColIdx));
maxY_NS4=max(matRatio(:,nColIdx+4));
maxY_N4S=max(matRatio(:,nColIdx+8));

fMargin = 0.2;  % Margin on Y axis


maxY_NN = fix(maxY_NN*100)/100 + fMargin;
maxY_NS4 = fix(maxY_NS4*100)/100 + fMargin;
maxY_N4S = fix(maxY_N4S*100)/100 + fMargin;

tmpMatNN = [];
tmpMatNS4 = [];
tmpMatN4S = [];
for i=1:nRow
    tmpMatNN(i,1) = matRatio(i,nColIdx);
    tmpMatNS4(i,1) = matRatio(i,nColIdx+4);
    tmpMatN4S(i,1) = matRatio(i,nColIdx+8);
end

t=tmpMatNN(:,1);
t(~t)=Inf;
minY_NN=min(t);

t=tmpMatNS4(:,1);
t(~t)=Inf;
minY_NS4=min(t);

t=tmpMatN4S(:,1);
t(~t)=Inf;
minY_N4S=min(t);

minY_NN = fix(minY_NN*100)/100 - fMargin;
minY_NS4 = fix(minY_NS4*100)/100 - fMargin;
minY_N4S = fix(minY_N4S*100)/100 - fMargin;

nMaxCnt = 0;
% Calculate value range of X axis
for i=1:3
    nTmpCnt = 0;
    for j=1:nSetRow
        if (matRatio((i-1)*nSetRow+j,nColIdx) ~= 0) || (matRatio((i-1)*nSetRow+j,nColIdx+4) ~= 0) || (matRatio((i-1)*nSetRow+j,nColIdx+8) ~= 0)
            nTmpCnt = nTmpCnt + 1;
        end
    end
    
    if nTmpCnt > nMaxCnt
        nMaxCnt = nTmpCnt;
    end
end

nMaxX = matRatio(nMaxCnt, 2);
nMinX = 10;
nStepX = 5;

fTickStep = 0.1;

% Calculate average
avgNN = 0.0;
avgNS4 = 0.0;
avgN4S = 0.0;
nNN = 0;
nNS4 = 0;
nN4S = 0;

for i=1:nRow
    if matRatio(i, nColIdx) ~= 0
        nNN = nNN + 1;
        avgNN = avgNN + matRatio(i, nColIdx);
    end

    if matRatio(i, nColIdx+4) ~= 0
        nNS4 = nNS4 + 1;
        avgNS4 = avgNS4 + matRatio(i, nColIdx+4);
    end
    
    if matRatio(i, nColIdx+8) ~= 0
        nN4S = nN4S + 1;
        avgN4S = avgN4S + matRatio(i, nColIdx+8);
    end 
end

avgNN = avgNN/nNN;
avgNN = fix(avgNN*1000)/1000

avgNS4 = avgNS4/nNS4;
avgNS4 = fix(avgNS4*1000)/1000

avgN4S = avgN4S/nN4S;
avgN4S = fix(avgN4S*1000)/1000

%figure(1); % Ratio of Euclidian distance
figure('numbertitle', 'off', 'name', 'Ratio of Smartphone Camera Focal Length (based on Euclidian distance of matche points)');  
set(gca, 'FontSize', 18);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Plot Ratio of Galaxy Nexus ~ Galaxy Nexus
nStartRow = 1;
nEndRow = nSetRow;
subplot(1,3,1);
x=matRatio(nStartRow:nEndRow, 2);
y=matRatio(nStartRow:nEndRow, nColIdx);
maxY = max(y);
y(~y)=Inf;
minY = min(y);
plot(x, y,'r','LineWidth',2);
hold on;

nStartRow = nSetRow+1;
nEndRow = nSetRow*2;
x=matRatio(nStartRow:nEndRow, 2);
y=matRatio(nStartRow:nEndRow, nColIdx);
maxY = max(y);
y(~y)=Inf;
minY = min(y);
plot(x, y, 'g','LineWidth',2);
hold on;

nStartRow = nSetRow*2+1;
nEndRow = nSetRow*3;
x=matRatio(nStartRow:nEndRow, 2);
y=matRatio(nStartRow:nEndRow, nColIdx);
maxY = max(y);
y(~y)=Inf;
minY = min(y);
plot(x, y,'b','LineWidth',2);
hold on;

plot([nMinX nMaxX], [avgNN avgNN],'LineWidth',3, 'Color',[0 0 0]);
text(nMaxX-5, avgNN+0.015, sprintf('%.3f', avgNN), 'FontSize', 18);
ylim([minY_NN maxY_NN]);
set(gca,'ytick',minY_NN:fTickStep:maxY_NN);
xlim([nMinX nMaxX]);
set(gca,'xtick',nMinX:nStepX:nMaxX, 'FontSize', 18);
xlabelStr = 'Distance between vehicles (m)';
xlabel(xlabelStr, 'FontSize', 18);
ylabel('Ratio', 'FontSize', 18);
%legend('Rear','Left15', 'Left30','Mean');
title(gca, 'Focal Ratio of Galaxy Nexus 1 vs. Galaxy Nexus 2','FontSize', 18);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Plot Ratio of Galaxy Nexus ~ Galaxy S4
nStartRow = 1;
nEndRow = nSetRow;
subplot(1,3,2);
x=matRatio(nStartRow:nEndRow, 2);
y=matRatio(nStartRow:nEndRow, nColIdx+4);
maxY = max(y);
y(~y)=Inf;
minY = min(y);
plot(x, y,'r','LineWidth',2);
hold on;

nStartRow = nSetRow+1;
nEndRow = nSetRow*2;
x=matRatio(nStartRow:nEndRow, 2);
y=matRatio(nStartRow:nEndRow, nColIdx+4);
maxY = max(y);
y(~y)=Inf;
minY = min(y);
plot(x, y, 'g','LineWidth',2);
hold on;

nStartRow = nSetRow*2+1;
nEndRow = nSetRow*3;
x=matRatio(nStartRow:nEndRow, 2);
y=matRatio(nStartRow:nEndRow, nColIdx+4);
maxY = max(y);
y(~y)=Inf;
minY = min(y);
plot(x, y,'b','LineWidth',2);

hold on;
plot([nMinX nMaxX], [avgNS4 avgNS4],'LineWidth',3, 'Color',[0 0 0]);
text(nMaxX-5, avgNS4+0.015, sprintf('%.3f', avgNS4), 'FontSize', 18);
ylim([minY_NS4 maxY_NS4]);
set(gca,'ytick',minY_NS4:fTickStep:maxY_NS4);
xlim([nMinX nMaxX]);
set(gca,'xtick',nMinX:nStepX:nMaxX, 'FontSize', 18);
xlabelStr = 'Distance between vehicles (m)';
xlabel(xlabelStr, 'FontSize', 18);
ylabel('Ratio', 'FontSize', 18);
legend('Rear','Left15', 'Left30','Mean');
title(gca, 'Focal Ratio of Galaxy Nexus vs. Galaxy S4','FontSize', 18);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Plot Ratio of Galaxy Nexus ~ iPhone 4S

nStartRow = 1;
nEndRow = nSetRow;

subplot(1,3,3);
x=matRatio(nStartRow:nEndRow, 2);
y=matRatio(nStartRow:nEndRow, nColIdx+8);
maxY = max(y);
y(~y)=Inf;
minY = min(y);
plot(x, y, 'r','LineWidth',2);
hold on;

nStartRow = nSetRow+1;
nEndRow = nSetRow*2;
x=matRatio(nStartRow:nEndRow, 2);
y=matRatio(nStartRow:nEndRow, nColIdx+8);
maxY = max(y);
y(~y)=Inf;
minY = min(y);
plot(x, y,'g','LineWidth',2);
hold on;

nStartRow = nSetRow*2+1;
nEndRow = nSetRow*3;
x=matRatio(nStartRow:nEndRow, 2);
y=matRatio(nStartRow:nEndRow, nColIdx+8);
maxY = max(y);
y(~y)=Inf;
minY = min(y);
plot(x, y,'b','LineWidth',2);
hold on;

plot([nMinX nMaxX], [avgN4S avgN4S],'LineWidth',3, 'Color',[0 0 0]);
text(nMaxX-5, avgN4S+0.015, sprintf('%.3f',avgN4S), 'FontSize', 18);
ylim([minY_N4S maxY_N4S]);
set(gca,'ytick',minY_N4S:fTickStep:maxY_N4S);
xlim([nMinX nMaxX]);
set(gca,'xtick',nMinX:nStepX:nMaxX, 'FontSize', 18);
xlabelStr = 'Distance between vehicles (m)';
xlabel(xlabelStr, 'FontSize', 18);
ylabel('Ratio', 'FontSize', 18);
title(gca, 'Focal Ratio of Galaxy Nexus vs. iPhone 4S', 'FontSize', 18);


f = 0;

return;

