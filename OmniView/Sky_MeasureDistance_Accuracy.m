function f=Sky_MeasureDistance_Accuracy(matMatchedNum)
% Here matching the image (self-image) taken by GN(1) with the images (received image) taken by GN2, GS4, iS4,
% in this way to calculate the distance of GN(1) images
%
% The matMatchedNum contains the following fields
% The matrix contains the matching ratio of GN1 vs. GN2, GN vs. GS4, GN vs. i4S
% 1st: Distance of base image (Ground Truth)
% 2nd: Distance of reference image

% 3rd: 1=GN1 vs. GN2
% 4th: Number of matched count between GN1 vs. GN2
% 5th: matching ratio between GN1 vs. GN2

% 6rd: 2=GN vs. GS4
% 7th: Number of matched count between GN vs. GS4
% 8th: matching ratio between GN vs. GS4

% 9th: 3=GN vs. iS4
% 10th: Number of matched count between GN vs. i4S
% 11th: matching ratio between GN vs. i4S

% Distance formula: Z = W0/Wnew * fB/fA * Z0 * S
% W0/Wnew is matching ratio
% fB/fA is pre-measured (define below)
% Z0 is known distance
% S is usually 1

% Average based ratio [Rear, Left15, Left30]
fFocalRatioNN = 0.999
fFocalRatioNS4 = 1.059;
fFocalRatioN4S = 0.912;

[nRow nCol] = size(matMatchedNum);

mDist = unique(matMatchedNum(:,1));

[nCount nTmpCol] = size(mDist);

mMatchingRatioNN = [];
mMatchingRatioNS4 = [];
mMatchingRatioN4S = [];

mMatchingDistNN = [];
mMatchingDistNS4 = [];
mMatchingDistN4S = [];

for i=1:nCount
    nBaseDist = mDist(i,1);
    nMatchingNumNN = 0;
    nMatchingNumNS4 = 0;
    nMatchingNumN4S = 0;
    nMatchedDistNN = 0; % The image at this distance matched most
    nMatchedDistNS4 = 0;
    nMatchedDistN4S = 0;
    fMatchingRatioNN = 0.0;
    fMatchingRatioNS4 = 0.0;
    fMatchingRatioN4S = 0.0;
    fRatioGapNN = 1000;
    fRatioGapNS4 = 1000;
    fRatioGapN4S = 1000;
    
    for j=1:nRow
        if matMatchedNum(j,1) == nBaseDist
            fTmpGapNN = abs(matMatchedNum(j, 5) - fFocalRatioNN);
            if matMatchedNum(j, 4) > nMatchingNumNN
                nMatchingNumNN = matMatchedNum(j, 4);
                nMatchedDistNN =  matMatchedNum(j, 2);
                fMatchingRatioNN = matMatchedNum(j, 5);
                fRatioGapNN = fTmpGapNN;
            elseif matMatchedNum(j, 4) == nMatchingNumNN && fTmpGapNN < fRatioGapNN
                nMatchingNumNN = matMatchedNum(j, 4);
                nMatchedDistNN =  matMatchedNum(j, 2);
                fMatchingRatioNN = matMatchedNum(j, 5);
                fRatioGapNN = fTmpGapNN;                
            end

            fTmpGapNS4 = abs(matMatchedNum(j, 8) - fFocalRatioNS4);            
            if matMatchedNum(j, 7) > nMatchingNumNS4
                nMatchingNumNS4 = matMatchedNum(j, 7);
                nMatchedDistNS4 =  matMatchedNum(j, 2);
                fMatchingRatioNS4 = matMatchedNum(j, 8);
                fRatioGapNS4 = fTmpGapNS4;
            elseif matMatchedNum(j, 7) == nMatchingNumNS4 && fTmpGapNS4 < fRatioGapNS4
                nMatchingNumNS4 = matMatchedNum(j, 7);
                nMatchedDistNS4 =  matMatchedNum(j, 2);
                fMatchingRatioNS4 = matMatchedNum(j, 8);
                fRatioGapNS4 = fTmpGapNS4;                
            end

            fTmpGapN4S = abs(matMatchedNum(j, 11) - fFocalRatioN4S);            
            if matMatchedNum(j, 10) > nMatchingNumN4S
                nMatchingNumN4S = matMatchedNum(j, 10);
                nMatchedDistN4S = matMatchedNum(j, 2);
                fMatchingRatioN4S = matMatchedNum(j, 11);
                fRatioGapN4S = fTmpGapN4S;
            elseif matMatchedNum(j, 10) == nMatchingNumN4S && fTmpGapN4S < fRatioGapN4S
                nMatchingNumN4S = matMatchedNum(j, 10);
                nMatchedDistN4S = matMatchedNum(j, 2);
                fMatchingRatioN4S = matMatchedNum(j, 11);
                fRatioGapN4S = fTmpGapN4S;                
            end
            
        end
    end

    mMatchingRatioNN(i, 1) = fMatchingRatioNN;
    mMatchingDistNN(i, 1) = nMatchedDistNN;
    mMatchingRatioNS4(i, 1) = fMatchingRatioNS4;
    mMatchingDistNS4(i, 1) = nMatchedDistNS4;
    mMatchingRatioN4S(i, 1) = fMatchingRatioN4S;
    mMatchingDistN4S(i, 1) = nMatchedDistN4S;
    
end

mMeasuredDistanceNN = [];
mMeasuredDistanceNS4 = [];
mMeasuredDistanceN4S = [];

for i=1:nCount
    mMeasuredDistanceNN(i,1) = mMatchingRatioNN(i, 1)* (1.0/fFocalRatioNN) * mMatchingDistNN(i,1);
    mMeasuredDistanceNS4(i,1) = mMatchingRatioNS4(i, 1)* (1.0/fFocalRatioNS4) * mMatchingDistNS4(i,1);
    mMeasuredDistanceN4S(i,1) = mMatchingRatioN4S(i, 1)* (1.0/fFocalRatioN4S) * mMatchingDistN4S(i,1);
end


maxMeasuredNN = max(mMeasuredDistanceNN(:,1));
maxMeasuredNS4 = max(mMeasuredDistanceNS4(:,1));
maxMeasuredN4S = max(mMeasuredDistanceN4S(:,1));

maxMeasuredNN = fix(fix(maxMeasuredNN)*10/100)*10 + 10; 
maxMeasuredNS4 = fix(fix(maxMeasuredNS4)*10/100)*10 + 10; 
maxMeasuredN4S = fix(fix(maxMeasuredN4S)*10/100)*10 + 10; 


figure('numbertitle', 'off', 'name', 'Distance Accuracy');  
set(gca, 'FontSize', 18);

subplot(1,3,1);
plot(mDist(:,1), mDist(:,1), 'r', 'LineWidth',2);
hold on;
y = mMeasuredDistanceNN;
y(~y)=Inf;
plot(mDist(:,1), y, 'b*', 'LineWidth',2);
ylim([0 maxMeasuredNN]);
xlim([0 mDist(nCount,1)]);
set(gca,'xtick',0:10:mDist(nCount,1), 'FontSize', 18);
set(gca,'ytick',0:10:maxMeasuredNN, 'FontSize', 18);
%xlabelStr = 'Ground Truth Distance (m)';
xlabel('Ground Truth Distance (m)', 'FontSize', 18);
ylabel('Measured Distance (m)', 'FontSize', 18);
%legend('Ground Truth','Measured Distance');
title(gca, 'Distance Measurement (GN 1 vs GN 2)','FontSize', 18);

subplot(1,3,2);
plot(mDist(:,1), mDist(:,1), 'r', 'LineWidth',2);
hold on;
y = mMeasuredDistanceNS4;
y(~y)=Inf;
plot(mDist(:,1), y, 'b*', 'LineWidth',2);
ylim([0 maxMeasuredNS4]);
xlim([0 mDist(nCount,1)]);
set(gca,'xtick',0:10:mDist(nCount,1), 'FontSize', 18);
set(gca,'ytick',0:10:maxMeasuredNS4, 'FontSize', 18);
%xlabelStr = 'Ground Truth Distance (m)';
xlabel('Ground Truth Distance (m)', 'FontSize', 18);
ylabel('Measured Distance (m)', 'FontSize', 18);
legend('Ground Truth','Measured Distance');
title(gca, 'Distance Measurement (GN vs GS4)','FontSize', 18);

subplot(1,3,3);
plot(mDist(:,1), mDist(:,1), 'r', 'LineWidth',2);
hold on;
y = mMeasuredDistanceN4S;
y(~y)=Inf;
plot(mDist(:,1), y, 'b*', 'LineWidth',2);
ylim([0 maxMeasuredN4S]);
xlim([0 mDist(nCount,1)]);
set(gca,'xtick',0:10:mDist(nCount,1), 'FontSize', 18);
set(gca,'ytick',0:10:maxMeasuredN4S, 'FontSize', 18);
%xlabelStr = 'Ground Truth Distance (m)';
xlabel('Ground Truth Distance (m)', 'FontSize', 18);
ylabel('Measured Distance (m)', 'FontSize', 18);
%legend('Rear','Left30','Mean');
title(gca, 'Distance Measurement(GN vs i4S)','FontSize', 18);

f = 0;

return;