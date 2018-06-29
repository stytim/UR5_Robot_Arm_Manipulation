% usage: 	plotv4(X0_vec, X1_vec);
% input: 	X0_vec 4x1 vector e.g.: X0_vec = [1;0;0;1]
%        	X1_vec 4x1 vector e.g.: X1_vec = [1;1;0;1]
%
%		optional additional argument: 
%               plotv4(X0_vec, X1_vec, 'r');
%
% output:	plots a vector starting at X0_vec to X1_vec
% in the example it will be a RED vector parallel to the y-axis
% starting 	at x=1,y=0,z=0 
% ending 	at x=1,y=1,z=0
% 
%  1997  Louis Whitcomb Created and Written

function plotv4(X0_vec, X1_vec, linespec)

% check argument dimension
[rows, cols] = size(X0_vec);
if ((rows ~= 4) | (cols ~= 1))
  error('PLOTV4 requires a 4x1 vector argument. Check your dimensions.');
end

% check argument dimension
[rows, cols] = size(X1_vec);
if ((rows ~= 4) | (cols ~= 1))
  error('PLOTV4 requires a 4x1 vector argument. Check your dimensions.');
end

% assemble a matrix with the two position vectors
m = [X0_vec(1:3,1)'; X1_vec(1:3,1)'];

% check if the given value for the linestyle exists
if 0 == exist('linespec')
   linespec = 'k';
end;

plot3(m(:,1), m(:,2), m(:,3), linespec);



