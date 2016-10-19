function f=SE_TestCall_WARP()
% Show Detection Rate for each category of ROI based on the given threshold
%

thrsd = 46.1391;  % Threshold for WARP scheme

WARP_empty = evalin('base', 'WARP_empty');
WARP_emptyshadow = evalin('base', 'WARP_emptyshadow');
WARP_10p = evalin('base', 'WARP_10p');
WARP_20p = evalin('base', 'WARP_20p');
WARP_30p = evalin('base', 'WARP_30p');
WARP_40p = evalin('base', 'WARP_40p');
WARP_50p = evalin('base', 'WARP_50p');
WARP_60p = evalin('base', 'WARP_60p');
WARP_70p = evalin('base', 'WARP_70p');
WARP_80p = evalin('base', 'WARP_80p');
WARP_90p = evalin('base', 'WARP_90p');
WARP_100p = evalin('base', 'WARP_100p');
WARP_rest = evalin('base', 'WARP_rest');

SE_Test_ROI_Category_Intensity(WARP_empty, WARP_emptyshadow, WARP_10p, WARP_20p, WARP_30p, WARP_40p, WARP_50p, WARP_60p, WARP_70p, WARP_80p, WARP_90p, WARP_100p, WARP_rest, 'Rate of Detection on Each Category of ROI (Warping)', thrsd);

f=0;

return;
