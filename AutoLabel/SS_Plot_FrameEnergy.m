function f = SS_Plot_FrameEnergy(sFeatureFiles, sStores, nFigureNo)
% This function is used to plot the frames Energy for show
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

nHistBin = 50;
nPolynomial = 10;
nDataIndex = 1;

cellStores = cellstr(sStores);

cellFeatureFiles = cellstr(sFeatureFiles);

[nCnt nCol] = size(cellFeatureFiles);

nPlotColCnt = ceil(sqrt(nCnt));

nFontSize = floor(sqrt(2*18*18/nPlotColCnt));  % If 2 columns, font is 18 (this is treated as base)

nPlotRowCnt = ceil(nCnt/nPlotColCnt);

figure(nFigureNo);

fXmaxEnergy = 0.0;
fXminEnergy = 0.0;

fYmaxPercent = 0.0;

for i=1:nCnt
    %fprintf('Training HMM based on :  %s\n', cellFeatureFiles{i});
    mData = load(cellFeatureFiles{i});
    mEnergy = mData(:,nDataIndex);
    
    [mHistEnergy mXvalues] = hist(mEnergy, nHistBin);
    mNormalizedHistEnergy = 1.0*mHistEnergy/sum(mHistEnergy);
    
    if fYmaxPercent < max(mNormalizedHistEnergy)
        fYmaxPercent = max(mNormalizedHistEnergy);
    end
    
    if fXmaxEnergy < max(mEnergy)
       fXmaxEnergy = max(mEnergy);
    end
    
    if fXminEnergy > min(mEnergy)
        fXminEnergy = min(mEnergy);
    end
    
    hold on;
    
    subplot(nPlotRowCnt,nPlotColCnt,i);
   
    A = polyfit(mXvalues, mNormalizedHistEnergy, nPolynomial);
    Xi = linspace(min(mXvalues), max(mXvalues), length(mXvalues));
    Yi = polyval(A, Xi);
    plot(Xi, Yi, 'r', 'linewidth', 4);
    hold on;
    bar(mXvalues, mNormalizedHistEnergy);
    
end

for i=1:nCnt
    hold on;
    subplot(nPlotRowCnt,nPlotColCnt,i);
    
    if nCnt == 1
        sTitle = ['Energy Distribution of ' cellStores{i} ' Audio' ];
    else
        sTitle = cellStores{i};
    end
    
    title(sTitle, 'FontName','Times New Roman','FontSize', nFontSize);
    ylim([0 fYmaxPercent]);
    ylabel('% of Frame Energy',  'FontName','Times New Roman','FontSize', nFontSize);
    xlim([fXminEnergy fXmaxEnergy]);
    xlabel('Frame Energy',  'FontName','Times New Roman','FontSize', nFontSize);    
end

if nCnt ~= 1
    suptitle('Frame-based Audio Energy Distribution');
end

return;
