function rot_M = ROTX(roll)
% The ROTX() function accepts scalar roll value (in radians) and 
% returns the corresponding 3*3 rotation matrix.
rot_M = [1, 0, 0;
        0, cos(roll), -sin(roll);
        0, sin(roll), cos(roll)];
