function f = SS_CalPlotConfusion(TargetVec, PredictVec, xLabel, yLabel)
% This function is used to calculate the confusion matrix between TargetVec
% and PrecictVec.

% Calculate the matrix
[CMat, order] = confusionmat(TargetVec,PredictVec);

imagesc(CMat);           %# Create a colored plot of the matrix values
colormap(flipud(gray));  %# Change the colormap to gray (so higher values are
                         %#   black and lower values are white)

nLen = length(TargetVec);

if mod(nLen, 2) == 1
    nHalf = floor(nLen/2) + 1;
else
    nHalf = nLen/2;
end
                         
% Format the numbers in CMat                         
textStrings = num2str(CMat(:),'%0.2f');  %# Create strings from the matrix values
textStrings = strtrim(cellstr(textStrings));  %# Remove any space padding

% If the cell value in matrix is 0, don't show it, leave the space
%idx = find(strcmp(textStrings(:), '0.00'));
%textStrings(idx) = {'   '};

[x,y] = meshgrid(1:nLen);   %# Create x and y coordinates for the strings
hStrings = text(x(:),y(:),textStrings(:),'HorizontalAlignment','center');      %# Plot the strings

midValue = mean(get(gca,'CLim'));  %# Get the middle value of the color range
textColors = repmat(CMat(:) > midValue,1,3);  %# Choose white or black for the
                                             %#   text color of the strings so
                                             %#   they can be easily seen over
                                             %#   the background color
set(hStrings,{'Color'},num2cell(textColors,2));  %# Change the text colors

% {'A','B','C','D','E'}

set(gca,'XTick',1:nLen,...                        
        'XTickLabel',xLabel,...  %#   and tick labels
        'YTick',1:nLen,...
        'YTickLabel',yLabel,...
        'TickLength',[0 0]);
    
return;
