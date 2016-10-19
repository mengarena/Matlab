function f = SE_ExecTime()
% Plot Execution Time
%
%

%tick2 = sprintf('%s\n%s','Intensity Variation','with Warping');
XTickTxt = {'Intensity Variation'; 'Warping'; 'Optical Flow'; 'Chamfer Matching'};

%matET = [38 53 90 128];
matET = [38 53 128];

maxET = max(matET);
maxY = round(maxET*1.1);

figure(1);
figure('numbertitle', 'off', 'name', 'Execution Time');

bar(matET(1,:));
set(gca, 'FontSize', 14)
set(gca, 'XTickLabel', XTickTxt);
xlabel('Scheme', 'FontSize', 18);
ylabel('Execution Time (ms)', 'FontSize', 18);
set(gca, 'Ylim', [0 maxY]);

yAxis = get(gca,'Ylim');
hold on
set(gca, 'FontSize', 14)
for i=1:3
    text(i, matET(1,i)+(yAxis(2)-yAxis(1))/100*2, num2str(matET(1,i)));
end
hold off


f = 0;

return;

