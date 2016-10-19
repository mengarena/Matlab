function f = SE_TestCall_Hybrid()
% Show Detection Rate for each category of ROI for Hybrid Scheme
%

matHybrid = evalin('base', 'Hybrid1');


f = SE_Test_ROI_Category_Hybrid(matHybrid);

return;
