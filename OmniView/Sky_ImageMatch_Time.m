function f = Sky_ImageMatch_Time(tmMat, nIndex)
% nIndex: the column of time
%

rowCnt = size(tmMat, 1);
avgTm = mean(tmMat(:,nIndex))
stdTm = std(tmMat(:,nIndex))

figure('numbertitle', 'off', 'name', 'Time of Image Matching');
set(gca, 'FontSize', 26);
plot(tmMat(:,nIndex), 'r*');
hold on;
plot(1:rowCnt, avgTm, 'bo-', 'linewidth', 2);

%set(gca, 'FontSize', 24)
title(gca, 'Time of Image Matching', 'FontName','Times New Roman', 'FontSize', 30);
%legend('5KB', '10KB','15KB', '20KB', '25KB', '30KB', '35KB', '40KB', '45KB');
%legend('10KB','15KB');
xlabel('Matched Image Pair', 'FontName','Times New Roman', 'FontSize', 30);
ylabel('Time (ms)', 'FontName','Times New Roman', 'FontSize', 30);
set(gca,'ygrid','on');

return;