%{

Assume a circular tunnel

+z
^
|
|
|
-----------> +x
 
+y: into page

clockwise rotation = +ve (left hand)

%}
clear all
close all
clc

%{
tunnel_r = input('Radius of tunnel (mm) = ');
quad_pos(1) = input('Quad x (mm) off centre: ');
quad_pos(2) = input('Quad y (mm) off centre: ');

fprintf('Rotation angle in degree:\n');
pitch = input('pitch = ');
roll  = input('roll = ');
yaw   = input('yaw = ');
%}

%for easy testing/debugging
sensor_offset = 0;
tunnel_r = 3;
quad_pos(1) = 0;
quad_pos(2) = 0;

pitch = 30;
roll = 40;
yaw = 60;

%centre
xc = quad_pos(1);
yc = quad_pos(2);
zc = 0;

%Rotation matrices
Rx = [1 0 0;0 cosd(pitch) -sind(pitch); 0 sind(pitch) cosd(pitch)];
Ry = [cosd(roll) 0 sind(roll);0 1 0; -sind(roll) 0 cosd(roll)];
Rz = [cosd(yaw) -sind(yaw) 0;sind(yaw) cosd(yaw) 0; 0 0 1];

R = Rx*Ry*Rz;

theta = 0:360;

x = tunnel_r * cosd(theta);
y = tunnel_r * sind(theta);
z = zeros(1,size(x,2));

pointCloud = R*[x;y;z];
x = pointCloud(1,:);
y = pointCloud(2,:);
z = pointCloud(3,:);


%generate line
m_xy = y./x;
m_zy = y./z;

if pitch == 0 
    y_zint = 0;
else
    y_zint = sensor_offset/sind(pitch);   
end
a = 1 + m_xy.^2;
b = -2 .* (xc + yc.*m_xy);
c = xc^2 + yc^2 - tunnel_r^2;

x_new = (-b + sqrt(b.^2 - 4.*a.*c))./(2*a);

y_new = sqrt(tunnel_r^2 - (x-xc).^2) + yc;
%y_new(181:361) = -1 * y_new(181:361);

z_new = (y - y_zint)./m_zy;

figure;
scatter3(x,y,z,'.')
%
xlabel('x')
ylabel('y')
zlabel('z')
daspect([1 1 1])

hold on
scatter3(xc, yc, zc, 'ro')

hold on 
scatter3(x_new, y_new, z_new, 'g.');


%cylinder
hold on

sect = 360; % number of sectors of cylinder base
h = 10; %cylinder height

Zcylinder = meshgrid(linspace(-h, h, sect), linspace(-h, h, sect))';
A = meshgrid(linspace(0, 2*pi, sect), linspace(0, 2*pi, sect)) ;
Ycylinder = tunnel_r .* sin(A);
Xcylinder = tunnel_r .* cos(A);

surf(Xcylinder,Ycylinder,Zcylinder,'FaceAlpha',0.3),axis equal
xlabel('x')
ylabel('y')
zlabel('z')


shading interp 
colormap([.8 .8 .8])
camlight('right','local')



