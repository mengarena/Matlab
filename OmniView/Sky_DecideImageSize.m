function f = Sky_DecideImageSize(matchedMat, nImagePairStartPos)
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
        processedMat(nIndex,1) = min(matchedMat(i,nImagePairStartPos), matchedMat(i,nImagePairStartPos+1)); %Smaller size
        processedMat(nIndex,2) = matchedMat(i,nImagePairStartPos+2);  % #matched point
  %  end
end

sortedMat = sortrows(processedMat, 2);  % Sort according to number of matched points

figure('numbertitle', 'off', 'name', 'ImageSize_NumberOfMatchedPoints(Same Car, ORB)');
%%figure('numbertitle', 'off', 'name', 'ImagePair_NumberOfMatchedPoints(Different Car, ORB)');

%%plot(sortedMat(:,2), sortedMat(:,1), 'r*');
plot(sortedMat(:,1), sortedMat(:,2), 'r*');

%%plot(matchedMat(:,nImagePairStartPos+2), 'r*');

set(gca, 'FontSize', 14)
title(gca, 'Image Size - Number of Matched Points');
%%%title(gca, 'Image Pair (Different Cars) - Number of Matched Points');

xlabel('(Smaller) Image Size of Matched Pair (KB)', 'FontSize', 16);
%%xlabel('Matched Image Pair', 'FontSize', 16);

ylabel('# Matched Points', 'FontSize', 16);
set(gca,'ygrid','on');

return;
