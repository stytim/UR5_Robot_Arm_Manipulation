% Author: Mengze Xu
% Date: 07-24-2017
% Class ur5_interface provides Matlab API to ur_modern_driver which 
% controls the ur5 robots through ROS


classdef ur5_interface < handle
    % Class used to interface with ROS topics to communicate with UR5
    % To create a robot interface
    
    
    % settings that are not supposed to change after constructor
    properties (SetAccess = immutable)
        speed_limit = 0.5; % percentage of maxium speed
        acc_limit = 0.1;   % m(rad)/s2
        home = [0 -pi 0 -pi 0 0]'/2;  % joint states in home position [rad]
        DH_base = [-pi 0 0 0 pi 0]/2; % init joint states in DH_base [rad]
        joint_names = {...
            'shoulder_pan_joint',...
            'shoulder_lift_joint',...
            'elbow_joint',...
            'wrist_1_joint',...
            'wrist_2_joint',...
            'wrist_3_joint'};
        collision_request = rosmessage('moveit_msgs/GetStateValidityRequest');

    end
    
    % values set by this class, can be read by others
    properties (SetAccess = protected)
        current_joint_states   % Last received current joint_states
        tftree                 % Last received tftree
    end
   
    % only this class methods can view/modify
    properties (SetAccess = private)
        % subscribers
        current_joint_states_sub
        marker_list_sub
        marker_pose_sub
     
        % publishers
        trajectory_goal_pub
        joint_speed_pub
        tool_pub
        % client
        collision_check_client
        gripper_control_client
        
        % request and msg
      
    end
    
    methods
        % constructor
        function self = ur5_interface()
            rosshutdown;
            rosinit;
            self.current_joint_states_sub = rossubscriber('/joint_states','sensor_msgs/JointState','BufferSize',125);
            self.marker_list_sub = rossubscriber('/aruco_marker_publisher/markers_list','std_msgs/UInt32MultiArray');
            self.marker_pose_sub = rossubscriber('/aruco_marker_publisher/PoseArray','geometry_msgs/PoseArray');
            self.trajectory_goal_pub = rospublisher('/trajectory_goal','trajectory_msgs/JointTrajectory');
            self.joint_speed_pub = rospublisher('/ur_driver/URScript','std_msgs/String');
            self.tool_pub = rospublisher('/ur_driver/URScript','std_msgs/String');
            self.tftree = rostf;
            %self.collision_check_client = rossvcclient('/check_state_validity');
            self.current_joint_states = receive(self.current_joint_states_sub);
                        
        end
        
        % update current_joint _states and return array of current joint angles
        function joint_angles = get_current_joints(self)
            self.current_joint_states = receive(self.current_joint_states_sub);
            joint_angles = zeros(6,1);
            for i=1:6
                for j=1:6
                    if strcmp(self.current_joint_states.Name{i},self.joint_names{j})
                        joint_angles(j) = self.current_joint_states.Position(i);
                    end
                end
            end
        end
        
        % get current transformation from target frame to source frame 
        function g = get_current_transformation(self,target,source)
            tran = getTransform(self.tftree,target,source);
            t = [tran.Transform.Translation.X, tran.Transform.Translation.Y, tran.Transform.Translation.Z];
            R = quat2rotm([tran.Transform.Rotation.W, tran.Transform.Rotation.X, tran.Transform.Rotation.Y, tran.Transform.Rotation.Z]);
            g = [R t';0 0 0 1];
        end
        
        % move in joint space
        % goal should be 6*1 vector
        function move_joints(self,joint_goal,time_interval)
            % check input
            if size(joint_goal,1)~=6
                error('Wrong size of joint_goal');
            end
            
            trajectory_goal = rosmessage('trajectory_msgs/JointTrajectory');
            % set joint names
            trajectory_goal.JointNames{1} = 'shoulder_pan_joint';
            trajectory_goal.JointNames{2} = 'shoulder_lift_joint';
            trajectory_goal.JointNames{3} = 'elbow_joint';
            trajectory_goal.JointNames{4} = 'wrist_1_joint';
            trajectory_goal.JointNames{5} = 'wrist_2_joint';
            trajectory_goal.JointNames{6} = 'wrist_3_joint';
            
            % set initial pose as current pose
            trajectory_point = rosmessage('trajectory_msgs/JointTrajectoryPoint');
            trajectory_point.Positions = self.get_current_joints();
            trajectory_point.Velocities = zeros(6,1);
            trajectory_point.TimeFromStart = rosduration(0);
            trajectory_goal.Points(1) = trajectory_point;
            
            % check speed limit
            joint_v = zeros(size(joint_goal));
            joint_v(:,1) = joint_goal(:,1)-self.get_current_joints();
            if size(joint_goal,2)>=2
                for i=2:size(joint_goal,2)
                    joint_v(:,i) = joint_goal(:,i)-joint_goal(:,i-1);
                end
            end
            if max(max(abs(joint_v)))/time_interval > pi*self.speed_limit
                error('Velocity over speed limit, please increase time_interval');
            end
            
            % set trajectory
            for i=1:size(joint_goal,2)
                trajectory_point = rosmessage('trajectory_msgs/JointTrajectoryPoint');
                trajectory_point.Velocities = zeros(6,1);
                
                trajectory_point.Positions = joint_goal(:,i);
                trajectory_point.TimeFromStart = rosduration(time_interval*i);
                trajectory_goal.Points(i+1) = trajectory_point;
            end
            
            % publish the trajectory
            send(self.trajectory_goal_pub,trajectory_goal);
        end
        
        function str = set_joint_speed(self,joint_speed,time_out)
            if size(joint_speed,1)~=6
                error('Wrong size of joint speed');
            end
            
            msg = rosmessage('std_msgs/String');
            str = 'speedj(['+num2str(joint_speed(1),4);
            for i=2:6
                str = str+','+num2str(joint_speed(i),4);
            end
            str = str+'],'+num2str(self.acc_limit,4)+','+num2str(time_out)+')';
            msg.Data = char(str);
            send(self.joint_speed_pub,msg);
        end
        
        % read marker pose, return ID list, marker pose and mesasge time
        function [list,G,t] = read_markers(self)
            list = receive(self.marker_list_sub);
            list = list.Data;
            poseArray = receive(self.marker_pose_sub);
            G = zeros(4,4,length(list));
            for i=1:length(list)
                G(:,:,i) = pose2g(poseArray.Poses(i));
            end
            t = poseArray.Header.Stamp.Sec+poseArray.Header.Stamp.Nsec*1e-9;
        end
        
        function validity = check_collision(self,joints)
            % validity = 1: valid state, no collision
            % validity = 0: invalid state, collision happens
            
            % setup robotstates as joints
            self.collision_request.RobotState.JointState = self.current_joint_states;
            
            % remind that joint names are in different order between Matlab
            % and ROS
            self.collision_request.RobotState.JointState.Position(4:6) = joints(4:6);
            self.collision_request.RobotState.JointState.Position(3) = joints(1);
            self.collision_request.RobotState.JointState.Position(2) = joints(2);
            self.collision_request.RobotState.JointState.Position(1) = joints(3);
            q = call(self.collision_check_client,self.collision_request);
            validity = q.Valid;
        end
        
        function init_gripper(self)
          msg = rosmessage('std_msgs/String');
          str = 'set_tool_voltage(24)';
          msg.Data = char(str);
          send(self.tool_pub,msg);
        end
        
        function open_gripper(self)
          msg = rosmessage('std_msgs/String');
          str = 'set_digital_out(8,False)';
          msg.Data = char(str);
          send(self.tool_pub,msg);
          pause(0.5);
          str = 'set_digital_out(9,True)';
          msg.Data = char(str);
          send(self.tool_pub,msg);
            
        end
        
        function close_gripper(self)
          msg = rosmessage('std_msgs/String');
          str = 'set_digital_out(8,True)';
          msg.Data = char(str);
          send(self.tool_pub,msg);
          pause(0.5);
          str = 'set_digital_out(9,False)';
          msg.Data = char(str);
          send(self.tool_pub,msg);
            
        end
    end % methods
    
end % class

% function that transform sensor_msgs/Pose to 4*4 matrix g
function g = pose2g(pose)
t = [pose.Position.X pose.Position.Y pose.Position.Z]';
g = [quat2rotm([pose.Orientation.W pose.Orientation.X pose.Orientation.Y pose.Orientation.Z]) t;0 0 0 1;];
end
