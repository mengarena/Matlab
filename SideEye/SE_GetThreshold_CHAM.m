function f=SE_GetThreshold_CHAM()
% Get threshold for Chamfer scheme

CHAM_empty = evalin('base', 'CHAM_empty');
CHAM_emptyshadow = evalin('base', 'CHAM_emptyshadow');
CHAM_10p = evalin('base', 'CHAM_10p');
CHAM_20p = evalin('base', 'CHAM_20p');
CHAM_30p = evalin('base', 'CHAM_30p');
CHAM_40p = evalin('base', 'CHAM_40p');
CHAM_50p = evalin('base', 'CHAM_50p');
CHAM_60p = evalin('base', 'CHAM_60p');
CHAM_70p = evalin('base', 'CHAM_70p');
CHAM_80p = evalin('base', 'CHAM_80p');
CHAM_90p = evalin('base', 'CHAM_90p');
CHAM_100p = evalin('base', 'CHAM_100p');
CHAM_rest = evalin('base', 'CHAM_rest');

%f = SE_GetThreshold_forCham(CHAM_empty, CHAM_emptyshadow, CHAM_10p, CHAM_20p, CHAM_30p, CHAM_40p, CHAM_50p, CHAM_60p, CHAM_70p, CHAM_80p, CHAM_90p, CHAM_100p, CHAM_rest);
f = SE_GetThreshold_forCham_F(CHAM_empty, CHAM_emptyshadow, CHAM_10p, CHAM_20p, CHAM_30p, CHAM_40p, CHAM_50p, CHAM_60p, CHAM_70p, CHAM_80p, CHAM_90p, CHAM_100p, CHAM_rest, 'Chamfer Matching Threshold', 'Threshold of Chamfer Matching Cost');

disp(['Threshold for Chamfer scheme = ', num2str(f)]);

return;
