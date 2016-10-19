function f = SBM_RouteTraceSegStat()

% This function is used for overall evaluation

format long;

sArr_ParentFolders = [ ...
%      'E:\SensorMatching\Data\SchoolShuttle\20150924\Green1_full_good                           '; ...
%      'E:\SensorMatching\Data\SchoolShuttle\20150928_withPhani\Green1_full_goodQ                '; ...
%      'E:\SensorMatching\Data\SchoolShuttle\20150928_withPhani\Green2_full_goodQ                '; ...
     'E:\SensorMatching\Data\SchoolShuttle\20150924\Yellow1_full_good                          '; ...
     'E:\SensorMatching\Data\SchoolShuttle\20150928_withPhani\Yellow1_full_goodQ               '; ...
     'E:\SensorMatching\Data\SchoolShuttle\20150929_withXiang\Yellow1_full_good                '; ...
%      'E:\SensorMatching\Data\SchoolShuttle\20150925_morning\Blue1_full_good                    '; ...
%      'E:\SensorMatching\Data\SchoolShuttle\20150925_morning\Blue2_full_good                    '; ...
%      'E:\SensorMatching\Data\SchoolShuttle\20150925_morning\Blue3_full_good                    '; ...
%      'E:\SensorMatching\Data\SchoolShuttle\20150925_morning\North1_full_good                   '; ...
%      'E:\SensorMatching\Data\SchoolShuttle\20150925_morning\North2_full_good                   '; ...
%      'E:\SensorMatching\Data\SchoolShuttle\20150925_morning\North3_full_good                   '; ...
%      'E:\SensorMatching\Data\SchoolShuttle\20150928_withPhani\Red2_full_good                   '; ...
%      'E:\SensorMatching\Data\SchoolShuttle\20150928_withXiang\Red1_full_good                   '; ...
%      'E:\SensorMatching\Data\SchoolShuttle\20150929_withXiang\Red1_full_good                   '; ...
%      'E:\SensorMatching\Data\SchoolShuttle\20150924\Evening1_full_good                         '; ...
%      'E:\SensorMatching\Data\SchoolShuttle\20150924\Evening2_full_good                         '; ...
%      'E:\SensorMatching\Data\SchoolShuttle\20150924\Evening3_full_good                         '; ...
];

cellParentFolders = cellstr(sArr_ParentFolders);

% Route:
%   1-Green, 2-Yellow, 3-Blue, 4-North, 5-Red, 6-Evening

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
%mSelectedFeatures = [1 2 3 4 11 18 19 20 21 22 23 24 31 38 39 40];   % Feature Index starts from 1   ??????

%sSegStatFile = 'E:\SensorMatching\Data\SchoolShuttle\Stat\SegStat.csv';
sSegStatFile = 'E:\SensorMatching\Data\SchoolShuttle\Stat\SegStat_Yellow.csv';

fidRet = fopen(sSegStatFile, 'w');

% Select PASSENGER Trace Segment and then try to match possible Reference
% Trace Segment
%for i = 1:5  % Route
for i = 1:1  % Route

    for j = 1:3  % Trace
        sParentFolder = cellParentFolders{(i-1)*3 + j};
        sBFFilename = '';
        sDFFilename = '';
        sInfoGFile = '';
        
        mSegCnt = [];
        for k = 1:2   % 1--Hand, 2--Pocket
            if k == 1  % hand
                sInfoGFile = [sParentFolder '\hand_Uniqued_TmCrt_InfoG.csv'];
                sBFFilename = 'hand_Uniqued_TmCrt_TraceBF.csv';
                sDFFilename = 'hand_Uniqued_TmCrt_TraceDF.csv';
            else k == 2 % pocket
                sInfoGFile = [sParentFolder '\pantpocket_Uniqued_TmCrt_InfoG.csv'];
                sBFFilename = 'pantpocket_Uniqued_TmCrt_TraceBF.csv';
                sDFFilename = 'pantpocket_Uniqued_TmCrt_TraceDF.csv';
            end
            
            mInfoG = load(sInfoGFile);
            nSegCnt = sum(mInfoG(:,1)==1);
            mSegCnt(k) = nSegCnt;

        end
        
        fprintf(fidRet, 'Route = %d, Trace = %d,   SegCnt = [Hand] %d, [Pocket] %d\n', i,j,mSegCnt(1), mSegCnt(2));
    end
end
    
fclose(fidRet);


return;

