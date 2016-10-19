function f=SS_ZeroCrossCount(x)
% This function counts the number of zero crossing
% Works for vector and matrix 
%   if x is a Vector returns the zero crossing number of the vector
%   Ex:  x = [1 2 -3 4 5 -6 -2 -6 2]; 
%        y = ZCR(x) -> y = 0.444 
%   if x is a matrix returns a row vector with the zero crossing number of
%   the columns values

f = sum(abs(diff(x>0)));

return;


