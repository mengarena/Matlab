disp('Start Testing Stop Detection [with SVM].............');

sResultFile = 'E:\SensorMatching\Data\SchoolShuttle\TrainedModel\SVM\Normal\SVM_Result.csv';
fidWrite = fopen(sResultFile, 'w');

mPosition = [1 2 3 4 0];    %1: Ref, 2: Pocket, 3: Hand, 4: Pocket+Hand (Passenger),  0-All,  


disp('--------Feature: [2]');
mSelectedFeatures = [2];

sLine = '';
for j = 1:length(mPosition)
    fAccuracy = SBM_Script_StopDetection_SVM(mSelectedFeatures, mPosition(j));
    if j == 1
        sLine = sprintf('%2.3f', fAccuracy);
    elseif j == length(mPosition)
        sLine = sprintf('%s, %2.3f;   ', sLine, fAccuracy);
    else
        sLine = sprintf('%s, %2.3f', sLine, fAccuracy);
    end
end

sLine = sprintf('%s  Feature Idx: [', sLine);
for k = 1:length(mSelectedFeatures)
    sLine = sprintf('%s %d', sLine, mSelectedFeatures(k));
end
sLine = sprintf('%s ]', sLine);

fprintf(fidWrite, '%s\n', sLine);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
mSelectedFeatures = [3];
disp('--------Feature: [3]');

sLine = '';
for j = 1:length(mPosition)
    fAccuracy = SBM_Script_StopDetection_SVM(mSelectedFeatures, mPosition(j));
    if j == 1
        sLine = sprintf('%2.3f', fAccuracy);
    elseif j == length(mPosition)
        sLine = sprintf('%s, %2.3f;   ', sLine, fAccuracy);
    else
        sLine = sprintf('%s, %2.3f', sLine, fAccuracy);
    end
end

sLine = sprintf('%s  Feature Idx: [', sLine);
for k = 1:length(mSelectedFeatures)
    sLine = sprintf('%s %d', sLine, mSelectedFeatures(k));
end
sLine = sprintf('%s ]', sLine);

fprintf(fidWrite, '%s\n', sLine);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
mSelectedFeatures = [2 3];
disp('--------Feature: [2 3]');

sLine = '';
for j = 1:length(mPosition)
    fAccuracy = SBM_Script_StopDetection_SVM(mSelectedFeatures, mPosition(j));
    if j == 1
        sLine = sprintf('%2.3f', fAccuracy);
    elseif j == length(mPosition)
        sLine = sprintf('%s, %2.3f;   ', sLine, fAccuracy);
    else
        sLine = sprintf('%s, %2.3f', sLine, fAccuracy);
    end
end

sLine = sprintf('%s  Feature Idx: [', sLine);
for k = 1:length(mSelectedFeatures)
    sLine = sprintf('%s %d', sLine, mSelectedFeatures(k));
end
sLine = sprintf('%s ]', sLine);

fprintf(fidWrite, '%s\n', sLine);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
mSelectedFeatures = [2 3 6];
disp('--------Feature: [2 3 6]');

sLine = '';
for j = 1:length(mPosition)
    fAccuracy = SBM_Script_StopDetection_SVM(mSelectedFeatures, mPosition(j));
    if j == 1
        sLine = sprintf('%2.3f', fAccuracy);
    elseif j == length(mPosition)
        sLine = sprintf('%s, %2.3f;   ', sLine, fAccuracy);
    else
        sLine = sprintf('%s, %2.3f', sLine, fAccuracy);
    end
end

sLine = sprintf('%s  Feature Idx: [', sLine);
for k = 1:length(mSelectedFeatures)
    sLine = sprintf('%s %d', sLine, mSelectedFeatures(k));
end
sLine = sprintf('%s ]', sLine);

fprintf(fidWrite, '%s\n', sLine);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
mSelectedFeatures = [2 3 11];
disp('--------Feature: [2 3 11]');

sLine = '';
for j = 1:length(mPosition)
    fAccuracy = SBM_Script_StopDetection_SVM(mSelectedFeatures, mPosition(j));
    if j == 1
        sLine = sprintf('%2.3f', fAccuracy);
    elseif j == length(mPosition)
        sLine = sprintf('%s, %2.3f;   ', sLine, fAccuracy);
    else
        sLine = sprintf('%s, %2.3f', sLine, fAccuracy);
    end
end

sLine = sprintf('%s  Feature Idx: [', sLine);
for k = 1:length(mSelectedFeatures)
    sLine = sprintf('%s %d', sLine, mSelectedFeatures(k));
end
sLine = sprintf('%s ]', sLine);

fprintf(fidWrite, '%s\n', sLine);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
mSelectedFeatures = [2 3 4 5 6 7 8 9];
disp('--------Feature: [2 3 4 5 6 7 8 9]');

sLine = '';
for j = 1:length(mPosition)
    fAccuracy = SBM_Script_StopDetection_SVM(mSelectedFeatures, mPosition(j));
    if j == 1
        sLine = sprintf('%2.3f', fAccuracy);
    elseif j == length(mPosition)
        sLine = sprintf('%s, %2.3f;   ', sLine, fAccuracy);
    else
        sLine = sprintf('%s, %2.3f', sLine, fAccuracy);
    end
end

sLine = sprintf('%s  Feature Idx: [', sLine);
for k = 1:length(mSelectedFeatures)
    sLine = sprintf('%s %d', sLine, mSelectedFeatures(k));
end
sLine = sprintf('%s ]', sLine);

fprintf(fidWrite, '%s\n', sLine);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
mSelectedFeatures = [2 3 4 5 6 7 8 9 11];
disp('--------Feature: [2 3 4 5 6 7 8 9 11]');

sLine = '';
for j = 1:length(mPosition)
    fAccuracy = SBM_Script_StopDetection_SVM(mSelectedFeatures, mPosition(j));
    if j == 1
        sLine = sprintf('%2.3f', fAccuracy);
    elseif j == length(mPosition)
        sLine = sprintf('%s, %2.3f;   ', sLine, fAccuracy);
    else
        sLine = sprintf('%s, %2.3f', sLine, fAccuracy);
    end
end

sLine = sprintf('%s  Feature Idx: [', sLine);
for k = 1:length(mSelectedFeatures)
    sLine = sprintf('%s %d', sLine, mSelectedFeatures(k));
end
sLine = sprintf('%s ]', sLine);

fprintf(fidWrite, '%s\n', sLine);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
mSelectedFeatures = [2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 24 25];   % 23 Skewness is removed, which gives skewness = NaN
disp('--------Feature: [2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 24 25]');

sLine = '';
for j = 1:length(mPosition)
    fAccuracy = SBM_Script_StopDetection_SVM(mSelectedFeatures, mPosition(j));
    if j == 1
        sLine = sprintf('%2.3f', fAccuracy);
    elseif j == length(mPosition)
        sLine = sprintf('%s, %2.3f;   ', sLine, fAccuracy);
    else
        sLine = sprintf('%s, %2.3f', sLine, fAccuracy);
    end
end

sLine = sprintf('%s  Feature Idx: [', sLine);
for k = 1:length(mSelectedFeatures)
    sLine = sprintf('%s %d', sLine, mSelectedFeatures(k));
end
sLine = sprintf('%s ]', sLine);

fprintf(fidWrite, '%s\n', sLine);

fclose(fidWrite);


disp('>>>>>>>>>>>>>>Mission Accomplished!<<<<<<<<<<<<<<');

