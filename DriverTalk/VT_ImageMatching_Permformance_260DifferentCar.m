function f = VT_ImageMatching_Permformance_260DifferentCar(nThreshold, nSizeLimit)

format long;

sMatchedResultFile = 'F:\\DriverTalk_DiversityResult\\DifferentCar_MatchResult_RequiredKeypoint_1000.csv';

mResult = load(sMatchedResultFile);
    
fTmpAccuracy = VT_CalculateMatchingAccuracy_DifferentCar(mResult, nThreshold, nSizeLimit);
fTmpAccuracy = fTmpAccuracy * 100;

disp(strcat('[Threshold==] ', num2str(nThreshold), '   , [Accuracy==] ', num2str(fTmpAccuracy)));
    
disp('###############################################################');

end
