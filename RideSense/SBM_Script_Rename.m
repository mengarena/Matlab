% rename


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
%       'E:\SensorMatching\Data\SchoolShuttle\20150925_afternoon\Green3_full_AlmostGood           '; ...
%      'E:\SensorMatching\Data\SchoolShuttle\20150928_withPhani\Green1_full_goodQ                '; ...
%      'E:\SensorMatching\Data\SchoolShuttle\20150928_withPhani\Green2_full_goodQ                '; ...
%      'E:\SensorMatching\Data\SchoolShuttle\20150928_withPhani\Red1_abnormal_almostgood         '; ...
%      'E:\SensorMatching\Data\SchoolShuttle\20150928_withPhani\Red2_full_good                   '; ...
%      'E:\SensorMatching\Data\SchoolShuttle\20150928_withPhani\Yellow1_full_goodQ               '; ...
%      'E:\SensorMatching\Data\SchoolShuttle\20150928_withXiang\Green1_half_good                 '; ...
%      'E:\SensorMatching\Data\SchoolShuttle\20150928_withXiang\Red1_full_good                   '; ...
%      'E:\SensorMatching\Data\SchoolShuttle\20150929_withXiang\Yellow1_full_good                '; ...
%      'E:\SensorMatching\Data\SchoolShuttle\20150929_withXiang\Green1_half_almostgood           '; ...
%      'E:\SensorMatching\Data\SchoolShuttle\20150929_withXiang\Red1_full_good                   '; ...
%       'E:\SensorMatching\Data\SchoolShuttle\20150925_afternoon\Green1_half_Bad                  '; ...
       'E:\SensorMatching\Data\SchoolShuttle\20150925_afternoon\Green2_full_Bad                  '; ...
       'E:\SensorMatching\Data\SchoolShuttle\20150925_afternoon\Red_half_Bad                     '; ...
];

cellParentFolders = cellstr(sArr_ParentFolders);

sPrefix1 = 'Ref';
sPrefix2 = 'hand';
sPrefix3 = 'pantpocket';

sPostFix1 = 'Uniqued.csv';
sPostFix2 = 'Uniqued_TmCrt.csv';
sPostFix3 = 'Uniqued_TmCrt_InfoG.csv';
sPostFix4 = 'Uniqued_TmCrt_SegMF.csv';
sPostFix5 = 'Uniqued_TmCrt_SegMF_LessFiltered.csv';
sPostFix6 = 'Uniqued_TmCrt_SegMF_MoreFiltered.csv';
sPostFix7 = 'Uniqued_TmCrt_SegMF_N.csv';
sPostFix8 = 'Uniqued_TmCrt_SegMF_NoFilter.csv';


disp('Extract Reference Segment Feature.....');
for k=1:length(cellParentFolders)
    sParentFolder = cellParentFolders{k} ; 

    sMsg = ['Processing...' sParentFolder];
    disp(sMsg);
    
    Files = dir(sParentFolder);

    
    for i=3:length(Files)        
        sFullFolderPathFileOrg = [sParentFolder '\' Files(i).name];

        sFilePrefix = '';
        nPrefix = 0;

        sFilePostfix = '';
        nPostfix = 0;
        
        mCheckPrefix1 = [];
        mCheckPrefix2 = [];
        mCheckPrefix3 = [];
        
        mCheckPrefix1 = strfind(Files(i).name, sPrefix1);
        mCheckPrefix2 = strfind(Files(i).name, sPrefix2);
        mCheckPrefix3 = strfind(Files(i).name, sPrefix3);
 
        if length(mCheckPrefix1) > 0
            sFilePrefix = sPrefix1;
            nPrefix = 1;
        elseif length(mCheckPrefix2) > 0
            sFilePrefix = sPrefix2;
            nPrefix = 1;
        elseif length(mCheckPrefix3) > 0
            sFilePrefix = sPrefix3;
            nPrefix = 1;
        end
 
        mCheckPostfix1 = [];
        mCheckPostfix2 = [];
        mCheckPostfix3 = [];
        mCheckPostfix4 = [];
        mCheckPostfix5 = [];
        mCheckPostfix6 = [];
        mCheckPostfix7 = [];
        mCheckPostfix8 = [];
       
        mCheckPostfix1 = strfind(lower(Files(i).name), lower(sPostFix1));
        mCheckPostfix2 = strfind(lower(Files(i).name), lower(sPostFix2));
        mCheckPostfix3 = strfind(lower(Files(i).name), lower(sPostFix3));
        mCheckPostfix4 = strfind(lower(Files(i).name), lower(sPostFix4));
        mCheckPostfix5 = strfind(lower(Files(i).name), lower(sPostFix5));
        mCheckPostfix6 = strfind(lower(Files(i).name), lower(sPostFix6));
        mCheckPostfix7 = strfind(lower(Files(i).name), lower(sPostFix7));
        mCheckPostfix8 = strfind(lower(Files(i).name), lower(sPostFix8));
        
        if length(mCheckPostfix1) > 0
            sFilePostfix = sPostFix1;
            nPostfix = 1;
        elseif length(mCheckPostfix2) > 0
            sFilePostfix = sPostFix2;
            nPostfix = 1;
        elseif length(mCheckPostfix3) > 0
            sFilePostfix = sPostFix3;
            nPostfix = 1;
        elseif length(mCheckPostfix4) > 0
            sFilePostfix = sPostFix4;
            nPostfix = 1;
        elseif length(mCheckPostfix5) > 0
            sFilePostfix = sPostFix5;
            nPostfix = 1;
        elseif length(mCheckPostfix6) > 0
            sFilePostfix = sPostFix6;
            nPostfix = 1;
        elseif length(mCheckPostfix7) > 0
            sFilePostfix = sPostFix7;
            nPostfix = 1;
        elseif length(mCheckPostfix8) > 0
            sFilePostfix = sPostFix8;
            nPostfix = 1;
        end
        

        if nPrefix == 1 && nPostfix == 1
            sFullFolderPathFileNew = [sParentFolder '\' sFilePrefix '_' sFilePostfix];
            movefile(sFullFolderPathFileOrg, sFullFolderPathFileNew);
        elseif nPrefix == 1 && nPostfix == 0
            sFullFolderPathFileNew = [sParentFolder '\' sFilePrefix '.csv'];
            movefile(sFullFolderPathFileOrg, sFullFolderPathFileNew);
        end
     end

end



disp('>>>>>>>>>>>>>>DONE<<<<<<<<<<<<<<');
