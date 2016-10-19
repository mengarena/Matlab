function f = SBM_GetSensorTimeGap(nSensorType)

% This function returns the gap between two consecutive data of a given
% sensor type
%
% These data are based on Nexus 5
%

format long;

fTimeGap = 0.0;

if nSensorType == 1 || nSensorType == 2 || nSensorType == 3 || nSensorType == 4 || nSensorType == 12   % Accl/LinerAccl/Gyro/Orientation/Gravity
    fTimeGap = 1.0/200;
elseif nSensorType == 5   % Magnet
    fTimeGap = 1.0/60;
elseif nSensorType == 7   % Barometer
    fTimeGap = 1.0/30;
elseif nSensorType == 9   % Cellular Network
    fTimeGap = 1.0/2;
elseif nSensorType == 10  % GPS
    fTimeGap = 1.0/1;
end
    
f = fTimeGap;

return;

