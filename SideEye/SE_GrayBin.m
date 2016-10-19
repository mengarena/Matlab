function f = SE_GrayBin()
% Graylevel bin
%
%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Grey-bin for Road with Car
matCar = evalin('base', 'Car');

[r c] = size(matCar);
matCarNormal = [];
tmpCar = sum(matCar, 1);
totalPix = tmpCar(1,2);

% Normalize the pixel count
for i=1:r
    matCarNormal(i,1) = matCar(i,2)/totalPix;
end

maxCarNormalVal = max(matCarNormal);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Grey-bin for Empty Road
matEmptyRoad = evalin('base', 'EmptyRoad');

[r c] = size(matEmptyRoad);
matEmptyNormal = [];
tmpEmpty = sum(matEmptyRoad, 1);
totalPix = tmpEmpty(1,2);

% Normalize the pixel count
for i=1:r
    matEmptyNormal(i,1) = matEmptyRoad(i,2)/totalPix;
end

maxEmptyNormalVal = max(matEmptyNormal);

maxYlim = max(maxCarNormalVal, maxEmptyNormalVal);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plot Grey Level/Bin for Empty Road
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(1);
figure('numbertitle', 'off', 'name', 'Graylevel-Bin for Empty Road');
set(gca, 'FontSize', 14)
bar(matEmptyRoad(:,1), matEmptyNormal(:,1));
xlabel('Gray Level (Empty Road)', 'FontSize', 18);
ylabel('Pixel Distribution', 'FontSize', 18);
set(gca, 'Ylim', [0 maxYlim]);
set(gca, 'Xlim', [0 255]);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plot Grey Level/Bin for Road with Vehicle
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(2);
figure('numbertitle', 'off', 'name', 'Graylevel-Bin for Road with Vehicle');
set(gca, 'FontSize', 14)
bar(matCar(:,1), matCarNormal(:,1));
xlabel('Gray Level (Road with Vehicle)', 'FontSize', 18);
ylabel('Pixel Distribution', 'FontSize', 18);
set(gca, 'Ylim', [0 maxYlim]);
set(gca, 'Xlim', [0 255]);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plot Together
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(3);
figure('numbertitle', 'off', 'name', 'Graylevel-Bin for Empty Road-Road with Vehicle');
subplot(1,2,1);
set(gca, 'FontSize', 14)
bar(matEmptyRoad(:,1), matEmptyNormal(:,1));
xlabel('Gray Level (Empty Road)', 'FontSize', 18);
ylabel('Pixel Distribution', 'FontSize', 18);
set(gca, 'Ylim', [0 maxYlim]);
set(gca, 'Xlim', [0 255]);

subplot(1,2,2);
set(gca, 'FontSize', 14)
bar(matCar(:,1), matCarNormal(:,1));
xlabel('Gray Level (Road with Vehicle)', 'FontSize', 18);
ylabel('Pixel Distribution', 'FontSize', 18);
set(gca, 'Ylim', [0 maxYlim]);
set(gca, 'Xlim', [0 255]);


f = 0;

return;
