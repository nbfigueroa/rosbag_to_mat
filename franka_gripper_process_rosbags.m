%% Clear everything and Set Bag Directory
clear all; clc; close all

%%---> MODIFY THESE DIRECTORIES
bag_dir = '../../recordings/gripper-prototypes/bags/';
data_dir = '../../recordings/gripper-prototypes/mat/';
bags = dir(strcat(bag_dir,'*.bag'));

%% Set Topics of Interest (all of these are geometry_msgs::PoseStamped)

% From Franka Emika Panda
ee_pose_topic      = '/franka_state_controller/O_T_EE';

%% Read Topics from N demonstrations (bags)

% Extract measurements from ROSBag
N = length(bags);
data_ee_pose        = {};
for ii=1:N   
    
    % Load one bag and visualize info
    fprintf('Reading bag %s \n',bags(ii).name);
    bag = rosbag(strcat(bag_dir,bags(ii).name));
     
    % Create data structure for right hand measurements
    data_ee_pose{ii}      = extractPoseStamped(bag, ee_pose_topic);     
end

%% Visualize Trajectories on Franka Inspection Workspace!!
close all; 
figure('Color',[1 1 1])

% Get Bowl Transforms (should get them from Apriltags or Optitrack for "adaptable demo")
[H_pickup_station, H_inspection_tunnel, H_release_station] = computeFrankaInspectionTransforms();

% Plot Franka Inspection Workspace
Objects_APregions = plotFrankaInspectionWorkspace(H_pickup_station, H_inspection_tunnel, H_release_station);

% Plot Demonstrations
sample_step  = 1;
for ii=1:N
% Extract desired variables
hand_traj  = data_ee_pose{ii}.pose(1:3,1:sample_step:end);   

% Plot Cartesian Trajectories
scatter3(hand_traj(1,:), hand_traj(2,:), hand_traj(3,:), 7.5, 'MarkerEdgeColor','k','MarkerFaceColor',[rand rand rand]); hold on;
hold on;
end

xlabel('$x_1$', 'Interpreter', 'LaTex', 'FontSize',20);
ylabel('$x_2$', 'Interpreter', 'LaTex','FontSize',20);
zlabel('$x_3$', 'Interpreter', 'LaTex','FontSize',20);
title('Franka End-Effector Trajectories',  'Interpreter', 'LaTex','FontSize',20)
xlim([-0.25 1.75])
ylim([-1.1 1.1])
zlim([-1  1.5])
view([62,22])
grid on
axis equal

%% Save raw data to matfile
matfile = strcat(data_dir,'demos_gripper1_raw_data_good.mat');
save(matfile,'data_ee_pose', 'Objects_APregions', 'bags','bag_dir')
