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

sStatPassengerFile = '';

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
nMaxSegNum = 0;
for i=1:6   % Route
    for j=1:3
        mRouteTraceSeg = mStatRef(mStatRef(:,1)==i & mStatRef(:,2)==j & mStatRef(:,3)==1,:);
        [nSegCnt ~] = size(mRouteTraceSeg);
        
        if nSegCnt > nMaxSegNum
            nMaxSegNum = nSegCnt;
        end
    end
end



mSelectedFeatures = [2];   % Index starts from 1


% Select Passenger Trace Segment and then try to match possible Reference
% Trace Segment
for nSegNum = 1:nMaxSegNum   % Number of Segment to try
    for i = 1:6  % Route
        for j = 1:3  % Trace
            for k = 1:2   % 1--Hand, 2--Pocket
                % Select Passenger Trace Segment (Its basic feature; and its detailed feature)
                
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
                
                [MatchedRouteNo MatchedTraceNo MatchedSegCnt MatchedSegSrc MatchedSegDst] = SBM_MatchTrace(mPassengerBF, mPassengerDF, mSelectedFeatures);
                %
                % By comparing RouteNo, TraceNo, SegCnt, SegSrc, SegDst to
                % Evaluation
                %
                
                
            end
        end
    end
    
end



return;

