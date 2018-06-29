%  usage:  plotp4([1;0;0;1]) plots a * at the point x=1, y=0, z=0
%          plotp4 accepts a 4x1 array
%
%  Aug 15 1997  Louis Whitcomb Created and Written
%  Sept 18 modified  Ralf Bachmayer
%
%

% if user does not specify a colorspec, set it to black.
%
function plotp4(p0, colorspec )
%

[rows, cols] = size(p0);
if ((rows ~= 4) | (cols ~= 1))
  error('plotp4 requires a 4x1 vector argument. Check your dimensions.');
end

if 0 == exist('colorspec')
   colorspec = 'k*';
end;

plot3(p0(1), p0(2), p0(3), colorspec);