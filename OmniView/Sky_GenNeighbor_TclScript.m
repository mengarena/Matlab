function f=Sky_GenNeighbor_TclScript()
% This function is used to generate the Tcl Script for getting the neighbor
% nodes for each sender node at each timestamp
%
%

fprintf('Start Time: %s\n', datestr(clock, 'yyyy-mm-dd HH:MM:SS'));

nModulScheme = 1;

mTransRange = [60 80 100 120 150 200];
mPacketSize = [5 10 15 20 25 30 35 40 45];

nRangeCount = length(mTransRange);
nSizeCount = length(mPacketSize);

format long;

%sOutputFilePre = 'E:\\USC_Project\\SkyEye\\Simulation\\Sim_output\\Straight\\Straight_GetNeighborTclScript\\Straight_GetNeigh';
%sFilePath = 'E:\\USC_Project\\SkyEye\\Simulation\\Sim_output\\Straight\\Straight_Trace\\SkyEye_Straight';

sOutputFilePre = 'E:\\USC_Project\\SkyEye\\Simulation\\Sim_output\\Dense40_20\\Dense_40_20_GetNeighborTclScript\\Dense_GetNeigh';
sFilePath = 'E:\\USC_Project\\SkyEye\\Simulation\\Sim_output\\Dense40_20\\Dense_40_20_Trace\\SkyEye_Dense';

for i=1:nRangeCount

    nRange = mTransRange(1,i);

    for j=1:nSizeCount

        nSize = mPacketSize(1,j);
        
        sFileName = sprintf('%s_%s_%s_1.csv', sFilePath, num2str(nRange), num2str(nSize)); % Pre-processed trace file
        disp('*****************************************************');
        fprintf('Processing: %s\n', sFileName);
        
        sOutputFile = sprintf('%s_%s_%s_1.tcl', sOutputFilePre, num2str(nRange), num2str(nSize));
        fprintf('Output Tcl script: %s\n', sOutputFile);
        fid_result = fopen(sOutputFile,'w');
        
        mTrace = load(sFileName);
        [nRow nCol] = size(mTrace);
        
        for k=1:nRow
            nEventType = mTrace(k,1);
            if nEventType == 1    % Sender
                fTimestamp = mTrace(k,2);
                nHostNodeId = mTrace(k,3);
                
                fprintf(fid_result,'$ns_ at %.9f "get_neighborlist %d %.9f"\n',fTimestamp, nHostNodeId, fTimestamp);
            end
        end
        
        fclose(fid_result);
        
    end
end    

disp('***********All scripts are generated!******************');

fprintf('Finish Time: %s\n', datestr(clock, 'yyyy-mm-dd HH:MM:SS'));

return;
