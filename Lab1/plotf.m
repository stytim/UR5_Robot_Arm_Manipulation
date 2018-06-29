function plotf(m)
% Function accepts a single 4x4 matrix and plots the frame
%
%  usage example:
%
%  h = [1 0 0 1; 1 0 0 0; 0 0 1 0; 0 0 0 1]
%  plotf(h) 
%
%
%
% 18 Sept 97 RB+LLW
% Copyright Louis L. Whitcomb, 2013
%

[rows, cols] = size(m);
if ((rows ~= 4) | (cols ~= 4))
  error('PLOTF requires a 4x4 matrix argument. Check your dimensions.');
end

d = det(m);
if ((d <0.999) | (d >1.001))
  fprintf(1,'Error in PLOTF: the argument is not a rotation. Determinent is %f, should be 1.0\n',d);
  error('aborting');
end

zer=m(1:3,4);
plotv3(zer,zer+m(1:3,1),'r');
hold on 
plotv3(zer,zer+m(1:3,2),'y');
plotv3(zer,zer+m(1:3,3),'c');
text(m(1,4)+m(1,1),m(2,4)+m(2,1),m(3,4)+m(3,1),'x');
text(m(1,4)+m(1,2),m(2,4)+m(2,2),m(3,4)+m(3,2),'y');
text(m(1,4)+m(1,3),m(2,4)+m(2,3),m(3,4)+m(3,3),'z');

xlabel('X_0');
ylabel('Y_0');
zlabel('Z_0');

hold off;
axis equal;
grid on;
