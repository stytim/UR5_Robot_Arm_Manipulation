%  usage:  plotp3([1;0;0]) plots a * at the point x=1, y=0, z=0
%          plotp3 accepts a 3x1 array
%
%  Aug 15 1997  Louis Whitcomb Created and Written
%
%

% if user does not specify a colorspec, set it to black.
function plotp3(p0, colorspec )

[rows, cols] = size(p0);
if ((rows ~= 3) | (cols ~= 1))
  error('plotp3 requires a 3x1 vector argument. Check your dimensions.');
end

if 0 == exist('colorspec')
   colorspec = 'k*';
end;

plot3(p0(1), p0(2), p0(3), colorspec);