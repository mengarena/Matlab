function f = Sky_DecideImageSize_Special(matchedMat, nMatchedPointPos, nonMatchedMat, nNonMatchedPointPos)
% This function is used to decide the optimal image size for image matching
%
% The original "matchedMat" contains the result from image matching,
% Each lines contains: size of image1, size of image2, number of matched
% points
%

[rowNum colNum] = size(matchedMat);

processedMat = [];  % This only stored the smaller size of the two images and the number of matched points

nIndex = 0;

for i=1:rowNum
  %  if matchedMat(i,nImagePairStartPos+2) > 0
        nIndex = nIndex + 1;
        processedMat(nIndex,1) = matchedMat(i,nMatchedPointPos); %Smaller size
        processedMat(nIndex,2) = matchedMat(i,nMatchedPointPos+1);  % #matched point
  %  end
end


[rowNumNon colNumNon] = size(nonMatchedMat);

processedMatNon = [];  % This only stored the smaller size of the two images and the number of matched points

nIndex = 0;

for i=1:rowNumNon
  %  if matchedMat(i,nImagePairStartPos+2) > 0
        nIndex = nIndex + 1;
        processedMatNon(nIndex,1) = nonMatchedMat(i,nNonMatchedPointPos); %Smaller size
        processedMatNon(nIndex,2) = nonMatchedMat(i,nNonMatchedPointPos+1);  % #matched point
  %  end
end

%%sortedMat = sortrows(processedMat, 2);  % Sort according to number of matched points

figure('numbertitle', 'off', 'name', 'ImageSize_NumberOfMatchedPoints(Same Car, ORB)');
%%figure('numbertitle', 'off', 'name', 'ImagePair_NumberOfMatchedPoints(Different Car, ORB)');

%%plot(sortedMat(:,2), sortedMat(:,1), 'r*');

%%plot(sortedMat(:,1), sortedMat(:,2), 'r*');
plot(processedMat(:,1), processedMat(:,2), 'b+');

hold on;

plot(processedMatNon(:,1), processedMatNon(:,2), 'r*');

ylim([0 100]);
set(gca, 'YTick', 0:10:100, 'FontName', 'Times New Roman', 'FontSize', 24);

xlim([6 24]);
set(gca, 'XTick', 6:1:24, 'FontName', 'Times New Roman', 'FontSize', 24);

legend('Matching between same vehicle images','Matching between different vehicle images');

%%plot(matchedMat(:,nImagePairStartPos+2), 'r*');

set(gca, 'FontSize', 24);
title(gca, 'Image Size - Number of Matched Points',  'FontName', 'Times New Roman', 'FontSize', 24);
%%%title(gca, 'Image Pair (Different Cars) - Number of Matched Points');

xlabel('(Smaller) Image Size of Matching Pair (KB)', 'FontName', 'Times New Roman', 'FontSize', 24);
%%xlabel('Matched Image Pair', 'FontSize', 16);

ylabel('# Matched Points', 'FontName', 'Times New Roman', 'FontSize', 24);
set(gca,'ygrid','on');

return;
