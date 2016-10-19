function f=SE_GetThreshold_WARP()
% Get threshold for Warp scheme

WARP_empty = evalin('base', 'WARP_empty');
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

%f = SE_GetThreshold(WARP_empty, WARP_10p, WARP_20p, WARP_30p, WARP_40p, WARP_50p, WARP_60p, WARP_70p, WARP_80p, WARP_90p, WARP_100p, WARP_rest);
f = SE_GetThreshold_F(WARP_empty, WARP_10p, WARP_20p, WARP_30p, WARP_40p, WARP_50p, WARP_60p, WARP_70p, WARP_80p, WARP_90p, WARP_100p, WARP_rest, 'Warping Threshold', 'Threshold of Intensity Variation (Warping)');

disp(['Threshold for Warp scheme = ', num2str(f)]);

return;
