function H = XF(v)
% The functions XF() accepts a single 6x1 vector containing
% [x; y; z; theta1; theta2; theta3] (angles in radians) and returns the corre-
% sponding 4x4 homogeneous transformation.
[rows, cols] = size(v);
if ((rows ~= 6) | (cols ~= 1))
  error('EULERXYZINV requires a 6x1 argument. Please check your dimensions.');
end
fprintf('input translation is [%g, %g, %g]  \n',roundn(v(1),-4),roundn(v(2),-4),roundn(v(3),-4));
fprintf('input roll is %g \n',roundn(v(4),-4));
fprintf('input pitch is %g \n',roundn(v(5),-4));
fprintf('input yaw is %g \n',roundn(v(6),-4));
t = v(1:3);
R = [ cos(v(5))*cos(v(6)), cos(v(6))*sin(v(4))*sin(v(5)) - cos(v(4))*sin(v(6)), sin(v(4))*sin(v(6)) + cos(v(4))*cos(v(6))*sin(v(5));
               cos(v(5))*sin(v(6)), cos(v(4))*cos(v(6)) + sin(v(4))*sin(v(5))*sin(v(6)), cos(v(4))*sin(v(5))*sin(v(6)) - cos(v(6))*sin(v(4));
                 -sin(v(5)),                           cos(v(5))*sin(v(4)),                           cos(v(4))*cos(v(5))];
H = [R,t;0 0 0 1];

