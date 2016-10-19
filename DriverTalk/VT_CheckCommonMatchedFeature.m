function f=VT_CheckCommonMatchedFeature(nSizeLimited)
% In a group, all other images are matched with the first image,
% here check whether some keypoint indexes of the first image are common in
% all matched result
%

fprintf('Start Time: %s\n', datestr(clock, 'yyyy-mm-dd HH:MM:SS'));

if nSizeLimited == 0
    sPlace = 'F:\\ImageFeature_MatchedPointPos\\';
    sMatchedFeatureIdx = 'F:\\ImageFeature_MatchedPointPos\FeaturePointIndex.csv';
else
    sPlace = 'F:\\ImageFeature_MatchedPointPos_SizeLimit\\';
    sMatchedFeatureIdx = 'F:\\ImageFeature_MatchedPointPos_SizeLimit\\FeaturePointIndex.csv';
end

sImagePlace = 'E:\\TestVideo\\ForDecideSize_50group\\';


mCommonExistGroup = [];

nCommonExistGroupCnt = 0;

sOutputFile = sprintf('%s%s', sPlace, 'CommonMatchedPointIndexStat.csv');   % Transmission Time file

fid_result = fopen(sOutputFile,'w');

fid_featureidx = fopen(sMatchedFeatureIdx,'w');

for i=1:50
    fprintf('Group: %d.........................\n', i);
    % First, check how many image files exist
    nFileCnt = 0;
    for j=1:40
        sImageFileName = sprintf('%s%s%d%s%d%s', sImagePlace, 'Group', i, '\\image', j, '.jpg');
        
        if exist(sImageFileName, 'file') == 2
            nFileCnt = nFileCnt + 1;
        else
            break;
        end
    end
    
    nPossibleMatchedPairCnt = nFileCnt - 1;

    % Second, check how many matched pair files exist
    nFileCnt = 0;
    for j=1:40
        sMatchedFileName = sprintf('%s%s%d%s%d%s', sPlace, 'Group', i, '\\MatchedPointIdx_', j, '.csv');
        
        if exist(sMatchedFileName, 'file') == 2
            nFileCnt = nFileCnt + 1;
        else
            break;
        end
    end
    
    nActualMatchedPairCnt = nFileCnt;
    
    % The feature points descriptors from the first image are treated as
    % reference. The feature points descriptors in other images of the same
    % group will be checked against the first image, to check whether any
    % feature point descriptor is common to all these images
    sFeatureFileNameRef = sprintf('%s%s%d%s', sPlace, 'Group', i, '\\MatchedPointIdx_1.csv');
    if exist(sFeatureFileNameRef, 'file') ~= 2
        continue;
    end
    
    mRef = load(sFeatureFileNameRef);
    [nRowRef nColRef] = size(mRef);
    
    nCommonFeatureCnt = 0;  % How many common feature points found in each group
    
    for t=1:nRowRef
        mFeaturePointRef = mRef(t,:);

        nCommonFeatureFileCnt = 0;    
        
        for s=2:nActualMatchedPairCnt
            fprintf('       Pair: %d---------\n', s);
            sFeatureFileNameQuery = sprintf('%s%s%d%s%d%s', sPlace, 'Group', i, '\\MatchedPointIdx_', s, '.csv');
            mQuery = load(sFeatureFileNameQuery);
            [nRowQuery nColQuery] = size(mQuery);
            for ss=1:nRowQuery
                mFeaturePointQuery = mQuery(ss,:);
                if isequal(mFeaturePointRef, mFeaturePointQuery) == 1
                    nCommonFeatureFileCnt = nCommonFeatureFileCnt + 1;
                    break;
                end
            end
            
        end
        
        % If this feature point is common in all images
        if nCommonFeatureFileCnt == nActualMatchedPairCnt - 1
            nCommonFeatureCnt = nCommonFeatureCnt + 1;
            if nCommonFeatureCnt == 1
                fprintf(fid_featureidx, '%d', mFeaturePointRef(1,1));
            else
                fprintf(fid_featureidx, ',%d', mFeaturePointRef(1,1));
            end
        end
        
    end
    
    if nCommonFeatureCnt < 30
        for kkk=nCommonFeatureCnt+1:30
             fprintf(fid_featureidx, ',%d', -1);
        end
    end
    
    fprintf(fid_featureidx, '\n');
     
    mCommonExistGroup(1, i) = nCommonFeatureCnt;
    
    fprintf(fid_result, '%d,%d\n', i, nCommonFeatureCnt);
    
    if nCommonFeatureCnt ~= 0
        nCommonExistGroupCnt = nCommonExistGroupCnt + 1;
    end
        
end

fclose(fid_featureidx);

fclose(fid_result);


fprintf('\n');

mCommonExistGroup

fprintf('\n');

disp('***********Processing is done!******************');

fprintf('Number of Group which have common features: %d\n', nCommonExistGroupCnt);

fprintf('Finish Time: %s\n', datestr(clock, 'yyyy-mm-dd HH:MM:SS'));

return;


