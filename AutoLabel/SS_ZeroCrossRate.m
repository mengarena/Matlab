function f = SS_ZeroCrossRate(x)
% This function calculate the zero crossing rate
% Works for vector and matrix 
%   if x is a Vector returns the zero crossing rate of the vector
%   Ex:  x = [1 2 -3 4 5 -6 -2 -6 2]; 
%        y = ZCR(x) -> y = 0.444 
%   if x is a matrix returns a row vector with the zero crossing rate of
%   the columns values

f = sum(abs(diff(x>0)))/length(x);

end