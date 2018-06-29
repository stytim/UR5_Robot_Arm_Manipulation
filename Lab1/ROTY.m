function rot_M = ROTY(pitch)
% The ROTY() function accepts scalar pitch value (in radians) and 
% returns the corresponding 3*3 rotation matrix.
rot_M = [cos(pitch), 0,sin(pitch);
        0, 1, 0;
        -sin(pitch), 0, cos(pitch)];