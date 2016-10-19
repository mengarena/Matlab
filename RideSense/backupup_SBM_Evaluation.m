function f = backup_SBM_Evaluation()

% This function is used for overall evaluation

format long;

sArr_ParentFolders = [ ...
     'E:\SensorMatching\Data\SchoolShuttle\20150924\Green1_full_good                           '; ...
     'E:\SensorMatching\Data\SchoolShuttle\20150928_withPhani\Green1_full_goodQ                '; ...
     'E:\SensorMatching\Data\SchoolShuttle\20150928_withPhani\Green2_full_goodQ                '; ...
     'E:\SensorMatching\Data\SchoolShuttle\20150924\Yellow1_full_good                          '; ...
     'E:\SensorMatching\Data\SchoolShuttle\20150928_withPhani\Yellow1_full_goodQ               '; ...
     'E:\SensorMatching\Data\SchoolShuttle\20150929_withXiang\Yellow1_full_good                '; ...
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

% Route:
%   1-Green, 2-Yellow, 3-Blue, 4-North, 5-Red, 6-Evening

sStatRefFile = 'E:\SensorMatching\Data\SchoolShuttle\Stat\StatRef.csv';

sFeatureSubFolder = 'Feature';

sStatPsgFile = '';

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

% Get max Segment number among all reference trace
% nMaxSegNum = 0;
% for i=1:6   % Route
%     for j=1:3
%         mRouteTraceSeg = mStatRef(mStatRef(:,1)==i & mStatRef(:,2)==j & mStatRef(:,3)==1,:);
%         [nSegCnt ~] = size(mRouteTraceSeg);
%         
%         if nSegCnt > nMaxSegNum
%             nMaxSegNum = nSegCnt;
%         end
%     end
% end

% Original          [2 3 4 5 12 19 20 21 22 23 24 25 32 39 40 41] 
mSelectedFeatures = [1 2 3 4 11 18 19 20 21 22 23 24 31 38 39 40];   % Feature Index starts from 1   ??????

sEvaluationResultPrefix = 'E:\SensorMatching\Data\SchoolShuttle\Stat\EvaluationResult';
sEvaluationResultFile = sEvaluationResultPrefix;
for i = 1:length(mSelectedFeatures)
    sEvaluationResultFile = sprintf('%s_%d', sEvaluationResultFile, mSelectedFeatures(i));
end

sEvaluationResultFile = [sEvaluationResultFile '.csv'];

fidRet = fopen(sEvaluationResultFile, 'w');

% Select Passenger Trace Segment and then try to match possible Reference
% Trace Segment
for i = 1:6  % Route
    for j = 1:3  % Trace
        sParentFolder = cellParentFolders{(i-1)*3 + j};
        sBFPrefix = '';
        sDFPrefix = '';
        sInfoGFile = '';
        
        for k = 1:2   % 1--Hand, 2--Pocket
            if k == 1  % hand
                sInfoGFile = [sParentFolder '\hand_Uniqued_TmCrt_InfoG.csv'];
                sBFPrefix = 'hand_Uniqued_TmCrt_SegBF_';
                sDFPrefix = 'hand_Uniqued_TmCrt_SegDF_';
            else k == 2 % pocket
                sInfoGFile = [sParentFolder '\pantpocket_Uniqued_TmCrt_InfoG.csv'];
                sBFPrefix = 'pantpocket_Uniqued_TmCrt_SegBF_';
                sDFPrefix = 'pantpocket_Uniqued_TmCrt_SegDF_';
            end
            
            mInfoG = load(sInfoGFile);
            nSegCnt = sum(mInfoG(:,1)==1);
            
            for nCombLen = 1:nSegCnt  % Number of segments in each combination
                for nSrcSegNo = 1:nSegCnt
                    nDstSegNo = nSrcSegNo + nCombLen - 1;
                    if nDstSegNo > nSegCnt
                        break;
                    end

                    mSegIndex = find(mInfoG(:,1) == 1);
                    nSrcSegStationIdx = mSegIndex(nSrcSegNo);
                    nDstSegStationIdx = mSegIndex(nDstSegNo);
                    
                    fPsgTotalTravelDuration = sum(mInfoG(nSrcSegStationIdx:nDstSegStationIdx,4));
                    
                    fPsgBeginBaro = -1;
                    if nSrcSegStationIdx > 1
                        if mInfoG(nSrcSegStationIdx-1, 1) == 0
                            fPsgBeginBaro = mInfoG(nSrcSegStationIdx-1,5);
                        end                        
                    end
                    
                    fPsgEndBaro = -1;
                    [nSegStationRowCnt ~] = size(mInfoG);
                    if nDstSegStationIdx < nSegStationRowCnt
                        if mInfoG(nDstSegStationIdx+1,1) == 0
                            fPsgEndBaro = mInfoG(nDstSegStationIdx+1,5);
                        end
                    end
                    
                    % Select Passenger Trace Segment (Its basic feature; and its detailed feature)
                    % Get Passenger BF
                    mPsgBF = [];
                    for m = nSrcSegNo:nDstSegNo
                        sBFFile = [sParentFolder '\' sFeatureSubFolder '\' sBFPrefix num2str(m) '.csv'];
                        mSinglePsgBF = load(sBFFile);
                        mPsgBF = [mPsgBF; mSinglePsgBF];
                    end
                    
                    % Get DF
                    mPsgDF = [];
                    for m = nSrcSegNo:nDstSegNo
                        sDFFile = [sParentFolder '\' sFeatureSubFolder '\' sDFPrefix num2str(m) '.csv'];
                        mSinglePsgDF = load(sDFFile);
                        mPsgDF = [mPsgDF; mSinglePsgDF];
                    end
                    
                    
                    % Call a function to match with Reference trace
                    % Input: Basic Feature;  Detailed Feature
                    % The nSegNum is only used to select test segments, for
                    % Reference, it does not know how many segments the
                    % Passenger trace contains

                    % To evalute:
                    %   1) Whether Passenger trace matches correct route
                    %   2) Whether Passenger trace matches correct route-trace
                    %   3) Whether Passenger trace matches correct segments of
                    %   route-trace
                    %
                    % Return:  Route No., Trace No., Number of Segments, Src
                    % Segment No., Dst Segment No.

                    [MatchedRouteNo MatchedTraceNo MatchedSegCnt MatchedSegSrc MatchedSegDst] = SBM_MatchTrace(mPsgBF, mPsgDF, mSelectedFeatures, fPsgTotalTravelDuration, fPsgBeginBaro, fPsgEndBaro);
                    
                    %
                    % By comparing RouteNo, TraceNo, SegCnt, SegSrc, SegDst to
                    % Evaluation
                    %
                    
                    % Write result into result file
                    % Fields in result file:
                    % (Passenger) RouteNo, TraceNo, Position, SegLen, SrcSegNo,
                    % DstSegNo, 
                    fprintf(fidRet, '%d,%d,%d,%d,%d,%d,   %d,%d,%d,%d,%d\n', i,j,k,nCombLen,nSrcSegNo,nDstSegNo,   MatchedRouteNo,MatchedTraceNo,MatchedSegCnt,MatchedSegSrc,MatchedSegDst);
                    
                end
                
            end

        end
    end
end
    
fclose(fidRet);


return;

