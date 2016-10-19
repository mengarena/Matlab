function f = SS_LargeScale_Standardize_Kmean(nMeans)
% This function is used to do large scale feature vector standardization
% and K-Means.
% The purpose of this function is to generate Mean/Std from
% standardization, which could be used to standardize the featuer vectors
% in other small-scale training (e.g. a HMM) or test,
% And it generates the Centroid of the K-Means, which could be used to
% classify other feature vectors later in training (to get observation
% sequence) or test
%
% Steps:
%   1) Extract feature vectors from all Wav files
%   2) Standardize the whole feature vector set --> Get Mean/Std which
%   should be saved into files
%   3) Do K-Means on the standardized feature vectors --> Get Centroid
%
% Parameter:
%   @ nMeans:   K in K-Means
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf('Start Time: %s\n', datestr(clock, 'yyyy-mm-dd HH:MM:SS'));

format long;

sOutputFoler = 'E:\UIUC\LargeScale_StandKmeans\';

sArr_AudioFiles = [ ...
    'E:\UIUC\Multimedia_Data\AM_KO\Gear_01\20140624182938.wav                                           '; ...
    'E:\UIUC\Multimedia_Data\BedBathBeyond\Gear_01\20140621152728.wav                                   '; ...
    'E:\UIUC\Multimedia_Data\BestBuy\Gear_02\20140629154339.wav                                         '; ...
    'E:\UIUC\Multimedia_Data\BookStore\BarnesNoble\Gear_01\20140621151730.wav                           '; ...
    'E:\UIUC\Multimedia_Data\BookStore\FriendShopBookStore_publiclibrary\Gear_01\20140621133223.wav     '; ...
    'E:\UIUC\Multimedia_Data\BookStore\IlliniUnionBookstore\Gear_01\20140627144203.wav                  '; ...
    'E:\UIUC\Multimedia_Data\BookStore\JaneAddamsBookShop\Gear_01\20140621140234.wav                    '; ...
    'E:\UIUC\Multimedia_Data\BookStore\PricelessBooks\Gear_01\20140621143226.wav                        '; ...
    'E:\UIUC\Multimedia_Data\BookStore\TisCollege_Bookstore\Gear_02\20140627145811.wav                  '; ...
    'E:\UIUC\Multimedia_Data\CravingsRestaurant\Gear_03\20140623192645.wav                              '; ...
    'E:\UIUC\Multimedia_Data\CravingsRestaurant\Gear_04\20140701121328.wav                              '; ...
    'E:\UIUC\Multimedia_Data\CSL\Daytime\Gear_01\20140701110031.wav                                     '; ...
    'E:\UIUC\Multimedia_Data\CSL\Daytime\Gear_02\20140701111337.wav                                     '; ...
    'E:\UIUC\Multimedia_Data\CSL\MiddleNight\Gear_01\20140624004626.wav                                 '; ...
    'E:\UIUC\Multimedia_Data\CVS\GreenStreet_S_Neil\Gear_02\20140621134248.wav                          '; ...
    'E:\UIUC\Multimedia_Data\MarketPlace\Gear_01\20140629151355.wav                                     '; ...
    'E:\UIUC\Multimedia_Data\Sports\FinishLine\Gear_01\20140629152745.wav                               '; ...
    'E:\UIUC\Multimedia_Data\Sports\McSports\Gear_01\20140621153212.wav                                 '; ...
    'E:\UIUC\Multimedia_Data\Street\Gear_01\20140627143036.wav                                          '; ...
    'E:\UIUC\Multimedia_Data\Street\Gear_02\20140627150434.wav                                          '; ...
    'E:\UIUC\Multimedia_Data\ToysRus\Gear_01\20140621150219.wav                                         '; ...
    'E:\UIUC\Multimedia_Data\Walmart\Urbana\Gear_02\20140624172936.wav                                  '; ...
    'E:\UIUC\Multimedia_Data\Walsgreen\407E_GreenSt\Gear_02\20140627150829.wav                          '; ...
    'E:\UIUC\Multimedia_Data\Walsgreen\602W_UniversityAve\Gear_01\20140621141634.wav                    '
 ];

cellAudioFiles = cellstr(sArr_AudioFiles);

% Parameter:
nFrameLen = 40;  % ms
nFrameStep = 20; % ms
nPreCut = 15;    % s
fPostCut = 0.1;  % 10%

nUsageType = 1;
fDataRatio = 1.0;   % All the valid data are used for extracting featuer vectors and 

% Step 1:  Extract feature vector
mFeatureVector = [];
nFeatureCnt = 0;

for i=1:length(cellAudioFiles)
    fprintf('Extracting Feature: %s\n', cellAudioFiles{i});
    [matEng, matZcr, matMfcc] = SS_ExtractFeature_Audio(cellAudioFiles{i}, nFrameLen, nFrameStep, nPreCut, fPostCut, nUsageType, fDataRatio);

    [nRow nCol] = size(matMfcc);
    
    for j = 1:nRow
        nFeatureCnt = nFeatureCnt + 1;
        mFeatureVector(nFeatureCnt, 1) = matEng(j,1);
        mFeatureVector(nFeatureCnt, 2) = matZcr(j,1);
        
        for jj = 1:nCol
            mFeatureVector(nFeatureCnt, 2+jj) = matMfcc(j,jj);
        end
    end
    
end

% Step 2: Standardize the feature vectors ---> Get and save Mean/Std
fprintf('Standardizing......\n');
[mStandardizedFeatureVector, mMean, mStd] = zscore(mFeatureVector);

sStandardizationParameterFile = [sOutputFoler 'StandarizationParam_' num2str(nMeans) '.csv'];
fid_resultStandardize = fopen(sStandardizationParameterFile, 'w');
for i = 1:length(mMean)
    fprintf(fid_resultStandardize, '%f,%f\n', mMean(i), mStd(i));
end
fclose(fid_resultStandardize);


% Step 3: K-Means the standardized the feature vectors ---> Get and save
% Centroid
fprintf('K-Means Clustering......\n');
[IDX Centroid] = kmeans(mStandardizedFeatureVector, nMeans);

%%%%%%%%%%%% Save KMeans Centroid
[nCentroidRow nCentroidCol] = size(Centroid);

sKmeansCentroidFile = [sOutputFoler 'KmeansCentroid_' num2str(nMeans) '.csv'];

fid_resultCentroid = fopen(sKmeansCentroidFile, 'w');

for ii=1:nCentroidRow
    for jj=1:nCentroidCol
        fprintf(fid_resultCentroid, '%f,', Centroid(ii,jj));
    end
    fprintf(fid_resultCentroid,'\n');
end    

fclose(fid_resultCentroid);

fprintf('Finish Time: %s\n', datestr(clock, 'yyyy-mm-dd HH:MM:SS'));

return;
