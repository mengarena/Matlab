% SBM_Script_Extract_SegmentFeature_Ref

sArr_ParentFolders = [ ...
%    'D:\Evening1_full_good  '; ...
    'E:\SensorMatching\Data\SchoolShuttle\20150924\Evening1_full_good                         '; ...
%       'E:\SensorMatching\Data\SchoolShuttle\20150924\Evening2_full_good                         '; ...
%       'E:\SensorMatching\Data\SchoolShuttle\20150924\Evening3_full_good                         '; ...
%       'E:\SensorMatching\Data\SchoolShuttle\20150924\Green1_full_good                           '; ...
%       'E:\SensorMatching\Data\SchoolShuttle\20150924\Yellow1_full_good                          '; ...
%       'E:\SensorMatching\Data\SchoolShuttle\20150924\Yellow2_half_good                          '; ...
%       'E:\SensorMatching\Data\SchoolShuttle\20150925_morning\Blue1_full_good                    '; ...
%       'E:\SensorMatching\Data\SchoolShuttle\20150925_morning\Blue2_full_good                    '; ...
%       'E:\SensorMatching\Data\SchoolShuttle\20150925_morning\Blue3_full_good                    '; ...
%       'E:\SensorMatching\Data\SchoolShuttle\20150925_morning\North1_full_good                   '; ...
%      'E:\SensorMatching\Data\SchoolShuttle\20150925_morning\North2_full_good                   '; ...
%      'E:\SensorMatching\Data\SchoolShuttle\20150925_morning\North3_full_good                   '; ...
%      'E:\SensorMatching\Data\SchoolShuttle\20150925_morning\Yellow_half_good                   '; ...
%      'E:\SensorMatching\Data\SchoolShuttle\20150928_withPhani\Green1_full_goodQ                '; ...
%      'E:\SensorMatching\Data\SchoolShuttle\20150928_withPhani\Green2_full_goodQ                '; ...
%      'E:\SensorMatching\Data\SchoolShuttle\20150928_withPhani\Red1_abnormal_almostgood         '; ...
%      'E:\SensorMatching\Data\SchoolShuttle\20150928_withPhani\Red2_full_good                   '; ...
%      'E:\SensorMatching\Data\SchoolShuttle\20150928_withPhani\Yellow1_full_goodQ               '; ...
%      'E:\SensorMatching\Data\SchoolShuttle\20150928_withXiang\Green1_half_good                 '; ...
%      'E:\SensorMatching\Data\SchoolShuttle\20150928_withXiang\Red1_full_good                   '; ...
%      'E:\SensorMatching\Data\SchoolShuttle\20150929_withXiang\Yellow1_full_good                '; ...
%      'E:\SensorMatching\Data\SchoolShuttle\20150929_withXiang\Green1_half_almostgood           '; ...
%     'E:\SensorMatching\Data\SchoolShuttle\20150929_withXiang\Red1_full_good                   '; ...
];

cellParentFolders = cellstr(sArr_ParentFolders);

sPrefix = 'Ref';

sTracePostfix = 'Uniqued_TmCrt.csv';

sTraceInfoPostfix = 'InfoG.csv';   % General Information

% In PCA stat file, the fields are: Type (1: linearAccl, 2: Gyro) explained(1), explained(2), explained(3), latent(1), latent(2), latent(3)
sPCAStatFile = 'E:\SensorMatching\Data\SchoolShuttle\Stat\PCAStat_Ref.csv';
fPCAStat = fopen(sPCAStatFile, 'a+'); 

disp('Extract Reference Segment Feature.....');
for k=1:length(cellParentFolders)
    sParentFolder = cellParentFolders{k} ; 

    bFindRef = 0;
    bFindTracePostfix = 0;
    bFindTraceInfoPostfix = 0;

    sMsg = ['Processing...' sParentFolder];
    disp(sMsg);
    
    Files = dir(sParentFolder);

    sRefTraceFile = '';
    nTraceFile = 0;
    sRefTraceInfoFile = '';
    nTraceInfoFile = 0;
    
    for i=3:length(Files)        
        sFullFolderPathFile = [sParentFolder '\' Files(i).name];
        
        mCheckPrefixRef = strfind(lower(Files(i).name), lower(sPrefix));
        mCheckTracePostfix = strfind(lower(Files(i).name), lower(sTracePostfix));
        mCheckTraceInfoPostfix = strfind(lower(Files(i).name), lower(sTraceInfoPostfix));
                
        if length(mCheckPrefixRef) == 1 && length(mCheckTracePostfix) == 1
            sRefTraceFile = sFullFolderPathFile;
            nTraceFile = 1;
        end
        
        if length(mCheckPrefixRef) == 1 && length(mCheckTraceInfoPostfix) == 1
            sRefTraceInfoFile = sFullFolderPathFile;
            nTraceInfoFile = 1;
        end
        
        if nTraceFile == 1 && nTraceInfoFile == 1
            SBM_GetRefFeature(sRefTraceFile, sRefTraceInfoFile, fPCAStat);
            
            %Test_SBM_GetRefFeature(sRefTraceFile, sRefTraceInfoFile, fPCAStat);
            
            %SBM_GetRefFeatureS(sRefTraceFile, sRefTraceInfoFile);
            break;
        end
    end

end

fclose(fPCAStat);

disp('Extract Reference Segment Feature.....Done !!!');



disp('>>>>>>>>>>>>>>DONE<<<<<<<<<<<<<<');
