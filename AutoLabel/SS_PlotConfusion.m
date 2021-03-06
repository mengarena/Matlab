function f = SS_PlotConfusion(CMat, xLabels, xTicks, yLabels, yTicks, sTitle, figNo, nFontSizeTitleAxis, nFontSizeContent)
% This function is used to plot 
%
% xLabel: example {'A','B','C','D','E'}
%

nStringFontSize = 40;

figure(figNo);

imagesc(CMat);           %# Create a colored plot of the matrix values


%colormap parameter:  , gray, hsv(128), jet, hot, cool, spring, summer, autumn, winter, bone, copper, pink, lines, flag,prism, white 
%use flipud() to flip the color map, for example flipud(gray)

colormap(flipud(hot));  %# Change the colormap to gray (so higher values are
                         %#   black and lower values are white)

colorbar;

[nLenY nLenX] = size(CMat);

% if nLen ~= nLen1 
%     disp('x, y size in confusion matrix does not equal');
%     return;
% end


% Format the numbers in CMat                         
textStrings = num2str(CMat(:),'%0.3f');  %# Create strings from the matrix values
textStrings = strtrim(cellstr(textStrings));  %# Remove any space padding

% If the cell value in matrix is 0, don't show it, leave the space
idx = find(strcmp(textStrings(:), '0.000'));
textStrings(idx) = {'   '};


[x,y] = meshgrid(1:nLenX, 1:nLenY);   %# Create x and y coordinates for the strings

hStrings = text(x(:),y(:),textStrings(:),'HorizontalAlignment','center', 'FontName','Times New Roman','FontSize', nStringFontSize);      %# Plot the strings

midValue = mean(get(gca,'CLim'));  %# Get the middle value of the color range
textColors = repmat(CMat(:) > midValue,1, 3);  %# Choose white or black for the
                                             %#   text color of the strings so
                                             %#   they can be easily seen over
                                             %#   the background color
set(hStrings,{'Color'},num2cell(textColors,2));  %# Change the text colors


set(gca,'XTick',1:nLenX,...                        
        'XTickLabel',xTicks,...  %#   and tick labels
        'YTick',1:nLenY,...
        'YTickLabel',yTicks,...
        'TickLength',[0 0],'FontName','Times New Roman','FontSize', nFontSizeContent);

xlabel(xLabels, 'FontName','Times New Roman','FontSize', nFontSizeTitleAxis);    
ylabel(yLabels, 'FontName','Times New Roman','FontSize', nFontSizeTitleAxis);
    
rotateXLabels(gca, 30);  % rotate the x tick

title(sTitle, 'FontName','Times New Roman','FontSize', nFontSizeTitleAxis);

return;
