function rot_M = EULERXYZ(v)
% The EULERXYZ() function accepts one input - a 3-vector of angles 
% (in radians), and returns the corresponding 3*3 rotation matrix.
% The order of rotation is x-y-z, which means that the function first 
% rotates roll angles with respect to x axis, the followed pitch angles 
% by y axis and finally yaw angles with respect to z axis.
roll = v(1);
pitch = v(2);
yaw = v(3);
fprintf('input roll is %g \n',roundn(roll,-4));
fprintf('input pitch is %g \n',roundn(pitch,-4));
fprintf('input yaw is %g \n',roundn(yaw,-4));
rot_M = [ cos(pitch)*cos(yaw), cos(yaw)*sin(pitch)*sin(roll) - cos(roll)*sin(yaw), sin(roll)*sin(yaw) + cos(roll)*cos(yaw)*sin(pitch);
          cos(pitch)*sin(yaw), cos(roll)*cos(yaw) + sin(pitch)*sin(roll)*sin(yaw), cos(roll)*sin(pitch)*sin(yaw) - cos(yaw)*sin(roll);
         -sin(pitch),                               cos(pitch)*sin(roll),                               cos(pitch)*cos(roll)];