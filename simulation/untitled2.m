close all; clear all; clc

r = 10; % cylinder radius
sect = 100; % number of sectors of cylinder base
h = 30; %cylinder height

Xcylinder = meshgrid(linspace(-h, h, sect), linspace(-h, h, sect))';
A = meshgrid(linspace(0, 2*pi, sect), linspace(0, 2*pi, sect)) ;
Ycylinder = r .* sin(A);
Zcylinder = r .* cos(A);

surf(Xcylinder,Ycylinder,Zcylinder,'FaceAlpha',0.8),axis equal
xlabel('x')
ylabel('y')
zlabel('z')


shading interp 
colormap([.8 .8 .8])
camlight('right','local')

hold on

pitch = 0;
roll = 40;
yaw = 0;

Rx = [1 0 0
    0 cosd(roll) -sind(roll)
    0 sind(roll) cosd(roll)];

Ry = [cosd(pitch) 0 sind(pitch)
    0 1 0
    -sind(pitch) 0 cosd(pitch)];

Rz = [cosd(yaw) -sind(yaw) 0
    sind(yaw) cosd(yaw) 0
    0 0 1];


P1 = Rz*Ry*Rx*[1;0;0];
P2 = Rz*Ry*Rx*[0;1;0];

A = [P1(1) P1(2)
    P2(1) P2(2)];

B = [P1(3)
    P2(3)];

sol = linsolve(A,B);




t = -r:0.1:r;

z = t;
y = sqrt(r^2-t.^2);
x1 = sol(1).*t + sol(2).*sqrt(r^2-t.^2);
x2 = sol(1).*t - sol(2).*sqrt(r^2-t.^2);

z = [z z];
y = [y -y];
x = [x1 x2];

scatter3(x,y,z); axis equal

Rx = [1 0 0
      0 cosd(-roll) -sind(-roll)
      0 sind(-roll) cosd(-roll)];

Ry = [cosd(pitch) 0 sind(pitch)
      0 1 0
     -sind(pitch) 0 cosd(pitch)];

Rz = [cosd(yaw) -sind(yaw) 0
      sind(yaw) cosd(yaw) 0
      0 0 1];
p = Rx*Ry*Rz*[x;y;z];


hold on 
plot(0,0,x(1), y(1))