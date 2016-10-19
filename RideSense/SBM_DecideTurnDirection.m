function f = SBM_DecideTurnDirection(mSegBasicFeature, mCellUnitAcclInfo, nSegIdx, mCellTurnGyroRows, nIdxDataType)
%
% This function is used to decide the direction of each turn
%
%     mSegBasicFeature(nBasicFeatureCnt, 1) = 2;    % Turn
%     mSegBasicFeature(nBasicFeatureCnt, 2) = mTurns(nTurnIdx, 3);   % Turn Direction 
%     mSegBasicFeature(nBasicFeatureCnt, 3) = mTurns(nTurnIdx, 1);   % Turn Begin Line 
%     mSegBasicFeature(nBasicFeatureCnt, 4) = mTurns(nTurnIdx, 2);   % Turn End Line (in Original trace)
%
%     mUnitAcclInfo(nUnitAcclInfoCnt, 1) = nWinBeginLine + nBeginLine -1;
%     mUnitAcclInfo(nUnitAcclInfoCnt, 2) = nRealEndLine;                    
%     mUnitAcclInfo(nUnitAcclInfoCnt, 3) = mUnitAccl(1);
%     mUnitAcclInfo(nUnitAcclInfoCnt, 4) = mUnitAccl(2);
%     mUnitAcclInfo(nUnitAcclInfoCnt, 5) = mUnitAccl(3);
%
%     mCellTurnGyroRows{nTurnGyroRowsSetCnt} = mCandidateTurnGyroRows;
%     mCandidateTurnGyroRows = mWinTurnTrace(find(mWinTurnTrace(:,nIdxDataType) == nDataTypeGyro),:);
%
%     Numberof mSegBasicFeature (Turn) = #mCellTurnGyroRows
%
%  Currently, the direction of turn in mSegBasicFeature(:,2) is uncertain
%  need to decide the direction (1: left, -1: right, 0: Uncertain, 9: No turn)
%  

format long;

mResultSegBasicFeature = mSegBasicFeature;

nTurnCnt = length(mCellTurnGyroRows);

mTurnSegBasicFeature = mSegBasicFeature(mSegBasicFeature(:,1) == 2,:);

mTurnDirection = [];
nTurnDirectionCnt = 0;

for i = 1:nTurnCnt
    nTurnBeginLine = mTurnSegBasicFeature(i, 3);
    nTurnEndLine = mTurnSegBasicFeature(i, 4);
    
    mUnitAccl = SBM_FindPassengerUnitAccl(mCellUnitAcclInfo, nSegIdx, nTurnBeginLine, nTurnEndLine);
    
    if length(mUnitAccl) == 0
        nTurnDirectionCnt = nTurnDirectionCnt + 1;
        mTurnDirection(nTurnDirectionCnt) = 0;  % Uncertain
    else
        mTurnGyroRows = mCellTurnGyroRows{i};
        
        nTmpTurnDirection = SBM_DecideSingleTurnDirection(mTurnGyroRows, mUnitAccl, nIdxDataType);
        
        nTurnDirectionCnt = nTurnDirectionCnt + 1;
        mTurnDirection(nTurnDirectionCnt) = nTmpTurnDirection;
    end
end

mResultSegBasicFeature(mResultSegBasicFeature(:,1)==2,2) = mTurnDirection;

f = mResultSegBasicFeature;

return;

