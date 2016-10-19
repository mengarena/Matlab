function f = Sky_DecideImageSize_Group(matchedMat1000, matchedMat750, matchedMat500, matchedMat300, matchedMat200, matchedMat100, nImagePairStartPos)
% This function is used to decide the optimal image size for image matching
%
% The original "matchedMat" contains the result from image matching,
% Each lines contains: size of image1, size of image2, number of1 matched
% points
%

[rowNum1000 colNum1000] = size(matchedMat1000);

processedMat1000 = [];  % This only stored the smaller size of the two images and the number of matched points

nIndex = 0;

for i=1:rowNum1000
  %  if matchedMat(i,nImagePairStartPos+2) > 0
        nIndex = nIndex + 1;
        processedMat1000(nIndex,1) = min(matchedMat1000(i,nImagePairStartPos), matchedMat1000(i,nImagePairStartPos+1)); %Smaller size
        processedMat1000(nIndex,2) = matchedMat1000(i,nImagePairStartPos+2);  % #matched point
  %  end
end

processedMat1000 = sortrows(processedMat1000, 2);  % Sort according to number of matched points

figure('numbertitle', 'off', 'name', 'ImageSize_NumberOfMatchedPoints(Same Car, ORB)');
%%figure('numbertitle', 'off', 'name', 'ImagePair_NumberOfMatchedPoints(Different Car, ORB)');

subplot(2,3,1);
%%plot(sortedMat(:,2), sortedMat(:,1), 'r*');
plot(processedMat1000(:,1), processedMat1000(:,2), 'r*');

%%plot(matchedMat(:,nImagePairStartPos+2), 'r*');

set(gca, 'FontSize', 12)
title(gca, 'Image Size - Number of Matched Points (allowed 1000 features)');
%%%title(gca, 'Image Pair (Different Cars) - Number of Matched Points');

xlabel('(Smaller) Image Size of Matched Pair (KB)', 'FontSize', 12);
%%xlabel('Matched Image Pair', 'FontSize', 12);

ylabel('# Matched Points', 'FontSize', 12);
set(gca,'ygrid','on');
ylim([0 150]);
set(gca, 'YTick', 0:10:150);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[rowNum750 colNum750] = size(matchedMat750);

processedMat750 = [];  % This only stored the smaller size of the two images and the number of matched points

nIndex = 0;

for i=1:rowNum750
  %  if matchedMat(i,nImagePairStartPos+2) > 0
        nIndex = nIndex + 1;
        processedMat750(nIndex,1) = min(matchedMat750(i,nImagePairStartPos), matchedMat750(i,nImagePairStartPos+1)); %Smaller size
        processedMat750(nIndex,2) = matchedMat750(i,nImagePairStartPos+2);  % #matched point
  %  end
end

processedMat750 = sortrows(processedMat750, 2);  % Sort according to number of matched points

subplot(2,3,2);
%%plot(sortedMat(:,2), sortedMat(:,1), 'r*');
plot(processedMat750(:,1), processedMat750(:,2), 'r*');

%%plot(matchedMat(:,nImagePairStartPos+2), 'r*');

set(gca, 'FontSize', 12)
title(gca, 'Image Size - Number of Matched Points (allowed 750 features)');
%%%title(gca, 'Image Pair (Different Cars) - Number of Matched Points');

xlabel('(Smaller) Image Size of Matched Pair (KB)', 'FontSize', 12);
%%xlabel('Matched Image Pair', 'FontSize', 12);

ylabel('# Matched Points', 'FontSize', 12);
set(gca,'ygrid','on');
ylim([0 150]);
set(gca, 'YTick', 0:10:150);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[rowNum500 colNum500] = size(matchedMat500);

processedMat500 = [];  % This only stored the smaller size of the two images and the number of matched points

nIndex = 0;

for i=1:rowNum500
  %  if matchedMat(i,nImagePairStartPos+2) > 0
        nIndex = nIndex + 1;
        processedMat500(nIndex,1) = min(matchedMat500(i,nImagePairStartPos), matchedMat500(i,nImagePairStartPos+1)); %Smaller size
        processedMat500(nIndex,2) = matchedMat500(i,nImagePairStartPos+2);  % #matched point
  %  end
end

processedMat500 = sortrows(processedMat500, 2);  % Sort according to number of matched points

subplot(2,3,3);
%%plot(sortedMat(:,2), sortedMat(:,1), 'r*');
plot(processedMat500(:,1), processedMat500(:,2), 'r*');

%%plot(matchedMat(:,nImagePairStartPos+2), 'r*');

set(gca, 'FontSize', 12)
title(gca, 'Image Size - Number of Matched Points (allowed 500 features)');
%%%title(gca, 'Image Pair (Different Cars) - Number of Matched Points');

xlabel('(Smaller) Image Size of Matched Pair (KB)', 'FontSize', 12);
%%xlabel('Matched Image Pair', 'FontSize', 12);

ylabel('# Matched Points', 'FontSize', 12);
set(gca,'ygrid','on');
ylim([0 150]);
set(gca, 'YTick', 0:10:150);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[rowNum300 colNum300] = size(matchedMat300);

processedMat300 = [];  % This only stored the smaller size of the two images and the number of matched points

nIndex = 0;

for i=1:rowNum300
  %  if matchedMat(i,nImagePairStartPos+2) > 0
        nIndex = nIndex + 1;
        processedMat300(nIndex,1) = min(matchedMat300(i,nImagePairStartPos), matchedMat300(i,nImagePairStartPos+1)); %Smaller size
        processedMat300(nIndex,2) = matchedMat300(i,nImagePairStartPos+2);  % #matched point
  %  end
end

processedMat300 = sortrows(processedMat300, 2);  % Sort according to number of matched points

subplot(2,3,4);
%%plot(sortedMat(:,2), sortedMat(:,1), 'r*');
plot(processedMat300(:,1), processedMat300(:,2), 'r*');

%%plot(matchedMat(:,nImagePairStartPos+2), 'r*');

set(gca, 'FontSize', 12)
title(gca, 'Image Size - Number of Matched Points (allowed 300 features)');
%%%title(gca, 'Image Pair (Different Cars) - Number of Matched Points');

xlabel('(Smaller) Image Size of Matched Pair (KB)', 'FontSize', 12);
%%xlabel('Matched Image Pair', 'FontSize', 12);

ylabel('# Matched Points', 'FontSize', 12);
set(gca,'ygrid','on');
ylim([0 150]);
set(gca, 'YTick', 0:10:150);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[rowNum200 colNum200] = size(matchedMat200);

processedMat200 = [];  % This only stored the smaller size of the two images and the number of matched points

nIndex = 0;

for i=1:rowNum200
  %  if matchedMat(i,nImagePairStartPos+2) > 0
        nIndex = nIndex + 1;
        processedMat200(nIndex,1) = min(matchedMat200(i,nImagePairStartPos), matchedMat200(i,nImagePairStartPos+1)); %Smaller size
        processedMat200(nIndex,2) = matchedMat200(i,nImagePairStartPos+2);  % #matched point
  %  end
end

processedMat200 = sortrows(processedMat200, 2);  % Sort according to number of matched points

subplot(2,3,5);
%%plot(sortedMat(:,2), sortedMat(:,1), 'r*');
plot(processedMat200(:,1), processedMat200(:,2), 'r*');

%%plot(matchedMat(:,nImagePairStartPos+2), 'r*');

set(gca, 'FontSize', 12)
title(gca, 'Image Size - Number of Matched Points (allowed 200 features)');
%%%title(gca, 'Image Pair (Different Cars) - Number of Matched Points');

xlabel('(Smaller) Image Size of Matched Pair (KB)', 'FontSize', 12);
%%xlabel('Matched Image Pair', 'FontSize', 12);

ylabel('# Matched Points', 'FontSize', 12);
set(gca,'ygrid','on');
ylim([0 150]);
set(gca, 'YTick', 0:10:150);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[rowNum100 colNum100] = size(matchedMat100);

processedMat100 = [];  % This only stored the smaller size of the two images and the number of matched points

nIndex = 0;

for i=1:rowNum100
  %  if matchedMat(i,nImagePairStartPos+2) > 0
        nIndex = nIndex + 1;
        processedMat100(nIndex,1) = min(matchedMat100(i,nImagePairStartPos), matchedMat100(i,nImagePairStartPos+1)); %Smaller size
        processedMat100(nIndex,2) = matchedMat100(i,nImagePairStartPos+2);  % #matched point
  %  end
end

processedMat100 = sortrows(processedMat100, 2);  % Sort according to number of matched points

subplot(2,3,6);
%%plot(sortedMat(:,2), sortedMat(:,1), 'r*');
plot(processedMat100(:,1), processedMat100(:,2), 'r*');

%%plot(matchedMat(:,nImagePairStartPos+2), 'r*');

set(gca, 'FontSize', 12)
title(gca, 'Image Size - Number of Matched Points (allowed 100 features)');
%%%title(gca, 'Image Pair (Different Cars) - Number of Matched Points');

xlabel('(Smaller) Image Size of Matched Pair (KB)', 'FontSize', 12);
%%xlabel('Matched Image Pair', 'FontSize', 12);

ylabel('# Matched Points', 'FontSize', 12);
set(gca,'ygrid','on');
ylim([0 150]);
set(gca, 'YTick', 0:10:150);

return;
