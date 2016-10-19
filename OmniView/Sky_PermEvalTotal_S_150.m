function f = Sky_PermEvalTotal_S_150(fRcvTimeGap)
% This function measure all the transmission time (average, standard
% deviation, max, min;
% It also get statistics about the list of receivers for each send event
%
% The result is saved as csv files
%
% fRcvTimeGap: Receive time constraint, if 1000.0, then no time constraint
%
% Transmission Range: 60, 80, 100, 120, 150, 200
% Packet Size: 5, 10, 15, 20, 25, 30, 35, 40, 45
% Modulation Scheme: 1 (6 Mbps)
%
%

fprintf('Start Time: %s\n', datestr(clock, 'yyyy-mm-dd HH:MM:SS'));

nModulScheme = 1;

mTransRange = [150];
mPacketSize = [5 10 15 20 25 30 35 40 45];

nRangeCount = length(mTransRange);
nSizeCount = length(mPacketSize);

format long;

%fRcvTimeGap = 1000.0;    % 1000.0 is big enough as packet receiving during for WITHOUT constraint

if fRcvTimeGap >= 999.0   % No receive time constraint
    sOutputFile = 'E:\\SkyEye_Backup20130801\\Simulation\\Sim_output\\Straight_TransTimeEval_NoRcvTimeCnst_150.csv';
else
    sOutputFile = 'E:\\SkyEye_Backup20130801\\Simulation\\Sim_output\\Straight_TransTimeEval_RcvTimeCnst_150.csv';
end

fid_result = fopen(sOutputFile,'w');
fprintf(fid_result, '#Trans range, Packet size, Modulation scheme, Avg trans time, Std trans time, Max trans time, Min trans time\n');

sFilePath = 'E:\\SkyEye_Backup20130801\\Simulation\\Sim_output\\Straight\\SkyEye_Straight';

for i=1:nRangeCount
    nRange = mTransRange(1,i);
    
    for j=1:nSizeCount
        nSize = mPacketSize(1,j);
        
        sFileName = sprintf('%s_%s_%s_1.csv', sFilePath, num2str(nRange), num2str(nSize));    % This is the pre-processed ns trace result
        disp('*****************************************************');
        fprintf('Processing: %s\n', sFileName);
        
        mTrace = load(sFileName);
        mResult = Sky_PermEval_S_sub(mTrace, nRange, nSize, fRcvTimeGap);   
        
        fprintf(fid_result,'%d,%d,%d,%f,%f,%f,%f\n',nRange, nSize, nModulScheme, mResult(1,1), mResult(1,2), mResult(1,3), mResult(1,4));
        fprintf('Average Transmission Time: %f\n', mResult(1,1));
        fprintf('Std Transmission Time: %f\n', mResult(1,2));
        fprintf('Max Transmission Time: %f\n', mResult(1,3));
        fprintf('Min Transmission Time: %f\n', mResult(1,4));
    end
end    

fclose(fid_result);

disp('***********Processing is done!******************');

fprintf('Finish Time: %s\n', datestr(clock, 'yyyy-mm-dd HH:MM:SS'));

return;
