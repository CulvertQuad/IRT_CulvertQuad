%{

    +z
    ^
    |
    |
    |
    |
    x------------> +y
   (out)

all length unit in mm

avg tunnel size:
    radius = 700
    length = 2200

%}
close all; clear all; clc


%============================= initialisation ============================
global A

A.tunnel_r = 700;
A.tunnel_l = 2000;
A.init = 0;
fi = 0:359;

%----- Pitch and trans
pitch = -30;
roll  = 0;
yaw   = 20;

trans_x = 400;
trans_y = 0;
trans_z = 300;
%-----------
figure('Position',[50 50 1600 900]);
%=========================END OF initialisation ============================


while (1)%(A.init == 0)
    
    %what = input('press enter to continue');
    
    [quad_x, quad_y, quad_z] = quadcopter(trans_x,trans_y,trans_z,pitch,roll,yaw);
    [x, y, z, scan_x, scan_z] = lidar_scan_gen(quad_x, quad_y, quad_z, pitch ,roll , yaw);

    [cx, cy, ~] = centroid(scan_x,scan_z);

    % x - distance to centroid
    x_correction = PID_controller(0.05,0.0005,0,-cx,0,1, [-25 25]);
    trans_x = trans_x + x_correction;
  
    z_correction = PID_controller(0.02,0.0005,0,-cy,0,1, [-25 25]);
    trans_z = trans_z + z_correction;
    
    roll = 20* x_correction/25;
    clf;
    %plot stuff
    plot_result;
    A.init = 1;
    pause(0.1);
end

