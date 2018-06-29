% Author: Mengze Xu
% Date: 09-30-2017 
% Class to create and maintain a frame in tf 
% communicate with ros through topic matlab_frame

classdef tf_frame < handle
    
    properties (SetAccess = protected)
        frame_name  % frame name
        base_frame_name % reference frame name
        pose % g 4*4 matrix
        tftree % same as ur5_interface, it's better to use one tftree to lookup, but just for the course, take it easy.
    end
    
    methods
        
        % constructor
        function self = tf_frame(base_frame_name, frame_name, g)
            self.frame_name = frame_name;
            self.base_frame_name = base_frame_name;
            self.pose = g;
            self.tftree = rostf;
            self.move_frame(base_frame_name,g);
        end
        
        % move the frame by g relative to ref_frame
        function move_frame(self,ref_frame_name,g)
            msg = rosmessage('geometry_msgs/TransformStamped');
            msg.ChildFrameId = self.frame_name;
            msg.Header.FrameId = ref_frame_name;
            
            % geometry transformation
            q = rotm2quat(g(1:3,1:3));
            t = g(1:3,4);
            msg.Transform.Translation.X = t(1);
            msg.Transform.Translation.Y = t(2);
            msg.Transform.Translation.Z = t(3);
            msg.Transform.Rotation.W = q(1);
            msg.Transform.Rotation.X = q(2);
            msg.Transform.Rotation.Y = q(3);
            msg.Transform.Rotation.Z = q(4);
            
            rospublisher('matlab_frame', msg);
            %sendTransform(self.tftree, msg)
        end
        
        function g = read_frame(self,ref_frame_name)
            tran = getTransform(self.tftree, ref_frame_name, self.frame_name);
            t = [tran.Transform.Translation.X, tran.Transform.Translation.Y, tran.Transform.Translation.Z];
            R = quat2rotm([tran.Transform.Rotation.W, tran.Transform.Rotation.X, tran.Transform.Rotation.Y, tran.Transform.Rotation.Z]);
            g = [R t';0 0 0 1];
        end
            
        % delete the frame in RVIZ, can be recoverd by move_frame
        function disappear(self)
            msg = rosmessage('geometry_msgs/TransformStamped');
            msg.Header.FrameId = 'Delete';
            msg.ChildFrameId = self.frame_name;
            rospublisher('matlab_frame', msg);
        end
    end
    
end