function f=Sky_AverageNodeNumber(mNodeList)
% This function calculate the average number of nodes in each row of the
% input matrix
%
% mNodeList: A matrix which contains the node list
%            Each row contains (left->right): host node ID, timestamp,
%            neighbor/receiver node IDs (-1 is not a valid ID)
%
% Output:
%       A number stands for the average node number
%

[nRow nCol] = size(mNodeList);

nTotalNum = 0;

for i=1:nRow
    for j=3:nCol
        if mNodeList(i,j) ~= -1
            nTotalNum = nTotalNum + 1;
        else
            break;
        end
    end
end

avgNum = nTotalNum*1.0/nRow;

f = avgNum;

return;
