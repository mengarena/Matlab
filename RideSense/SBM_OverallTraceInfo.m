function f = SBM_OverallTraceInfo()
% This function is to summarize overall trace information

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
%      
%      'E:\SensorMatching\Data\SchoolShuttle\20150925_morning\North1_full_good                   '; ...
%      'E:\SensorMatching\Data\SchoolShuttle\20150925_morning\North2_full_good                   '; ...
%      'E:\SensorMatching\Data\SchoolShuttle\20150925_morning\North3_full_good                   '; ...
%      
%      'E:\SensorMatching\Data\SchoolShuttle\20150928_withPhani\Red2_full_good                   '; ...
%      'E:\SensorMatching\Data\SchoolShuttle\20150928_withXiang\Red1_full_good                   '; ...
%      'E:\SensorMatching\Data\SchoolShuttle\20150929_withXiang\Red1_full_good                   '; ...
%      
%      'E:\SensorMatching\Data\SchoolShuttle\20150924\Evening1_full_good                         '; ...
%      'E:\SensorMatching\Data\SchoolShuttle\20150924\Evening2_full_good                         '; ...
%      'E:\SensorMatching\Data\SchoolShuttle\20150924\Evening3_full_good                         '; ...
];

cellParentFolders = cellstr(sArr_ParentFolders);

% Get statistics of the reference trace:
%   #segment of trace
%   Time duration of each segment
%   Time duration of stop and moving within each segment
%   #Turn within each segment
%   Turn direction

disp('Extracting Reference Trace Statistics.............');

nFolderCnt = length(cellParentFolders);
nRouteCnt = nFolderCnt/3;

nTraceCnt = 3;

sRefTraceInfoFile = 'Ref_Uniqued_TmCrt_InfoG.csv';

sFeatureFolder = 'Feature';

sSegBfRef = 'Ref_Uniqued_TmCrt_SegBF';
sSegDfRef = 'Ref_Uniqued_TmCrt_SegDF';

%sRefStatFile = 'E:\SensorMatching\Data\SchoolShuttle\Stat\StatRef.csv';
sRefStatFile = 'E:\SensorMatching\Data\SchoolShuttle\Stat\StatRef_Yellow.csv';

fidWriteStatRef = fopen(sRefStatFile, 'w');

nMaxSegTurnCnt = 20;  % Max number of turns within a segment

% Route:
%   1-Green, 2-Yellow, 3-Blue, 4-North, 5-Red, 6-Evening
%
for i = 1:nRouteCnt
    for j = 1:3   % Trace
        sParentFolder = cellParentFolders{(i-1)*3+j};
        
        sFullFolderPathFileOrg = [sParentFolder '\' sRefTraceInfoFile];
        mInfoG = load(sFullFolderPathFileOrg);
        [nSegStationCnt ~] = size(mInfoG);
        
        nSegIdx = 0;
        for k = 1:nSegStationCnt
            nType = mInfoG(k, 1);
            fDuration = mInfoG(k, 4);
            fBaro = mInfoG(k, 5);
            
            sLine = sprintf('%d,%d,%d,%f,%f', i,j,nType,fBaro,fDuration);
            
            if nType == 0  % Station
                for m = 6:28
                    sLine = sprintf('%s,%d', sLine, 0);
                end
            else  % Segment
                nSegIdx = nSegIdx + 1;
                sSegStatFile = [sParentFolder '\' sFeatureFolder '\' sSegBfRef '_' num2str(nSegIdx) '.csv'];
                mSegStat = load(sSegStatFile);
                nMovingUnitCnt = sum(mSegStat(:,1)==1);
                if nMovingUnitCnt > 0 
                    fTotalMovingDuration = sum(mSegStat(mSegStat(:,1)==1,2));
                else
                    fTotalMovingDuration = 0;
                end

                nStopUnitCnt = sum(mSegStat(:,1)==0);
                if nStopUnitCnt > 0 
                    fTotalStopDuration = sum(mSegStat(mSegStat(:,1)==0,2));
                else
                    fTotalStopDuration = 0;
                end
                                
                sLine = sprintf('%s,%f,%f', sLine,fTotalMovingDuration,fTotalStopDuration);
                
                mTurns = mSegStat(mSegStat(:,1)==2,:)
                [nTurnCnt ~] = size(mTurns)
                sLine = sprintf('%s,%d', sLine, nTurnCnt);
                
                for m=1:nTurnCnt
                    sLine = sprintf('%s,%d', sLine, mTurns(m,2));
                end
                
                for m = 1:nMaxSegTurnCnt-nTurnCnt
                    sLine = sprintf('%s,%d', sLine, 0);
                end
                
            end
            
            fprintf(fidWriteStatRef, '%s\n', sLine);
        end
            
    end
end

fclose(fidWriteStatRef);

disp('>>>>>>>>>>>>>>DONE<<<<<<<<<<<<<<');

return;
