function f = VT_StudyFeature()

mGroundTruth = [164 691 692];

mFeatureNum = [20 40 60 80 100 120 140 160 180 200 250 300 500 1000];
%mFeatureNum = [20 40 60 80 100 120 140 160 180 200 250 300];

[nRow nCol] = size(mFeatureNum);

sPlace = 'F:\\DriverTalk_DiversityResult\\';

for i=1:nCol
    sResultFile = sprintf('%s%s_%s.csv', sPlace,  'MatchResult_RequiredKeypoint', num2str(mFeatureNum(1, i)));
    mResult = load(sResultFile);
    disp(strcat('[Begin]Processing..............', num2str(mFeatureNum(1, i))));
    mRet = VT_GetMatchedNumIdx(mResult)
    disp('[End].............................................................');
end

