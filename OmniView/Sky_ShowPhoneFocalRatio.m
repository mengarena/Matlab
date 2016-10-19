function f=ShowPhoneFocalRatio(matRatio)
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

[nRow nCol] = size(matRatio);

nSetRow = nRow/3;

nColIdx = 6;  % Euclidian distance
% Calculate value range of Y axis
maxY_NS4=max(matRatio(:,nColIdx));
maxY_N4S=max(matRatio(:,nColIdx+4));

fMargin = 0.25;

maxY_NS4 = fix(maxY_NS4*100)/100 + fMargin;
maxY_N4S = fix(maxY_N4S*100)/100 + fMargin;

tmpMatNS4 = [];
tmpMatN4S = [];
for i=1:nRow
    tmpMatNS4(i,1)=matRatio(i,nColIdx);
    tmpMatN4S(i,1)=matRatio(i,nColIdx+4);
end

t=tmpMatNS4(:,1);
t(~t)=Inf;
minY_NS4=min(t);

t=tmpMatN4S(:,1);
t(~t)=Inf;
minY_N4S=min(t);

minY_NS4 = fix(minY_NS4*100)/100 - fMargin;
minY_N4S = fix(minY_N4S*100)/100 - fMargin;

nMaxCnt = 0;
% Calculate value range of X axis
for i=1:3
    nTmpCnt = 0;
    for j=1:nSetRow
        if (matRatio((i-1)*nSetRow+j,nColIdx) ~= 0) || (matRatio((i-1)*nSetRow+j,nColIdx+4) ~= 0)
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

%figure(1); % Ratio of Euclidian distance
figure('numbertitle', 'off', 'name', 'Ratio of Smartphone Camera Focal Length (based on Euclidian distance of matche points)');  

nStartRow = 1;
nEndRow = nSetRow;
subplot(3,2,1);
x=matRatio(nStartRow:nEndRow, 2);
y=matRatio(nStartRow:nEndRow, nColIdx);
maxY = max(y);
y(~y)=Inf;
minY = min(y);
plot(x, y);
ylim([minY_NS4 maxY_NS4]);
set(gca,'ytick',minY_NS4:fTickStep:maxY_NS4);
xlim([nMinX nMaxX]);
set(gca,'xtick',nMinX:nStepX:nMaxX);
title(gca, 'Galaxy Nexus vs. Galaxy S4 (Rear)');

subplot(3,2,2);
x=matRatio(nStartRow:nEndRow, 2);
y=matRatio(nStartRow:nEndRow, nColIdx+4);
maxY = max(y);
y(~y)=Inf;
minY = min(y);
plot(x, y);
ylim([minY_N4S maxY_N4S]);
set(gca,'ytick',minY_N4S:fTickStep:maxY_N4S);
xlim([nMinX nMaxX]);
set(gca,'xtick',nMinX:nStepX:nMaxX);
title(gca, 'Galaxy Nexus vs. iPhone 4S (Rear)');


nStartRow = nSetRow+1;
nEndRow = nSetRow*2;
subplot(3,2,3);
x=matRatio(nStartRow:nEndRow, 2);
y=matRatio(nStartRow:nEndRow, nColIdx);
maxY = max(y);
y(~y)=Inf;
minY = min(y);
plot(x, y);
ylim([minY_NS4 maxY_NS4]);
set(gca,'ytick',minY_NS4:fTickStep:maxY_NS4);
xlim([nMinX nMaxX]);
set(gca,'xtick',nMinX:nStepX:nMaxX);
title(gca, 'Galaxy Nexus vs. Galaxy S4 (Left 15)');


subplot(3,2,4);
x=matRatio(nStartRow:nEndRow, 2);
y=matRatio(nStartRow:nEndRow, nColIdx+4);
maxY = max(y);
y(~y)=Inf;
minY = min(y);
plot(x, y);
ylim([minY_N4S maxY_N4S]);
set(gca,'ytick',minY_N4S:fTickStep:maxY_N4S);
xlim([nMinX nMaxX]);
set(gca,'xtick',nMinX:nStepX:nMaxX);
title(gca, 'Galaxy Nexus vs. iPhone 4S (Left 15)');

nStartRow = nSetRow*2+1;
nEndRow = nSetRow*3;
subplot(3,2,5);
x=matRatio(nStartRow:nEndRow, 2);
y=matRatio(nStartRow:nEndRow, nColIdx);
maxY = max(y);
y(~y)=Inf;
minY = min(y);
plot(x, y);
ylim([minY_NS4 maxY_NS4]);
set(gca,'ytick',minY_NS4:fTickStep:maxY_NS4);
xlim([nMinX nMaxX]);
set(gca,'xtick',nMinX:nStepX:nMaxX);
title(gca, 'Galaxy Nexus vs. Galaxy S4 (Left 30)');


subplot(3,2,6);
x=matRatio(nStartRow:nEndRow, 2);
y=matRatio(nStartRow:nEndRow, nColIdx+4);
maxY = max(y);
y(~y)=Inf;
minY = min(y);
plot(x, y);
ylim([minY_N4S maxY_N4S]);
set(gca,'ytick',minY_N4S:fTickStep:maxY_N4S);
xlim([nMinX nMaxX]);
set(gca,'xtick',nMinX:nStepX:nMaxX);
title(gca, 'Galaxy Nexus vs. iPhone 4S (Left 30)');


f = 0;

return;

