clc
clear
%% Initialize the robot.
ur5=ur5_interface();
ur5.init_gripper();
prompt = 'Please choose from\n [A]IK-based contol \n [B]DK-based control \n [C]Gradient-based control \n [D]Creative Drawing \n';
str = input(prompt,'s');
%% Frames convertion
gt6 = [0 0 1 0; -1 0 0 0; 0 -1 0 0; 0 0 0 1];
g0b = [1 0 0 0; 0 1 0 0; 0 0 1 0; 0 0 0 1];


%% Get start and end pose
rest_pose = [
   -1.4572
   -1.6567
   -1.2494
   -2.1263
    0.9051
    0.0088];
g_rest = ur5FwdKin(rest_pose);
w = waitforbuttonpress;
if w ~= 2
    q0 = ur5.get_current_joints();
    g_start = ur5FwdKin(q0);
%     g_start = [0 -1 0 0.47;
%                0  0 1 0.55;
%                -1 0 0 0.12;
%                0 0 0 1];
    g_start_ = g0b*g_start*gt6;
    s = ur5InvKin(g_start_);
    start_pose = s(:,6);
    
    g_start_up = g_start;
    g_start_up(3,4) = g_start_up(3,4)+0.2;
    g_start_up_ = g0b*g_start_up*gt6;
    s = ur5InvKin(g_start_up_);
    start_pose_up = s(:,6);
    disp('start position recorded');
end
w = waitforbuttonpress;
if w ~=2
        q1 = ur5.get_current_joints();
    g_end = ur5FwdKin(q1);
%     g_end =   [0 -1 0 -0.30;
%                0  0 1 0.39;
%                -1 0 0 0.12;
%                0 0 0 1];
    g_end_ = g0b*g_end*gt6;
    s = ur5InvKin(g_end_);
    end_pose = s(:,6);
    
    g_end_up = g_end;
    g_end_up(3,4) = g_end_up(3,4)+0.2;
    g_end_up_ = g0b*g_end_up*gt6;
    s = ur5InvKin(g_end_up_);
    end_pose_up = s(:,6);
    disp('end position recorded');
end
w = waitforbuttonpress;
ur5.move_joints(rest_pose,5);
pause(5);
switch str
    case 'A'
        ur5.move_joints(start_pose_up,3);
        pause(3)
        ur5.open_gripper();
        pause(1);
        ur5.move_joints(start_pose,3);
        pause(3)
        ur5.close_gripper();
        pause(1);
        ur5.move_joints(start_pose_up,3);
        pause(3)
        ur5.move_joints(end_pose_up,3);
        pause(3)
        ur5.move_joints(end_pose,3);
        pause(3);
        ur5.open_gripper();
    case 'B'
        ur5RRcontrol(ur5,g_start_up,1);
        ur5.open_gripper();
        pause(1);
        ur5RRcontrol(ur5,g_start,1);
        pause(1);
        ur5.close_gripper();
        pause(1);
        ur5RRcontrol(ur5,g_start_up,1);
        ur5RRcontrol(ur5,g_end_up,1);
        ur5RRcontrol(ur5,g_end,1);
        pause(1);
        ur5.open_gripper();
        pause(1);
        ur5RRcontrol(ur5,g_end_up,1);
        pause(1);
        ur5RRcontrol(ur5,g_rest,1);
    case 'C'
        ur5GBcontrol(ur5,g_start_up,1);        
        pause(1);
        ur5.open_gripper();
        ur5GBcontrol(ur5,g_start,1);
        pause(1);
        ur5.close_gripper();
        pause(1);
        ur5GBcontrol(ur5,g_start_up,1);
        ur5GBcontrol(ur5,g_end_up,0.5);
        ur5GBcontrol(ur5,g_end,1);
        pause(1);
        ur5.open_gripper();
        pause(1);
    case 'D'
        begin_x=[];
        begin_y=[];
        end_x=[];
        end_y=[];
        [begin_x,begin_y,end_x,end_y]=ur5_creative();

        for k=1:length(begin_x)
            g_plot_start = g_start;
            g_plot_end = g_start;
            
            g_plot_start(1,4) = g_plot_start(1,4)+begin_x(k);
            g_plot_start(2,4) = g_plot_start(2,4)+begin_y(k);
            g_plot_start_ = g0b*g_plot_start*gt6;
            s = ur5InvKin(g_plot_start_);
            plot_start_pose = s(:,6);

            g_plot_end(1,4) = g_plot_end(1,4)+end_x(k);
            g_plot_end(2,4) = g_plot_end(2,4)+end_y(k);
            g_plot_end_ = g0b*g_plot_end*gt6;
            s = ur5InvKin(g_plot_end_);
            plot_end_pose = s(:,6);

            g_end_up = g_plot_end;
            g_end_up(3,4) = g_end_up(3,4)+0.05;
            g_end_up_ = g0b*g_end_up*gt6;
            s = ur5InvKin(g_end_up_);
            plot_end_pose_up = s(:,6);
            
            ur5.move_joints(plot_start_pose,2);
            pause(2);
            ur5.move_joints(plot_end_pose,2);
            pause(2);
            ur5.move_joints(plot_end_pose_up,2);
            pause(2);
        end
        ur5.move_joints(rest_pose,5);
    otherwise
        disp('Wrong input, please type A, B, C or D.')
end