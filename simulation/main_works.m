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
global A

A.tunnel_r = 700;
A.tunnel_l = 5000;

fi = 0:359;

%----- Pitch and trans
pitch = 30;
roll  = 20;
yaw   = 20;

trans_x = 10;
trans_y = 350;
trans_z = 200;
%-----------


[quad_x, quad_y, quad_z] = quadcopter(trans_x,trans_y,trans_z,pitch,roll,yaw);


[x, y, z] = lidar_scan_gen(quad_x, quad_y, quad_z, pitch ,roll , yaw);




for i = 1:length(x)  
    EuclidDistance(i) = EuclidDist(quad_x(end),quad_y(end),quad_z(end), x(i), y(i), z(i));
end

scan_x = EuclidDistance .* -sind(fi);
scan_z = EuclidDistance .* -cosd(fi);

[cx, cy, ~] = centroid(scan_x,scan_z);

%=========================== PLOT ========================================
figure('Position',[50 50 1200 900]);
Plot_cylinder
hold on

%plot3(x_circle, y_circle, z_circle, '.c');

%lidar scan 
fill3(x,y,z,'r'); alpha(0.2)
plot3(x,y,z,'.r');
l1 = plot3([quad_x(end) x(1)],[quad_y(end) y(1)],[quad_z(end) z(1)],'r',...
    [quad_x(end) x(91)],[quad_y(end) y(91)],[quad_z(end) z(91)],'r',...
    [quad_x(end) x(181)],[quad_y(end) y(181)],[quad_z(end) z(181)],'r',...
    [quad_x(end) x(271)],[quad_y(end) y(271)],[quad_z(end) z(271)],'r');
set(l1, 'linewidth', 1.5);
%quad frame
g1 = plot3([quad_x(1) quad_x(2)],[quad_y(1) quad_y(2)],...
    [quad_z(1) quad_z(2)],[quad_x(3) quad_x(4)],...
    [quad_y(3) quad_y(4)],[quad_z(3) quad_z(4)],...
    [quad_x(5) quad_x(6)],[quad_y(5) quad_y(6)],[quad_z(5) quad_z(6)]);
set(g1, 'linewidth', 2);
set(g1, 'color', 'k');

g2 = plot3(quad_x(2), quad_y(2), quad_z(2),'.g',...
    quad_x(3), quad_y(3), quad_z(3),'.g',quad_x(4),...
    quad_y(4), quad_z(4),'.c', quad_x(1), quad_y(1),...
    quad_z(1),'.c', quad_x(6), quad_y(6), quad_z(6), '.m');
set(g2, 'MarkerSize', 30);

grid on

figure;

plot(scan_x,scan_z,'r.',0,0,'or',cx,cy,'ok')
axis equal


