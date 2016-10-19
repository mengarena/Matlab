function f = SS_Plot_FrameZcr(sFeatureFiles, sStores, nFigureNo)
% This function is used to plot the frames ZCR for show
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

nHistBin = 50;
nPolynomial = 8;
nDataIndex = 2;

cellStores = cellstr(sStores);

cellFeatureFiles = cellstr(sFeatureFiles);

[nCnt nCol] = size(cellFeatureFiles);

nPlotColCnt = ceil(sqrt(nCnt));

nFontSize = floor(sqrt(2*18*18/nPlotColCnt));  % If 2 columns, font is 18 (this is treated as base)

nPlotRowCnt = ceil(nCnt/nPlotColCnt);

figure(nFigureNo);

fXmaxZcr = 0.0;
fXminZcr = 0.0;

fYmaxPercent = 0.0;

for i=1:nCnt
    %fprintf('Training HMM based on :  %s\n', cellFeatureFiles{i});
    mData = load(cellFeatureFiles{i});
    mZcr = mData(:,nDataIndex);
    
    [mHistZcr mXvalues] = hist(mZcr, nHistBin);
    mNormalizedHistZcr = 1.0*mHistZcr/sum(mHistZcr);
    
    if fYmaxPercent < max(mNormalizedHistZcr)
        fYmaxPercent = max(mNormalizedHistZcr);
    end
    
    if fXmaxZcr < max(mZcr)
       fXmaxZcr = max(mZcr);
    end
    
    if fXminZcr > min(mZcr)
        fXminZcr = min(mZcr);
    end
    
    hold on;
    
    subplot(nPlotRowCnt,nPlotColCnt,i);
   
    A = polyfit(mXvalues, mNormalizedHistZcr, nPolynomial);
    Xi = linspace(min(mXvalues), max(mXvalues), length(mXvalues));
    Yi = polyval(A, Xi);
    plot(Xi, Yi, 'r', 'linewidth', 4);
    hold on;
    bar(mXvalues, mNormalizedHistZcr);
    
end

for i=1:nCnt
    hold on;
    subplot(nPlotRowCnt,nPlotColCnt,i);
    
    if nCnt == 1
        sTitle = ['ZCR Distribution of ' cellStores{i} ' Audio' ];
    else
        sTitle = cellStores{i};
    end
    
    title(sTitle, 'FontName','Times New Roman','FontSize', nFontSize);
    ylim([0 fYmaxPercent]);
    ylabel('% of Frame ZCR',  'FontName','Times New Roman','FontSize', nFontSize);
    xlim([fXminZcr fXmaxZcr]);
    xlabel('Frame ZCR',  'FontName','Times New Roman','FontSize', nFontSize);    
end

if nCnt ~= 1
    suptitle('Frame-based Audio Zero Crossing Rate Distribution');
end

return;
