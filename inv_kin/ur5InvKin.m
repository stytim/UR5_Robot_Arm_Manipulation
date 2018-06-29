function [ theta ] = ur5InvKin( gd )
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% UR5INV - Long Qian   %%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Inverse kinematics of UR5
%   Formulas adapted from Ryan Keating's "UR5 Inverse Kinematics" paper
%   Input args:
%           gd - the 4x4 matrix - desired transformation from base to end
%   Output args:
%           theta - 6x8 matrix, each colum represents one possible solution 
%           of joint angles

    % Check input size
    if ~isequal(size(gd), [4,4])
        msg ='ur5invKin function: Wrong input format, must be a 4x4 matrix';
        error(msg);
    end

    theta = zeros(6, 8);
    % DH parameters
    d1 = 0.0892;
    d2 = 0;
    d3 = 0;
    d4 = 0.1093;
    d5 = 0.09475;
    d6 = 0.0825;
    a1 = 0;
    a2 = -0.425;
    a3 = -0.392;
    a4 = 0;
    a5 = 0;
    a6 = 0;
    alpha1 = pi/2;
    alpha2 = 0;
    alpha3 = 0;
    alpha4 = pi/2;
    alpha5 = -pi/2;
    alpha6 = 0;
    
    % Calculating theta1
    p05 = gd * [0, 0, -d6, 1]'  - [0, 0, 0, 1]';
    psi = atan2(p05(2), p05(1));
    phi = acos(d4 / sqrt(p05(2)*p05(2) + p05(1)*p05(1)));
    theta(1, 1:4) = pi/2 + psi + phi;
    theta(1, 5:8) = pi/2 + psi - phi;
    theta = real(theta);
    
    
    % Calculating theta5
    cols = [1, 5];
    for i=1:length(cols)
        c = cols(i);
        T10 = inv(DH(a1, alpha1, d1, theta(1,c)));
        T16 = T10 * gd;
        p16z = T16(3,4);
        t5 = acos((p16z-d4)/d6);
        theta(5, c:c+1) = t5;
        theta(5, c+2:c+3) = -t5;
    end
    theta = real(theta);
    
    % Calculating theta6
    cols = [1, 3, 5, 7];
    for i=1:length(cols)
        c = cols(i);
        T01 = DH(a1, alpha1, d1, theta(1,c));
        T61 = inv(gd) * T01;
        T61zy = T61(2, 3);
        T61zx = T61(1, 3);
        t5 = theta(5, c);
        theta(6, c:c+1) = atan2(-T61zy/sin(t5), T61zx/sin(t5));
    end
    theta = real(theta);
    
    % Calculating theta3
    cols = [1, 3, 5, 7];
    for i=1:length(cols)
        c = cols(i);
        T10 = inv(DH(a1, alpha1, d1, theta(1,c)));
        T65 = inv(DH(a6, alpha6, d6, theta(6,c)));
        T54 = inv(DH(a5, alpha5, d5, theta(5,c)));
        T14 = T10 * gd * T65 * T54;
        p13 = T14 * [0, -d4, 0, 1]' - [0,0,0,1]';
        p13norm2 = norm(p13) ^ 2;
        t3p = acos((p13norm2-a2*a2-a3*a3)/(2*a2*a3));
        theta(3, c) = t3p;
        theta(3, c+1) = -t3p;
    end
    theta = real(theta);
    
    % Calculating theta2 and theta4
    cols = [1, 2, 3, 4, 5, 6, 7, 8];
    for i=1:length(cols)
        c = cols(i);
        T10 = inv(DH(a1, alpha1, d1, theta(1,c)));
        T65 = inv(DH(a6, alpha6, d6, theta(6,c)));
        T54 = inv(DH(a5, alpha5, d5, theta(5,c)));
        T14 = T10 * gd * T65 * T54;
        p13 = T14 * [0, -d4, 0, 1]' - [0,0,0,1]';
        p13norm = norm(p13);
        theta(2, c) = -atan2(p13(2), -p13(1))+asin(a3*sin(theta(3,c))/p13norm);
        T32 = inv(DH(a3, alpha3, d3, theta(3,c)));
        T21 = inv(DH(a2, alpha2, d2, theta(2,c)));
        T34 = T32 * T21 * T14;
        theta(4, c) = atan2(T34(2,1), T34(1,1));
    end
    theta = real(theta);
    
    for j=1:8
        theta(1,j) = theta(1,j)-pi;
    end
    
    % Bound the joint angles from -pi to pi
    for i=1:6
        for j=1:8
            if theta(i,j) <= -pi
                theta(i,j) = theta(i,j) + 2*pi;
            elseif theta(i,j) > pi
                theta(i,j) = theta(i,j) - 2*pi;
            end
        end
    end
                
                    
end

