function f = SBM_Plot_PCA_Explained(sFile, sTitle)
% nSensorType: 1: Linear Accl;  2: Gyro

mData = load(sFile);

mLinearAccl = mData((mData(:,1)==1),:);
mGyro = mData((mData(:,1)==2),:);

mLinearAcclFirst = mLinearAccl(:,2);
mLinearAcclSecond = mLinearAccl(:,3);
mLinearAcclFirstSecond = mLinearAcclFirst + mLinearAcclSecond;

mGyroFirst = mGyro(:,2);
mGyroSecond = mGyro(:,3);
mGyroFirstSecond = mGyroFirst + mGyroSecond;

nFontSize = 30;

figure(1);
subplot(3,1,1);
plot(mLinearAcclFirst);
title(gca, [sTitle '--LinearAccl 1st Comp'], 'FontName','Times New Roman', 'FontSize', nFontSize);
xlabel('#Sample', 'FontName','Times New Roman', 'FontSize', nFontSize);
ylabel('% Explained', 'FontName','Times New Roman', 'FontSize', nFontSize);


subplot(3,1,2);
plot(mLinearAcclSecond);
title(gca, [sTitle '--LinearAccl 2nd Comp'], 'FontName','Times New Roman', 'FontSize', nFontSize);
xlabel('#Sample', 'FontName','Times New Roman', 'FontSize', nFontSize);
ylabel('% Explained', 'FontName','Times New Roman', 'FontSize', nFontSize);

subplot(3,1,3);
plot(mLinearAcclFirstSecond);
title(gca, [sTitle '--LinearAccl 1st+2nd Comp'], 'FontName','Times New Roman', 'FontSize', nFontSize);
xlabel('#Sample', 'FontName','Times New Roman', 'FontSize', nFontSize);
ylabel('% Explained', 'FontName','Times New Roman', 'FontSize', nFontSize);


figure(2);
subplot(3,1,1);
plot(mGyroFirst);
title(gca, [sTitle '--Gyro 1st Comp'], 'FontName','Times New Roman', 'FontSize', nFontSize);
xlabel('#Sample', 'FontName','Times New Roman', 'FontSize', nFontSize);
ylabel('% Explained', 'FontName','Times New Roman', 'FontSize', nFontSize);

subplot(3,1,2);
plot(mGyroSecond);
title(gca, [sTitle '--Gyro 2nd Comp'], 'FontName','Times New Roman', 'FontSize', nFontSize);
xlabel('#Sample', 'FontName','Times New Roman', 'FontSize', nFontSize);
ylabel('% Explained', 'FontName','Times New Roman', 'FontSize', nFontSize);

subplot(3,1,3);
plot(mGyroFirstSecond);
title(gca, [sTitle '--Gyro 1st+2nd Comp'], 'FontName','Times New Roman', 'FontSize', nFontSize);
xlabel('#Sample', 'FontName','Times New Roman', 'FontSize', nFontSize);
ylabel('% Explained', 'FontName','Times New Roman', 'FontSize', nFontSize);

return;
