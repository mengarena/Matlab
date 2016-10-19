function f = SE_TestCall_SI()
% Show Detection Rate for each category of ROI based on the given threshold
%

thrsd = 35.1845;  % Threshold for Simple Intensity scheme

SI_empty = evalin('base', 'SI_empty');
SI_emptyshadow = evalin('base', 'SI_emptyshadow');
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

f = SE_Test_ROI_Category_Intensity(SI_empty, SI_emptyshadow, SI_10p, SI_20p, SI_30p, SI_40p, SI_50p, SI_60p, SI_70p, SI_80p, SI_90p, SI_100p, SI_rest, 'Rate of Detection on Each Category of ROI (Simple Intensity)', thrsd);

return;
