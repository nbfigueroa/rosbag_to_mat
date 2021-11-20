%% Clear everything and Set Bag Directory
clear all; clc; close all

%%---> MODIFY THESE DIRECTORIES
bag_dir = '../../nov2021-datacollection-felix/bags/';
data_dir = '../../nov2021-datacollection-felix/mat/';
bags = dir(strcat(bag_dir,'*.bag'));

%% Set Topics of Interest (all of these are geometry_msgs::PoseStamped)

% From XSens IMU Motion Capture System
rh_pose_topic      = '/xsens_rh_pose';
rp_pose_topic      = '/xsens_rp_pose';
pelvis_pose_topic  = '/xsens_pelvis_pose'; % Not used, but here for completeness

% From AprilTags Tracking on Kinect Images (Static)
pick_tray_pose_topic     = '/workspace/pick_tray';
scanner_pose_topic       = '/workspace/scanner';
proc_station_pose_topic  = '/workspace/proc_station';
check_station_pose_topic = '/workspace/check_station';
ok_tray_pose_topic       = '/workspace/OK_tray';
ng_tray_pose_topic       = '/workspace/NG_tray';

%% Read Topics from N demonstrations (bags)

N = length(bags);
data_rh         = {};
data_rp         = {};
workspace_poses = {};
for ii=1:N   
    
    % Load one bag and visualize info
    fprintf('Reading bag %s \n',bags(ii).name);
    bag = rosbag(strcat(bag_dir,bags(ii).name));
    
    % Extract workspace poses (/base_link) and relative TFs
    
    
    % Create data structure for right hand measurements
    data_rh{ii}      = extractPoseStamped(bag, rh_pose_topic);
    data_rh{ii}.name = strrep(bags(ii).name,'.bag','');    
    
    % Transform poses to /base_link
    
    % Create data structure for right hand prop measurements
    data_rp{ii}      = extractPoseStamped(bag, rp_pose_topic);
    data_rp{ii}.name = strrep(bags(ii).name,'.bag','');       
    
    % Transform poses to /base_link
    
end


%% Save raw data to matfile
matfile = strcat(data_dir,'demos_nov2021_raw_data.mat');
save(matfile,'data_rh','data_rp', 'bags','bag_dir')

%% Visualize Trajectories on Mitsubishi Workspace!!

close all; 
figure('Color',[1 1 1])

% Plot Mitsibishi World
plotMitsubishiWorld()

% Plot Demonstrations
for ii=1:N
sample  = 1;

% Extract desired variables
hand_traj  = data_rp{ii}.pose(1:3,1:sample:end);   

% Plot Cartesian Trajectories
scatter3(hand_traj(1,:), hand_traj(2,:), hand_traj(3,:), 7.5, 'MarkerEdgeColor','k','MarkerFaceColor',[rand rand rand]); hold on;
hold on;
end

xlabel('$x_1$', 'Interpreter', 'LaTex', 'FontSize',20);
ylabel('$x_2$', 'Interpreter', 'LaTex','FontSize',20);
zlabel('$x_3$', 'Interpreter', 'LaTex','FontSize',20);
grid on
title('XSens Raw Right Hand Trajectories',  'Interpreter', 'LaTex','FontSize',20)
axis equal

xlim([-0.25 1.25])
ylim([-1.1 1.1])
zlim([0.0  1.35])
