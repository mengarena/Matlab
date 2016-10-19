function f=SE_TestCall_CHAM()
% Show Detection Rate for each category of ROI based on the given threshold
%

thrsd = 0.19845;  % Threshold for CHAM scheme

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

SE_Test_ROI_Category_Cham(CHAM_empty, CHAM_emptyshadow, CHAM_10p, CHAM_20p, CHAM_30p, CHAM_40p, CHAM_50p, CHAM_60p, CHAM_70p, CHAM_80p, CHAM_90p, CHAM_100p, CHAM_rest, 'Rate of Detection on Each Category of ROI (Chamfer Matching)', thrsd);

f=0;

return;
