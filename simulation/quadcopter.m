function [quad_x, quad_y, quad_z] = quadcopter(global_x,global_y,global_z,pitch,roll,yaw)


lidar_pos = 250;
quad_size = 160;

quad_x = [-1 1 -1 1] * quad_size; % quadcopter initial location
quad_y = [-1 1 1 -1] * quad_size; % inputed in cross way
quad_z = [0 0 0 0] * quad_size;   % BL FR FL BR

quad_x = [quad_x 0 0];
quad_y = [quad_y 0 lidar_pos];
quad_z = [quad_z 0 0]; % adding laser location



[quad_x, quad_y, quad_z] = rotation3(quad_x,quad_y,quad_z,pitch,roll,yaw);

quad_x = quad_x + global_x;
quad_y = quad_y + global_y;
quad_z = quad_z + global_z;


end

