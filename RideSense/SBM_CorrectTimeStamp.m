function f = SBM_CorrectTimeStamp(sUniquedTraceFile, sResultPostFix, nWithLabel)
%
% In the trace, for the cellular ID information, the writing might not be
% in order, so it might occur that the timestamp of next line is smaller
% than the timestamp of the previous line
%
% This function is used to correct the timestamp
%
% withLabel line:
% Each line:
% time, Label, datatype, sensor_x, sensor_y, sensor_z, GPS lat, GPS long, GPS alt,
% GPS speed, GPS bearing


format long;

[pathstr, filename, ext] = fileparts(sUniquedTraceFile);
sResultFile = [pathstr '\' filename '_' sResultPostFix '.csv'];
fidWrite = fopen(sResultFile, 'w');

mUniqueTrace = load(sUniquedTraceFile);
[nRow nCol] = size(mUniqueTrace);

if nWithLabel == 1
    fprintf(fidWrite, '%4.5f,%d,%d,%5.12f,%5.12f,%5.12f,%5.8f,%5.8f,%5.4f,%3.4f,%3.4f\n', mUniqueTrace(1,1), mUniqueTrace(1,2), mUniqueTrace(1,3), mUniqueTrace(1,4), mUniqueTrace(1,5), ...
                                                                                            mUniqueTrace(1,6), mUniqueTrace(1,7), mUniqueTrace(1,8), mUniqueTrace(1,9), mUniqueTrace(1,10), ...
                                                                                            mUniqueTrace(1,11));
else
    fprintf(fidWrite, '%4.5f,%d,%5.12f,%5.12f,%5.12f,%5.8f,%5.8f,%5.4f,%3.4f,%3.4f\n', mUniqueTrace(1,1), mUniqueTrace(1,2), mUniqueTrace(1,3), mUniqueTrace(1,4), mUniqueTrace(1,5), ...
                                                                                         mUniqueTrace(1,6), mUniqueTrace(1,7), mUniqueTrace(1,8), mUniqueTrace(1,9), mUniqueTrace(1,10));    
end

mType = [];  % Sensor types with the same timestamp
% Correct the timestamp
for i = 2:nRow
    if mUniqueTrace(i,1) < mUniqueTrace(i-1,1)
        if nWithLabel == 1 && mUniqueTrace(i,3) == mUniqueTrace(i-1,3) 
            mUniqueTrace(i,1) = mUniqueTrace(i-1,1) + 0.0005;
            mType = [];
        elseif nWithLabel == 1 && mUniqueTrace(i,3) ~= mUniqueTrace(i-1,3)
            if length(mType) == 0
                mUniqueTrace(i,1) = mUniqueTrace(i-1,1);
                mType(1) = mUniqueTrace(i-1,3);
                mType(2) = mUniqueTrace(i,3);
            else
                if (length(find(mType == mUniqueTrace(i,3)))) > 0
                    mUniqueTrace(i,1) = mUniqueTrace(i-1,1)+0.00025;
                else
                    mUniqueTrace(i,1) = mUniqueTrace(i-1,1);
                    mType(end+1) = mUniqueTrace(i,3);
                end
            end
            
        elseif nWithLabel ~= 1 && mUniqueTrace(i,2) == mUniqueTrace(i-1,2)
            mUniqueTrace(i,1) = mUniqueTrace(i-1,1) + 0.0005;
            mType = [];
        elseif nWithLabel ~= 1 && mUniqueTrace(i,2) ~= mUniqueTrace(i-1,2)
            if length(mType) == 0
                mUniqueTrace(i,1) = mUniqueTrace(i-1,1);
                mType(1) = mUniqueTrace(i-1,2);
                mType(2) = mUniqueTrace(i,2);
            else
                if (length(find(mType == mUniqueTrace(i,2)))) > 0
                    mUniqueTrace(i,1) = mUniqueTrace(i-1,1)+0.00025;
                else
                    mUniqueTrace(i,1) = mUniqueTrace(i-1,1);
                    mType(end+1) = mUniqueTrace(i,2);
                end
            end            
        end
    elseif mUniqueTrace(i,1) == mUniqueTrace(i-1,1)
        if nWithLabel == 1 && mUniqueTrace(i,3) == mUniqueTrace(i-1,3) 
            mUniqueTrace(i,1) = mUniqueTrace(i-1,1) + 0.0005;
            mType = [];
            
        elseif nWithLabel == 1 && mUniqueTrace(i,3) ~= mUniqueTrace(i-1,3)
            if length(mType) == 0
                mType(1) = mUniqueTrace(i-1,3);
                mType(2) = mUniqueTrace(i,3);
            else
                if (length(find(mType == mUniqueTrace(i,3)))) > 0
                    mUniqueTrace(i,1) = mUniqueTrace(i-1,1)+0.00025;
                else
                    mType(end+1) = mUniqueTrace(i,3);
                end
            end
            
        elseif nWithLabel ~= 1 && mUniqueTrace(i,2) == mUniqueTrace(i-1,2)
            mUniqueTrace(i,1) = mUniqueTrace(i-1,1) + 0.0005;
            mType = [];
            
        elseif nWithLabel ~= 1 && mUniqueTrace(i,2) ~= mUniqueTrace(i-1,2)
            if length(mType) == 0
                mType(1) = mUniqueTrace(i-1,2);
                mType(2) = mUniqueTrace(i,2);
            else
                if (length(find(mType == mUniqueTrace(i,2)))) > 0
                    mUniqueTrace(i,1) = mUniqueTrace(i-1,1)+0.00025;
                else
                    mType(end+1) = mUniqueTrace(i,2);
                end
            end            
            
        end
    else  % mUniqueTrace(i,1) > mUniqueTrace(i-1,1)
        mType = [];
    end

    if nWithLabel == 1
        fprintf(fidWrite, '%4.5f,%d,%d,%5.12f,%5.12f,%5.12f,%5.8f,%5.8f,%5.4f,%3.4f,%3.4f\n', mUniqueTrace(i,1), mUniqueTrace(i,2), mUniqueTrace(i,3), mUniqueTrace(i,4), mUniqueTrace(i,5), ...
                                                                                                mUniqueTrace(i,6), mUniqueTrace(i,7), mUniqueTrace(i,8), mUniqueTrace(i,9), mUniqueTrace(i,10), ...
                                                                                                mUniqueTrace(i,11));
    else
        fprintf(fidWrite, '%4.5f,%d,%5.12f,%5.12f,%5.12f,%5.8f,%5.8f,%5.4f,%3.4f,%3.4f\n', mUniqueTrace(i,1), mUniqueTrace(i,2), mUniqueTrace(i,3), mUniqueTrace(i,4), mUniqueTrace(i,5), ...
                                                                                             mUniqueTrace(i,6), mUniqueTrace(i,7), mUniqueTrace(i,8), mUniqueTrace(i,9), mUniqueTrace(i,10));    
    end
    
end

fclose(fidWrite);

return;
