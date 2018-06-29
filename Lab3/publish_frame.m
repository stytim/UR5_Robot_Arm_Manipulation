% Author: Mengze Xu
% Date: 07-24-2017
% This function moves "your_frame" to pose g represented as 4*4 matrix relative to "base_link" 


function publish_frame(g)
q = rotm2quat(g(1:3,1:3));
t = g(1:3,4);
pose = rosmessage('geometry_msgs/Pose');

pose.Position.X = t(1);
pose.Position.Y = t(2);
pose.Position.Z = t(3);

pose.Orientation.W = q(1);
pose.Orientation.X = q(2);
pose.Orientation.Y = q(3);
pose.Orientation.Z = q(4);

rospublisher('your_frame',pose);
