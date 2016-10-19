function [MatchedRouteNo MatchedTraceNo MatchedSegCnt MatchedSegSrc MatchedSegDst nRawRefCombCnt nFeatureMatchingRefCombCnt fMatchedRefPsgDist] = SBM_MatchTrace_Exp(nPsgRoute, nPsgTrace, nPsgPosition, nPsgSrcSegNo, nPsgDstSegNo, mPsgBF, mPsgDF, mSelectedFeatures, ...
                                                                                                    fPsgTotalTravelDuration, fPsgBeginBaro, fPsgEndBaro, nUseFilter)
%This function searchs in the Reference trace database to match the given
%Passenger trace based on its Basic Feature (i.e. Segment property) and
%Detailed Feature, and also the selected features (used in Detailed
%Feature)

format long;

MatchedRouteNo = 0;
MatchedTraceNo = 0;
MatchedSegCnt = 0;
MatchedSegSrc = 0;
MatchedSegDst = 0;
nRawRefCombCnt = 0;
nFeatureMatchingRefCombCnt = 0;
fMatchedRefPsgDist = 0; 

sArr_ParentFolders = [ ...
     'E:\SensorMatching\Data\SchoolShuttle\20150924\Green1_full_good                           '; ...
     'E:\SensorMatching\Data\SchoolShuttle\20150928_withPhani\Green1_full_goodQ                '; ...
     'E:\SensorMatching\Data\SchoolShuttle\20150928_withPhani\Green2_full_goodQ                '; ...
     
%      'E:\SensorMatching\Data\SchoolShuttle\20150924\Yellow1_full_good                          '; ...
%      'E:\SensorMatching\Data\SchoolShuttle\20150928_withPhani\Yellow1_full_goodQ               '; ...
%      'E:\SensorMatching\Data\SchoolShuttle\20150929_withXiang\Yellow1_full_good                '; ...
     
     'E:\SensorMatching\Data\SchoolShuttle\20150925_morning\Blue1_full_good                    '; ...
     'E:\SensorMatching\Data\SchoolShuttle\20150925_morning\Blue2_full_good                    '; ...
     'E:\SensorMatching\Data\SchoolShuttle\20150925_morning\Blue3_full_good                    '; ...
     
     'E:\SensorMatching\Data\SchoolShuttle\20150925_morning\North1_full_good                   '; ...
     'E:\SensorMatching\Data\SchoolShuttle\20150925_morning\North2_full_good                   '; ...
     'E:\SensorMatching\Data\SchoolShuttle\20150925_morning\North3_full_good                   '; ...
     
     'E:\SensorMatching\Data\SchoolShuttle\20150928_withPhani\Red2_full_good                   '; ...
     'E:\SensorMatching\Data\SchoolShuttle\20150928_withXiang\Red1_full_good                   '; ...
     'E:\SensorMatching\Data\SchoolShuttle\20150929_withXiang\Red1_full_good                   '; ...
     
     'E:\SensorMatching\Data\SchoolShuttle\20150924\Evening1_full_good                         '; ...
     'E:\SensorMatching\Data\SchoolShuttle\20150924\Evening2_full_good                         '; ...
     'E:\SensorMatching\Data\SchoolShuttle\20150924\Evening3_full_good                         '; ...
];

cellParentFolders = cellstr(sArr_ParentFolders);

%  Get statistics Passenger BF 
[nTotalPsgBFCnt ~] = size(mPsgBF);

%fTotalDurationMoving fTotalDurationStop nTotalTurnNum nTotalTurnLeftCnt nTotalTurnRightCnt nTotalTurnUncertainCnt
fPsgTotalDurationMoving = sum(mPsgBF(mPsgBF(:,1) == 1, 2));
fPsgTotalDurationStop = sum(mPsgBF(mPsgBF(:,1) == 0, 2)); 

nPsgTotalTurnNum = sum(mPsgBF(:,1) == 2);
nPsgTotalTurnLeftCnt = sum(mPsgBF(:,1) == 2 & mPsgBF(:,2) == 1);
nPsgTotalTurnRightCnt = sum(mPsgBF(:,1) == 2 & mPsgBF(:,2) == -1);
nPsgTotalTurnUncertainCnt = sum(mPsgBF(:,1) == 2 & mPsgBF(:,2) == 0);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
sFeatureSubFolder = 'Feature';
sRefPrefixDF = 'Ref_Uniqued_TmCrt_SegDF_';

sStatRefFile = 'E:\SensorMatching\Data\SchoolShuttle\Stat\StatRef.csv';

mStatRef = load(sStatRefFile);  % All the reference trace information, just like a database
% Index:  
% 1-Route, 
% 2-Trace, 
% 3-Seg/Station (0--station, 1--Moving segment), 
% 4-Baro, 
% 5-Duration,
% 6-TotalMovingDuration(in a segment), 
% 7-TotalStopDuration(in a segment),
% 8-Number of Turn,
% 9~29:Turn Direction

% First, Get all possible REFERENCE Segment combinations
% Due to there is no information about how many segments are there in the
% passenger trace, so need to get all possible Segment combination all the
% time
% **segment must be continuous
% Get a matrix, each line contains:  Route No, Trace No, Src Segment No.,
% Dst Segment No., Src.Baro, Dst.Baro, Total Duration, Total Moving Duration, Total Stop Duration, Total Number of Turns, Turn Directions
mCellSegComb = [];
nSegCombCnt = 0;

for i = 1:5  % Route
    for j = 1:3  % Trace
        mRouteTraceSeg = mStatRef(mStatRef(:,1)==i & mStatRef(:,2)==j & mStatRef(:,3)==1,:);
        [nSegCnt ~] = size(mRouteTraceSeg);

        mRouteTraceStationSeg = mStatRef(mStatRef(:,1)==i & mStatRef(:,2)==j,:);
        [nRouteTraceStationSegNum ~] = size(mRouteTraceStationSeg);
        
        for nCombLen = 1:nSegCnt  % Number of segments in each combination
            for nSrcSegNo = 1:nSegCnt
                nDstSegNo = nSrcSegNo + nCombLen - 1;
                if nDstSegNo > nSegCnt
                    break;
                end
                
                mSegIdx = find(mRouteTraceStationSeg(:,3)==1);
                nSrcSegStationIdx = mSegIdx(nSrcSegNo);
                nDstSegStationIdx = mSegIdx(nDstSegNo);
                
                fSrcBaro = -1;
                if nSrcSegStationIdx > 1
                    if mRouteTraceStationSeg(nSrcSegStationIdx-1,3) == 0
                        fSrcBaro = mRouteTraceStationSeg(nSrcSegStationIdx-1,4);
                    end
                end
                
                fDstBaro = -1;
                if nDstSegStationIdx < nRouteTraceStationSegNum
                    if mRouteTraceStationSeg(nDstSegStationIdx+1,3) == 0
                       fDstBaro = mRouteTraceStationSeg(nDstSegStationIdx+1,4);
                    end
                end
                
                fTotalDuration = sum(mRouteTraceStationSeg(nSrcSegStationIdx:nDstSegStationIdx, 5));
                mTraveledStationSeg = mRouteTraceStationSeg(nSrcSegStationIdx:nDstSegStationIdx,:);
                fTotalStationDuration = sum(mTraveledStationSeg(mTraveledStationSeg(:,3)==0,5));
                fTotalDurationMoving = sum(mRouteTraceStationSeg(nSrcSegStationIdx:nDstSegStationIdx, 6));
                fTotalDurationStop = sum(mRouteTraceStationSeg(nSrcSegStationIdx:nDstSegStationIdx, 7));
                fTotalDurationStop = fTotalDurationStop + fTotalStationDuration;   % Passenger trace only knows stop, no idea of station, stations is detected as stop
                nTotalTurnNum = sum(mRouteTraceStationSeg(nSrcSegStationIdx:nDstSegStationIdx, 8));
                % Add Turn Direction %%
                nTotalTurnLeftCnt = 0;
                nTotalTurnRightCnt = 0;
                nTotalTurnUncertainCnt = 0;
                
                % 1: left, -1: right, 0: Uncertain, 9: No turn
                for k = nSrcSegStationIdx:nDstSegStationIdx
                    if mRouteTraceStationSeg(k,3) == 1
                        nTmpTurnCnt = mRouteTraceStationSeg(k,8);
                        for t = 1:nTmpTurnCnt
                            if mRouteTraceStationSeg(k,8+t) == 1
                                nTotalTurnLeftCnt = nTotalTurnLeftCnt + 1;
                            elseif mRouteTraceStationSeg(k,8+t) == -1
                                nTotalTurnRightCnt = nTotalTurnRightCnt + 1;
                            elseif mRouteTraceStationSeg(k,8+t) == 0
                                nTotalTurnUncertainCnt = nTotalTurnUncertainCnt + 1;
                            end
                        end
                    end
                end
                
                nSegCombCnt = nSegCombCnt + 1;
                mSingleComb = [1 i j nSrcSegNo nDstSegNo fSrcBaro fDstBaro fTotalDuration fTotalDurationMoving fTotalDurationStop nTotalTurnNum nTotalTurnLeftCnt nTotalTurnRightCnt nTotalTurnUncertainCnt];
                mCellSegComb{nSegCombCnt} = mSingleComb;   % In each combination matrix, the first element marks whether this combination is a candidate for the Passenger trace: 1--Candiate, 0-Not candidate any more 
            end
        end

    end
end


if nUseFilter == 1
    % Based on Basic Feature, Filter Segment combinations 
    % Absolute Value %
    fTotalDurationErrorThreshold = 120;  % seconds
    fTotalMovingDurationErrorThreshold = 120;
    fTotalStopDurationErrorThreshold = 120;

    % Ratio %
    fTotalDurationErrorThresholdRatio = 0.25;  % seconds
    fTotalMovingDurationErrorThresholdRatio = 0.25;
    fTotalStopDurationErrorThresholdRatio = 0.25;

    fSrcDstBaroDifferenceThreshold = 0.5;  % 0.5 hPa difference corresponds to about 2.8~4 meters in altitude, only larger than this, it is meaningful to check high/low order between src/dst

    nTurnNumErrorThreshold = 3;
    nTotalLeftTurnErrorThreshold = 3;
    nTotalRightTurnErrorThreshold = 3;
    nTotalUncertainTurnErrorThreshold = 2;

    for i = 1:nSegCombCnt
        mSingleComb = mCellSegComb{i};
        if mSingleComb(1) == 0
            continue;
        end

        nRefRoute = mSingleComb(2);
        nRefTrace = mSingleComb(3);
        nRefSrcSegNo = mSingleComb(4);
        nRefDstSegNo = mSingleComb(5);
        
        fRefSrcBaro = mSingleComb(6);
        fRefDstBaro = mSingleComb(7);
        fRefTotalDuration = mSingleComb(8);
        fRefTotalDurationMoving = mSingleComb(9);
        fRefTotalDurationStop = mSingleComb(10);
        nRefTotalTurnNum = mSingleComb(11);
        nRefTotalTurnLeftCnt = mSingleComb(12);
        nRefTotalTurnRightCnt = mSingleComb(13);
        nRefTotalTurnUncertainCnt = mSingleComb(14);

        nSegLen = mSingleComb(5) - mSingleComb(4) + 1;

        % Fourth, check the baro relationship between Src and Dest.  
        % If the difference between Src and Dest is larger than a threshold in Passenger, 
        % the candidate Reference trace must also show a larger difference and
        % the High/Low relationship between Src/Dest should be the same
        % Note: some Baro value might be -1
        if fPsgBeginBaro > 0 && fPsgEndBaro > 0 && fRefSrcBaro > 0 && fRefDstBaro > 0
            fPsgBaroDiff = fPsgBeginBaro - fPsgEndBaro;
            fRefBaroDiff = fRefSrcBaro - fRefDstBaro;

            if abs(fPsgBaroDiff) >= fSrcDstBaroDifferenceThreshold
                if fPsgBaroDiff*fRefBaroDiff <= 0  % Order of High/Low between Src/Dst does not match between Ref and Psg
                    mCellSegComb{i}(1) = 0;
                                        
                    if nPsgRoute == nRefRoute && nPsgTrace == nRefTrace && nPsgSrcSegNo == nRefSrcSegNo && nPsgDstSegNo == nRefDstSegNo
                        fprintf('[Macro Filter] [Baro] [Psg Route=%d, TraceNo=%d, Position=%d] Ref Route=%d; Trace=%d; SrcSegNo=%d,DstSegNo=%d; [Baro Threshold=%f] PsgBeginBaro=%f, PsgEndBaro=%f; abs(PsgDiff)=%f; RefBeginBaro=%f, RefEndBaro=%f, abs(RefDiff)=%f\n', ...
                                                       nPsgRoute, nPsgTrace, nPsgPosition, ...
                                                       mCellSegComb{i}(2), mCellSegComb{i}(3), mCellSegComb{i}(4), mCellSegComb{i}(5), ...
                                                       fSrcDstBaroDifferenceThreshold, ...
                                                       fPsgBeginBaro, fPsgEndBaro, fPsgBaroDiff, ...
                                                       fRefSrcBaro, fRefDstBaro, fRefBaroDiff);
                        fprintf('---------------------------------------------\n');
                    end
                    continue;
                end
            end
        end
                
        % First, check Total duration: The abs(difference) between Passenger trace
        % and candidate trace should not be large than a threshold
 %       if abs(fRefTotalDuration - fPsgTotalTravelDuration) > fTotalDurationErrorThreshold      % fPsgTotalTravelDuration*fTotalDurationErrorThresholdRatio
        if abs(fRefTotalDuration - fPsgTotalTravelDuration) > fPsgTotalTravelDuration*fTotalDurationErrorThresholdRatio
            mCellSegComb{i}(1) = 0;
            
            if nPsgRoute == nRefRoute && nPsgTrace == nRefTrace && nPsgSrcSegNo == nRefSrcSegNo && nPsgDstSegNo == nRefDstSegNo   
                fprintf('[Macro Filter] [Total Duration] [Psg Route=%d, TraceNo=%d, Position=%d] Ref Route=%d; Trace=%d; SrcSegNo=%d,DstSegNo=%d; [Total Duration Error Threshold=%f] PsgTotalDuration=%f, RefTotalDuration=%f\n', ...
                                               nPsgRoute, nPsgTrace, nPsgPosition, ...
                                               mCellSegComb{i}(2), mCellSegComb{i}(3), mCellSegComb{i}(4), mCellSegComb{i}(5), ...
                                               fTotalDurationErrorThreshold, ...
                                               fPsgTotalTravelDuration, fRefTotalDuration);
                fprintf('---------------------------------------------\n');
            end
            continue;
        end

        % Third, check Total moving duration and Total stop duration between
        % Passenger trace and candidate trace should not be large than a
        % threshold
%        if abs(fRefTotalDurationMoving - fPsgTotalDurationMoving) > fTotalMovingDurationErrorThreshold    % fPsgTotalDurationMoving*fTotalMovingDurationErrorThresholdRatio
        if abs(fRefTotalDurationMoving - fPsgTotalDurationMoving) > fPsgTotalDurationMoving*fTotalMovingDurationErrorThresholdRatio
            mCellSegComb{i}(1) = 0;
            if nPsgRoute == nRefRoute && nPsgTrace == nRefTrace && nPsgSrcSegNo == nRefSrcSegNo && nPsgDstSegNo == nRefDstSegNo
                fprintf('[Macro Filter] [Total Duration Moving] [Psg Route=%d, TraceNo=%d, Position=%d] Ref Route=%d; Trace=%d; SrcSegNo=%d,DstSegNo=%d; [Total Moving Duration Error Threshold=%f] PsgTotalDurationMoving=%f, RefTotalDurationMoving=%f\n', ...
                                               nPsgRoute, nPsgTrace, nPsgPosition, ...
                                               mCellSegComb{i}(2), mCellSegComb{i}(3), mCellSegComb{i}(4), mCellSegComb{i}(5), ...
                                               fTotalMovingDurationErrorThreshold, ...
                                               fPsgTotalDurationMoving, fRefTotalDurationMoving);
                fprintf('---------------------------------------------\n');
            end
            continue;
        end

%        if abs(fRefTotalDurationStop - fPsgTotalDurationStop) > fTotalStopDurationErrorThreshold   % fPsgTotalDurationStop*fTotalStopDurationErrorThresholdRatio
        if abs(fRefTotalDurationStop - fPsgTotalDurationStop) > fPsgTotalDurationStop*fTotalStopDurationErrorThresholdRatio           
            mCellSegComb{i}(1) = 0;
            if nPsgRoute == nRefRoute && nPsgTrace == nRefTrace && nPsgSrcSegNo == nRefSrcSegNo && nPsgDstSegNo == nRefDstSegNo
                fprintf('[Macro Filter] [Total Duration Stop] [Psg Route=%d, TraceNo=%d, Position=%d] Ref Route=%d; Trace=%d; SrcSegNo=%d,DstSegNo=%d; [Total Stop Duration Error Threshold=%f] PsgTotalDurationStop=%f, RefTotalDurationStop=%f\n', ...
                                               nPsgRoute, nPsgTrace, nPsgPosition, ...
                                               mCellSegComb{i}(2), mCellSegComb{i}(3), mCellSegComb{i}(4), mCellSegComb{i}(5), ...
                                               fTotalStopDurationErrorThreshold, ...
                                               fPsgTotalDurationStop, fRefTotalDurationStop);
                fprintf('---------------------------------------------\n');
            end
            continue;
        end

        % Second, check Total number of turns, the abs(different) between
        % Passenger trace and candidate trace should not be large than a
        % threshold
        if abs(nRefTotalTurnNum - nPsgTotalTurnNum) > nTurnNumErrorThreshold*nSegLen
            mCellSegComb{i}(1) = 0;
            if nPsgRoute == nRefRoute && nPsgTrace == nRefTrace && nPsgSrcSegNo == nRefSrcSegNo && nPsgDstSegNo == nRefDstSegNo
                fprintf('[Macro Filter] [Total Turn Num] [Psg Route=%d, TraceNo=%d, Position=%d] Ref Route=%d; Trace=%d; SrcSegNo=%d,DstSegNo=%d; [Turn Num Error Threshold=%d, x SegLen=%d] PsgTotalTurnNum=%d, RefTotalTurnNum=%d\n', ...
                                               nPsgRoute, nPsgTrace, nPsgPosition, ...
                                               mCellSegComb{i}(2), mCellSegComb{i}(3), mCellSegComb{i}(4), mCellSegComb{i}(5), ...
                                               nTurnNumErrorThreshold, nSegLen, ...
                                               nPsgTotalTurnNum, nRefTotalTurnNum);
                fprintf('---------------------------------------------\n');
            end
            continue;
        end

        if abs(nRefTotalTurnLeftCnt - nPsgTotalTurnLeftCnt) > nTotalLeftTurnErrorThreshold*nSegLen
            mCellSegComb{i}(1) = 0;
            if nPsgRoute == nRefRoute && nPsgTrace == nRefTrace && nPsgSrcSegNo == nRefSrcSegNo && nPsgDstSegNo == nRefDstSegNo
                fprintf('[Macro Filter] [Total Turn Left Num] [Psg Route=%d, TraceNo=%d, Position=%d] Ref Route=%d; Trace=%d; SrcSegNo=%d,DstSegNo=%d; [Left Turn Num Error Threshold=%d, x SegLen=%d] PsgTotalTurnNumLeft=%d, RefTotalTurnNumLeft=%d\n', ...
                                               nPsgRoute, nPsgTrace, nPsgPosition, ...
                                               mCellSegComb{i}(2), mCellSegComb{i}(3), mCellSegComb{i}(4), mCellSegComb{i}(5), ...
                                               nTotalLeftTurnErrorThreshold, nSegLen, ...
                                               nPsgTotalTurnLeftCnt, nRefTotalTurnLeftCnt);
                fprintf('---------------------------------------------\n');
            end
            continue;
        end

        if abs(nRefTotalTurnRightCnt - nPsgTotalTurnRightCnt) > nTotalRightTurnErrorThreshold*nSegLen
            mCellSegComb{i}(1) = 0;
            if nPsgRoute == nRefRoute && nPsgTrace == nRefTrace && nPsgSrcSegNo == nRefSrcSegNo && nPsgDstSegNo == nRefDstSegNo
                fprintf('[Macro Filter] [Total Turn Right Num] [Psg Route=%d, TraceNo=%d, Position=%d] Ref Route=%d; Trace=%d; SrcSegNo=%d,DstSegNo=%d; [Right Turn Num Error Threshold=%d, x SegLen=%d] PsgTotalTurnNumRight=%d, RefTotalTurnNumRight=%d\n', ...
                                               nPsgRoute, nPsgTrace, nPsgPosition, ...
                                               mCellSegComb{i}(2), mCellSegComb{i}(3), mCellSegComb{i}(4), mCellSegComb{i}(5), ...
                                               nTotalRightTurnErrorThreshold, nSegLen, ...
                                               nPsgTotalTurnRightCnt, nRefTotalTurnRightCnt);
                fprintf('---------------------------------------------\n');
            end
            continue;
        end

        if abs(nRefTotalTurnUncertainCnt - nPsgTotalTurnUncertainCnt) > nTotalUncertainTurnErrorThreshold*nSegLen
            mCellSegComb{i}(1) = 0;
            if nPsgRoute == nRefRoute && nPsgTrace == nRefTrace && nPsgSrcSegNo == nRefSrcSegNo && nPsgDstSegNo == nRefDstSegNo
                fprintf('[Macro Filter] [Total Turn Uncertain Num] [Psg Route=%d, TraceNo=%d, Position=%d] Ref Route=%d; Trace=%d; SrcSegNo=%d,DstSegNo=%d; [Uncertain Turn Num Error Threshold=%d, x SegLen=%d] PsgTotalTurnNumUncertain=%d, RefTotalTurnNumUncertain=%d\n', ...
                                               nPsgRoute, nPsgTrace, nPsgPosition, ...
                                               mCellSegComb{i}(2), mCellSegComb{i}(3), mCellSegComb{i}(4), mCellSegComb{i}(5), ...
                                               nTotalUncertainTurnErrorThreshold, nSegLen, ...
                                               nPsgTotalTurnUncertainCnt, nRefTotalTurnUncertainCnt);
                fprintf('---------------------------------------------\n');
            end
            continue;
        end


    end

    % Check the remained Reference segment combination, if only one remained,
    % treat it as the result for the given passenger trace
    mRemainedComb = [];
    nRemainedCombCnt = 0;

    for i = 1:nSegCombCnt
        mSingleComb = mCellSegComb{i};
        if mSingleComb(1) == 1
            nRemainedCombCnt = nRemainedCombCnt + 1;
            mRemainedComb{nRemainedCombCnt} = mSingleComb;
        end
    end

   % fprintf('---After 1st Stage [Reducing Search Space] Total: %d, Remained: %d\n',nSegCombCnt, nRemainedCombCnt);

else   % No filter
    
    nRemainedCombCnt = nSegCombCnt;
    mRemainedComb = mCellSegComb;
end

if nRemainedCombCnt == 1
    % Conclude
    mSingleComb = mRemainedComb{1};
    
    MatchedRouteNo = mSingleComb(2);
    MatchedTraceNo = mSingleComb(3);
    MatchedSegCnt = mSingleComb(5) - mSingleComb(4)+1;
    MatchedSegSrc = mSingleComb(4);
    MatchedSegDst = mSingleComb(5);
    nRawRefCombCnt = nSegCombCnt;
    nFeatureMatchingRefCombCnt = nRemainedCombCnt;   % The number of combination remained from the first-stage reducing search space, i.e. the number of combination which goes through detailed feature matching
    
    fMatchedRefPsgDist = 0;
    return;
elseif nRemainedCombCnt == 0
    return;
end

% If there are more than one remained Reference segment combination, 
% Based on Detailed Feature, do DTW matching

mMatchResult = [];   % Record: Index of remained combination, matching score or distance

for i=1:nRemainedCombCnt
    mSingleComb = mRemainedComb{i};
    nRouteNo = mSingleComb(2);
    nTraceNo = mSingleComb(3);
    nSrcSegNo = mSingleComb(4);
    nDstSegNo = mSingleComb(5);
    
    sParentFolder = cellParentFolders{(nRouteNo-1)*3 + nTraceNo};
    % Get corresponding Detailed Feature
    mRefDF = [];
    
    for j = nSrcSegNo:nDstSegNo
        sSingleSegDFFile = [sParentFolder '\' sFeatureSubFolder '\' sRefPrefixDF num2str(j) '.csv'];
        mSingleSegDF = load(sSingleSegDFFile);
        mRefDF = [mRefDF; mSingleSegDF];
    end
    
    % Do matching
    fMatchingDist = SBM_MatchingMotion(mRefDF, mPsgDF, mSelectedFeatures);   %Returned distance is normalized over warping path length
    
    mMatchResult(i,1) = i;
    mMatchResult(i,2) = fMatchingDist;
    
end

% Select the Reference segment combination which has the highest matching
% score / minimal distance with the Passenger trace as the result
fMatchedRefPsgDist = min(mMatchResult(:,2));
nMatchedIdx = find(mMatchResult(:,2) == fMatchedRefPsgDist);   % If using Matching distance

mMatchedComb = mRemainedComb{nMatchedIdx};

MatchedRouteNo = mMatchedComb(2);
MatchedTraceNo = mMatchedComb(3);
MatchedSegCnt = mMatchedComb(5)-mMatchedComb(4)+1;
MatchedSegSrc = mMatchedComb(4);
MatchedSegDst = mMatchedComb(5);
nRawRefCombCnt = nSegCombCnt;
nFeatureMatchingRefCombCnt = nRemainedCombCnt;   % The number of combination remained from the first-stage reducing search space, i.e. the number of combination which goes through detailed feature matching

return;
