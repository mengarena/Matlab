function f = SS_PlotConfusionSingle(CMat, xLabels, xTicks, yLabels, yTicks, sTitle, figNo)
% This function is used to plot 
%
% xLabel: example {'A','B','C','D','E'}
%
figure(figNo);

imagesc(CMat);           %# Create a colored plot of the matrix values


%colormap parameter:  , gray, hsv(128), jet, hot, cool, spring, summer, autumn, winter, bone, copper, pink, lines, flag,prism, white 
%use flipud() to flip the color map, for example flipud(gray)

colormap(flipud(hot));  %# Change the colormap to gray (so higher values are
                         %#   black and lower values are white)

h = colorbar;

set(gca, 'CLim', [0 1.0]);

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

% idx = [];
% if nLenY == nLenX
%     for i=1:nLenY
%        idx(i) = 1 + nLenX*(i-1) + i - 1;
%     end
%     
%     textStrings(idx) = {'   '};
% end


[x,y] = meshgrid(1:nLenX, 1:nLenY);   %# Create x and y coordinates for the strings

hStrings = text(x(:),y(:),textStrings(:),'HorizontalAlignment','center', 'FontName','Times New Roman','FontSize', 11);      %# Plot the strings   24   12      26

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
        'TickLength',[0 0],'FontName','Times New Roman','FontSize', 16);  %36   20     30

xlabel(xLabels, 'FontName','Times New Roman','FontSize', 28);    % 44  30    36
ylabel(yLabels, 'FontName','Times New Roman','FontSize', 28);    % 44  30    36
    
rotateXLabels(gca, 30);% rotate the x tick

%title(sTitle, 'FontName','Times New Roman','FontSize', 32);


return;
