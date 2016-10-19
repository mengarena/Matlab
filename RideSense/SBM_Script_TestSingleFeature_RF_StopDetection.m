function f = SBM_Script_TestSingleFeature_RF_StopDetection()

for i = 2:51
    fprintf('Feature [%d]......', i);
    mSelectedFeature = [];
    mSelectedFeature(1)=i;
    SBM_Script_StopDetection_RF_Total_SingleFeature(mSelectedFeature);
end

return;
