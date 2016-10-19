function f = SBM_SelectFeatureCombination()
% This function is used to get the statistics of performance of different
% feature combination
%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The Order of the feature combination list here is different from other
% scripts (e.g SBM_Plot_SelectedFeatureCombination)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

format long;

%sParentFolder = 'E:\SensorMatching\Data\SchoolShuttle\Evaluation';
sParentFolder = 'E:\SensorMatching\Data\SchoolShuttle\Evaluation20160226';

sFilePrefix = 'EvRet';
nPlot = 0;

mCellSelectedFeatures = [];

% Accl Time
mCellSelectedFeatures{1} = [1 2 3 4];
mCellSelectedFeatures{2} = [1 2 3 4 5 6 7 8 9 10];

% Accl Frequency
mCellSelectedFeatures{3} = [11 12 13 14];
mCellSelectedFeatures{4} = [11 15 16 17];
mCellSelectedFeatures{5} = [11 18 19 20];
mCellSelectedFeatures{6} = [11 12 13 14 15 16 17 18 19 20];

% Accl Time & Frequency
mCellSelectedFeatures{7} = [1 2 3 4 11 12 13 14];
mCellSelectedFeatures{8} = [1 2 3 4 5 6 7 8 9 10 11 12 13 14];
mCellSelectedFeatures{9} = [1 2 3 4 5 6 7 8 9 10 11 15 16 17];
mCellSelectedFeatures{10} = [1 2 3 4 5 6 7 8 9 10 11 18 19 20];

% Gyro Time
mCellSelectedFeatures{11} = [21 22 23 24];
mCellSelectedFeatures{12} = [21 22 23 24 25 26 27 28 29 30];

% Gyro Frequency
mCellSelectedFeatures{13} = [31 32 33 34];
mCellSelectedFeatures{14} = [31 35 36 37];
mCellSelectedFeatures{15} = [31 38 39 40];
mCellSelectedFeatures{16} = [31 32 33 34 35 36 37 38 39 40];

% Gyro Time & Frequency
mCellSelectedFeatures{17} = [21 22 23 24 31 32 33 34];
mCellSelectedFeatures{18} = [21 22 23 24 25 26 27 28 30 31 32 33 34];
mCellSelectedFeatures{19} = [21 22 23 24 25 26 27 28 30 31 35 36 37];
mCellSelectedFeatures{20} = [21 22 23 24 25 26 27 28 30 31 38 39 40];


% Accl & Gyro
mCellSelectedFeatures{21} = [1 2 3 4 21 22 23 24];
mCellSelectedFeatures{22} = [1 2 3 4 5 6 7 8 10 21 22 23 24 25 26 27 28 30];
mCellSelectedFeatures{23} = [1 2 3 4 5 6 7 8 9 10 21 22 23 24 25 26 27 28 29 30];

mCellSelectedFeatures{24} = [11 12 13 14 31 32 33 34];
mCellSelectedFeatures{25} = [1 2 3 4 11 12 13 14 21 22 23 24 31 32 33 34];

mCellSelectedFeatures{26} = [1 2 3 4 11 18 19 20 21 22 23 24 31 38 39 40];  % Index starts from 1
% Accl & Gyro
mCellSelectedFeatures{27} = [1 2 3 4 5 6 7 8 9 10 11 12 13 14 21 22 23 24 25 26 27 28 29 30 31 32 33 34];

% Baro
mCellSelectedFeatures{28} = [41];  % Baro only

mCellSelectedFeatures{29} = [41 42 43 44];
mCellSelectedFeatures{30} = [41 42 43 44 45 46 47 48 49 50];

% Accl % Baro
mCellSelectedFeatures{31} = [1 2 3 4 41 42 43 44];
mCellSelectedFeatures{32} = [1 2 3 4 5 6 7 8 10 41 42 43 44 45 46 47 48 50];
mCellSelectedFeatures{33} = [1 2 3 4 5 6 7 8 9 10 41 42 43 44 45 46 47 48 49 50];

mCellSelectedFeatures{34} = [11 12 13 14 41 42 43 44];
mCellSelectedFeatures{35} = [1 2 3 4 5 6 7 8 9 10 11 12 13 14 41 42 43 44 45 46 47 48 49 50];

% Gyro & Baro
mCellSelectedFeatures{36} = [21 22 23 24 41 42 43 44];
mCellSelectedFeatures{37} = [21 22 23 24 25 26 27 28 30 41 42 43 44 45 46 47 48 50];
mCellSelectedFeatures{38} = [21 22 23 24 25 26 27 28 29 30 41 42 43 44 45 46 47 48 49 50];

mCellSelectedFeatures{39} = [31 32 33 34 41 42 43 44];
mCellSelectedFeatures{40} = [21 22 23 24 25 26 27 28 29 30 31 32 33 34 41 42 43 44 45 46 47 48 49 50];

% Accl & Gyro & Baro
mCellSelectedFeatures{41} = [1 2 3 4 21 22 23 24 41 42 43 44];
mCellSelectedFeatures{42} = [1 2 3 4 5 6 7 8 9 10 21 22 23 24 25 26 27 28 29 30 41 42 43 44 45 46 47 48 49 50];
mCellSelectedFeatures{43} = [1 2 3 4 11 12 13 14 21 22 23 24 31 32 33 34 41 42 43 44];
mCellSelectedFeatures{44} = [1 2 3 4 11 15 16 17 21 22 23 24 31 35 36 37 41 42 43 44];
mCellSelectedFeatures{45} = [1 2 3 4 11 18 19 20 21 22 23 24 31 38 39 40 41 42 43 44];
mCellSelectedFeatures{46} = [1 2 3 4 5 6 7 8 9 10 11 12 13 14 21 22 23 24 25 26 27 28 29 30 31 32 33 34 41 42 43 44 45 46 47 48 49 50];




% % First set:  Accl (Index: 1--10) +   Gyro (11-20);  Accl+Gyro (21-27);   Baro (28-30);   Accl/Gyro + Baro (31-46)
% % (outdated, because the above indexes have been adjusted to correct order) mFeatureCombIndex = [1 2 3 4 5 6 7 8 9 10    11 12 13 14 15 16 17 18 19 20    23 24 25 26 27 28 46    45 21 22    29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44];  
% %                           Accl                      Gyro                           Accl+Gyro            Baro                   Accl/Gyro + Baro
% %

sSelectFeatureCombWhichWhereWhen = 'E:\SensorMatching\Data\SchoolShuttle\SelectFeatureCombination20160226\WhichWhereWhen.csv';
fid3W = fopen(sSelectFeatureCombWhichWhereWhen, 'w');

sSelectFeatureCombWhichWhere = 'E:\SensorMatching\Data\SchoolShuttle\SelectFeatureCombination20160226\WhichWhere.csv';
fidWhichWhere = fopen(sSelectFeatureCombWhichWhere, 'w');

sSelectFeatureCombWhichWhen = 'E:\SensorMatching\Data\SchoolShuttle\SelectFeatureCombination20160226\WhichWhen.csv';
fidWhichWhen = fopen(sSelectFeatureCombWhichWhen, 'w');

sSelectFeatureCombWhich = 'E:\SensorMatching\Data\SchoolShuttle\SelectFeatureCombination20160226\Which.csv';
fidWhich = fopen(sSelectFeatureCombWhich, 'w');

mStatAllAccuracy = [];
mStatRouteSegAccuracy = [];

%for i = 1:length(mCellSelectedFeatures)
for i = 1:length(mCellSelectedFeatures)
    %nFeatureCombIndex = mFeatureCombIndex(i);
    sResultFile = [sParentFolder '\' sFilePrefix];
    
    mSelectedFeatures = mCellSelectedFeatures{i};
    
    for j = 1:length(mSelectedFeatures)
        sResultFile = sprintf('%s_%d', sResultFile, mSelectedFeatures(j));
    end
    
    sResultFile = [sResultFile '.csv'];
    
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Select Feature %%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(1);

myColor1 = [0.73 1 1];
hshade = area([0.5 10.5], [100 100], 'FaceColor', myColor1, 'LineStyle', 'none');   % Accl
hold on;

myColor2 = [0.68 0.92 1];
hshade = area([10.5 20.5], [100 100], 'FaceColor', myColor2, 'LineStyle', 'none');   % Gyro
hold on;

myColor3 = [0.85 0.95 0.9];
hshade = area([20.5 27.5], [100 100], 'FaceColor', myColor3, 'LineStyle', 'none');    % Accl + Gyro
hold on;

myColor4 = [0.93 0.84 0.84];
hshade = area([27.5 30.5], [100 100], 'FaceColor', myColor4, 'LineStyle', 'none');    % Baro
hold on;

myColor5 = [0.76 0.87 0.78];
hshade = area([30.5 46.5], [100 100], 'FaceColor', myColor5, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;


% Compare Accuracy of Which/Where/When (Overall) of Different Feature
% Combination
hLine1 = plot(mStatAllAccuracy(:,1), 'r-*', 'LineWidth', 3);
hold on;
hLine2 = plot(mStatAllAccuracy(:,2), 'g-*', 'LineWidth', 3);
hold on;
hLine3 = plot(mStatAllAccuracy(:,3), 'b-*', 'LineWidth', 3);
hold on;
legend([hLine1, hLine2, hLine3], 'Overall', 'Pocket', 'Hand');
title(gca, 'Accuracy of Which/Where/When (Overall)', 'FontName','Times New Roman', 'FontSize', 40);

set(gca, 'FontName','Times New Roman');
set(gca, 'FontSize', 24);
        
xlabelStr = 'Feature Combinations';

xlabel(xlabelStr, 'FontSize', 40);
ylabel('Accuracy (%)', 'FontSize', 40);
set(gca,'ygrid','on');
ylim([0 100]);
set(gca,'YTick',0:10:100);
set(gca,'xgrid','on');
xlim([0 47]);
set(gca,'XTick',0:1:47);
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
myColor1 = [0.73 1 1];
hshade = area([0.5 10.5], [100 100], 'FaceColor', myColor1, 'LineStyle', 'none');   % Accl
hold on;

myColor2 = [0.68 0.92 1];
hshade = area([10.5 20.5], [100 100], 'FaceColor', myColor2, 'LineStyle', 'none');   % Gyro
hold on;

myColor3 = [0.85 0.95 0.9];
hshade = area([20.5 27.5], [100 100], 'FaceColor', myColor3, 'LineStyle', 'none');    % Accl + Gyro
hold on;

myColor4 = [0.93 0.84 0.84];
hshade = area([27.5 30.5], [100 100], 'FaceColor', myColor4, 'LineStyle', 'none');    % Baro
hold on;

myColor5 = [0.76 0.87 0.78];
hshade = area([30.5 46.5], [100 100], 'FaceColor', myColor5, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

% Compare Accuracy of Which/Where (Overall) of Different Feature
% Combination
hLine1 = plot(mStatRouteSegAccuracy(:,1), 'r-*', 'LineWidth', 3);
hold on;
hLine2 = plot(mStatRouteSegAccuracy(:,2), 'g-*', 'LineWidth', 3);
hold on;
hLine3 = plot(mStatRouteSegAccuracy(:,3), 'b-*', 'LineWidth', 3);
hold on;
legend([hLine1, hLine2, hLine3], 'Overall', 'Pocket', 'Hand');
title(gca, 'Accuracy of Which/Where (Overall)', 'FontName','Times New Roman', 'FontSize', 40);

set(gca, 'FontName','Times New Roman');
set(gca, 'FontSize', 24);
        
xlabelStr = 'Feature Combinations';

xlabel(xlabelStr, 'FontSize', 40);
ylabel('Accuracy (%)', 'FontSize', 40);
set(gca,'ygrid','on');
ylim([0 100]);
set(gca,'YTick',0:10:100);
set(gca,'xgrid','on');
xlim([0 47]);
set(gca,'XTick',0:1:47);
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
myColor1 = [0.73 1 1];
hshade = area([0.5 10.5], [100 100], 'FaceColor', myColor1, 'LineStyle', 'none');   % Accl
hold on;

myColor2 = [0.68 0.92 1];
hshade = area([10.5 20.5], [100 100], 'FaceColor', myColor2, 'LineStyle', 'none');   % Gyro
hold on;

myColor3 = [0.85 0.95 0.9];
hshade = area([20.5 27.5], [100 100], 'FaceColor', myColor3, 'LineStyle', 'none');    % Accl + Gyro
hold on;

myColor4 = [0.93 0.84 0.84];
hshade = area([27.5 30.5], [100 100], 'FaceColor', myColor4, 'LineStyle', 'none');    % Baro
hold on;

myColor5 = [0.76 0.87 0.78];
hshade = area([30.5 46.5], [100 100], 'FaceColor', myColor5, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

% Compare Accuracy of Which/When (Overall) of Different Feature
% Combination
hLine1 = plot(mStatRouteTraceAccuracy(:,1), 'r-*', 'LineWidth', 3);
hold on;
hLine2 = plot(mStatRouteTraceAccuracy(:,2), 'g-*', 'LineWidth', 3);
hold on;
hLine3 = plot(mStatRouteTraceAccuracy(:,3), 'b-*', 'LineWidth', 3);
hold on;
legend([hLine1, hLine2, hLine3], 'Overall', 'Pocket', 'Hand');
title(gca, 'Accuracy of Which/When (Overall)', 'FontName','Times New Roman', 'FontSize', 40);

set(gca, 'FontName','Times New Roman');
set(gca, 'FontSize', 24);
        
xlabelStr = 'Feature Combinations';

xlabel(xlabelStr, 'FontSize', 40);
ylabel('Accuracy (%)', 'FontSize', 40);
set(gca,'ygrid','on');
ylim([0 100]);
set(gca,'YTick',0:10:100);
set(gca,'xgrid','on');
xlim([0 47]);
set(gca,'XTick',0:1:47);
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
myColor1 = [0.73 1 1];
hshade = area([0.5 10.5], [100 100], 'FaceColor', myColor1, 'LineStyle', 'none');   % Accl
hold on;

myColor2 = [0.68 0.92 1];
hshade = area([10.5 20.5], [100 100], 'FaceColor', myColor2, 'LineStyle', 'none');   % Gyro
hold on;

myColor3 = [0.85 0.95 0.9];
hshade = area([20.5 27.5], [100 100], 'FaceColor', myColor3, 'LineStyle', 'none');    % Accl + Gyro
hold on;

myColor4 = [0.93 0.84 0.84];
hshade = area([27.5 30.5], [100 100], 'FaceColor', myColor4, 'LineStyle', 'none');    % Baro
hold on;

myColor5 = [0.76 0.87 0.78];
hshade = area([30.5 46.5], [100 100], 'FaceColor', myColor5, 'LineStyle', 'none');    % Accl/Gyro + Baro
hold on;

% Compare Accuracy of Which (Overall) of Different Feature
% Combination
hLine1 = plot(mStatRouteAccuracy(:,1), 'r-*', 'LineWidth', 3);
hold on;
hLine2 = plot(mStatRouteAccuracy(:,2), 'g-*', 'LineWidth', 3);
hold on;
hLine3 = plot(mStatRouteAccuracy(:,3), 'b-*', 'LineWidth', 3);
hold on;
legend([hLine1, hLine2, hLine3], 'Overall', 'Pocket', 'Hand');
title(gca, 'Accuracy of Which (Overall)', 'FontName','Times New Roman', 'FontSize', 40);

set(gca, 'FontName','Times New Roman');
set(gca, 'FontSize', 24);
        
xlabelStr = 'Feature Combinations';

xlabel(xlabelStr, 'FontSize', 40);
ylabel('Accuracy (%)', 'FontSize', 40);
set(gca,'ygrid','on');
ylim([0 100]);
set(gca,'YTick',0:10:100);
set(gca,'xgrid','on');
xlim([0 47]);
set(gca,'XTick',0:1:47);
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