function v = EULERXYZINV(rot_M)
% The EULERXYZINV() accepts a 3x3 rotation matrix and returns a 3x1 vector 
% Singularity occurs when the pitch is equal to pi/2 or -pi/2. 
% When the pitch is equal to pi/2 or -pi/2, the roll and yaw align with
% each other and therefore, there're multiple solutions, which means we can
% either get the sum of (roll + yaw) or (yaw - roll), depending on the sign
% of pitch angle.

% Check if the input is a 3x3 matrix
[rows, cols] = size(rot_M);
if ((rows ~= 3) | (cols ~= 3))
  error('EULERXYZINV requires a 3x3 argument. Please check your dimensions.');
end
% Check if the input is a rotation matrix
r1 = rot_M(:,1);
r2 = rot_M(:,2);
r3 = rot_M(:,3);
c_12 = (r1')*r2;
c_13 = (r1')*r3;
c_23 = (r2')*r3;
if ((c_12 - 0)>0.01 | (c_13 - 0)>0.01 | (c_23 - 0)>0.01| ((r1')*r1 - 1)>0.01 | ((r2')*r2 - 1)>0.01| ((r3')*r3 - 1)>0.01)
  error('The input is not a rotation matrix. Please check your input.');
end
% Check if the input reaches singularity
% if (rot_M(3,1) == 1)
%   warning('EULERXYZINV reaches singularity and there are multiple solutions');
%   fprintf('cos(yaw + roll) is equal to %g\n', rot_M(2,2));
%   fprintf('sin(yaw + roll) is equal to %g\n', -rot_M(2,3));
%   roll = 'NaN';
%   pitch = -pi/2;
%   yaw = 'NaN'; 
% elseif rot_M(3,1) == -1
%   warning('EULERXYZINV reaches singularity and there are multiple solutions');  
%   fprintf('cos(yaw - roll) is equal to %g\n', rot_M(2,2));
%   fprintf('sin(yaw - roll) is equal to %g\n', rot_M(2,3));
%   roll = 'NaN';
%   pitch = pi/2;
%   yaw = 'NaN'; 
% else    
  roll = atan2(rot_M(3,2),rot_M(3,3));
  pitch = atan2(-rot_M(3,1),sqrt(rot_M(1,1)^2+rot_M(2,1)^2));
  yaw = atan2(rot_M(2,1),rot_M(1,1));  
  v = [roll; pitch; yaw];
  fprintf('roll is %g \n', roundn(roll,-4));
  fprintf('pitch is %g \n', roundn(pitch,-4));
  fprintf('yaw is %g \n', roundn(yaw,-4));
% end



