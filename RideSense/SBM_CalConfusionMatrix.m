function f = SBM_CalConfusionMatrix()

sCellPsg = [ ...
    'E:\SensorMatching\Data\SchoolShuttle\20150925_morning\North1_full_good\         '; ...
    'E:\SensorMatching\Data\SchoolShuttle\20150928_withXiang\Red1_full_good\         '; ...
    'E:\SensorMatching\Data\SchoolShuttle\20150924\Evening1_full_good\               '; ...
];

mCellPsg = cellstr(sCellPsg);

sCellRef = [ ...
    'E:\SensorMatching\Data\SchoolShuttle\20150925_morning\North1_full_good\         '; ...
    'E:\SensorMatching\Data\SchoolShuttle\20150928_withXiang\Red1_full_good\         '; ...
    'E:\SensorMatching\Data\SchoolShuttle\20150924\Evening1_full_good\               '; ...
];

mCellRef = cellstr(sCellRef);


mSelectedFeatures = [1 2 3 4 5 6 7 8 9 10 11 12 13 14 21 22 23 24 25 26 27 28 29 30 31 32 33 34 41 42 43 44 45 46 47 48 49 50];
mSelectedSegIndex = [1 3; 2 4;  3 5];


mCM = [];

nLen = length(mCellPsg)

for i = 1:nLen
    mPsgSegNo = mSelectedSegIndex(i,:);
    nSrcSegNo = mPsgSegNo(1);
    nDstSegNo = mPsgSegNo(2);
    
    sPsgInfoGFile = [mCellPsg{i} 'pantpocket_Uniqued_TmCrt_InfoG.csv'];
    sPsgBFFile = [mCellPsg{i} 'Feature\pantpocket_Uniqued_TmCrt_TraceBF.csv'];
    sPsgDFFile = [mCellPsg{i} 'Feature\pantpocket_Uniqued_TmCrt_TraceDF.csv'];
    
    mInfoG = load(sPsgInfoGFile);
    mSegIndex = find(mInfoG(:,1) == 1);
    nSrcSegStationIdx = mSegIndex(nSrcSegNo);
    nDstSegStationIdx = mSegIndex(nDstSegNo);
    nTravelBeginLine = mInfoG(nSrcSegStationIdx, 2);
    nTravelEndLine = mInfoG(nDstSegStationIdx, 3);
    
    mDF = load(sPsgDFFile);
    mPsgDF = SBM_GetTravelDF(mDF, nTravelBeginLine, nTravelEndLine);

    for j = 1:nLen   % Get Reference
        mRefSegNo = mSelectedSegIndex(j,:);
        
        nRefSrcSegNo = mRefSegNo(1);
        nRefDstSegNo = mRefSegNo(2);
        
        mRefDF = [];
        
        for k = nRefSrcSegNo:nRefDstSegNo
            sSingleSegDFFile = [mCellRef{j} '\Feature\Ref_Uniqued_TmCrt_SegDF_' num2str(k) '.csv'];
            mSingleSegDF = load(sSingleSegDFFile);
            mRefDF = [mRefDF; mSingleSegDF];            
        end
        
        fMatchingDist = SBM_MatchingMotion(mRefDF, mPsgDF, mSelectedFeatures);   %Returned distance is normalized over warping path length

        mCM(i,j) = fMatchingDist;
    end    
end

sCMFile = 'E:\SensorMatching\Data\SchoolShuttle\CM_Data\cm.csv';
fidCM = fopen(sCMFile, 'w');

for i = 1:nLen
    sLine = '';
    for j = 1:nLen
        if j == 1
            sLine = sprintf('%5.8f', mCM(i,j));
        else
            sLine = sprintf('%s, %5.8f', sLine, mCM(i,j));
        end
    end
    fprintf(fidCM, '%s\n', sLine);
end

fclose(fidCM);

mInverseCM = 1./mCM;
fMaxValue = max(mInverseCM(:));

mNormalizedCM = mInverseCM/fMaxValue;


xTicks = {'Bus Line A', 'Bus Line B', 'Bus Line C'};
yTicks = {'Bus Line A', 'Bus Line B', 'Bus Line C'};

xLabels = 'Reference Trace';
yLabels = 'Passenger Trace';

SBM_PlotConfusion(mNormalizedCM, xLabels, xTicks, yLabels, yTicks, '', 1);


return;
