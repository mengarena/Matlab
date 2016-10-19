function f = SS_ClassifyBasedOnKmeans(mKmeansCentroid, mTestData)
% This function is used calcuate the Class ID of the test data based on the
% clusters formed by K-Means.
%
% Parameter:
%      @ KmeansCentroid:  The centroids of the K-Means clusters
%      @ mTestData:   The data need to be classified (Could be one set of
%      data or many sets of data)
%
format long;

mDistRet = pdist2(mKmeansCentroid, mTestData, 'euclidean');

[nRow nCol] = size(mDistRet);

mRetIndex = [];   % Store the classified Class ID (i.e. observation sequence.

for i=1:nCol
   [fMinDist mRetIndex(i)] = min(mDistRet(:,i));  
end

f = mRetIndex;

return;
