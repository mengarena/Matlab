function f = SBM_Script_Extract_TraceFeature_Passenger_B(nType)
%This function is used to extract segment features for passenger traces
%(hand, pantpocket)
% nType = 1:  hand
% nType = 2:  pantpocket

% In evaluation, for hand and pantpocket phone, during correlation, use the
% features from TraceBF and TraceDF, so should use this script to extract
% features for Passenger phones, instead of getting SegDF and SegBF

format long;

sArr_ParentFolders = [ ...
%      'E:\SensorMatching\Data\SchoolShuttle\20150924\Evening1_full_good                         '; ...
%      'E:\SensorMatching\Data\SchoolShuttle\20150924\Evening2_full_good                         '; ...
%      'E:\SensorMatching\Data\SchoolShuttle\20150924\Evening3_full_good                         '; ...
%      'E:\SensorMatching\Data\SchoolShuttle\20150924\Green1_full_good                           '; ...
%      'E:\SensorMatching\Data\SchoolShuttle\20150924\Yellow1_full_good                          '; ...
%      'E:\SensorMatching\Data\SchoolShuttle\20150924\Yellow2_half_good                          '; ...
%      'E:\SensorMatching\Data\SchoolShuttle\20150925_morning\Blue1_full_good                    '; ...
%      'E:\SensorMatching\Data\SchoolShuttle\20150925_morning\Blue2_full_good                    '; ...
%      'E:\SensorMatching\Data\SchoolShuttle\20150925_morning\Blue3_full_good                    '; ...
%      'E:\SensorMatching\Data\SchoolShuttle\20150925_morning\North1_full_good                   '; ...
%      'E:\SensorMatching\Data\SchoolShuttle\20150925_morning\North2_full_good                   '; ...
%      'E:\SensorMatching\Data\SchoolShuttle\20150925_morning\North3_full_good                   '; ...
%      'E:\SensorMatching\Data\SchoolShuttle\20150925_morning\Yellow_half_good                   '; ...
     'E:\SensorMatching\Data\SchoolShuttle\20150928_withPhani\Green1_full_goodQ                '; ...
     'E:\SensorMatching\Data\SchoolShuttle\20150928_withPhani\Green2_full_goodQ                '; ...
     'E:\SensorMatching\Data\SchoolShuttle\20150928_withPhani\Red1_abnormal_almostgood         '; ...
     'E:\SensorMatching\Data\SchoolShuttle\20150928_withPhani\Red2_full_good                   '; ...
     'E:\SensorMatching\Data\SchoolShuttle\20150928_withPhani\Yellow1_full_goodQ               '; ...
     'E:\SensorMatching\Data\SchoolShuttle\20150928_withXiang\Green1_half_good                 '; ...
     'E:\SensorMatching\Data\SchoolShuttle\20150928_withXiang\Red1_full_good                   '; ...
     'E:\SensorMatching\Data\SchoolShuttle\20150929_withXiang\Yellow1_full_good                '; ...
     'E:\SensorMatching\Data\SchoolShuttle\20150929_withXiang\Green1_half_almostgood           '; ...
     'E:\SensorMatching\Data\SchoolShuttle\20150929_withXiang\Red1_full_good                   '; ...
];

cellParentFolders = cellstr(sArr_ParentFolders);

nIdxDataType = 0;

sPCAStatFile = '';

if nType == 1
    sPrefix = 'hand';
    nIdxDataType = 3;
    
    sPCAStatFile = 'E:\SensorMatching\Data\SchoolShuttle\Stat\PCAStat_hand.csv';
    
elseif nType == 2
    sPrefix = 'pantpocket';
    nIdxDataType = 2;
    sPCAStatFile = 'E:\SensorMatching\Data\SchoolShuttle\Stat\PCAStat_pantpocket.csv';
else
    return;
end

% In PCA stat file, the fields are: Type (1: linearAccl, 2: Gyro) explained(1), explained(2), explained(3), latent(1), latent(2), latent(3)
fPCAStat = fopen(sPCAStatFile, 'a+'); 

sTracePostfix = 'Uniqued_TmCrt.csv';

sTraceInfoPostfix = 'InfoG.csv';   % General Information

fprintf('Extract Passenger [%s] Segment Feature.....\n', sPrefix);

for k=1:length(cellParentFolders)
    sParentFolder = cellParentFolders{k} ; 

    bFindPsg = 0;
    bFindTracePostfix = 0;
    bFindTraceInfoPostfix = 0;

    sMsg = ['Processing...' sParentFolder];
    disp(sMsg);
    
    Files = dir(sParentFolder);

    sPsgTraceFile = '';
    nTraceFile = 0;
    sPsgTraceInfoFile = '';
    nTraceInfoFile = 0;
    
    for i=3:length(Files)        
        sFullFolderPathFile = [sParentFolder '\' Files(i).name];
        
        mCheckPrefixPsg = strfind(lower(Files(i).name), lower(sPrefix));
        mCheckTracePostfix = strfind(lower(Files(i).name), lower(sTracePostfix));
        mCheckTraceInfoPostfix = strfind(lower(Files(i).name), lower(sTraceInfoPostfix));
                
        if length(mCheckPrefixPsg) == 1 && length(mCheckTracePostfix) == 1
            sPsgTraceFile = sFullFolderPathFile
            nTraceFile = 1;
        end
        
        if length(mCheckPrefixPsg) == 1 && length(mCheckTraceInfoPostfix) == 1
            sPsgTraceInfoFile = sFullFolderPathFile
            nTraceInfoFile = 1;
        end
        
        if nTraceFile == 1 && nTraceInfoFile == 1
            SBM_GetPassengerFeature_WholeTrace(sPsgTraceFile, sPsgTraceInfoFile, nIdxDataType, fPCAStat);
%            SBM_GetPassengerFeature_WholeTraceS(sPsgTraceFile, sPsgTraceInfoFile, nIdxDataType);

            break;
        end
    end

end

fclose(fPCAStat);

fprintf('Extract Passenger [%s] Segment Feature......Done !!!\n', sPrefix);


disp('>>>>>>>>>>>>>>DONE<<<<<<<<<<<<<<');
