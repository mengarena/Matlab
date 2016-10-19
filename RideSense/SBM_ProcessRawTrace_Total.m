function f = SBM_ProcessRawTrace_Total(nPhoneType)
% This function process all Reference Raw Trace

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
     'E:\SensorMatching\Data\SchoolShuttle\20150925_afternoon\Green3_full_AlmostGood           '; ...
     'E:\SensorMatching\Data\SchoolShuttle\20150925_afternoon\Green1_half_Bad                  '; ...
     'E:\SensorMatching\Data\SchoolShuttle\20150925_afternoon\Green2_full_Bad                  '; ...
     'E:\SensorMatching\Data\SchoolShuttle\20150925_afternoon\Red_half_Bad                     '; ...
];


cellParentFolders = cellstr(sArr_ParentFolders);

if nPhoneType == 1  % Reference phone
    sPreFix = 'Ref';    % Reference phone (has label)
    bWithLabel = 1;
elseif nPhoneType == 2 % Hand phone
    sPreFix = 'hand';   % Phone in Hand (has label)
    bWithLabel = 1;
elseif nPhoneType == 3  % Pocket phone
    sPreFix = 'pocket'; % Phone in Pocket (no label)
    bWithLabel = 0;
end

sResultPostFix = 'Uniqued';

for k=1:length(cellParentFolders)
    sParentFolder = cellParentFolders{k} ; 

    Files = dir(sParentFolder);

    for i=3:length(Files)        
        sFullFolderPathFile = [sParentFolder '\' Files(i).name];
        
        mCheckPreFix = strfind(lower(Files(i).name), lower(sPreFix));
        mCheckPostFix = strfind(lower(Files(i).name), lower(sResultPostFix));
        if length(mCheckPreFix) == 1 && length(mCheckPostFix) == 0
            sMsg = ['Processing...' sFullFolderPathFile];
            disp(sMsg);
            if nPhoneType == 1
                SBM_ProcessRawTrace_RefPhone(sFullFolderPathFile, sResultPostFix, bWithLabel);
            elseif nPhoneType == 2
                SBM_ProcessRawTrace_HandPhone(sFullFolderPathFile, sResultPostFix, bWithLabel);
            elseif nPhoneType == 3
                SBM_ProcessRawTrace_PocketPhone(sFullFolderPathFile, sResultPostFix, bWithLabel);
            end
        end
    end

end


return;