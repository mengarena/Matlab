function f = SBM_GetTraceInfo_General_Total()
% This function process the _Uniqued_TmCrt.csv under each folder
% Ref,hand,pocket as a group
%
% This function get the general information about the _Uniqued_TmCrt.csv
%
%

sArr_ParentFolders = [ ...
     'E:\SensorMatching\Data\SchoolShuttle\20150924\Evening1_full_good                         '; ...
     'E:\SensorMatching\Data\SchoolShuttle\20150924\Evening2_full_good                         '; ...
     'E:\SensorMatching\Data\SchoolShuttle\20150924\Evening3_full_good                         '; ...
     'E:\SensorMatching\Data\SchoolShuttle\20150924\Green1_full_good                           '; ...
     'E:\SensorMatching\Data\SchoolShuttle\20150924\Yellow1_full_good                          '; ...
     'E:\SensorMatching\Data\SchoolShuttle\20150924\Yellow2_half_good                          '; ...
     'E:\SensorMatching\Data\SchoolShuttle\20150925_morning\Blue1_full_good                    '; ...
     'E:\SensorMatching\Data\SchoolShuttle\20150925_morning\Blue2_full_good                    '; ...
     'E:\SensorMatching\Data\SchoolShuttle\20150925_morning\Blue3_full_good                    '; ...
     'E:\SensorMatching\Data\SchoolShuttle\20150925_morning\North1_full_good                   '; ...
     'E:\SensorMatching\Data\SchoolShuttle\20150925_morning\North2_full_good                   '; ...
     'E:\SensorMatching\Data\SchoolShuttle\20150925_morning\North3_full_good                   '; ...
     'E:\SensorMatching\Data\SchoolShuttle\20150925_morning\Yellow_half_good                   '; ...
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

% to find Ref_xxxxx_Uniqued.csv, hand_xxxx_Uniqued.csv,
% pocket_xxx_Uniqued.csv

sPreFixRef = 'Ref';    
sPreFixHand = 'hand';  
sPreFixPocket = 'pocket';  

sPostFix = '_Uniqued_TmCrt.csv';

sResultPostFix = 'InfoG';   % General Information

for k=1:length(cellParentFolders)
    sParentFolder = cellParentFolders{k} ; 

    bFindRef = 0;
    bFindHand = 0;
    bFindPocket = 0;

    sMsg = ['Processing...' sParentFolder];
    disp(sMsg);
    
    Files = dir(sParentFolder);

    for i=3:length(Files)        
        sFullFolderPathFile = [sParentFolder '\' Files(i).name];
        
        mCheckPreFixRef = strfind(lower(Files(i).name), lower(sPreFixRef));
        mCheckPreFixHand = strfind(lower(Files(i).name), lower(sPreFixHand));
        mCheckPreFixPocket = strfind(lower(Files(i).name), lower(sPreFixPocket));
        
        mCheckPostFix = strfind(lower(Files(i).name), lower(sPostFix));
        
        if length(mCheckPreFixRef) == 1 && length(mCheckPostFix) == 1
            sUniquedRefTrace = sFullFolderPathFile
            bFindRef = 1;
        end
        
        if length(mCheckPreFixHand) == 1 && length(mCheckPostFix) == 1
            sUniquedHandTrace = sFullFolderPathFile
            bFindHand = 1;
        end

        if length(mCheckPreFixPocket) == 1 && length(mCheckPostFix) == 1
            sUniquedPocketTrace = sFullFolderPathFile
            bFindPocket = 1;
        end
        
        if bFindRef == 1 && bFindHand == 1 && bFindPocket == 1
            SBM_GetTraceInfo_General(sUniquedRefTrace, sUniquedHandTrace, sUniquedPocketTrace, sResultPostFix);
            break;
        end
    end

end


return;
