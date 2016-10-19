function f=SE_GetThreshold_SI()
% Get threshold for Simple Intensity scheme

SI_empty = evalin('base', 'SI_empty');
SI_10p = evalin('base', 'SI_10p');
SI_20p = evalin('base', 'SI_20p');
SI_30p = evalin('base', 'SI_30p');
SI_40p = evalin('base', 'SI_40p');
SI_50p = evalin('base', 'SI_50p');
SI_60p = evalin('base', 'SI_60p');
SI_70p = evalin('base', 'SI_70p');
SI_80p = evalin('base', 'SI_80p');
SI_90p = evalin('base', 'SI_90p');
SI_100p = evalin('base', 'SI_100p');
SI_rest = evalin('base', 'SI_rest');

%f = SE_GetThreshold(SI_empty, SI_10p, SI_20p, SI_30p, SI_40p, SI_50p, SI_60p, SI_70p, SI_80p, SI_90p, SI_100p, SI_rest);
f = SE_GetThreshold_F(SI_empty, SI_10p, SI_20p, SI_30p, SI_40p, SI_50p, SI_60p, SI_70p, SI_80p, SI_90p, SI_100p, SI_rest, 'Simple Intensity Variation Threshold', 'Threshold of Intensity Variation');

disp(['Threshold for Simple Intensity scheme = ', num2str(f)]);

return;
