function f = SBM_CorrectTimeStamp_Total_2()
% This function process the _Uniqued.csv under each folder
% To correct the timestamp for each record
%

sArr_ParentFolders = [ ...
%       'E:\SensorMatching\Data\SchoolShuttle\20150924\Evening1_full_good                         '; ...
%       'E:\SensorMatching\Data\SchoolShuttle\20150924\Evening2_full_good                         '; ...
%       'E:\SensorMatching\Data\SchoolShuttle\20150924\Evening3_full_good                         '; ...
%       'E:\SensorMatching\Data\SchoolShuttle\20150924\Green1_full_good                           '; ...
%       'E:\SensorMatching\Data\SchoolShuttle\20150924\Yellow1_full_good                          '; ...
%       'E:\SensorMatching\Data\SchoolShuttle\20150924\Yellow2_half_good                          '; ...
% 
%      'E:\SensorMatching\Data\SchoolShuttle\20150925_morning\Blue1_full_good                    '; ...
%      'E:\SensorMatching\Data\SchoolShuttle\20150925_morning\Blue2_full_good                    '; ...
%      'E:\SensorMatching\Data\SchoolShuttle\20150925_morning\Blue3_full_good                    '; ...
%       
%       'E:\SensorMatching\Data\SchoolShuttle\20150925_morning\North1_full_good                   '; ...
%       'E:\SensorMatching\Data\SchoolShuttle\20150925_morning\North2_full_good                   '; ...
%       'E:\SensorMatching\Data\SchoolShuttle\20150925_morning\North3_full_good                   '; ...
      
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
     'E:\SensorMatching\Data\SchoolShuttle\20150925_afternoon\Green3_full_AlmostGood           '; ...
     'E:\SensorMatching\Data\SchoolShuttle\20150925_afternoon\Green1_half_Bad                  '; ...
     'E:\SensorMatching\Data\SchoolShuttle\20150925_afternoon\Green2_full_Bad                  '; ...
     'E:\SensorMatching\Data\SchoolShuttle\20150925_afternoon\Red_half_Bad                     '; ...
];

cellParentFolders = cellstr(sArr_ParentFolders);

% to find Ref_xxxxx_Uniqued.csv, hand_xxxx_Uniqued.csv,
% pocket_xxx_Uniqued.csv

sPreFixRef = 'Ref';    
sPreFixHand = 'hand';  
sPreFixPocket = 'pocket';  

sPostFix = '_Uniqued.csv';

sResultPostFix = 'TmCrt';

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
            SBM_CorrectTimeStamp(sFullFolderPathFile, sResultPostFix, 0);
            bFindRef = 1;
        end
        
        if length(mCheckPreFixHand) == 1 && length(mCheckPostFix) == 1
            SBM_CorrectTimeStamp(sFullFolderPathFile, sResultPostFix, 1);
            bFindHand = 1;
        end

        if length(mCheckPreFixPocket) == 1 && length(mCheckPostFix) == 1
            SBM_CorrectTimeStamp(sFullFolderPathFile, sResultPostFix, 0);
            bFindPocket = 1;
        end
        
        if bFindRef == 1 && bFindHand == 1 && bFindPocket == 1
            break;
        end
    end

end


return;
