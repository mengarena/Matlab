function f=VT_CheckRepresentativeFeature(nSizeLimited)
% Search common features among the feature points (descriptors) of the
% images in each group
%

fprintf('Start Time: %s\n', datestr(clock, 'yyyy-mm-dd HH:MM:SS'));

if nSizeLimited == 0
    sPlace = 'F:\\ImageFeature\\';
else
    sPlace = 'F:\\ImageFeature_SizeLimit\\';
end

mCommonExistGroup = [];

nCommonExistGroupCnt = 0;

sOutputFile = sprintf('%s%s', sPlace, 'CommonFeatureStat.csv');   % Transmission Time file

fid_result = fopen(sOutputFile,'w');

for i=1:50
    fprintf('.');
    % First, check how many files exist
    nFileCnt = 0;
    for j=1:40
        sFeatureFileName = sprintf('%s%s%d%s%d%s', sPlace, 'Group', i, '\\imageFeature_', j, '.csv');
        
        if exist(sFeatureFileName, 'file') == 2
            nFileCnt = nFileCnt + 1;
        else
            break;
        end
    end
    
    
    % The feature points descriptors from the first image are treated as
    % reference. The feature points descriptors in other images of the same
    % group will be checked against the first image, to check whether any
    % feature point descriptor is common to all these images
    sFeatureFileNameRef = sprintf('%s%s%d%s', sPlace, 'Group', i, '\\imageFeature_1.csv');
    mRef = load(sFeatureFileNameRef);
    [nRowRef nColRef] = size(mRef);
    
    nCommonFeatureCnt = 0;  % How many common feature points found in each group
    
    for t=1:nRowRef
        mFeaturePointRef = mRef(t,:);

        nCommonFeatureFileCnt = 0;    
        
        for s=2:nFileCnt
            sFeatureFileNameQuery = sprintf('%s%s%d%s%d%s', sPlace, 'Group', i, '\\imageFeature_', s, '.csv');
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
        if nCommonFeatureFileCnt == nFileCnt - 1
            nCommonFeatureCnt = nCommonFeatureCnt + 1;
        end
        
    end
    
    mCommonExistGroup(1, i) = nCommonFeatureCnt;
    
    fprintf(fid_result, '%d,%d\n', i, nCommonFeatureCnt);
    
    if nCommonFeatureCnt ~= 0
        nCommonExistGroupCnt = nCommonExistGroupCnt + 1;
    end
        
end

fclose(fid_result);

fprintf('\n');

mCommonExistGroup

fprintf('\n');

disp('***********Processing is done!******************');

fprintf('Number of Group which have common features: %d\n', nCommonExistGroupCnt);

fprintf('Finish Time: %s\n', datestr(clock, 'yyyy-mm-dd HH:MM:SS'));

return;


