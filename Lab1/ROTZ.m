function rot_M = ROTZ(yaw)
% The ROTZ() function accepts scalar yaw value (in radians) and 
% returns the corresponding 3*3 rotation matrix.
rot_M = [cos(yaw), -sin(yaw), 0;
         sin(yaw), cos(yaw), 0;
        0, 0, 1];