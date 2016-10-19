function f = SBM_SelectFeatureCombination_withPCA_AllCombination()
% This function is used to get the statistics of performance of different
% feature combination
%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The Order of the feature combination list here is different from other
% scripts (e.g SBM_Plot_SelectedFeatureCombination)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

format long;

%sParentFolder = 'E:\SensorMatching\Data\SchoolShuttle\Evaluation';
%sParentFolder = 'E:\SensorMatching\Data\SchoolShuttle\Evaluation20160506_Yellow_SingleFeature';
%sParentFolder = 'E:\SensorMatching\Data\SchoolShuttle\Evaluation20160505_5Route_SingleFeature';
sParentFolder = 'E:\SensorMatching\Data\SchoolShuttle\Evaluation20160506_RawPcaPca2';


sFilePrefix = 'EvRet';
nPlot = 0;


sSelectFeatureCombWhichWhereWhen = 'E:\SensorMatching\Data\SchoolShuttle\SelectFeatureCombination20160506_RawPcaPca2\WhichWhereWhen.csv';
fid3W = fopen(sSelectFeatureCombWhichWhereWhen, 'w');

sSelectFeatureCombWhichWhere = 'E:\SensorMatching\Data\SchoolShuttle\SelectFeatureCombination20160506_RawPcaPca2\WhichWhere.csv';
fidWhichWhere = fopen(sSelectFeatureCombWhichWhere, 'w');

sSelectFeatureCombWhichWhen = 'E:\SensorMatching\Data\SchoolShuttle\SelectFeatureCombination20160506_RawPcaPca2\WhichWhen.csv';
fidWhichWhen = fopen(sSelectFeatureCombWhichWhen, 'w');

sSelectFeatureCombWhich = 'E:\SensorMatching\Data\SchoolShuttle\SelectFeatureCombination20160506_RawPcaPca2\Which.csv';
fidWhich = fopen(sSelectFeatureCombWhich, 'w');

mStatAllAccuracy = [];
mStatRouteSegAccuracy = [];

%mFeatures = [1:110, 112:116, 118:162, 164:168, 170:171];   %% Features, Feature 111, 117, 163, 169 are excluded
%mFeatures = [1:171];  

% Group/Sort Features
% mFeatures = [1:10, 51:56,       ...          % Linear Accl Time           (1  ~ 16)
%              11:20,  ...                     % Linear Accl Frequency      (17 ~ 26)
%              21:30, 57:62,     ...           % Gyro Time                  (27 ~ 42)
%              31:40,     ...                  % Gyro Frequency             (43 ~ 52)
%              41:50, 63:67,  ...              % Baro Time                  (53 ~ 67)
%              68:77, 108:110, 112:113, ...    % PCA Linear Accl Time       (68 ~ 82)
%              78:87,    ...                   % PCA Linear Accl Frequency  (83 ~ 92)
%              88:97, 114:116, 118:119, ...    % PCA Gyro Time              (93 ~ 107)
%              98:107,   ...                   % PCA Gyro Frequency         (108 ~ 117)
%              120:129, 160:162, 164:165, ...  % PCA2 Linear Accl Time      (118 ~ 132)
%              130:139, ...                    % PCA2 Linear Accl Frequency (133 ~ 142)
%              140:149, 166:168, 170:171, ...  % PCA2 Gyro Time             (143 ~ 157)
%              150:159, ...                    % PCA2 Gyro Time             (158 ~ 167)
%              ];

mFeaturesMotionOnly = [1:13, 14:26, 27:36, 59:69, 70:80, 81:86, 93:102, 103:112, 113:122, 129:139, 140:150, 151:156, 163:172, 173:182, 183:192, 199, 201:210];  % total 163

mFeaturesBaroOnly = [37:40,200];   % Total 5 (164~168)

mFeaturesMotionBaro = [41:58, 87:92,  123:128, 157:162, 193:198];   % Total 42  (169~210)


mFeatures = [mFeaturesMotionOnly, mFeaturesBaroOnly, mFeaturesMotionBaro];
%mFeatures = [1:200];

%xMaxVal = max(mFeatures)+1;
xMaxVal = length(mFeatures)+1;
xStep = 5;

%for i = 1:length(mCellSelectedFeatures)
for i = 1:length(mFeatures)
    %nFeatureCombIndex = mFeatureCombIndex(i);
    sResultFile = [sParentFolder '\' sFilePrefix];
    
%     if mFeatures(i) == 111 | mFeatures(i) == 117 | mFeatures(i) == 163 | mFeatures(i) == 169
%         mStatAllAccuracy(i,1) = 0;
%         mStatAllAccuracy(i,2) = 0;
%         mStatAllAccuracy(i,3) = 0;
%     
%         fprintf(fid3W, '%d, %3.5f, %3.5f, %3.5f\n', i, mAllAccuracy(1,1), mAllAccuracy(1,2), mAllAccuracy(1,3));
%        
%         mStatRouteSegAccuracy(i,1) = 0;
%         mStatRouteSegAccuracy(i,2) = 0;
%         mStatRouteSegAccuracy(i,3) = 0;
% 
%         fprintf(fidWhichWhere, '%d, %3.5f, %3.5f, %3.5f\n', i, mRouteSegAccuracy(1,1), mRouteSegAccuracy(1,2), mRouteSegAccuracy(1,3));
% 
%         mStatRouteTraceAccuracy(i,1) = 0;
%         mStatRouteTraceAccuracy(i,2) = 0;
%         mStatRouteTraceAccuracy(i,3) = 0;
% 
%         fprintf(fidWhichWhen, '%d, %3.5f, %3.5f, %3.5f\n', i, mRouteTraceAccuracy(1,1), mRouteTraceAccuracy(1,2), mRouteTraceAccuracy(1,3));
%   
%         mStatRouteAccuracy(i,1) = 0;
%         mStatRouteAccuracy(i,2) = 0;
%         mStatRouteAccuracy(i,3) = 0;
% 
%         fprintf(fidWhich, '%d, %3.5f, %3.5f, %3.5f\n', i, mRouteAccuracy(1,1), mRouteAccuracy(1,2), mRouteAccuracy(1,3));
%     
%         continue;
%     end
    
    %mSelectedFeatures = mCellSelectedFeatures{i};
    
    %for j = 1:length(mSelectedFeatures)
%        sResultFile = sprintf('%s_%d', sResultFile, mSelectedFeatures(j));
    %end
    
%    sResultFile = [sResultFile '.csv'];
    sResultFile = [sResultFile '_' num2str(mFeatures(i)) '.csv'];
    
    cellResult = SBM_EvaluteAccuracy(sResultFile, nPlot);

    % "All" means Route No, Trace No, Src Seg No and Dst Seg No all must be correct, 
                     % Column 1: Overall, Column 2: PantPocket, Column 3: Hand
                     % Row 1:  Overall
                     % Row 2~n:  Different Segment Len    
    mAllAccuracy = cellResult{1};    % (1+N)x3   (N = number of SegLen type)  

    mStatAllAccuracy(i,1) = mAllAccuracy(1,1);
    mStatAllAccuracy(i,2) = mAllAccuracy(1,2);
    mStatAllAccuracy(i,3) = mAllAccuracy(1,3);
    
    fprintf(fid3W, '%d, %3.5f, %3.5f, %3.5f\n', i, mAllAccuracy(1,1), mAllAccuracy(1,2), mAllAccuracy(1,3));
    
    % "RouteSeg" means Route No, Src Seg No and Dst Seg No all must be correct, 
                         % Column 1: Overall, Column 2: PantPocket, Column 3: Hand
                         % Row 1:  Overall
                         % Row 2~n:  Different Segment Len    
    mRouteSegAccuracy = cellResult{2};   % (1+N)x3   (N = number of SegLen type)

    mStatRouteSegAccuracy(i,1) = mRouteSegAccuracy(1,1);
    mStatRouteSegAccuracy(i,2) = mRouteSegAccuracy(1,2);
    mStatRouteSegAccuracy(i,3) = mRouteSegAccuracy(1,3);

    fprintf(fidWhichWhere, '%d, %3.5f, %3.5f, %3.5f\n', i, mRouteSegAccuracy(1,1), mRouteSegAccuracy(1,2), mRouteSegAccuracy(1,3));

    
    % "RouteTrace" means Route No, Trace No must be correct, 
                         % Column 1: Overall, Column 2: PantPocket, Column 3: Hand
                         % Row 1:  Overall
                         % Row 2~n:  Different Segment Len    
    mRouteTraceAccuracy = cellResult{3};   % (1+N)x3   (N = number of SegLen type)

    mStatRouteTraceAccuracy(i,1) = mRouteTraceAccuracy(1,1);
    mStatRouteTraceAccuracy(i,2) = mRouteTraceAccuracy(1,2);
    mStatRouteTraceAccuracy(i,3) = mRouteTraceAccuracy(1,3);

    fprintf(fidWhichWhen, '%d, %3.5f, %3.5f, %3.5f\n', i, mRouteTraceAccuracy(1,1), mRouteTraceAccuracy(1,2), mRouteTraceAccuracy(1,3));

    
    % "Route" means Route No must be correct, 
                         % Column 1: Overall, Column 2: PantPocket, Column 3: Hand
                         % Row 1:  Overall
                         % Row 2~n:  Different Segment Len    
    mRouteAccuracy = cellResult{4};   % (1+N)x3   (N = number of SegLen type)

    mStatRouteAccuracy(i,1) = mRouteAccuracy(1,1);
    mStatRouteAccuracy(i,2) = mRouteAccuracy(1,2);
    mStatRouteAccuracy(i,3) = mRouteAccuracy(1,3);

    fprintf(fidWhich, '%d, %3.5f, %3.5f, %3.5f\n', i, mRouteAccuracy(1,1), mRouteAccuracy(1,2), mRouteAccuracy(1,3));
    
    
    % "SegLen" shows different Segment Length statistics (PsgLen = RefLen;  PsgLen<RefLen; PsgLen > RefLen), 
                     % Column1~3: Overall; Column4~6: Pantpocket, Column7~9: Hand
                     % Row 1:  Overall
                     % Row 2~n:  Different Segment Len        
    %mSegLenStat = cellResult{3};    % (1+N)x9   (N = number of SegLen type)
    
end


fclose(fid3W);

fclose(fidWhichWhere);
fclose(fidWhichWhen);
fclose(fidWhich);


fprintf('Deciding Feature Combination...\n');


mStatAllAccuracy = mStatAllAccuracy*100.0;
mStatRouteSegAccuracy = mStatRouteSegAccuracy*100.0;
mStatRouteTraceAccuracy = mStatRouteTraceAccuracy*100.0;
mStatRouteAccuracy = mStatRouteAccuracy*100.0;


myColorLinearAcclT = [0.73 1 1];
myColorLinearAcclF = [0.68 0.92 1];
myColorGyroT = [0.85 0.95 0.9];
myColorGyroF = [0.76 0.87 0.78];
myColorBaro =  [0.93 0.84 0.84];


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Select Feature %%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(1);

hshade = area([0.5 163.5], [100 100], 'FaceColor', myColorLinearAcclT, 'LineStyle', 'none');   % Feature Combination including Motion sensor only
hold on;

hshade = area([163.5 168.5], [100 100], 'FaceColor', myColorBaro, 'LineStyle', 'none');   % Feature Combination including Baro only
hold on;

hshade = area([168.5 210.5], [100 100], 'FaceColor', myColorGyroT, 'LineStyle', 'none');   % Feature Combination including both Motion sensor and Baro
hold on;

% hshade = area([0.5 16.5], [100 100], 'FaceColor', myColorLinearAcclT, 'LineStyle', 'none');   % Linear Accl Time
% hold on;
% 
% hshade = area([16.5 26.5], [100 100], 'FaceColor', myColorLinearAcclF, 'LineStyle', 'none');   % Linear Accl Freq
% hold on;
% 
% hshade = area([26.5 42.5], [100 100], 'FaceColor', myColorGyroT, 'LineStyle', 'none');    % Gyro Time
% hold on;
% 
% hshade = area([42.5 52.5], [100 100], 'FaceColor', myColorGyroF, 'LineStyle', 'none');    % Gyro Freq
% hold on;
% 
% hshade = area([52.5 67.5], [100 100], 'FaceColor', myColorBaro, 'LineStyle', 'none');    % Baro
% hold on;
% 
% hshade = area([67.5 82.5], [100 100], 'FaceColor', myColorLinearAcclT, 'LineStyle', 'none');    % PCA Linear Accl Time
% hold on;
% 
% hshade = area([82.5 92.5], [100 100], 'FaceColor', myColorLinearAcclF, 'LineStyle', 'none');    % PCA Linear Accl Freq
% hold on;
% 
% hshade = area([92.5 107.5], [100 100], 'FaceColor', myColorGyroT, 'LineStyle', 'none');    % PCA Gyro Time
% hold on;
% 
% hshade = area([107.5 117.5], [100 100], 'FaceColor', myColorGyroF, 'LineStyle', 'none');    % PCA Gyro Freq
% hold on;
% 
% hshade = area([117.5 132.5], [100 100], 'FaceColor', myColorLinearAcclT, 'LineStyle', 'none');    % PCA2 Linear Accl Time
% hold on;
% 
% hshade = area([132.5 142.5], [100 100], 'FaceColor', myColorLinearAcclF, 'LineStyle', 'none');    % PCA2 Linear Accl Freq
% hold on;
% 
% hshade = area([142.5 157.5], [100 100], 'FaceColor', myColorGyroT, 'LineStyle', 'none');    % PCA2 Gyro Time
% hold on;
% 
% hshade = area([157.5 167.5], [100 100], 'FaceColor', myColorGyroF, 'LineStyle', 'none');    % PCA2 Gyro Freq
% hold on;






% Compare Accuracy of Which/Where/When (Overall) of Different Feature
% Combination
hLine1 = plot(mStatAllAccuracy(:,1), 'r-*', 'LineWidth', 3);
hold on;
hLine2 = plot(mStatAllAccuracy(:,2), 'g-*', 'LineWidth', 3);
hold on;
hLine3 = plot(mStatAllAccuracy(:,3), 'b-*', 'LineWidth', 3);
hold on;
legend([hLine1, hLine2, hLine3], 'Overall', 'Pocket', 'Hand');
title(gca, 'Accuracy of Which/Where/When (Overall)', 'FontName','Times New Roman', 'FontSize', 30);

set(gca, 'FontName','Times New Roman');
set(gca, 'FontSize', 24);
        
xlabelStr = 'Feature Combinations';

xlabel(xlabelStr, 'FontSize', 30);
ylabel('Accuracy (%)', 'FontSize', 30);
set(gca,'ygrid','on');
ylim([0 100]);
set(gca,'YTick',0:10:100);
set(gca,'xgrid','on');
xlim([0 xMaxVal]);
set(gca,'XTick',0:xStep:xMaxVal);
set(gca, 'Layer', 'top');



mIdxAllAccuracyOverall = find(mStatAllAccuracy(:,1)==max(mStatAllAccuracy(:,1)))
mIdxPocketAccuracyOverall = find(mStatAllAccuracy(:,2)==max(mStatAllAccuracy(:,2)))
mIdxHandAccuracyOverall = find(mStatAllAccuracy(:,3)==max(mStatAllAccuracy(:,3)))

sAllAccuracyOverall = '';
for i = 1:length(mIdxAllAccuracyOverall)
    if i == 1
        sAllAccuracyOverall = num2str(mIdxAllAccuracyOverall(i));
    else
        sAllAccuracyOverall = [sAllAccuracyOverall ',' num2str(mIdxAllAccuracyOverall(i))];
    end
end

sPocketAccuracyOverall = '';
for i = 1:length(mIdxPocketAccuracyOverall)
    if i == 1
        sPocketAccuracyOverall = num2str(mIdxPocketAccuracyOverall(i));
    else
        sPocketAccuracyOverall = [sPocketAccuracyOverall ',' num2str(mIdxPocketAccuracyOverall(i))];
    end
end

sHandAccuracyOverall = '';
for i = 1:length(mIdxHandAccuracyOverall)
    if i == 1
        sHandAccuracyOverall = num2str(mIdxHandAccuracyOverall(i));
    else
        sHandAccuracyOverall = [sHandAccuracyOverall ',' num2str(mIdxHandAccuracyOverall(i))];
    end
end

fprintf('[All] Accuracy Max Value Corresponding [Overall Index] = %s;  [Pocket Index] = %s;  [Hand Index] = %s\n', sAllAccuracyOverall, sPocketAccuracyOverall, sHandAccuracyOverall);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(2);
hshade = area([0.5 163.5], [100 100], 'FaceColor', myColorLinearAcclT, 'LineStyle', 'none');   % Feature Combination including Motion sensor only
hold on;

hshade = area([163.5 168.5], [100 100], 'FaceColor', myColorBaro, 'LineStyle', 'none');   % Feature Combination including Baro only
hold on;

hshade = area([168.5 210.5], [100 100], 'FaceColor', myColorGyroT, 'LineStyle', 'none');   % Feature Combination including both Motion sensor and Baro
hold on;

% hshade = area([0.5 16.5], [100 100], 'FaceColor', myColorLinearAcclT, 'LineStyle', 'none');   % Linear Accl Time
% hold on;
% 
% hshade = area([16.5 26.5], [100 100], 'FaceColor', myColorLinearAcclF, 'LineStyle', 'none');   % Linear Accl Freq
% hold on;
% 
% hshade = area([26.5 42.5], [100 100], 'FaceColor', myColorGyroT, 'LineStyle', 'none');    % Gyro Time
% hold on;
% 
% hshade = area([42.5 52.5], [100 100], 'FaceColor', myColorGyroF, 'LineStyle', 'none');    % Gyro Freq
% hold on;
% 
% hshade = area([52.5 67.5], [100 100], 'FaceColor', myColorBaro, 'LineStyle', 'none');    % Baro
% hold on;
% 
% hshade = area([67.5 82.5], [100 100], 'FaceColor', myColorLinearAcclT, 'LineStyle', 'none');    % PCA Linear Accl Time
% hold on;
% 
% hshade = area([82.5 92.5], [100 100], 'FaceColor', myColorLinearAcclF, 'LineStyle', 'none');    % PCA Linear Accl Freq
% hold on;
% 
% hshade = area([92.5 107.5], [100 100], 'FaceColor', myColorGyroT, 'LineStyle', 'none');    % PCA Gyro Time
% hold on;
% 
% hshade = area([107.5 117.5], [100 100], 'FaceColor', myColorGyroF, 'LineStyle', 'none');    % PCA Gyro Freq
% hold on;
% 
% hshade = area([117.5 132.5], [100 100], 'FaceColor', myColorLinearAcclT, 'LineStyle', 'none');    % PCA2 Linear Accl Time
% hold on;
% 
% hshade = area([132.5 142.5], [100 100], 'FaceColor', myColorLinearAcclF, 'LineStyle', 'none');    % PCA2 Linear Accl Freq
% hold on;
% 
% hshade = area([142.5 157.5], [100 100], 'FaceColor', myColorGyroT, 'LineStyle', 'none');    % PCA2 Gyro Time
% hold on;
% 
% hshade = area([157.5 167.5], [100 100], 'FaceColor', myColorGyroF, 'LineStyle', 'none');    % PCA2 Gyro Freq
% hold on;

% Compare Accuracy of Which/Where (Overall) of Different Feature
% Combination
hLine1 = plot(mStatRouteSegAccuracy(:,1), 'r-*', 'LineWidth', 3);
hold on;
hLine2 = plot(mStatRouteSegAccuracy(:,2), 'g-*', 'LineWidth', 3);
hold on;
hLine3 = plot(mStatRouteSegAccuracy(:,3), 'b-*', 'LineWidth', 3);
hold on;
legend([hLine1, hLine2, hLine3], 'Overall', 'Pocket', 'Hand');
title(gca, 'Accuracy of Which/Where (Overall)', 'FontName','Times New Roman', 'FontSize', 30);

set(gca, 'FontName','Times New Roman');
set(gca, 'FontSize', 24);
        
xlabelStr = 'Feature Combinations';

xlabel(xlabelStr, 'FontSize', 30);
ylabel('Accuracy (%)', 'FontSize', 30);
set(gca,'ygrid','on');
ylim([0 100]);
set(gca,'YTick',0:10:100);
set(gca,'xgrid','on');
xlim([0 xMaxVal]);
set(gca,'XTick',0:xStep:xMaxVal);
set(gca, 'Layer', 'top');

mIdxRouteSegAccuracyOverall = find(mStatRouteSegAccuracy(:,1)==max(mStatRouteSegAccuracy(:,1)));
mIdxPocketRouteSegAccuracyOverall = find(mStatRouteSegAccuracy(:,2)==max(mStatRouteSegAccuracy(:,2)));
mIdxHandRouteSegAccuracyOverall = find(mStatRouteSegAccuracy(:,3)==max(mStatRouteSegAccuracy(:,3)));


sRouteSegAccuracyOverall = '';
for i = 1:length(mIdxRouteSegAccuracyOverall)
    if i == 1
        sRouteSegAccuracyOverall = num2str(mIdxRouteSegAccuracyOverall(i));
    else
        sRouteSegAccuracyOverall = [sRouteSegAccuracyOverall ',' num2str(mIdxRouteSegAccuracyOverall(i))];
    end
end

sPocketRouteSegAccuracyOverall = '';
for i = 1:length(mIdxPocketRouteSegAccuracyOverall)
    if i == 1
        sPocketRouteSegAccuracyOverall = num2str(mIdxPocketRouteSegAccuracyOverall(i));
    else
        sPocketRouteSegAccuracyOverall = [sPocketRouteSegAccuracyOverall ',' num2str(mIdxPocketRouteSegAccuracyOverall(i))];
    end
end

sHandRouteSegAccuracyOverall = '';
for i = 1:length(mIdxHandRouteSegAccuracyOverall)
    if i == 1
        sHandRouteSegAccuracyOverall = num2str(mIdxHandRouteSegAccuracyOverall(i));
    else
        sHandRouteSegAccuracyOverall = [sHandRouteSegAccuracyOverall ',' num2str(mIdxHandRouteSegAccuracyOverall(i))];
    end
end


fprintf('[Route Seg] Accuracy Max Value Corresponding [Overall Index] = %s;  [Pocket Index] = %s;  [Hand Index] = %s\n', sRouteSegAccuracyOverall, sPocketRouteSegAccuracyOverall, sHandRouteSegAccuracyOverall);




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(3);
hshade = area([0.5 163.5], [100 100], 'FaceColor', myColorLinearAcclT, 'LineStyle', 'none');   % Feature Combination including Motion sensor only
hold on;

hshade = area([163.5 168.5], [100 100], 'FaceColor', myColorBaro, 'LineStyle', 'none');   % Feature Combination including Baro only
hold on;

hshade = area([168.5 210.5], [100 100], 'FaceColor', myColorGyroT, 'LineStyle', 'none');   % Feature Combination including both Motion sensor and Baro
hold on;

% hshade = area([0.5 16.5], [100 100], 'FaceColor', myColorLinearAcclT, 'LineStyle', 'none');   % Linear Accl Time
% hold on;
% 
% hshade = area([16.5 26.5], [100 100], 'FaceColor', myColorLinearAcclF, 'LineStyle', 'none');   % Linear Accl Freq
% hold on;
% 
% hshade = area([26.5 42.5], [100 100], 'FaceColor', myColorGyroT, 'LineStyle', 'none');    % Gyro Time
% hold on;
% 
% hshade = area([42.5 52.5], [100 100], 'FaceColor', myColorGyroF, 'LineStyle', 'none');    % Gyro Freq
% hold on;
% 
% hshade = area([52.5 67.5], [100 100], 'FaceColor', myColorBaro, 'LineStyle', 'none');    % Baro
% hold on;
% 
% hshade = area([67.5 82.5], [100 100], 'FaceColor', myColorLinearAcclT, 'LineStyle', 'none');    % PCA Linear Accl Time
% hold on;
% 
% hshade = area([82.5 92.5], [100 100], 'FaceColor', myColorLinearAcclF, 'LineStyle', 'none');    % PCA Linear Accl Freq
% hold on;
% 
% hshade = area([92.5 107.5], [100 100], 'FaceColor', myColorGyroT, 'LineStyle', 'none');    % PCA Gyro Time
% hold on;
% 
% hshade = area([107.5 117.5], [100 100], 'FaceColor', myColorGyroF, 'LineStyle', 'none');    % PCA Gyro Freq
% hold on;
% 
% hshade = area([117.5 132.5], [100 100], 'FaceColor', myColorLinearAcclT, 'LineStyle', 'none');    % PCA2 Linear Accl Time
% hold on;
% 
% hshade = area([132.5 142.5], [100 100], 'FaceColor', myColorLinearAcclF, 'LineStyle', 'none');    % PCA2 Linear Accl Freq
% hold on;
% 
% hshade = area([142.5 157.5], [100 100], 'FaceColor', myColorGyroT, 'LineStyle', 'none');    % PCA2 Gyro Time
% hold on;
% 
% hshade = area([157.5 167.5], [100 100], 'FaceColor', myColorGyroF, 'LineStyle', 'none');    % PCA2 Gyro Freq
% hold on;

% Compare Accuracy of Which/When (Overall) of Different Feature
% Combination
hLine1 = plot(mStatRouteTraceAccuracy(:,1), 'r-*', 'LineWidth', 3);
hold on;
hLine2 = plot(mStatRouteTraceAccuracy(:,2), 'g-*', 'LineWidth', 3);
hold on;
hLine3 = plot(mStatRouteTraceAccuracy(:,3), 'b-*', 'LineWidth', 3);
hold on;
legend([hLine1, hLine2, hLine3], 'Overall', 'Pocket', 'Hand');
title(gca, 'Accuracy of Which/When (Overall)', 'FontName','Times New Roman', 'FontSize', 30);

set(gca, 'FontName','Times New Roman');
set(gca, 'FontSize', 24);
        
xlabelStr = 'Feature Combinations';

xlabel(xlabelStr, 'FontSize', 30);
ylabel('Accuracy (%)', 'FontSize', 30);
set(gca,'ygrid','on');
ylim([0 100]);
set(gca,'YTick',0:10:100);
set(gca,'xgrid','on');
xlim([0 xMaxVal]);
set(gca,'XTick',0:xStep:xMaxVal);
set(gca, 'Layer', 'top');

mIdxRouteTraceAccuracyOverall = find(mStatRouteTraceAccuracy(:,1)==max(mStatRouteTraceAccuracy(:,1)));
mIdxPocketRouteTraceAccuracyOverall = find(mStatRouteTraceAccuracy(:,2)==max(mStatRouteTraceAccuracy(:,2)));
mIdxHandRouteTraceAccuracyOverall = find(mStatRouteTraceAccuracy(:,3)==max(mStatRouteTraceAccuracy(:,3)));


sRouteTraceAccuracyOverall = '';
for i = 1:length(mIdxRouteTraceAccuracyOverall)
    if i == 1
        sRouteTraceAccuracyOverall = num2str(mIdxRouteTraceAccuracyOverall(i));
    else
        sRouteTraceAccuracyOverall = [sRouteTraceAccuracyOverall ',' num2str(mIdxRouteTraceAccuracyOverall(i))];
    end
end

sPocketRouteTraceAccuracyOverall = '';
for i = 1:length(mIdxPocketRouteTraceAccuracyOverall)
    if i == 1
        sPocketRouteTraceAccuracyOverall = num2str(mIdxPocketRouteTraceAccuracyOverall(i));
    else
        sPocketRouteTraceAccuracyOverall = [sPocketRouteTraceAccuracyOverall ',' num2str(mIdxPocketRouteTraceAccuracyOverall(i))];
    end
end

sHandRouteTraceAccuracyOverall = '';
for i = 1:length(mIdxHandRouteTraceAccuracyOverall)
    if i == 1
        sHandRouteTraceAccuracyOverall = num2str(mIdxHandRouteTraceAccuracyOverall(i));
    else
        sHandRouteTraceAccuracyOverall = [sHandRouteTraceAccuracyOverall ',' num2str(mIdxHandRouteTraceAccuracyOverall(i))];
    end
end


fprintf('[Route Trace] Accuracy Max Value Corresponding [Overall Index] = %s;  [Pocket Index] = %s;  [Hand Index] = %s\n', sRouteTraceAccuracyOverall, sPocketRouteTraceAccuracyOverall, sHandRouteTraceAccuracyOverall);







%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(4);
hshade = area([0.5 163.5], [100 100], 'FaceColor', myColorLinearAcclT, 'LineStyle', 'none');   % Feature Combination including Motion sensor only
hold on;

hshade = area([163.5 168.5], [100 100], 'FaceColor', myColorBaro, 'LineStyle', 'none');   % Feature Combination including Baro only
hold on;

hshade = area([168.5 210.5], [100 100], 'FaceColor', myColorGyroT, 'LineStyle', 'none');   % Feature Combination including both Motion sensor and Baro
hold on;

% hshade = area([0.5 16.5], [100 100], 'FaceColor', myColorLinearAcclT, 'LineStyle', 'none');   % Linear Accl Time
% hold on;
% 
% hshade = area([16.5 26.5], [100 100], 'FaceColor', myColorLinearAcclF, 'LineStyle', 'none');   % Linear Accl Freq
% hold on;
% 
% hshade = area([26.5 42.5], [100 100], 'FaceColor', myColorGyroT, 'LineStyle', 'none');    % Gyro Time
% hold on;
% 
% hshade = area([42.5 52.5], [100 100], 'FaceColor', myColorGyroF, 'LineStyle', 'none');    % Gyro Freq
% hold on;
% 
% hshade = area([52.5 67.5], [100 100], 'FaceColor', myColorBaro, 'LineStyle', 'none');    % Baro
% hold on;
% 
% hshade = area([67.5 82.5], [100 100], 'FaceColor', myColorLinearAcclT, 'LineStyle', 'none');    % PCA Linear Accl Time
% hold on;
% 
% hshade = area([82.5 92.5], [100 100], 'FaceColor', myColorLinearAcclF, 'LineStyle', 'none');    % PCA Linear Accl Freq
% hold on;
% 
% hshade = area([92.5 107.5], [100 100], 'FaceColor', myColorGyroT, 'LineStyle', 'none');    % PCA Gyro Time
% hold on;
% 
% hshade = area([107.5 117.5], [100 100], 'FaceColor', myColorGyroF, 'LineStyle', 'none');    % PCA Gyro Freq
% hold on;
% 
% hshade = area([117.5 132.5], [100 100], 'FaceColor', myColorLinearAcclT, 'LineStyle', 'none');    % PCA2 Linear Accl Time
% hold on;
% 
% hshade = area([132.5 142.5], [100 100], 'FaceColor', myColorLinearAcclF, 'LineStyle', 'none');    % PCA2 Linear Accl Freq
% hold on;
% 
% hshade = area([142.5 157.5], [100 100], 'FaceColor', myColorGyroT, 'LineStyle', 'none');    % PCA2 Gyro Time
% hold on;
% 
% hshade = area([157.5 167.5], [100 100], 'FaceColor', myColorGyroF, 'LineStyle', 'none');    % PCA2 Gyro Freq
% hold on;

% Compare Accuracy of Which (Overall) of Different Feature
% Combination
hLine1 = plot(mStatRouteAccuracy(:,1), 'r-*', 'LineWidth', 3);
hold on;
hLine2 = plot(mStatRouteAccuracy(:,2), 'g-*', 'LineWidth', 3);
hold on;
hLine3 = plot(mStatRouteAccuracy(:,3), 'b-*', 'LineWidth', 3);
hold on;
legend([hLine1, hLine2, hLine3], 'Overall', 'Pocket', 'Hand');
title(gca, 'Accuracy of Which (Overall)', 'FontName','Times New Roman', 'FontSize', 30);

set(gca, 'FontName','Times New Roman');
set(gca, 'FontSize', 24);
        
xlabelStr = 'Feature Combinations';

xlabel(xlabelStr, 'FontSize', 30);
ylabel('Accuracy (%)', 'FontSize', 30);
set(gca,'ygrid','on');
ylim([0 100]);
set(gca,'YTick',0:10:100);
set(gca,'xgrid','on');
xlim([0 xMaxVal]);
set(gca,'XTick',0:xStep:xMaxVal);
set(gca, 'Layer', 'top');

mIdxRouteAccuracyOverall = find(mStatRouteAccuracy(:,1)==max(mStatRouteAccuracy(:,1)));
mIdxPocketRouteAccuracyOverall = find(mStatRouteAccuracy(:,2)==max(mStatRouteAccuracy(:,2)));
mIdxHandRouteAccuracyOverall = find(mStatRouteAccuracy(:,3)==max(mStatRouteAccuracy(:,3)));


sRouteAccuracyOverall = '';
for i = 1:length(mIdxRouteAccuracyOverall)
    if i == 1
        sRouteAccuracyOverall = num2str(mIdxRouteAccuracyOverall(i));
    else
        sRouteAccuracyOverall = [sRouteAccuracyOverall ',' num2str(mIdxRouteAccuracyOverall(i))];
    end
end

sPocketRouteAccuracyOverall = '';
for i = 1:length(mIdxPocketRouteAccuracyOverall)
    if i == 1
        sPocketRouteAccuracyOverall = num2str(mIdxPocketRouteAccuracyOverall(i));
    else
        sPocketRouteAccuracyOverall = [sPocketRouteAccuracyOverall ',' num2str(mIdxPocketRouteAccuracyOverall(i))];
    end
end

sHandRouteAccuracyOverall = '';
for i = 1:length(mIdxHandRouteAccuracyOverall)
    if i == 1
        sHandRouteAccuracyOverall = num2str(mIdxHandRouteAccuracyOverall(i));
    else
        sHandRouteAccuracyOverall = [sHandRouteAccuracyOverall ',' num2str(mIdxHandRouteAccuracyOverall(i))];
    end
end


fprintf('[Route] Accuracy Max Value Corresponding [Overall Index] = %s;  [Pocket Index] = %s;  [Hand Index] = %s\n', sRouteAccuracyOverall, sPocketRouteAccuracyOverall, sHandRouteAccuracyOverall);







return;





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Compare performance with different Feature Combination

mFeatureCombinationIdx = [2 10 12 20 22 25 28 31 33 40 44]; % Index of Feature Combination to Compare

mCompareCombinationAllAccuracy = mStatAllAccuracy(mFeatureCombinationIdx, :);

mCompareCombinationRouteSegAccuracy = mStatRouteSegAccuracy(mFeatureCombinationIdx, :);

mCompareCombinationAllAccuracy = mCompareCombinationAllAccuracy*100.0;
mCompareCombinationRouteSegAccuracy = mCompareCombinationRouteSegAccuracy*100.0;


xTickTextSegLen = [];
for i = 1:length(mFeatureCombinationIdx)
    xTickTextSegLen{i} = num2str(i);
end

% Compare Different Feature Combinations (Corresponding to Different usage
% of Sensors) based on Accuracy of Which/Where/When
figure(3);

bar(mCompareCombinationAllAccuracy);  %colormap(gray);

title(gca, 'Accuracy of Which/Where/When', 'FontName','Times New Roman', 'FontSize', 30);

set(gca, 'FontName','Times New Roman');
set(gca, 'FontSize', 30);
        
set(gca, 'XTickLabel', xTickTextSegLen);
set(gca,'YTick',0:10:100);
    
xlabelStr = 'Index of Feature Combination';

xlabel(xlabelStr, 'FontSize', 36);
ylabel('Accuracy (%)', 'FontSize', 36);
set(gca,'ygrid','on');
ylim([0 100]);
legend('Overall', 'Pocket', 'Hand');



% Compare Different Feature Combinations (Corresponding to Different usage
% of Sensors) based on Accuracy of Which/Where
figure(4);

bar(mCompareCombinationRouteSegAccuracy);  %colormap(gray);

title(gca, 'Accuracy of Which/Where', 'FontName','Times New Roman', 'FontSize', 30);

set(gca, 'FontName','Times New Roman');
set(gca, 'FontSize', 30);
        
set(gca, 'XTickLabel', xTickTextSegLen);
set(gca,'YTick',0:10:100);
    
xlabelStr = 'Index of Feature Combination';

xlabel(xlabelStr, 'FontSize', 36);
ylabel('Accuracy (%)', 'FontSize', 36);
set(gca,'ygrid','on');
ylim([0 100]);
legend('Overall', 'Pocket', 'Hand');


disp('>>>>>>>>>>>>>>DONE<<<<<<<<<<<<<<');

return;