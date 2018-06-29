function HINV = FINV(H)
% The function FINV() accepts a 4x4 homogeneous transformation and 
% returns its MATRIX inverse.
[rows, cols] = size(H);
if ((rows ~= 4) | (cols ~= 4))
  error('EULERXYZINV requires a 4x4 matrix. Please check your dimensions.');
end

R = H(1:3,1:3);
t = H(1:3,4);
HINV=[R', -R'*t; 0 0 0 1];