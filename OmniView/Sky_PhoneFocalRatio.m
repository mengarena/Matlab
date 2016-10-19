function f = Sky_PhoneFocalRatio(ratioMat, nIndex)
% This function is used to show the ratio of focal length between different
% phones
%
% The based phone is Galaxy Nexus 1
% Query phones are: Galaxy Nexus 3, iPhone4S, NexusOne, WP
%
% Fields in ratioMat (each row):
%   Distance (feet)
%   Index of Query Phone: 1--GN3; 2--iPhone4S; 3--NexusOne; 4--WP
%   Ratio from the two max feature points in the compared pair
%   Ratio of the average feature points size of the compared pairs
%
% nIndex decides which column to plot
%

X=[20 30 40 60 80 100];

figure('numbertitle', 'off', 'name', 'Smartphone Focal Length Ratio');

plot(X(1:5), ratioMat(1:4:17,nIndex), 'ro-', 'linewidth',2);
%plot(ratioMat(1:4:17,3), 'r-*');
hold on;
plot(X(1:4), ratioMat(2:4:14,nIndex), 'go-', 'linewidth',2);
%plot(ratioMat(2:4:14,3), 'g-*');

hold on;
%plot(X(1:1), ratioMat(3,3));
%hold on;
plot(X(1:2), ratioMat(4:4:8,nIndex), 'bo-', 'linewidth',2);
%plot(ratioMat(4:4:8,3), 'b-*');

hold on;

%XTickTxt = {'60m'; '80m'; '100m'; '120m'; '150m'; '200m'};
%XTickTxt = {'20'; '30'; '40'; '50'; '60'; '70'; '80'};
set(gca, 'FontSize', 20)
%set(gca, 'XTickLabel', XTickTxt);
title(gca, 'Ratio of Camera Focal Length [Compared with Galaxy Nexus]');
%legend('5KB', '10KB','15KB', '20KB', '25KB', '30KB', '35KB', '40KB', '45KB');
legend('2nd Galaxy Nexus','iPhone 4S', 'Windows Phone (HTC Surround)');
xlabel('Distance of Smartphone (Camera) - Vehicle (feet)', 'FontSize', 24);
ylabel('Ratio of Focal Length', 'FontSize', 24);
set(gca,'ytick',0.5:0.25:2.5);
axis([20 80 0.25 2.4]);
%set(gca,'ygrid','on');


return;
