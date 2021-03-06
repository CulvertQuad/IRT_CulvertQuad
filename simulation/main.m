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
pitch = -20;
roll  = -45;
yaw   = 30;

trans_x = 400;
trans_y = 0;
trans_z = -100;
%-----------
figure('Position',[50 50 1600 900]);
%=========================END OF initialisation ============================
set_pitch = 0;

while (1)%(A.init == 0)
    
    %what = input('press enter to continue');
    
    [quad_x, quad_y, quad_z] = quadcopter(trans_x,trans_y,trans_z,pitch,roll,yaw);
    [x, y, z, scan_x, scan_z] = lidar_scan_gen(quad_x, quad_y, quad_z, pitch ,roll , yaw);

    [cx, cy, ~] = centroid(scan_x,scan_z);

    % x - distance to centroid
    x_correction = PID_controller(0.05,0.0005,0,-cx,0,2, [-25 25]);
    trans_x = trans_x + x_correction;
  
    z_correction = PID_controller(0.02,0.0005,0,-cy,0,2, [-25 25]);
    trans_z = trans_z + z_correction;
    
    if (pitch < 0)
        trans_y = trans_y + 25 * abs(pitch/20) * cosd(abs(yaw));
        trans_x = trans_x + 25 * abs(pitch/20) * sind(-yaw);
    else
        trans_y = trans_y - 25 * abs(pitch/20) * cosd(abs(yaw));
        trans_x = trans_x + 25 * abs(pitch/20) * sind(yaw);   
    end
    
    
    %mouse input to move 
    m = get(0,'PointerLocation');
    
    if ((m(1) < 50) && (m(2) > 500))
        A.set_view = 1;
    else
        A.set_view = 0;
    end
    
    if ((m(1) > 1000)&&(m(2) < 100))
        set_pitch = -20;
    elseif ((m(1) < 1000)&&(m(2) < 100))
        set_pitch = 20;
    else
        set_pitch = 0;
    end
    %mouse input
    
    
    pitch_correction = PID_controller(0.45,0.0001,0,pitch,set_pitch,1,[-5 5]);
    pitch = pitch + pitch_correction;
    
    roll = 20* x_correction/25;
    clf;
    %plot stuff
    plot_result;
    A.init = 1;
    pause(0.1);
end

