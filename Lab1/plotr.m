function plotr(m)
% Function accepts a single 3x3 matrix and plots the columns of the matrix as vectors.
%
%  usage example:
%
%  h = [1 0 0; 1 0 0; 0 0 1];
%  plotr(h) 
%
% 18 Sept 97 RB+LLW
%

washoldon = ishold;


[rows, cols] = size(m);
if ((rows ~= 3) | (cols ~= 3))
  error('PLOTR requires a 3x3 matrix argument. Check your dimensions.');
end

d = det(m);
if ((d <0.999) | (d >1.001))
  fprintf(1,'Error in PLOTR: the argument is not a rotation. Determinent is %f, should be 1.0\n',d);
  error('aborting');
end

zer=[0;0;0];
plotv3(zer,m(:,1),'r');
hold on 
plotv3(zer,m(:,2),'y');
plotv3(zer,m(:,3),'c');
text(m(1,1),m(2,1),m(3,1),'x');
text(m(1,2),m(2,2),m(3,2),'y');
text(m(1,3),m(2,3),m(3,3),'z');

xlabel('X_0');
ylabel('Y_0');
zlabel('Z_0');
if ~washoldon
    hold off
end
axis equal
grid on
